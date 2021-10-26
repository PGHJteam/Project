from django.core.files.storage import FileSystemStorage
from django.http import JsonResponse, FileResponse
from rest_framework import status, generics
from rest_framework.parsers import JSONParser
from rest_framework.permissions import IsAuthenticated

from files.models import Upload, Material, Image
from files.serializers import MaterialSerializer
from files.pptx import create_pptx
from users.views import get_user
from pghj_server.responses import Error, JsonFormat
from models.views import detect_recognition


# View for PPTX
class MaterialView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # Create pptx, Return path
    def post(self, request):
        # Get user info from the header
        user = get_user(request)
        
        # Extract data from request
        data = JSONParser().parse(request)
        upload_id = data['upload_id']
        template_id = data['template_id']

        # Make pptx
        pptx_path = user.user_storage + str(upload_id) + "/" # Path to save pptx
        pptx_name = create_pptx(data, pptx_path, upload_id)

        # Save the pptx info into database & return json format response
        serializer = MaterialSerializer(
            data={
                'upload': upload_id, 
                'material_path': pptx_path,
                'material_name': pptx_name, 
                'material_template': template_id
            }
        )
        if serializer.is_valid(): # If serializer is valid, save data
            serializer.save()
            return JsonResponse(data=serializer.data, status=status.HTTP_200_OK)
        return JsonResponse(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# View for PPTX
class DownloadView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # Download pptx, Return pptx
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

# View for Image
class ImageView(generics.GenericAPIView):
    permission_classes = [IsAuthenticated, ]

    # Upload images, Return text
    def post(self, request):
        image_list = [] # List of Image name

        # Get user info from header
        user = get_user(request)

        # Create Upload
        upload = Upload.objects.create(user=user)
        upload.upload_path = user.user_storage + str(upload.id)
        upload.save()

        # Get image data
        images = request.FILES
        image_type = request.POST['image_type']
        image_path = upload.upload_path + "/images/"
        
        # Save images into storage & database
        fs = FileSystemStorage(location=image_path, base_url=image_path)
        for i in range(len(images)): 
            image = images['image'+str(i)]          # Get json key
            save_image = fs.save(image.name, image) # Save image into storage
            image_url = fs.url(save_image)          # Get image_url from the saved image
            image_name = image_url.split('/')[-1]   # 개발환경에서는 image_url에 이미지 이름 찍힘. 서버에서는 image_urll에 이미지 경로 찍힘

            Image.objects.create(        # Save image into database (이미지 시리얼라이저?)
                upload = upload,
                image_path = image_path,
                image_name = image_name,
                image_type = image_type,
            )

            image_list.append(image_name) # Make image_name list
        
        # Extract text from images  
        result = detect_recognition(image_path, image_type)

        # Get json format response
        data = JsonFormat(result, image_list, upload.id)

        # data ={} # compile
        return JsonResponse(data=data, status=status.HTTP_200_OK)