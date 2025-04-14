from pyspark.sql import SparkSession
from pyspark.sql import functions as F

# --- Configurações do S3 ---
S3_BUCKET_NAME = 'seu-bucket-s3'  # Substitua pelo nome do seu bucket S3
SILVER_PREFIX = f"s3://{S3_BUCKET_NAME}/camada-silver/"
OURO_PREFIX = f"s3://{S3_BUCKET_NAME}/camada-ouro/"

# --- Paths para os arquivos da camada Silver no S3 ---
clientes_silver_path = f"{SILVER_PREFIX}clientes.parquet"
transacoes_silver_path = f"{SILVER_PREFIX}transacoes.parquet"
emprestimos_silver_path = f"{SILVER_PREFIX}emprestimos.parquet"
pagamentos_silver_path = f"{SILVER_PREFIX}pagamentos.parquet"

# --- Inicializa a SparkSession ---
spark = SparkSession.builder.appName("OuroLayer").getOrCreate()

# --- Leitura dos DataFrames da camada Silver ---
df_clientes_silver = spark.read.parquet(clientes_silver_path)
df_transacoes_silver = spark.read.parquet(transacoes_silver_path)
df_emprestimos_silver = spark.read.parquet(emprestimos_silver_path)
df_pagamentos_silver = spark.read.parquet(pagamentos_silver_path)

print(f"Dados da camada Silver lidos de: {SILVER_PREFIX}")

# --- Transformações para a Camada Ouro (Exemplos) ---

# Agregação de transações por cliente e tipo no último ano
df_transacoes_ouro_agregado = df_transacoes_silver.filter(
    F.col("data_transacao") >= F.add_months(F.current_date(), -12)
).groupBy("cliente_id", "nome", "tipo_transacao").agg(
    F.count("*").alias("total_transacoes"),
    F.sum("valor").alias("valor_total_transacoes")
)

# Identificação de clientes com muitos empréstimos em atraso
df_emprestimos_atrasados = df_emprestimos_silver.filter(F.col("status") == "Em Atraso")
clientes_atrasados = df_emprestimos_atrasados.groupBy("cliente_id").agg(
    F.count("*").alias("total_emprestimos_atrasados")
)

df_clientes_ouro = df_clientes_silver.join(
    clientes_atrasados,
    "cliente_id",
    "left"
).fillna(0, subset=["total_emprestimos_atrasados"])

# --- Escrita dos DataFrames na camada Ouro no S3 ---
df_transacoes_ouro_agregado.write.mode("overwrite").parquet(f"{OURO_PREFIX}transacoes_agregadas.parquet")
df_clientes_ouro.write.mode("overwrite").parquet(f"{OURO_PREFIX}clientes_com_atraso.parquet")
df_emprestimos_silver.write.mode("overwrite").parquet(f"{OURO_PREFIX}emprestimos.parquet")
df_pagamentos_silver.write.mode("overwrite").parquet(f"{OURO_PREFIX}pagamentos.parquet")

print(f"Camada Ouro escrita em: {OURO_PREFIX}")

# --- Encerra a SparkSession ---
spark.stop()