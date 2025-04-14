from pyspark.sql import SparkSession

# --- Configurações do S3 ---
S3_BUCKET_NAME = 'seu-bucket-s3'  # Substitua pelo nome do seu bucket S3
S3_PREFIX = 'dados-banco/'        # Prefixo onde os arquivos Parquet estão
BRONZE_PREFIX = f"s3://{S3_BUCKET_NAME}/camada-bronze/"

# --- Paths para os arquivos de entrada no S3 ---
clientes_input_path = f"s3://{S3_BUCKET_NAME}/{S3_PREFIX}clientes.parquet"
transacoes_input_path = f"s3://{S3_BUCKET_NAME}/{S3_PREFIX}transacoes.parquet"
emprestimos_input_path = f"s3://{S3_BUCKET_NAME}/{S3_PREFIX}emprestimos.parquet"
pagamentos_input_path = f"s3://{S3_BUCKET_NAME}/{S3_PREFIX}pagamentos.parquet"

# --- Inicializa a SparkSession ---
spark = SparkSession.builder.appName("BronzeLayer").getOrCreate()

# --- Leitura dos dados brutos ---
df_clientes_bronze = spark.read.parquet(clientes_input_path)
df_transacoes_bronze = spark.read.parquet(transacoes_input_path)
df_emprestimos_bronze = spark.read.parquet(emprestimos_input_path)
df_pagamentos_bronze = spark.read.parquet(pagamentos_input_path)

# --- Escrita dos DataFrames na camada Bronze no S3 ---
df_clientes_bronze.write.mode("overwrite").parquet(f"{BRONZE_PREFIX}clientes.parquet")
df_transacoes_bronze.write.mode("overwrite").parquet(f"{BRONZE_PREFIX}transacoes.parquet")
df_emprestimos_bronze.write.mode("overwrite").parquet(f"{BRONZE_PREFIX}emprestimos.parquet")
df_pagamentos_bronze.write.mode("overwrite").parquet(f"{BRONZE_PREFIX}pagamentos.parquet")

print(f"Dados brutos lidos de: s3://{S3_BUCKET_NAME}/{S3_PREFIX}")
print(f"Camada Bronze escrita em: {BRONZE_PREFIX}")

# --- Encerra a SparkSession ---
spark.stop()