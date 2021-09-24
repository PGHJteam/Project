variable "aws_region" {
  description = "The AWS region to deploy your instance"
  type        = string
  default     = "ap-northeast-2"
}

variable "name" {
  description = "Name Tag for the resources"
  type        = string
  default     = "pghj"
}