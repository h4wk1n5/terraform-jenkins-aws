resource "aws_instance" "jenkins_server" {
  ami                    = "${var.jenkins-ami-name}"
  instance_type          = "t2.small"
  key_name               = "${var.ami_key_pair_name}"
  subnet_id              = "${aws_subnet.jenkins_subnet.id}"
  vpc_security_group_ids = ["${data.aws_security_group.jenkins_server.id}"]
  iam_instance_profile   = "jenkins_server"
  depends_on             = [aws_s3_bucket.jenkins-bucket]
  user_data              = "${data.template_file.jenkins_server.rendered}"



  tags = {
    "Name" = "jenkins_server"
  }
  root_block_device {
    delete_on_termination = true
  }
}

locals {
  subnet_ids_string = join(",", data.aws_subnet_ids.default_public.ids)
  subnet_ids_list   = split(",", local.subnet_ids_string)
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
  key_name   = "${var.ami_key_pair_name}"
  public_key = "${file("keys/jenkins_server.pub")}"
}

data "template_file" "jenkins_server" {
  template = "${file("scripts/jenkins_cloudinit.yml")}"
}

output "jenkins_server_public_ip" {
  value = "${aws_instance.jenkins_server.public_ip}"
}

output "jenkins_server_private_ip" {
  value = "${aws_instance.jenkins_server.private_ip}"
}

output "key_name" {
  value = "${aws_instance.jenkins_server.key_name}"
}

output "key_value" {
  value = "${aws_key_pair.jenkins_server.public_key}"
}


