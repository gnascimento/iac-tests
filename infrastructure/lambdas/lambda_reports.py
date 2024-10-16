import json
import boto3
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')
table_name = os.environ['PRODUCTS_TABLE']
bucket_name = os.environ['S3_REPORT_BUCKET']


def lambda_handler(event, context):
    for record in event['Records']:
        message_body = json.loads(record['body'])
        logger.info(f"Message received by SQS: {message_body}")
        
        sns_message = json.loads(message_body['Message'])
        logger.info(f"Message sent by SNS: {sns_message}")

         # Table name and product id are received from the event input
        product_id = sns_message['product_id']
        amount_to_remove = sns_message['amount']  # Amount to reduce from stock
        try:
            # Get reference to the DynamoDB table
            table = dynamodb.Table(table_name)
            # Fetch the product from the table by product_id
            response = table.get_item(
                Key={
                    'id': product_id
                }
            )

            if 'Item' not in response:
                logger.error(f"Product with id {product_id} not found.")
                return {
                    'statusCode': 404,
                    'body': f"Product with id {product_id} not found."
                }
            
            product = response['Item']
            
            # Check current stock
            current_stock = int(product['stock'])
            
            # If the stock is less than the amount to remove, return an error
            if current_stock < amount_to_remove:
                logger.error(f"Insufficient stock available.")
                return {
                    'statusCode': 400,
                    'body': "Insufficient stock available."
                }


            # Update the stock
            new_stock = current_stock - amount_to_remove
            
            # Update the item in DynamoDB
            table.update_item(
                Key={
                    'id': product_id
                },
                UpdateExpression='SET stock = :new_stock',
                ExpressionAttributeValues={
                    ':new_stock': new_stock
                },
                ReturnValues="UPDATED_NEW"
            )
            

            product_json = {
                'stock': int(new_stock),
                'id': product_id,
                'previous_stock': int(new_stock + amount_to_remove)
            }


            # Store the product object into S3
            s3_key = f"products/{product_id}.json"  # S3 key (file path)
            s3.put_object(
                Bucket=bucket_name,
                Key=s3_key,
                Body=json.dumps(product_json),
                ContentType='application/json'
            )
            
            logger.info(f"Product {product_id} stored successfully in S3 at {s3_key}")
            
            return {
                'statusCode': 200,
                'body': f"Stock updated and product stored in S3. New stock: {new_stock}"
            }
        except Exception as e:
            
            logger.error(f"Error fetching or updating product: {e}")

            return {
                'statusCode': 500,
                'body': f"Error fetching or updating product"
            }