#Create AWS S3 Bucket

resource "aws_s3_bucket" "levelup-s3bucket" {
  bucket = "levelup-bucket-34561"
  acl    = "private"

  tags = {
    Name = "levelup-bucket-34561"
  }
}

