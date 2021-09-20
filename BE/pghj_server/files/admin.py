from django.contrib import admin

from .models import Upload, Image, Material

class ImageInline(admin.TabularInline):
    model = Image

class MaterialInline(admin.TabularInline):
    model = Material

class UploadAdmin(admin.ModelAdmin):
    inlines = [ImageInline, MaterialInline]

admin.site.register(Upload, UploadAdmin)