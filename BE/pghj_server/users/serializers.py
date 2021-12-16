from rest_framework import serializers
from users.models import User


class UserSerializer(serializers.ModelSerializer):
    def create(self, validated_data):
        user = User.objects.create_user(
            user_id = validated_data['user_id'],
            password = validated_data['password'],
            user_name = validated_data['user_name'],
            #user_email = validated_data['user_email'],
        )
        return user

    class Meta:
        model = User
        fields = ('user_id', 'password', 'user_name')