from django.http import HttpResponse, JsonResponse
# from rest_framework.parsers import JSONParser
from rest_framework import status, generics
# from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

from files.models import Upload, Material, Image

from users.views import get_user


class FileView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # 이미지 업로드
    def post(self, request):
        user = get_user(request) # 유저 식별

        # upload 만들기
        upload = Upload.objects.create(user=user) 
                
        # image 만들기
        images = request.FILES.getlist('image')
        image_type = request.POST['image_type']
        print(images)

        for image in images:
            Image.objects.create(
                upload=upload,
                image = image,
                image_type = image_type,
            )

        return HttpResponse(status=status.HTTP_200_OK)