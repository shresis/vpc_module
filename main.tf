provider "aws" {
    region = "ap-south-1"
}

module "vpc-module" {
    source = "git::https://github.com/OpqTech/terraform-modules.git//modules/create_vpc"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "module-vpc"
    subnet_name = "module-subnet"
    subnet_cidr = "10.0.1.0/24"
    subnet_zone = "ap-south-1a"
    igw_name = "module-igw"
    public_rt_name = "module-rt"
}


resource "aws_s3_bucket" "remote-state" {
    bucket = "terraform-state-file-26072024"
    force_destroy = true 
}

resource "aws_s3_bucket_versioning" "s3-versioning" {
    bucket = aws_s3_bucket.remote-state.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_dynamodb_table" "remote-statelock" {
    name = "dynamodb-statelock"
    billing_mode = "PROVISIONED"
    read_capacity = 20
    write_capacity = 20
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
