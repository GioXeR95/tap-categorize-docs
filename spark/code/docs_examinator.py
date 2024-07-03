import os
import random
from pyspark.sql import SparkSession, Row
from pyspark.sql.functions import from_json, col, udf, current_timestamp, expr, date_format, inline
from pyspark.sql.types import StringType, IntegerType, StructType, StructField, FloatType
import openai
# Initialize Spark session
spark = SparkSession.builder \
    .appName("documentinator") \
    .config("es.nodes", "elasticsearch") \
    .config("es.port", "9200") \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

# Read OpenAI API key from environment variable
#openai.api_key = os.getenv('OPENAI_API_KEY')
openai.api_key = ":D"
openai.base_url = "http://192.168.0.75:8080"
# Kafka, ElasticSearch, and other configurations
kafkaServer = "broker:9092"
topic = "docstojson"
elastic_index = "documents-index"

# Define schema for Kafka messages
KafkaSchema = StructType([
    StructField("uuid", StringType(), True),
    StructField("file_name", StringType(), True),
    StructField("file_size_mb", FloatType(), True),
    StructField("file_extension", StringType(), True),
    StructField("content", StringType(), True),
    StructField("last_edit", StringType(), True)
])
# Cuts the a string, used to prevent text being too big for the AI model
def cut_string(s, max_length=2300):
    if len(s) > max_length:
        return s[:max_length]
    return s
# Function that returns a random fake response for testing
def get_ai_response_testing(uuid, filename, text):
    categories_list = ["personal", "business", "game", "payment", "recipe", "receipt"]
    category = random.choice(categories_list)
    summary = filename
    reliability = random.randint(1, 10)
    return Row(category=category, summary=summary, reliability=int(reliability))

def safe_cast_int(input_str):
    # Remove non-numeric characters
    numeric_str = ''.join(filter(str.isdigit, input_str))
    
    # Convert to integer
    try:
        result = int(numeric_str)
    except ValueError:
        result = None  # Handle cases where input_str does not form a valid integer
    
    return result
# Function that calls OpenAI API to get response
def get_ai_response(uuid, filename, text):
    system_prompt = """
     You are an expert data analyst helping us to understand the content of a document based on the title and the content.
     You'll receive an input with the following format: filename: <filename>  content: <content> 
     Your task is to tell us in what category the document could go: personal, business, game, payment, recipe, receipt or if it's not possible to understand use the category 'other'.
     Give a small summary of what the document contains in less than 25 words. 
     And on a scale from 1 to 10, rate the reliability of the document information.
     Your answer must be in this format only without descriptions or other text added: category: <category>, summary: <summary>, reliability: <reliability>"
    """
    file = f"filename: {filename}\ncontent: {cut_string(text)}"
    print("Input to AI model:")
    try:
        response = openai.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": file},
            ],
        )
        reply = response.choices[0].message.content
        print("Reply from AI model:")
        print(reply)
        # Extract category, summary, and reliability from the reply
        category_start = reply.find("category: ") + len("category: ")
        category_end = reply.find(", summary:")
        category = reply[category_start:category_end].strip()

        summary_start = reply.find("summary: ") + len("summary: ")
        summary_end = reply.find(", reliability:")
        summary = reply[summary_start:summary_end].strip()

        reliability_start = reply.find("reliability: ") + len("reliability: ")
        reliability = reply[reliability_start:].strip()

        return Row(category=category, summary=summary, reliability=safe_cast_int(reliability))
    except Exception as e:
        print(f"Error: {e}")
        return Row(category="error", summary="error", reliability=-1)

# Register the UDF
#get_ai_response_udf = udf(get_ai_response_testing)
# Register the UDF with Spark
spark.udf.register("get_ai_response_udf", get_ai_response, StructType([
    StructField("category", StringType(), True),
    StructField("summary", StringType(), True),
    StructField("reliability", IntegerType(), True)
]))
def main():
    """
    Main function to read from Kafka,
    apply transformations, 
    and write to Elasticsearch.
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
           .select("data.uuid", "data.file_name", "data.file_size_mb", "data.file_extension", "data.content", "data.last_edit")

    # Filter out empty content and select required columns
    df_filtered = df.filter(col("content").isNotNull() & (col("content") != ""))

    # Apply the custom function to get AI response using expr and inline
    df_with_ai = df_filtered.withColumn("ai_response", expr("get_ai_response_udf(uuid, file_name, content)"))
    # Add current timestamp
    df_final_with_timestamp = df_with_ai.withColumn("timestamp", date_format(current_timestamp(), "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))

    # Write in StandardOutput
    std_query = df_final_with_timestamp.select(col("uuid"),col("file_name"),col("ai_response.category").alias("category"),col("ai_response.summary").alias("summary"),col("ai_response.reliability").alias("reliability"))\
                                       .writeStream \
                                       .outputMode("append") \
                                       .format("console") \
                                       .start()

    # Write streaming DataFrame to Elasticsearch
    es_query = df_final_with_timestamp.select(
        col("uuid"),
        col("file_name"),
        col("file_size_mb"),
        col("file_extension"),
        col("content"),
        col("last_edit"),
        col("ai_response.category").alias("category"),
        col("ai_response.summary").alias("summary"),
        col("ai_response.reliability").alias("reliability"),
        col("timestamp")
    ) \
    .writeStream \
    .option("checkpointLocation", "/tmp/") \
    .option("es.batch.size.bytes", "30mb") \
    .option("es.batch.size.entries", "1000") \
    .format("es") \
    .start(elastic_index)
    es_query.awaitTermination()
    #.option("es.mapping.id", "timestamp") \
    std_query.awaitTermination()


if __name__ == "__main__":
    main()
