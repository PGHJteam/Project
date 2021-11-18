import boto3
from pghj_server.settings import AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME

def S3Access():
    s3_client = boto3.client(
        's3', 
        aws_access_key_id=AWS_ACCESS_KEY_ID, 
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY
    )
    return s3_client

def S3ImageUpload(file, s3_path):
    S3Access().upload_fileobj(     # Save file into S3 storage directly      
        file,
        BUCKET_NAME,
        s3_path,
    )

def S3FileUpload(local_path, s3_path):
    S3Access().upload_file(         # Save file into S3 storage from local      
        local_path,
        BUCKET_NAME,
        s3_path,
    )