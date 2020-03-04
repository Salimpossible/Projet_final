#####################################################
# Création des règles de sécurité pour la vm master #
#####################################################
resource "azurerm_network_security_group" "nsgmaster" {
    name                = "nsgmaster"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    security_rule {
        name                       = "SSH"
        priority                   = "1001"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "Jenkins"
        priority                   = "1002"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"  
    }
}


#########################################
# Création de la carte réseau virtuelle #
#########################################
resource "azurerm_network_interface" "nic_master" {
    name = "nic_master"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    #network_security_group_ids = azurerm_network_security_group.nsgmaster.id
    ip_configuration{
        name = "nic_masterconfig"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Static"
        private_ip_address = "10.0.1.70"
        #public_ip_address_id = "${azurerm_public_ip.pub_ip.id}"
    }
}

#########################################
# Association du nsg au nic #
#########################################
resource "azurerm_network_interface_security_group_association" "master_link" {
  network_interface_id      = azurerm_network_interface.nic_master.id
  network_security_group_id = azurerm_network_security_group.nsgmaster.id
}

###################################################
# Création de la machine virtuelle master jenkins #
###################################################
resource "azurerm_virtual_machine" "master_jenkins" {
    name                  = "master"
    location              = azurerm_resource_group.rg.location
    resource_group_name        = azurerm_resource_group.rg.name
    network_interface_ids = [ azurerm_network_interface.nic_master.id ]
    vm_size               = "Standard_B1s"
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true
    
    storage_os_disk {
        name              = "OsDisk_master"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    storage_data_disk {
        name              = "datadisk_master"
        managed_disk_type = "Standard_LRS"
        create_option     = "Empty"
        lun               = 0
        disk_size_gb      = "512"
    }
    storage_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }
    os_profile {
        computer_name  = "master"
        admin_username = var.user
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.user}/.ssh/authorized_keys"
            key_data = file("/home/vagrant/.ssh/id_rsa.pub")
        }
    }

}