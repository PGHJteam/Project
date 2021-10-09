resource "aws_iam_instance_profile" "bastion" {
  name = "bastion"
  role = aws_iam_role.bastion.name
}

resource "aws_iam_role" "bastion" {
  name = "bastion"
  path = "/" # 이게뭐지

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "State" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "bastion" {
  name = "bastion"
  role = aws_iam_role.bastion.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:List*"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}