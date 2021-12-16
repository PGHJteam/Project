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