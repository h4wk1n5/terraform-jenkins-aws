data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_public" {
  vpc_id = "${data.aws_vpc.default_vpc.id}"
}

data "aws_security_group" "jenkins_server" {
  filter {
    name   = "group-name"
    values = ["jenkins_server"]
  }
  depends_on    =  ["aws_security_group.jenkins_server"]
}
