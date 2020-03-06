####################################################
# Création des règles de sécurité pour la vm slave #
####################################################
resource "azurerm_network_security_group" "nsgslave" {
    name                = "nsgslave"
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
#    security_rule {
#        name                       = "Docker_engine"
#        priority                   = "1002"
#        direction                  = "Inbound"
#        access                     = "Allow"
#        protocol                   = "Tcp"
#        source_port_range          = "*"
#        destination_port_range     = "5000"
#        source_address_prefix      = "*"
#        destination_address_prefix = "*"  
#    }
}
#########################################
# Création de la carte réseau virtuelle #
#########################################
resource "azurerm_network_interface" "nic_slave" {
    name = "nic_slave"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    #network_security_group_ids = azurerm_network_security_group.nsgslave.id
    ip_configuration{
        name = "nic_slaveconfig"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Static"
        private_ip_address = "10.0.1.80"
        #public_ip_address_id = "${azurerm_public_ip.pub_ip.id}"
    }
}
#########################################
# Association du nsg au nic #
#########################################
resource "azurerm_network_interface_security_group_association" "slave_link" {
  network_interface_id      = azurerm_network_interface.nic_slave.id
  network_security_group_id = azurerm_network_security_group.nsgslave.id
}
###################################################
# Création de la machine virtuelle slave jenkins #
###################################################
resource "azurerm_virtual_machine" "slave_jenkins" {
    name                  = "slave"
    location              = azurerm_resource_group.rg.location
    resource_group_name        = azurerm_resource_group.rg.name
    network_interface_ids = [ azurerm_network_interface.nic_slave.id ]
    vm_size               = "Standard_B2s"
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true
    
    storage_os_disk {
        name              = "OsDisk_slave"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    storage_data_disk {
        name              = "datadisk_slave"
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
        computer_name  = "slave"
        admin_username = var.user
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.user}/.ssh/authorized_keys"
            key_data = var.pub_key
        }
    }

}
