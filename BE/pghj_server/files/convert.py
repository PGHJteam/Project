import json

# Convert String to Json Format
def convert(data, upload_id):
    # Decode data (Bytes to String)
    decoded_data = data.decode('utf-8')
    
    # Extract meaningful data from decoded data
    results = decoded_data.split("\n") 
    meaningful_data = results[-1]

    # String to Dictionary
    dict_result = json.loads(meaningful_data)
    
    # Make Json Format
    images = []
    for index, (key, value) in enumerate(dict_result.items()):
        image = {
            "image_id": index,
            "results": value
        }
        images.append(image)
    
    response = {
        "upload": upload_id,
        "images": images
    }
    return response