variable "aws_region" {
  description = "Region where you want to provision this EC2 WebServer"
  type        = string // number , bool
  default     = "us-east-1"
}

variable "port_list" {
  description = "List of Port to open for our WebServer"
  type        = list(any)
}

variable "instance_size" {
  description = "EC2 Instance Size to provision"
  type        = string
}

variable "tags" {
  description = "Tags to Apply to Resources"
  type        = map(any)
  default = {
    Owner       = "Dilshad"
    Environment = "Prod"
    Project     = "tfawsreuse"
  }
}

variable "key_pair" {
  description = "SSH Key pair name to ingest into EC2"
  type        = string
  default     = "OhioKey"
  sensitive   = true
}

/*
variable "password" {
  description = "Please Enter Password lenght of 10 characters!"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.password) == 10
    error_message = "Your Password must be 10 characted exactly!!!"
  }
}*/

variable "bg_list" {
  description = "Blue Green indicator list"
  type        = list(any)
  default     = ["blue", "green"]
}