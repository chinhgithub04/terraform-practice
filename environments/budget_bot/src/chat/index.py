import json

def handler(event, context):
    print("Received chat request")
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "message": "Hello from Budget Bot Chat Lambda!"
        })
    }
