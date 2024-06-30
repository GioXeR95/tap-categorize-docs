import os
from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, udf
from pyspark.sql.types import StringType, StructType, StructField
import openai

# Initialize Spark session
spark = SparkSession.builder \
    .appName("docstojson") \
    .config("es.nodes", "elasticsearch") \
    .config("es.port", "9200") \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

# Read OpenAI API key from environment variable
openai.api_key = os.getenv('OPENAI_API_KEY')

# Kafka, ElasticSearch, and other configurations
kafkaServer = "broker:9092"
topic = "docstojson"
elastic_index = "docs-data"

# Define schema for Kafka messages
KafkaSchema = StructType([
    StructField("uuid", StringType(), True),
    StructField("file_name", StringType(), True),
    StructField("content", StringType(), True),
    StructField("last_edit", StringType(), True),
    StructField("data_creation", StringType(), True)
])

def get_ai_response(uuid, filename, text):
    system = "You are an expert data analyst helping us to understand the content of a document based on the title and the content"
    prompt = """
    # You'll receive an input with the following format: filename: <filename>  content: <content> 
    # Your task is to tell us in what category the document could go: personal, business, game, payment, recipe, receipt or if it's not possible to understand use the category 'other'.
    # Give a small summary of what the document contains in less than 25 words. 
    # And on a scale from 1 to 10, rate the reliability of the document information.
    # Your answer must be in this format only without descriptions or other text added: category: <category>, summary: <summary>, reliability: <reliability>"
    """
    file = f"filename: {filename}\ncontent: {text}"
    
    try:
        response = openai.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": system},
                {"role": "user", "content": prompt + "\n" + file},
            ],
        )
        reply = response.choices[0].message.content
        
        # Extract category, summary, and reliability from the reply
        category_start = reply.find("category: ") + len("category: ")
        category_end = reply.find(", summary:")
        category = reply[category_start:category_end].strip()

        summary_start = reply.find("summary: ") + len("summary: ")
        summary_end = reply.find(", reliability:")
        summary = reply[summary_start:summary_end].strip()

        reliability_start = reply.find("reliability: ") + len("reliability: ")
        reliability = reply[reliability_start:].strip()

        return category, summary, reliability
    except Exception as e:
        print(f"Error: {e}")
        return "error", "error", "error"  # Handle error with default values

# Register the UDF
get_ai_response_udf = udf(lambda uuid, filename, text: get_ai_response(uuid, filename, text), 
                          StructType([StructField("category", StringType(), True),
                                      StructField("summary", StringType(), True),
                                      StructField("reliability", StringType(), True)]))

def main():
    """
    Main function to read from Kafka, apply transformations, and write to Elasticsearch.
    """
    print("Reading stream from Kafka...")

    # Read from Kafka stream
    df = spark \
        .readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", kafkaServer) \
        .option("subscribe", topic) \
        .load()

    # Deserialize JSON and select relevant fields
    df = df.selectExpr("CAST(value AS STRING)") \
           .select(from_json("value", KafkaSchema).alias("data")) \
           .select("data.uuid", "data.file_name", "data.content", "data.last_edit", "data.data_creation")

    # Filter out empty content and select required columns
    df_filtered = df.filter(col("content").isNotNull() & (col("content") != ""))

    # Apply the UDF to get AI response
    df_with_ai = df_filtered.withColumn("ai_response", get_ai_response_udf(col("uuid"), col("file_name"), col("content")))
    df_final = df_with_ai.select("uuid", "file_name", "content", "last_edit", "data_creation", 
                                 col("ai_response.category"), col("ai_response.summary"), col("ai_response.reliability"))
    
    # Write streaming DataFrame to Elasticsearch
    es_query = df_final.writeStream \
                    .option("checkpointLocation", "/tmp/") \
                    .format("es") \
                    .start(elastic_index) 
    es_query.awitTermination()

if __name__ == "__main__":
    main()
