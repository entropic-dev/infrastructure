resource "aws_instance" "entropic_dev" {
  ami                         = "ami-005bdb005fb00e791"
  disable_api_termination     = true
  associate_public_ip_address = true
  availability_zone           = "us-west-2a"
  instance_type               = "t3.medium"
  ebs_optimized               = true
  key_name                    = "ceejbotaws"
  security_groups             = ["basic web server"]
  tags                        = {
    Name                      = "entropic.dev"
  }
}

resource "aws_instance" "discourse" {
  ami                         = "ami-005bdb005fb00e791"
  disable_api_termination     = true
  associate_public_ip_address = true
  availability_zone           = "us-west-2a"
  instance_type               = "t3a.medium"
  ebs_optimized               = true
  key_name                    = "ceejbotaws"
  security_groups             = ["basic web server"]
  tags                        = {
    Name                      = "discourse.entropic.dev"
    name                      = "discourse.entropic.dev"
  }
}
