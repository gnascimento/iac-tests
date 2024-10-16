import json
import logging
import os
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)


# Initialize the SNS client
sns_client = boto3.client('sns')

def lambda_handler(event, context):

     # Fetch the SNS topic ARN from environment variables
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']

    product_id = event['product_id']
    amount = event['amount']
    
    amount_request = {
        'product_id': product_id,
        'amount': amount
    }
        
    logger.info(f"Request: product: {amount_request['product_id']}, amount: {amount_request['amount']}")
    
     
    # Send the message to the SNS topic
    try:
        response = sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=json.dumps(amount_request),
            Subject='Lambda SNS Message'
        )
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Message sent successfully!',
                'response': response
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }
