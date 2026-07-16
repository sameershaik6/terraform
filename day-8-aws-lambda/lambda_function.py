import json

def lambda_handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello, World! this is my first lambda function in terraform uploaded using s3 bucket')
    }