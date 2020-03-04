# create subnet================================================================================
resource "azurerm_subnet" "mySubnet" {
  name                 = "${var.nameSubnet}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.myFirstVnet.name}"
  address_prefix       = "${var.adress_prefix}"
}

# create address ip===============================================================================
resource "azurerm_public_ip" "myIp1" {
  name = "${var.nameIP1}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method = "Static"
}
resource "azurerm_public_ip" "myIp2" {
  name = "${var.nameIP2}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method = "Static"
}

# create a network interface========================================================================
resource "azurerm_network_interface" "myNIC1" {
  name = "${var.nameNIC1}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  ip_configuration{
    name = "ipConfig"
    subnet_id = "${azurerm_subnet.mySubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.myIp1.id}"
  }
}

resource "azurerm_network_interface" "myNIC2" {
  name = "${var.nameNIC2}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  ip_configuration{
    name = "ipConfig"
    subnet_id = "${azurerm_subnet.mySubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.myIp2.id}"
  }
}
# create a virtual machine =====================================================================
resource "azurerm_virtual_machine" "serverTest"{
  name = "VMTest"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.myNIC1.id}"]
  vm_size = "${var.vmSize}"

  storage_os_disk{
    name ="myDisk1"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference{
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "7.6"
    version = "latest"
  }
  os_profile{
    computer_name = "vmLynda"
    admin_username = "lynda"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys{
       path =  "/home/lynda/.ssh/authorized_keys"
       key_data = "${var.key_data}"
    }
  }
}

resource "azurerm_virtual_machine" "vmDB"{
  name = "VMDB"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.myNIC2.id}"]
  vm_size = "${var.vmSize}"

  storage_os_disk{
    name ="myDisk_2"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference{
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "7.6"
    version = "latest"
  }
  os_profile{
    computer_name = "vmLynda"
    admin_username = "lynda"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys{
       path =  "/home/lynda/.ssh/authorized_keys"
       key_data = "${var.key_data}"
    }
  }
}

