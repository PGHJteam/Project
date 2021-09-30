from django.http import JsonResponse, FileResponse
from rest_framework import status, generics
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated

from files.models import Upload, Material, Image
from files.serializers import MaterialSerializer
from files.make_pptx import get_pptx
from users.views import get_user


class MaterialView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]


    def post(self, request): # ppt 파일 생성 요청
        user = get_user(request) # 토큰에서 유저 정보 분리하여 유저 식별 (유저아이디가 넘어옴?)
        upload = Upload.objects.create(user=user)
        data = JSONParser().parse(request) # json 에서 정보 분리하기
        path = get_pptx(data, user.user_id, upload.id) # ppt 만들어서 저장 경로 반환하기

        serializer = MaterialSerializer(  # DB에 ppt 저장하고, 저장정보 json으로 반환하기
            data={
                'upload': upload.id, 
                'material': path, 
                'material_template': data['template_id']
            }
        )

        if serializer.is_valid():
            return JsonResponse(data=serializer.data, status=status.HTTP_200_OK) # ppt 저장된 위치에서 ppt 파일로 반환해주기
        
        return JsonResponse(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)


    def get(self, request): # ppt 파일 다운로드 요청
        data = JSONParser().parse(request)
        path = data['path']

        try:
            file = open(path, 'rb')

        except FileNotFoundError:
            return JsonResponse(data={"detail": "File Not Found Error."}, status=status.HTTP_400_BAD_REQUEST)
        
        else:
            return FileResponse(file)


'''class ImageView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # 이미지 업로드
    def post(self, request):
        user = get_user(request) # 유저 식별

        # upload 만들기
        upload = Upload.objects.create(user=user) 

        # image 만들기
        try:
            images = request.FILES.getlist('images')
            image_type = request.POST['image_type']

            for image in images:
                Image.objects.create(
                    upload=upload,
                    image=image,
                    image_type=image_type,
                )
        except:
            response_data = {'detail': 'ERROR: Invalid format or invalid values.'}
            response_status = status.HTTP_400_BAD_REQUEST
        else:
            response_data = {'detail': 'SUCCESS'}
            response_status = status.HTTP_200_OK

        return JsonResponse(data=response_data, status=response_status)'''