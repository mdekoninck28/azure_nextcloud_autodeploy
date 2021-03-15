#variable image name
variable "image_name" {
  type    = string
  default = "image"
}

#variable resource group
variable "resourcegroup" {
  type	  = string
  default = "resourcegroup1"
}

#variable OS Author
variable "os_type" {
  type	  = string
  default = "Linux"
}

#variable Editeur de l'OS à installer
variable "image_publisher" {
  type    = string
  default = "Canonical"
}

#variable OS Name
variable "image_offer" {
  type    = string
  default = "UbuntuServer"
}

#variable OS Version
variable "image_sku" {
  type    = string
  default = "18.04-LTS"
}

#variable Department
variable "dept" {
  type    = string
  default = "test"
}

#variable client ID
variable "client_id" {
  type    = string
}

#variable client secret
variable "client_secret" {
  type    = string
}

#variable subscription ID
variable "subscription_id" {
  type    = string
}

#variable tenant ID
variable "tenant_id" {
  type    = string
}

