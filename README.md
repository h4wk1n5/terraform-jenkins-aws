# terraform-jenkins-aws

This will generate the required network configuration for Jenkins Master in an EC2 instance ready for initial setup.

Pre-requisites:
1-In your local machine configure your AWS profile
2-Add your own terraform.tfvars file
myip                  = "x.x.x.x/32"
myprofile             = "my-aws-profile"
jenkins_admin_pass    = "thisissosecret"
ami_key_pair_name     = "jenkins_server"
aws_region            = "my-region"
aws_availability_zone = "my-zone"
jenkins-ami-name      = "ami-0801f2dbf0b6f98c9" 

3-A keys directory with private and public key named as ami_key_pair_name=jenkins_server

Steps
Run terraform init; terraform validate; terraform apply

TODO
-store jenkins backup in S3
