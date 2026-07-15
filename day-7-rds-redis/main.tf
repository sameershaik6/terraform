resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
   tags = {
    Name = "my-subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
   tags = {
    Name = "my-subnet-2"
  }
}

#create a security group for the RDS instance
resource "aws_security_group" "sg" {
    name        = "my-security-group"
    description = "Allow access to the RDS instance from within the VPC"
    vpc_id      = aws_vpc.vpc.id
    ingress {
      description = "Allow MySQL access from within the VPC"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }
    egress {
      description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#create a security group for the Redis cache
resource "aws_security_group" "redis_sg" {
  name        = "my-redis-security-group"
  description = "Allow Redis access from within the VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create a DB subnet group for the RDS instance
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  tags = {
    Name = "my-db-subnet-group"
  }
}

#create a MySQL RDS instance
resource "aws_db_instance" "db_instance" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  identifier           = "mysamdatabase"
  username             = "admin"
  password             = "password123"  #selfmanaged_master_user_password
  #manage_master_user_password = "password123" #secret managed password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg.id]
  skip_final_snapshot   = true
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_retention_period = 7
}

#create a read replica of the RDS instance
# resource "aws_db_instance" "db_replica" {
#   count                 = 1
#   replicate_source_db   = aws_db_instance.db_instance.id
#   instance_class        = "db.t3.micro"
#   identifier            = "mysamdatabase-replica-${count.index + 1}"
#   #db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.sg.id]
#   skip_final_snapshot    = true
# }

#create a serverless Redis cache
resource "aws_elasticache_serverless_cache" "redis" {
  name                 = "mysam-serverless-redis"
  description          = "Serverless Redis cache"
  engine               = "redis"
  major_engine_version = "7"

  subnet_ids = [
    aws_subnet.subnet-1.id,
    aws_subnet.subnet-2.id
  ]

  security_group_ids = [aws_security_group.redis_sg.id]
}