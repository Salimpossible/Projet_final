#####################################################################
# Création des règles de sécurité pour le serveur web reverse proxy #
#####################################################################
resource "azurerm_network_security_group" "nsgproxy" {
    name                = "nsgproxy"
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
        name                       = "HTTP"
        priority                   = "1002"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"  
    }
}
#########################################
# Création de la carte réseau virtuelle #
#########################################
resource "azurerm_network_interface" "nic_proxy" {
    name = "nic_proxy"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    #network_security_group_ids= azurerm_network_security_group.nsgproxy.id
    ip_configuration{
        name = "nic_proxyconfig"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Static"
        private_ip_address = "10.0.1.90"
        public_ip_address_id = azurerm_public_ip.pub_ip.id
    }
}
#########################################
# Association du nsg au nic #
#########################################
resource "azurerm_network_interface_security_group_association" "proxy_link" {
  network_interface_id      = azurerm_network_interface.nic_proxy.id
  network_security_group_id = azurerm_network_security_group.nsgproxy.id
}
#########################################
# Création du serveur web reverse proxy #
#########################################
resource "azurerm_virtual_machine" "reverse_proxy" {
    name                  = "proxy"
    location              = azurerm_resource_group.rg.location
    resource_group_name        = azurerm_resource_group.rg.name
    network_interface_ids = [ azurerm_network_interface.nic_proxy.id ]
    vm_size               = "Standard_B1s"
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true
    
    storage_os_disk {
        name              = "OsDisk_proxy"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    storage_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }
    os_profile {
        computer_name  = "proxy"
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