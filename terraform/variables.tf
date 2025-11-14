variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  default     = "jenkins1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS"
  default     = "ami-0dee22c13ea7a9a67"
}
