from django.http import JsonResponse, FileResponse
from rest_framework import status, generics
from rest_framework.parsers import JSONParser
from django.core.files.storage import FileSystemStorage
from rest_framework.permissions import IsAuthenticated
from files.serializers import MaterialSerializer
from pghj_server.settings import MEDIA_DIR
from files.models import Upload, Image
from files.convert import convert
from files.detection_recognition import detection_recognition
from files.s3 import s3_upload, get_path
from files.pptx import create_pptx
from pghj_server.responses import Error


class MaterialView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]
    serialize_class = MaterialSerializer

    # Create pptx, Return path
    def post(self, request):
        user = request.user
        upload_id = request.data.get('upload')
        template_id = request.data.get('template_id')
        file_name = request.data.get('material_name')
        items = request.data.get('items', {})
        path = get_path(user.user_id, upload_id)             
        local_path = MEDIA_DIR + path 
        
        # Serialize       
        serialized_data = {
            'upload': upload_id,
            'material_path': local_path,
            'material_name': file_name,
            'material_template': template_id
        }
        serializer = self.serialize_class(data=serialized_data)
        if serializer.is_valid():
            serializer.save()
            
            create_pptx(template_id, local_path, file_name, items) # Create pptx 
            local_path += file_name    # ppt파일이 저장된 서버 스토리지 경로 
            s3_path = path + file_name # ppt파일을 업로드할 s3 스토리지 경로
            s3_upload(local_path, s3_path) # Upload pptx to S3
            
            return JsonResponse(data=serializer.data, status=status.HTTP_200_OK)
        return JsonResponse(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class DownloadView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # Return pptx
    def post(self, request):
        name = request.data.get('material_name')
        path = request.data.get('material_path')       
                 
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
        image_type = request.data.get('image_type')
        path = get_path(user.user_id, upload.id) + 'images/'
        local_path = MEDIA_DIR + path
        
        # Save images into storage & database
        fs = FileSystemStorage(location=local_path, base_url=local_path)
        for i in range(len(images)): 
            image = images['image'+str(i)] # Get image file
            fs.save(image.name, image)     # save image into local storage           
            Image.objects.create(          # save image into database
                upload = upload,
                image_path = path,
                image_name = image,
                image_type = image_type,
            )
            
            local_path += str(image)
            s3_path = path + str(image)
            s3_upload(local_path, s3_path)  # save image into S3 storage 
        
        # Extract text from images 
        result = detection_recognition(local_path, image_type)

        # convert result into json format, and return it
        data = convert(result, upload.id)
        return JsonResponse(data=data, status=status.HTTP_200_OK)