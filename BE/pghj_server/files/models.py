from django.db import models

from users.models import User


class Upload(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=False)
    uploaded_at = models.DateTimeField("업로드 날짜", auto_now=True)

    class Meta:
        db_table = "uploads"


class Image(models.Model):
    upload = models.ForeignKey(Upload, on_delete=models.CASCADE)
    image = models.ImageField("이미지", upload_to = "images/")
    image_type = models.CharField("이미지 타입", max_length=10)

    class Meta:
        db_table = "images"


class Material(models.Model):
    upload = models.ForeignKey(Upload, on_delete=models.CASCADE)
    #material_path = models.CharField("자료 경로", max_length=200)
    #material = models.FileField()
    material_tag = models.CharField("자료 과목분류", max_length=20)
    material_template = models.CharField("템플릿 정보", max_length=200)

    class Meta:
        db_table = "materials"