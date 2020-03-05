#VPC

resource "aws_vpc" "dev_jenkins" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev_jenkins"
  }
}

# Security group

resource "aws_security_group" "jenkins_server" {
  name        = "jenkins_server"
  description = "Jenkins Server: created by Terraform for ${var.myprofile}"
  vpc_id      = "${aws_vpc.dev_jenkins.id}"

  tags = {
    Name = "jenkins_server"
    env  = "dev_jenkins"
  }
}

resource "aws_security_group_rule" "jenkins_server_from_source_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["${var.myip}", "10.0.0.0/16"]
  description       = "ssh to jenkins_server"
}

resource "aws_security_group_rule" "jenkins_server_from_source_ingress_webui" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "jenkins server web"
}

resource "aws_security_group_rule" "jenkins_server_from_source_ingress_jnlp" {
  type              = "ingress"
  from_port         = 33453
  to_port           = 33453
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["10.0.0.0/16"]
  description       = "jenkins server JNLP Connection"
}

resource "aws_security_group_rule" "jenkins_server_to_other_machines_ssh" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins servers to ssh to other machines"
}

resource "aws_security_group_rule" "jenkins_server_outbound_all_80" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins servers for outbound to repo"
}

resource "aws_security_group_rule" "jenkins_server_outbound_all_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins_server.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow jenkins servers for outbound to repo"
}

resource "aws_internet_gateway" "jenkins_gw" {
  vpc_id = "${aws_vpc.dev_jenkins.id}"

  tags = {
    Name = "dev_jenkins"
  }
}

resource "aws_route_table" "jenkins_route_table" {
  vpc_id = "${aws_vpc.dev_jenkins.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jenkins_gw.id}"
  }
}

resource "aws_subnet" "jenkins_subnet" {
  cidr_block = "${cidrsubnet(aws_vpc.dev_jenkins.cidr_block, 3, 1)}"
  vpc_id     = "${aws_vpc.dev_jenkins.id}"
  availability_zone =  "us-west-1a"
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.jenkins_subnet.id}"
  route_table_id = "${aws_route_table.jenkins_route_table.id}"
}
