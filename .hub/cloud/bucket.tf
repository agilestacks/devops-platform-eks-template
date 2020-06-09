resource "aws_s3_bucket" "state" {
  bucket        = "agilestacks.${var.domain_name}"
  acl           = "private"

  versioning {
    enabled = true
  }

  tags = {
    Provider = "Agile Stacks Inc"
    Purpose  = "Automation state storage"
  }
}
