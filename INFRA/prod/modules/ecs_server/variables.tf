variable "vpc_id" {
  description = ""
  type        = string
  default     = ""
}

variable "ecs_sg_port" {
  description = ""
  type        = list(any)
  default     = []
}

variable "ecs_iam_role" {
  description = ""
  type        = string
  default     = ""
}

variable "ecs_subnets" {
  description = ""
  type        = list(string)
  default     = []
}