from django.http import JsonResponse
from rest_framework.parsers import JSONParser
from rest_framework import status, generics
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated

import jwt
from pghj_server.settings import SECRET_KEY, ALGORITHM

from .models import User
from .serializers import UserSerializer


# 회원가입 
@api_view(['POST'])
@permission_classes([AllowAny]) # 누구나 접근 가능
def SignUp(request):
    if request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            response_data = {'detail': 'SUCCESS'}
            response_status = status.HTTP_201_CREATED
        else:
            response_data = {'detail': 'ERROR: Invalid format or invalid values.'}
            response_status = status.HTTP_400_BAD_REQUEST

        return JsonResponse(data=response_data, status=response_status)
        

# 헤더 토큰에서 유저 기본키 식별 후 해당 유저를 반환
def get_user(request): 
    key, token = request.headers.get("Authorization").split()
    payload = jwt.decode(token, SECRET_KEY, algorithms=ALGORITHM)
    user = User.objects.get(id=payload['user_id'])
    return user


# 해당 유저 정보 조회/수정/삭제
class UserView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,) # 인증된 사용자(토큰 있는 사용자)만 접근 가능

    def get(self, request): # 해당 유저 정보 조회
        user = get_user(request)
        serializer = UserSerializer(user) 
        return JsonResponse(serializer.data, status=status.HTTP_200_OK) 

    def put(self, request): # 해당 유저 정보 수정
        user = get_user(request)
        data = JSONParser().parse(request)
        serializer = UserSerializer(user, data=data) 
        if serializer.is_valid(): 
            serializer.save() 
            response_data = {'detail': 'SUCCESS'}
            response_status = status.HTTP_201_CREATED
        else:
            response_data = {'detail': 'ERROR: Invalid format or invalid values.'}    
            response_status = status.HTTP_400_BAD_REQUEST

        return JsonResponse(data=response_data, status=response_status) 

    def delete(self, request): # 해당 유저 정보 삭제
        user = get_user(request)    
        user.is_active = False
        user.save()
        response_data = {'detail': 'SUCCESS'}
        response_status = status.HTTP_200_OK
        return JsonResponse(data=response_data, status=response_status)