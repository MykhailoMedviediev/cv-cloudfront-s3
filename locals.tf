locals {
  origin_id         = "cv-s3-origin"
  http_read_methods = ["HEAD", "GET"]

  tags = {
    ManagedBy = "Terraform"
    Owner     = "Mykhailo Medviediev"
  }
}
