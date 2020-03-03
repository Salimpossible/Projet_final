resource "azurerm_resource_group" "rg" {
    name = "${var.name}"
    location = "${var.location}"

    tags {
        owner = "${var.owner}"
    }
}

resource "azurerm_virtual_network" "myFirstVnet"{
    name = "${var.name_vnet}"
    address_space = "${var.adress_space}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
}
#créer un subnet
resource "azurerm_subnet" "subnet" {
    name = "${var.name_subnet}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.myFirstVnet.name}"
    address_prefix = "${var.adress_prefix}"
}

resource "azurerm_network_security_group" "myFirstnsg"{
    name = "${var.nameNsg}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
      name = "SSH"
      priority = "1001"
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "22"
      source_address_prefix = "*"
      destination_address_prefix = "*"
  }
  security_rule {
      name = "HTTP"
      priority = "1002"
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "80"
      source_address_prefix = "*"
      destination_address_prefix = "*"  }
}
resource "azurerm_public_ip" "myFirstPubIp" {
  name = "${var.nameIpPub}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  allocation_method = "${var.allocation_method}"
}

resource "azurerm_network_interface" "myFirstNIC" {
  name = "${var.nameNICConfig}"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.myFirstnsg.id}"
  ip_configuration{
    name = "${var.nameNICConfig}"
    subnet_id = "${azurerm_subnet.subnet.id}"
    #public_ip_address_id = "${azurerm_public_ip.myFirstPubIp.id}"
    private_ip_address_allocation = "${var.allocation_method}"
  }
}


resource "azurerm_network_interface" "test" {
 count               = 2
 name                = "acctni${count.index}"
 location            = "${azurerm_resource_group.rg.location}"
 resource_group_name = "${azurerm_resource_group.rg.name}"

 ip_configuration {
   name                          = "testConfiguration"
   subnet_id                     = "${azurerm_subnet.subnet.id}"
   private_ip_address_allocation = "dynamic"
   load_balancer_backend_address_pools_ids = [ "${azurerm_lb_backend_address_pool.test.id}" ]
 }
}

resource "azurerm_managed_disk" "test" {
 count                = 2
 name                 = "datadisk_existing_${count.index}"
 location             = "${azurerm_resource_group.rg.location}"
 resource_group_name  = "${azurerm_resource_group.rg.name}"
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

resource "azurerm_virtual_machine" "test" {
 count                 = 2
 name                  = "acctvm${count.index}"
 location              = "${azurerm_resource_group.rg.location}"
 availability_set_id   = "${azurerm_availability_set.avset.id}"
 resource_group_name   = "${azurerm_resource_group.rg.name}"
 network_interface_ids = [ "${element(azurerm_network_interface.test.*.id, count.index)}" ]
 vm_size               = "${var.vm_size}"

 # Uncomment this line to delete the OS disk automatically when deleting the VM
 # delete_os_disk_on_termination = true

 # Uncomment this line to delete the data disks automatically when deleting the VM
 # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher= "OpenLogic"
    offer= "CentOS"
    sku= "7.5"
    version= "latest"
  }

 }

 storage_os_disk {
   name              = "myosdisk${count.index}"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 # Optional data disks
 storage_data_disk {
   name              = "datadisk_new_${count.index}"
   managed_disk_type = "Standard_LRS"
   create_option     = "Empty"
   lun               = 0
   disk_size_gb      = "1023"
 }

 storage_data_disk {
   name            = "${element(azurerm_managed_disk.test.*.name, count.index)}"
   managed_disk_id = "${element(azurerm_managed_disk.test.*.id, count.index)}"
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = "${element(azurerm_managed_disk.test.*.disk_size_gb, count.index)}"
 }

   os_profile {
    computer_name  = "hostname"
    admin_username = "salim"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/salim/.ssh/authorized_keys"
      key_data = "${var.key_data}"
    }
 }

 tags = {
   environment = "staging"
 }
}

#créer une VM linux
# resource "azurerm_virtual_machine" "main" {
#   name                  = "${var.name_vm}"
#   location              = "${azurerm_resource_group.rg.location}"
#   resource_group_name   = "${azurerm_resource_group.rg.name}"
#   network_interface_ids = ["${azurerm_network_interface.myFirstNIC.id}"]
#   vm_size               = "${var.vm_size}"


#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "hostname"
#     admin_username = "salim"
    
#   }
#   os_profile_linux_config {
#     disable_password_authentication = true

#     ssh_keys{
#       path = "/home/salim/.ssh/authorized_keys"
#       key_data = "${var.key_data}"
#     }
#   }
#   tags = {
#     environment = "staging"
#   }

# }
