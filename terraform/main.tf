terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#Declare the resource group to use

data "azurerm_resource_group" "rg" {
  name     = var.resourcegroup
}

#Declare the image to use

data "azurerm_image" "image" {
  name                = var.image
  resource_group_name = data.azurerm_resource_group.rg.name
}

#Create virtual private network for the VM

resource "azurerm_virtual_network" "vnet" {
  name = "network01"
  address_space = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

#Create virtual private subnet

resource "azurerm_subnet" "subnet" {
  name                 = "subnet01"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#Create virtual network adapter

resource "azurerm_network_interface" "nic" {
  name                      = "myNIC"
  location                  = var.location
  resource_group_name       = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

#Create Public IP

resource "azurerm_public_ip" "publicip" {
  name                = "myTFPublicIP"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

#Configure SSH

resource "azurerm_network_security_group" "nsg" {
  name                = "myTFNSG"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Create VM in Azure

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-${var.name}"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    id                = data.azurerm_image.image.id
  }

  os_profile {
    computer_name = "${var.prefix}-VM-1"
    admin_username       = "azureuser"
    admin_password       = var.azureuser_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

}

