from rest_framework import serializers
from files.models import Material, Image, Upload
from files.s3 import get_path

 
class MaterialSerializer(serializers.ModelSerializer):
    def create(self, validated_data):
        material = Material.objects.create(
            upload=validated_data['upload'], 
            material_path=validated_data['material_path'],
            material_name=validated_data['material_name'],
            material_template=validated_data['material_template']
        )
        return material
    
    class Meta:
        model = Material
        fields = ('upload', 'material_name', 'material_path', 'material_template')