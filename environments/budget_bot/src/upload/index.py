import json

def handler(event, context):
    print("Received upload/parse request")
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message": "Hello from Budget Bot CSV Upload Lambda!"
        })
    }
