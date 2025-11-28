# Find the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Official Ubuntu owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create a Security Group to allow HTTP and SSH traffic
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = var.vpc_id

  # HTTP (Port 80)
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH (Port 22)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# Create Key Pair for SSH access
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key_material
}

# Create EC2 Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  key_name = aws_key_pair.deployer.key_name

  # Attach security group
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User data to install Netdata
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y ca-certificates curl gnupg lsb-release

              mkdir -p /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              
              apt-get update
              apt-get install -y docker-ce docker-ce-cli containerd.io

              # -p 80:19999 -> 
              # -v /proc... -> 
              docker run -d --name=netdata \
                -p 80:19999 \
                -v netdataconfig:/etc/netdata \
                -v netdatalib:/var/lib/netdata \
                -v netdatacache:/var/cache/netdata \
                -v /etc/passwd:/host/etc/passwd:ro \
                -v /etc/group:/host/etc/group:ro \
                -v /proc:/host/proc:ro \
                -v /sys:/host/sys:ro \
                -v /etc/os-release:/host/etc/os-release:ro \
                --restart unless-stopped \
                --cap-add SYS_PTRACE \
                --security-opt apparmor=unconfined \
                netdata/netdata
              EOF

  tags = {
    Name = "${var.project_name}-ec2"
  }
}