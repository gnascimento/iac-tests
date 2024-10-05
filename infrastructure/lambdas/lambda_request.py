import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    
    # runtime converts the event object to a Python dictionary
    a = event['a']
    b = event['b']
    
    sum = a + b
    print(f"The sum is {sum}")
        
    # return the calculated sum as a JSON string
    data = {"sum": sum}
    return json.dumps(data)
