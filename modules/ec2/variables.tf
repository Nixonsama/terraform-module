variable "ami" {
  default = "ami-0557a15b87f6559cf"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "tags" {
  default = "web"
}

variable "cider" {
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
  default = "dev"
}