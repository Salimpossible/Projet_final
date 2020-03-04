##########################################
# Création du resource group pour la pic #
##########################################
resource "azurerm_resource_group" "rg" {
    name     = var.rg_pic
    location = var.location_pic
}
###########################################
# Création du réseau virtuel pour la pic #
###########################################
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet_pic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = [ "10.0.0.0/16" ]
}
###########################
# Création du sous réseau #
###########################
resource "azurerm_subnet" "subnet" {
    name                 = "subnet_pic"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix       = "10.0.1.0/24"
}
###########################################################
# Création de l'adresse ip publique pour le reverse proxy #
###########################################################
resource "azurerm_public_ip" "pub_ip" {
    name                         = "ip_proxy"
    location                     = azurerm_resource_group.rg.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"
    domain_name_label            = var.dns
}