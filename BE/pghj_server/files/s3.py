import boto3
from pghj_server.settings import AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME

def get_path(user_id, upload_id):
    return 'media/' + user_id + "/upload" + str(upload_id) + "/"

def s3_access():
    s3_client = boto3.client(
        's3', 
        aws_access_key_id=AWS_ACCESS_KEY_ID, 
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY
    )
    return s3_client

def s3_upload(local_path, s3_path):
    s3_access().upload_file(         # Save file into S3 storage from local      
        local_path,
        BUCKET_NAME,
        s3_path,
    )