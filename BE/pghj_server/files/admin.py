from django.contrib import admin
from files.models import Upload, Image, Material


class ImageInline(admin.TabularInline):
    model = Image
    extra = 0


class MaterialInline(admin.TabularInline):
    model = Material
    extra = 0


class UploadAdmin(admin.ModelAdmin):
    inlines = [ImageInline, MaterialInline]
    list_display = ['id', 'user', 'upload_path', 'uploaded_at']
    search_fields = ('id', )


admin.site.register(Upload, UploadAdmin)
