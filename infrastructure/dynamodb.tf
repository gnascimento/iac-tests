locals {
  products = {
    product1 = {
      id            = "product-001"
      creation_date = "2024-10-05"
      name          = "Product Name 1"
      price         = "19.99"
      category      = "Category A"
      stock         = "100"
    },
    product2 = {
      id            = "product-002"
      creation_date = "2024-10-05"
      name          = "Product Name 2"
      price         = "29.99"
      category      = "Category B"
      stock         = "50"
    }
  }
}

resource "aws_dynamodb_table" "product_table" {
  name           = "products-table"
  billing_mode   = "PROVISIONED"  # Set to PAY_PER_REQUEST for on-demand
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S" 
  }

  tags = {
    Name        = "product-table"
  }

}


resource "aws_dynamodb_table_item" "product1" {
  for_each = local.products
  table_name = aws_dynamodb_table.product_table.name
  hash_key   = "id"
  item = <<ITEM
{
  "id": {"S": "${each.value.id}"},
  "creation_date": {"S": "${each.value.creation_date}"},
  "name": {"S":  "${each.value.name}"},
  "price": {"N": "${each.value.price}"},
  "category": {"S": "${each.value.category}"},
  "stock": {"N": "${each.value.stock}"}
}
ITEM
}

