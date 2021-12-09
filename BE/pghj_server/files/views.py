from django.http import JsonResponse, FileResponse
from rest_framework import status, generics
from rest_framework.parsers import JSONParser
from django.core.files.storage import FileSystemStorage
from rest_framework.permissions import IsAuthenticated
from files.serializers import MaterialSerializer
from pghj_server.settings import MEDIA_DIR
from files.models import Upload, Image
from models.views import detect_recognition
from files.convert import get_json
from files.s3 import s3_upload, get_path
from files.pptx import create_pptx
from pghj_server.responses import Error


class MaterialView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # Create pptx, Return path
    def post(self, request):
        # Extract data from request
        user = request.user       
        data = JSONParser().parse(request)
        
        upload = Upload.objects.get(pk=data['upload_id'])
        template_id = data['template_id']

        # Make pptx
        pptx_name = data['material_name']
        pptx_path = get_path(user.user_id, upload.id)        # S3 path
        local_path = create_pptx(data, pptx_path, pptx_name) # local path    
                
        # Save the pptx into S3 storage
        s3_upload(local_path+pptx_name, pptx_path+pptx_name)
                
        # Save the pptx info into database & return json format response        
        material = {
            'upload': upload.id,
            'material_path': local_path,
            'material_name': pptx_name,
            'material_template': template_id
        }
        
        serializer = MaterialSerializer(data=material)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(data=serializer.data, status=status.HTTP_200_OK)
        return JsonResponse(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class DownloadView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # Return pptx
    def post(self, request):
        data = JSONParser().parse(request) 
        name = data['material_name']
        path = data['material_path']       
                 
        try:
            file = open(path+name, 'rb')
        except FileNotFoundError:
            return JsonResponse(data=Error("File Not Found Error."), status=status.HTTP_400_BAD_REQUEST)

        response = FileResponse(file, headers={
            'Content-Type': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            'Content-Disposition': 'attachment; filename={name}',
        })
        return response


class ImageView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # Save images, Return text
    def post(self, request):    
        user = request.user
                
        # Create Upload
        upload = Upload.objects.create(user=user)
        upload.upload_path = get_path(user.user_id, upload.id)
        upload.save()
                
        # Get image data
        images = request.FILES
        image_type = request.POST['image_type']
        s3_path = get_path(user.user_id, upload.id) + "images/"
        local_path = MEDIA_DIR + s3_path
        
        # Save images into storage & database
        fs = FileSystemStorage(location=local_path, base_url=local_path)
        for i in range(len(images)): 
            image = images['image'+str(i)]                          # Get image file
            save_image = fs.save(image.name, image)                 # save image into local storage
            image_name = fs.url(save_image).split('/')[-1]
            
            s3_upload(local_path+image_name, s3_path+image_name)  # save image into S3 storage 
            Image.objects.create(                                 # save image into database
                upload = upload,
                image_path = s3_path,
                image_name = image_name,
                image_type = image_type,
            )
        
        ## 소켓통신 ##
        ## 1. 텍스트추출
        ## 2. s3 이미지 업로드
        
        ## 배치 ##
        ## 1. 이미지 일괄 삭제(업로드 이후 24시간 지나면)
        
        # Extract text from images 
        result = detect_recognition(local_path, image_type)

        # convert result into json format, and return it
        data = get_json(result, upload.id)
    
        return JsonResponse(data=data, status=status.HTTP_200_OK)