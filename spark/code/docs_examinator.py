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
tweetKafkaSchema = StructType([
    StructField("uuid", StringType(), True),
    StructField("file_name", StringType(), True),
    StructField("content", StringType(), True),
    StructField("last_edit", StringType(), True),
    StructField("data_creation", StringType(), True)
])

def get_ai_response(uuid,filename, text):
    system = "You are an expert data analyst helping us to understand the content of a document basing on the title and the content"
    prompt = """
    # You'll receive an input with the following format: filename: <filename>  content: <content> 
    # Your task is to tell us in what category the document could go: personal, business, game, payment, recipe, receipt or if it's not possible to understand use the category 'other'.
    # Give a small summary of what the document contains in less then 25 words. 
    # And on a scale from 1 to 10, rate the reliability of the document informations
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
        
        # Extract category and summary from the reply
        category_start = reply.find("category: ") + len("category: ")
        category_end = reply.find(", summary:")
        category = reply[category_start:category_end].strip()

        summary_start = reply.find("summary: ") + len("summary: ")
        summary_end = reply.find(", reliability:")
        summary = reply[summary_start:summary_end].strip()
        reliability_start = reply.find("reliability: ") + len("reliability: ")
        reliability = reply[reliability_start:].strip()
        return uuid,category, summary,reliability
    except Exception as e:
        print(f"Error: {e}")
        return None, None  # Handle error or return a default value


def foreach_batch_add_ai_result(batch_df, batch_id):
    """
    Function to apply UDF and save results to Elasticsearch for each batch DataFrame.
    """
    print("Batch ID:", batch_id)
    batch_df.show()

    # Check if batch_df is not empty
    if batch_df.rdd.isEmpty():
        print("Skipping batch because it is empty.")
        return
    
    try:
        # Apply UDF to get AI response (category and summary)
        udf_result = batch_df.rdd.map(lambda row: get_ai_response(row['uuid'],row['file_name'], row['content'])).toDF(['uuid','category', 'summary', 'reliability'])
        #udf_result.show()
        batch_df = batch_df.join(udf_result, on='uuid', how='left')
        batch_df = batch_df.dropDuplicates(['uuid'])
        print("Batch after adding AI content:")
        batch_df.show()

        # Write to Elasticsearch
        batch_df.write \
                    .format("es") \
                    .mode("append") \
                    .save(elastic_index)

        print("Batch successfully written to Elasticsearch.")
        
    except Exception as e:
        print(f"Error writing batch to Elasticsearch: {e}")
        # Handle exception, log, retry, or fail gracefully

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
           .select(from_json("value", tweetKafkaSchema).alias("data")) \
           .select("data.uuid","data.file_name", "data.content", "data.last_edit", "data.data_creation")

    # Filter out empty content and select required columns
    df_filtered = df.filter(col("content").isNotNull() & (col("content") != ""))
    df_selected = df_filtered.select("uuid","file_name", "content", "last_edit", "data_creation")

    # Write streaming DataFrame to Elasticsearch with AI content
    query = df_selected.writeStream \
                       .option("checkpointLocation", "/tmp/") \
                       .foreachBatch(foreach_batch_add_ai_result) \
                       .start()

    # Wait for termination
    query.awaitTermination()

if __name__ == "__main__":
    main()
