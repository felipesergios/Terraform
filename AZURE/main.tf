resource "azurerm_resource_group" "RGS" {
  name     = "RGS-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "RGS" {
  name                = "RGS-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RGS.location
  resource_group_name = azurerm_resource_group.RGS.name
}

resource "azurerm_subnet" "RGS" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.RGS.name
  virtual_network_name = azurerm_virtual_network.RGS.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "RGS" {
  name                = "RGS-nic"
  location            = azurerm_resource_group.RGS.location
  resource_group_name = azurerm_resource_group.RGS.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.RGS.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "RGSVMAPP" {
  name                = "dev-machine"
  resource_group_name = azurerm_resource_group.RGS.name
  location            = azurerm_resource_group.RGS.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.RGS.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}