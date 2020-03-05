variable "myip" {
  type        = string
  description = "my source IP"
}
variable "myprofile" {
  type        = string
  description = "my aws profile"
}

variable "jenkins_admin_pass" {
  type        = string
  description = "jenkins admin password"
}

variable "ami_key_pair_name" {}

variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "aws_availability_zone" {
  type        = string
  description = "a single aws availability zone within a region"
}

variable "jenkins-ami-name" {
  type       = string
}

