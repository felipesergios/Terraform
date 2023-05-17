resource "aws_vpc" "RocketVPC" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "rc-vpc"
  }
}

resource "aws_subnet" "RocketDEV" {
  vpc_id            = aws_vpc.RocketVPC.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "rc-vpc"
  }
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "DockerSRV" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "c6a.2xlarge"
  subnet_id     = aws_subnet.RocketDEV.id

  cpu_options {
    core_count       = 2
    threads_per_core = 4
  }

  tags = {
    Name = "rc-vm-dev"
  }
}