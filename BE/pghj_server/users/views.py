from django.http import JsonResponse
from rest_framework.parsers import JSONParser
from rest_framework import status, generics
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from pghj_server.responses import Success, Error
from users.serializers import UserSerializer
from files.models import Upload, Material

# Sign Up
class SignUpView(generics.GenericAPIView):
    permission_classes = (AllowAny,) # Anyone can access

    def post(self, request):
        data = JSONParser().parse(request)
        serializer = UserSerializer(data=data)

        if serializer.is_valid():
            serializer.save()
            return JsonResponse(data=Success(), status=status.HTTP_201_CREATED)     
        return JsonResponse(data=Error("Sign Up Failed."), status=status.HTTP_400_BAD_REQUEST)
        
# Sign Out
class SignOutView(generics.GenericAPIView):
    permission_classes = (AllowAny,) # Anyone can access
    
    def post(self, request):
        refresh_token = request.data.get('refresh')
        token = RefreshToken(token=refresh_token) # New refresh token
        token.blacklist()                         # Blacklist new refresh token
        return JsonResponse(data=Success(), status=status.HTTP_205_RESET_CONTENT)

# History
class HistoryView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,) # Only Authorized users can access

    def get(self, request):
        # find user's upload list
        upload_objs = Upload.objects.filter(user=request.user)
        history_lst = []
        for upload in upload_objs:
            pptx_lst = []
            material_objs = Material.objects.filter(upload=upload).values('material_name')
            for material in material_objs:
                pptx_lst.append(material)
            history_lst.append({
                "upload_id": upload.id,
                "material_list": pptx_lst
            })
        data = {
            "history": history_lst
        }
        return JsonResponse(data=data, status=status.HTTP_200_OK) 