resource "aws_dynamodb_table" "product_table" {
  name           = "products-table"
  billing_mode   = "PROVISIONED"  # Set to PAY_PER_REQUEST for on-demand
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "creation_date"

  attribute {
    name = "id"
    type = "S"  # S stands for string type
  }

  attribute {
    name = "creation_date"
    type = "S"  # S stands for string type
  }

  tags = {
    Name        = "product-table"
  }

}


resource "aws_dynamodb_table_item" "product1" {
  table_name = aws_dynamodb_table.product_table.name
  hash_key   = "id"
  range_key  = "creation_date"

  item = <<ITEM
{
  "id": {"S": "product-001"},
  "creation_date": {"S": "2024-10-05"},
  "name": {"S": "Product Name 1"},
  "price": {"N": "19.99"},
  "category": {"S": "Category A"},
  "stock": {"N": "100"}
}
ITEM
}

resource "aws_dynamodb_table_item" "product2" {
  table_name = aws_dynamodb_table.product_table.name
  hash_key   = "id"
  range_key  = "creation_date"

  item = <<ITEM
{
  "id": {"S": "product-002"},
  "creation_date": {"S": "2024-10-05"},
  "name": {"S": "Product Name 2"},
  "price": {"N": "29.99"},
  "category": {"S": "Category B"},
  "stock": {"N": "50"}
}
ITEM
}
