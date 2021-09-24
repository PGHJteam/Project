from django.db import models

from users.models import User


class Upload(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=False)
    uploaded_at = models.DateTimeField("DATE", auto_now=True)

    def __str__(self):
        return "Upload id: " + str(self.id)

    class Meta:
        db_table = "uploads"


class Image(models.Model):
    upload = models.ForeignKey(Upload, on_delete=models.CASCADE)
    image = models.ImageField("PATH", upload_to = "images/", null=False, blank=False)
    image_type = models.CharField("TAG", max_length=10, default="etc")

    class Meta:
        db_table = "images"


class Material(models.Model):
    upload = models.ForeignKey(Upload, on_delete=models.CASCADE)
    material = models.CharField("PATH", max_length=200)
    material_tag = models.CharField("TAG", max_length=20)
    material_template = models.CharField("TEMPLATE", max_length=200)

    class Meta:
        db_table = "materials"