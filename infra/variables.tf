variable "key_name" {
  description = "Name of your existing EC2 Key Pair"
  type        = string
}

variable "region" {
  description = "AWS region where resources will be created"
  default = "ap-south-1"
  type        = string
}
