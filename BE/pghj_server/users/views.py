from django.http import JsonResponse
from rest_framework.parsers import JSONParser
from rest_framework import status, generics
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated

import jwt
from pghj_server.settings import SECRET_KEY, ALGORITHM
from pghj_server.responses import Success, Error

from users.models import User
from users.serializers import UserSerializer


# Sign Up
@api_view(['POST'])
@permission_classes([AllowAny]) # Anyone can access
def SignUp(request):
    if request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = UserSerializer(data=data)

        if serializer.is_valid():
            serializer.save()
            return JsonResponse(data=Success(), status=status.HTTP_201_CREATED)     
        return JsonResponse(data=Error("Sign Up Failed."), status=status.HTTP_400_BAD_REQUEST)
        

# Extract user_pk from header, get user, return user
def get_user(request): 
    _, token = request.headers.get("Authorization").split()
    payload = jwt.decode(token, SECRET_KEY, algorithms=ALGORITHM)
    user = User.objects.get(id=payload['user_id'])
    return user


# Get/Update/Delete user account
class UserView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,) # Only Authorized users can access

    # Get user information
    def get(self, request):
        user = get_user(request)
        serializer = UserSerializer(user) # get user-info list
        return JsonResponse(serializer.data, status=status.HTTP_200_OK) 

    # Update user information
    def put(self, request): 
        user = get_user(request)
        data = JSONParser().parse(request)
        serializer = UserSerializer(user, data=data) # update user-info
        if serializer.is_valid(): 
            serializer.save()
            return JsonResponse(data=Success(), status=status.HTTP_201_CREATED)
        return JsonResponse(data=Error("User Update Failed."), status=status.HTTP_400_BAD_REQUEST)

    # Delete user information
    def delete(self, request): 
        user = get_user(request)    
        user.is_active = False      # deactivate user
        user.save()
        return JsonResponse(data=Success(), status=status.HTTP_200_OK)