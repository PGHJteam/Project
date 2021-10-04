from django.db import models

from users.models import User


class Upload(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=False)
    upload_path = models.CharField("Upload Path", max_length=200)
    uploaded_at = models.DateTimeField("DATE", auto_now=True)

    def __str__(self):
        return "Upload id: " + str(self.id)

    class Meta:
        db_table = "uploads"


class Image(models.Model):
    upload = models.ForeignKey(Upload, on_delete=models.CASCADE)
    image_path = models.CharField("PATH", max_length=200)
    image_type = models.CharField("TAG", max_length=10, default="etc-ocr")

    def __str__(self):
        return "Image id: " + str(self.id)

    class Meta:
        db_table = "images"


class Material(models.Model):
    upload = models.ForeignKey(Upload, on_delete=models.CASCADE)
    material = models.CharField("PATH", max_length=200) 
    # material_tag = models.CharField("TAG", max_length=20)
    material_template = models.CharField("TEMPLATE", max_length=20, default="template00") 

    def __str__(self):
        return "Material id: " + str(self.id)

    class Meta:
        db_table = "materials"