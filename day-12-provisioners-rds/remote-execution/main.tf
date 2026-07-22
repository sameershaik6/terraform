provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "mykey"
  public_key = file("C:/Users/samee/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "ec2_sg" {
  name = "sql-runner-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sql_runner" {
  ami                         = "ami-0b826bb6d96d2afe4"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.example.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "SQL Runner"
  }
}

# Use null_resource to execute the SQL script from ec2 server
resource "null_resource" "remote_sql_exec" {
  depends_on = [aws_instance.sql_runner]   #changed

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/samee/.ssh/id_ed25519")
    host        = aws_instance.sql_runner.public_ip
    timeout     = "5m"
  }

#copy init.sql file from local to ec2 remote
  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

#will run this commands to install mariadb and connect to db and run sql queries
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install mariadb105-server -y",
      "mysql -h my-mysql-db.ca7w4oagy9pu.us-east-1.rds.amazonaws.com -u admin -pPassword123! dev < /tmp/init.sql"
    ]
  }

#it will every time we apply 
  triggers = {
    always_run = timestamp()
  }
}

#