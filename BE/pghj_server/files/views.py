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
    
from files.s3 import S3ImageUpload, S3FileUpload

def get_path(user_id, upload_id):
    return user_id + "/upload" + str(upload_id) + "/"


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
        pptx_name = user.user_id + "_upload" + str(upload_id) + "_" + data['material_name']
        s3_path = get_path(user.user_id, upload_id)      # Path for s3
        pptx_path = create_pptx(data, pptx_name)         # Path for local
        
        # Save the pptx into S3 storage
        S3FileUpload(pptx_path + pptx_name, s3_path + pptx_name)
                
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
        # Get user info from header
        user = get_user(request)

        # Create Upload
        upload = Upload.objects.create(user=user)
        upload.upload_path = get_path(user.user_id, upload.id)
        upload.save()

        
        # Get image data
        images = request.FILES
        image_type = request.POST['image_type']
        
        image_path = get_path(user.user_id, upload.id) + "images/"
        image_list = [] # List of images
        
        # Save images into storage & database
        for i in range(len(images)): 
            image = images['image'+str(i)]         # Get image file
            image_name = str(i) + '_' + image.name
            
            S3ImageUpload(image, image_path+image_name) # Save image into S3 storage 
            
            Image.objects.create(         # Save image into database
                upload = upload,
                image_path = image_path,
                image_name = image_name,
                image_type = image_type,
            )

            image_list.append(image_name) # Make image_name list
        
        # Extract text from images 
        result = detect_recognition(image_list, image_type)   ##### 이부분을 image 직접 넘기는 방향으로?

        # Get json format response
        data = JsonFormat(result, image_list, upload.id)

        #data ={} # compile
        return JsonResponse(data=data, status=status.HTTP_200_OK)