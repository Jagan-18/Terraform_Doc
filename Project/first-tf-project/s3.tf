# Now we can simple deploy the S3 bucket 
resource "random_id" "bucket_suffix" {
    byte_length = 6
}

resource "aws_s3_bucket" "example_bucket" {
    bucket = "example_bucket-${random_id.bucket_suffix.id}"
  
}

output "bucket_name" {
    value = aws_s3_bucket.example_bucket.bucket
  
}