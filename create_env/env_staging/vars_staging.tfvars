aws_region    = "us-east-1"
port_list     = ["80", "443", "8443"]
instance_size = "t2.micro"
key_pair      = "OhioKey"

tags = {
  Owner       = "Dilshad"
  Environment = "Staging"
  Project     = "tfawsreuse"
  Code        = "234567"
}

bg_list = ["blue", "green"]
