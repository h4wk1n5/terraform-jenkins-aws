resource "aws_instance" "jenkins_server" {
  ami                    = "ami-951945d0"
  instance_type          = "t1.micro"
  key_name               = "${aws_key_pair.jenkins_server.key_name}"
  subnet_id              =  local.subnet_ids_list[0]
  vpc_security_group_ids = ["${data.aws_security_group.jenkins_server.id}"]
  iam_instance_profile   = "jenkins_server"
  depends_on             = [aws_s3_bucket.jenkins-bucket]
}

locals {
  subnet_ids_string = join(",", data.aws_subnet_ids.default_public.ids)
  subnet_ids_list = split(",", local.subnet_ids_string)
}

resource "aws_s3_bucket" "jenkins-bucket" {
  bucket = "jenkins-master-terraform-us-west-1"
  acl    = "private"

}

resource "aws_eip" "jenkins_ip" {
  vpc      = true
  instance = aws_instance.jenkins_server.id
}

resource "aws_key_pair" "jenkins_server" {
  key_name   = "jenkins_server"
  public_key = "${file("keys/jenkins_key.pub")}"
}
