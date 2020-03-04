
variable "subscription_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "tenant_id" {}

variable "name" {}

variable "owner" {}

variable "version" {}

variable "location" {}

variable "name_vnet" {}

variable "adress_space" {
    type = "list"
}

variable "name_subnet" {}

variable "ip_subnet"{
}

variable "ip_range" {
    type = "map"
}

variable "nameNsg" {}

variable "allocation_method" {}

variable "nameIpPub" {}
variable "nameIpPub2" {}

variable "nameNICConfig" {}

variable "vm_size" {}

variable "name_vm" {}

variable "key_data" {}