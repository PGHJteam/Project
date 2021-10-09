resource "aws_iam_instance_profile" "server" {
  name = "server"
  role = aws_iam_role.server.name
}

resource "aws_iam_role_policy_attachment" "server"{
  role = aws_iam_role.server.name
  policy_arn = aws_iam_policy.server.arn
}

resource "aws_iam_role" "server" {
  name = "server"
  path = "/"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
    EOF
}

resource "aws_iam_policy" "server" {
  name = "server"
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*",
          "s3-object-lambda:*"
        ],
        "Resource" : "*"
      },
    ]
  })
}