resource "azurerm_resource_group" "rgpil" {
  name     = "rgpil_pil"
  location = var.location
  tags = {
    environment = "Test"
  }
}

###########################################
# Création du réseau virtuel pour la pil #
###########################################
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet_pil"
    location            = azurerm_resource_group.rgpil.location
    resource_group_name = azurerm_resource_group.rgpil.name
    address_space       = [ "10.0.0.0/16" ]
}

# create subnet================================================================================
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rgpil.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.adress_prefix
}
resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rgpil.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.adress_prefix2
}

# create address ip===============================================================================
resource "azurerm_public_ip" "myIp1" {
  name = var.nameIP1
  location = azurerm_resource_group.rgpil.location
  resource_group_name = azurerm_resource_group.rgpil.name
  allocation_method = "Static"
  domain_name_label = "dnsenvtest"
}
resource "azurerm_public_ip" "myIp2" {
  name = var.nameIP2
  location = azurerm_resource_group.rgpil.location
  resource_group_name = azurerm_resource_group.rgpil.name
  allocation_method = "Static"
  domain_name_label = "dnsenvprod"
}

#####################################################
# Création des règles de sécurité pour la vm bddtest #
#####################################################
resource "azurerm_network_security_group" "nsgbddtest" {
    name                = "nsgbddtest"
    location            = azurerm_resource_group.rgpil.location
    resource_group_name = azurerm_resource_group.rgpil.name
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
        name                       = "mongo"
        priority                   = "1002"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "27017"
        source_address_prefix      = "*"
        destination_address_prefix = "*"  
    }
}

#####################################################
# Création des règles de sécurité pour la vm servertest #
#####################################################
resource "azurerm_network_security_group" "nsgservtest" {
    name                = "nsgservtest"
    location            = azurerm_resource_group.rgpil.location
    resource_group_name = azurerm_resource_group.rgpil.name
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
#####################################################
# Création des règles de sécurité pour la vm bddprod #
#####################################################
resource "azurerm_network_security_group" "nsgbddprod" {
    name                = "nsgbddprod"
    location            = azurerm_resource_group.rgpil.location
    resource_group_name = azurerm_resource_group.rgpil.name
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
        name                       = "mongo"
        priority                   = "1002"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "27017"
        source_address_prefix      = "*"
        destination_address_prefix = "*"  
    }
}

#####################################################
# Création des règles de sécurité pour la vm server prod #
#####################################################
resource "azurerm_network_security_group" "nsgservprod" {
    name                = "nsgservprod"
    location            = azurerm_resource_group.rgpil.location
    resource_group_name = azurerm_resource_group.rgpil.name
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


# create a network interface========================================================================
resource "azurerm_network_interface" "myNIC1" {
  name = var.nameNIC1
  location = azurerm_resource_group.rgpil.location
  resource_group_name = azurerm_resource_group.rgpil.name
  ip_configuration{
    name = "ipConfig"
    subnet_id = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.50"
    public_ip_address_id = azurerm_public_ip.myIp1.id
  }
}
#########################################
# Association du nsg server test  au nic server test #
#########################################
resource "azurerm_network_interface_security_group_association" "master_link" {
  network_interface_id      = azurerm_network_interface.myNIC1.id
  network_security_group_id = azurerm_network_security_group.nsgservtest.id
}


resource "azurerm_network_interface" "myNIC2" {
  name = var.nameNIC2
  location = azurerm_resource_group.rgpil.location
  resource_group_name = azurerm_resource_group.rgpil.name
  ip_configuration{
    name = "ipConfig"
    subnet_id = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.60"
    #public_ip_address_id = "azurerm_public_ip.myIp2.id"
  }
}
#########################################
# Association du nsg bddtest  au nic bdd test #
#########################################
resource "azurerm_network_interface_security_group_association" "app_link" {
  network_interface_id      = azurerm_network_interface.myNIC2.id
  network_security_group_id = azurerm_network_security_group.nsgbddtest.id
}

# create a network interface========================================================================
resource "azurerm_network_interface" "myNIC3" {
  name = var.nameNIC3
  location = azurerm_resource_group.rgpil.location
  resource_group_name = azurerm_resource_group.rgpil.name
  ip_configuration{
    name = "ipConfig"
    subnet_id = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.50"
    public_ip_address_id = azurerm_public_ip.myIp2.id
  }
}
#########################################
# Association du nsg serverprod  au nic server prod #
#########################################
resource "azurerm_network_interface_security_group_association" "master2_link" {
  network_interface_id      = azurerm_network_interface.myNIC3.id
  network_security_group_id = azurerm_network_security_group.nsgservprod.id
}


resource "azurerm_network_interface" "myNIC4" {
  name = var.nameNIC4
  location = azurerm_resource_group.rgpil.location
  resource_group_name = azurerm_resource_group.rgpil.name
  ip_configuration{
    name = "ipConfig"
    subnet_id = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.60"
    #public_ip_address_id = "azurerm_public_ip.myIp2.id"
  }
}
#########################################
# Association du nsg bdd prod  au nic bdd test #
#########################################
resource "azurerm_network_interface_security_group_association" "app2_link" {
  network_interface_id      = azurerm_network_interface.myNIC4.id
  network_security_group_id = azurerm_network_security_group.nsgbddtest.id
}



# create a virtual machine =====================================================================
resource "azurerm_virtual_machine" "serverTest"{
  name = "servtest"
  location = var.location
  resource_group_name = azurerm_resource_group.rgpil.name
  network_interface_ids = [ azurerm_network_interface.myNIC1.id ]
  vm_size = var.vmSize

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
    computer_name = "servtest"
    admin_username = "stage"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys{
       path =  "/home/stage/.ssh/authorized_keys"
       key_data = var.pub_key
    }
  }
}

resource "azurerm_virtual_machine" "vmDBtest"{
  name = "dbtest"
  location = var.location
  resource_group_name = azurerm_resource_group.rgpil.name
  network_interface_ids = [ azurerm_network_interface.myNIC2.id ]
  vm_size = var.vmSize

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
    computer_name = "dbtest"
    admin_username = "stage"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys{
       path =  "/home/stage/.ssh/authorized_keys"
       key_data = var.pub_key
    }
  }
}
# create a virtual machine =====================================================================
resource "azurerm_virtual_machine" "serverProd"{
  name = "servprod"
  location = var.location
  resource_group_name = azurerm_resource_group.rgpil.name
  network_interface_ids = [ azurerm_network_interface.myNIC3.id ]
  vm_size = var.vmSize

  storage_os_disk{
    name ="myDisk3"
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
    computer_name = "servprod"
    admin_username = "stage"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys{
       path =  "/home/stage/.ssh/authorized_keys"
       key_data = var.pub_key
    }
  }
}

resource "azurerm_virtual_machine" "vmDBprod"{
  name = "dbprod"
  location = var.location
  resource_group_name = azurerm_resource_group.rgpil.name
  network_interface_ids = [ azurerm_network_interface.myNIC4.id ]
  vm_size = var.vmSize

  storage_os_disk{
    name ="myDisk_4"
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
    computer_name = "dbprod"
    admin_username = "stage"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys{
       path =  "/home/stage/.ssh/authorized_keys"
       key_data = var.pub_key
    }
  }
}
