resource "aws_lakeformation_data_lake_settings" "main" {
  admins = [var.lakeformation_admin_arn] # ARN do usuário ou role administrador do Lake Formation
}

# Exemplo de concessão de permissões a um principal (usuário/role) em um banco de dados do Glue
resource "aws_lakeformation_permissions" "database_access" {
  principal = var.lakeformation_principal_arn
  permissions = ["CREATE_TABLE", "ALTER", "DROP"]
  database = {
    name = var.glue_database_name
  }
}

# Exemplo de concessão de permissões a um principal em uma tabela específica
resource "aws_lakeformation_permissions" "table_access" {
  principal = var.lakeformation_principal_arn
  permissions = ["SELECT", "INSERT", "ALTER", "DROP"]
  database = {
    name = var.glue_database_name
  }
  table = {
    name = var.glue_table_name
  }
}

# (Opcional) Criar um catálogo de dados do Glue (se ainda não existir)
resource "aws_glue_catalog_database" "main" {
  name = var.glue_database_name
}