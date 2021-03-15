variable "location" {
  type  = string
  default = "eastus"
}

variable "prefix" {
  type    = string
  default = "tf"
}

variable "tags" {
  type = map

  default = {
    Environment = "Terraform GS"
    Dept        = "Engineering"
  }
}

variable "name" {
    type    = string
    default = "tf1"
}

variable "image" {
    type    = string
    default = "image1"
}

variable "resourcegroup" {
    type = string
    default = "resourcegroup1"
}

variable "azureuser_password" {
    type = string
}
