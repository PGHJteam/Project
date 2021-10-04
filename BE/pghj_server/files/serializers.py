from rest_framework import serializers

from files.models import Material

class MaterialSerializer(serializers.ModelSerializer):
    def create(self, validated_data):
        print(validated_data)
        material = Material.objects.create(
            upload=validated_data['upload'],
            material=validated_data['material'],
            material_template=validated_data['material_template']
        )
        return material

    class Meta:
        model = Material
        fields = ('upload', 'material', 'material_template')
