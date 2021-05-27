resource "aws_s3_bucket" "terraform-state" {
  bucket = "prasv"
  acl    = "private"

  tags = {
    Name = "Terraform state"
  }
}

