import json

# Return Json Error Message
def Error(error_message):
    response = {
        "detail": error_message
    }
    return response

# Return Json Success Message
def Success():
    response = {
        "detail": "Success."
    }
    return response

# Return Json Response
def JsonFormat(data, image_list, upload_id):
    # Decode data
    decoded_data = data.decode('cp949')  # utf-8

    # Extract meaningful data from decoded data
    results = decoded_data.split("\n") 
    meaningful_data = results[-1]

    # String to Dictionary
    dict_result = json.loads(meaningful_data)
    
    # Make Json Format
    images = []
    for i in range(len(image_list)):
        image = {
            "image_id": i,
            "results": dict_result[image_list[i]]
        }
        images.append(image)
    
    response = {
        "upload_id": upload_id,
        "images": images
    }
    return response