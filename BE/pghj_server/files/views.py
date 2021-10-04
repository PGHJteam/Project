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
        pptx_dir = user.user_storage + upload_id + "/" # Path to save pptx
        path = create_pptx(data, pptx_dir, upload_id)

        # Save the pptx info into database & return json format response
        serializer = MaterialSerializer(
            data={
                'upload': upload_id, 
                'material': path, 
                'material_template': data['template_id']
            }
        )
        if serializer.is_valid(): # If serializer is valid, save data
            serializer.save()
            return JsonResponse(data=serializer.data, status=status.HTTP_200_OK)
        return JsonResponse(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    # Download pptx, Return pptx
    def get(self, request):
        data = JSONParser().parse(request) 
        path = data['path']                
        try:
            file = open(path, 'rb')
        except FileNotFoundError:
            return JsonResponse(data=Error("File Not Found Error."), status=status.HTTP_400_BAD_REQUEST)
        return FileResponse(file)


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
        upload.upload_path = user.user_storage + str(upload.id) + "/images/"
        upload.save()

        # Get image data
        images = request.FILES
        image_type = request.POST['image_type']
        
        # Save images into storage & database
        fs = FileSystemStorage(location=upload.upload_path, base_url=upload.upload_path)
        for i in range(len(images)): 
            image = images['image'+str(i)]          # Get json key
            save_image = fs.save(image.name, image) # Save image into storage
            image_name = fs.url(save_image)         # Get image_name from the saved image

            img = Image.objects.create(             # Save image into database
                upload = upload,
                image_path = upload.upload_path+image_name,
                image_type = image_type,
            )

            image_list.append(image_name)            # Make image_name list
        
        # Extract text from mages  
        result = detect_recognition(upload.upload_path, image_type)

        # Get json format response
        data = JsonFormat(result, image_list, upload.id)

        return JsonResponse(data=data, status=status.HTTP_200_OK)