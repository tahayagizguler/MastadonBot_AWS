variable "bucket_name" {
  type = string
}

variable "region" {  
  type        = string  
  default     = "us-east-1"  
  description = "Name of the s3 bucket to be created."
}
