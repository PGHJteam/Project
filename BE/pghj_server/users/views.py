from django.http import HttpResponse, JsonResponse
#from django.contrib.auth import authenticate
from rest_framework.parsers import JSONParser
from rest_framework import status, generics
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
# from rest_framework_simplejwt.tokens import RefreshToken

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
            return HttpResponse(status=status.HTTP_201_CREATED)
    
        return HttpResponse(status=status.HTTP_400_BAD_REQUEST)


# 로그인
'''@api_view(['POST'])              
@permission_classes([AllowAny]) # 누구나 접근 가능
def SignIn(request):
    if request.method == 'POST':
        data = JSONParser().parse(request) 

        # 인증 - DB에서 일치하는 아이디 찾고 비밀번호 맞는지 비교
        user = authenticate(  
            user_id=data['user_id'], 
            password=data['password']
            ) 

        # 유효한 유저 없으면 BAD_REQUEST 반환
        if user is None:
            return HttpResponse(status=status.HTTP_400_BAD_REQUEST)

        # 유효한 유저 있으면 해당 유저의 로그인 토큰 발급
        else:
            refresh = RefreshToken.for_user(user) 
            refresh_token = str(refresh)
            access_token = str(refresh.access_token)

            response = {
                'accessToken': access_token,
                'refreshToken': refresh_token 
            }

            return JsonResponse(response, status=status.HTTP_200_OK) '''


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
            return HttpResponse(status=status.HTTP_201_CREATED) 
        return HttpResponse(status=status.HTTP_400_BAD_REQUEST) 

    def delete(self, request): # 해당 유저 정보 삭제
        user = get_user(request)
        user.is_active = False
        user.save()
        return HttpResponse(status=status.HTTP_200_OK)