from django.http import JsonResponse
from rest_framework.parsers import JSONParser
from rest_framework import status, generics
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken

import jwt
from pghj_server.settings import SECRET_KEY, ALGORITHM
from pghj_server.responses import Success, Error

from users.models import User
from users.serializers import UserSerializer

from files.models import Upload, Material

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
        

# Sign Out
@api_view(['POST'])
@permission_classes([IsAuthenticated]) # Only Authorized users can access
def SignOut(request):
    if request.method == 'POST':
        data = JSONParser().parse(request)
        refresh_token = data['refresh_token']
        token = RefreshToken(token=refresh_token)
        token.blacklist()

        return JsonResponse(data=Success(), status=status.HTTP_205_RESET_CONTENT)


# Extract user_pk from header, find user from database, return user
def get_user(request): 
    _, token = request.headers.get("Authorization").split()
    payload = jwt.decode(token, SECRET_KEY, algorithms=ALGORITHM)
    user = User.objects.get(id=payload['user_id'])
    return user


# User History
class HistoryView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,) # Only Authorized users can access

    # Get user history information
    def get(self, request):
        user = get_user(request) # get user info

        # find user's uploads & pptx names
        upload_objects = Upload.objects.filter(user=user)
        history_list = []
        for upload in upload_objects:
            pptx_list = []
            material_objects = Material.objects.filter(upload=upload).values('material_name')
            for material in material_objects:
                pptx_list.append(material)

            history_list.append({
                "upload_id": upload.id,
                "material_list": pptx_list
            })

        data = {
            "history": history_list
        }
        return JsonResponse(data, status=status.HTTP_200_OK) 

"""
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
"""