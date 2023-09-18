from flask import Flask
from flask_cors import CORS
import boto3

s3 = boto3.client('s3')
app = Flask("api")
CORS(app)

@app.route("/")
def list_emails():
    res = s3.list_objects_v2(
        Bucket="${domain}-emails",
    )
    return {
        "emails": [
            {
                "Id": o["Key"],
                "Data": s3.get_object(
                    Bucket="${domain}-emails",
                    Key=o["Key"],
                )["Body"].read().decode("utf-8")
            }
            for o in res["Contents"]
        ]
    }

app.run(host="0.0.0.0", port=80)
