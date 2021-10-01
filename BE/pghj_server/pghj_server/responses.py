def Error(error_message):
    response = {
        "detail": error_message
    }

    return response

def Success():
    response = {
        "detail": "Success."
    }
    
    return response