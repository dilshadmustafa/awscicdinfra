aws_region    = "us-east-1"
port_list     = ["80", "443", "8443"]
instance_size = "t3.large"
key_pair      = "OhioKey"

tags = {
  Owner       = "Dilshad"
  Environment = "Prod"
  Project     = "tfawsreuse"
  Code        = "123456"
}

bg_list = ["blue", "green"]
