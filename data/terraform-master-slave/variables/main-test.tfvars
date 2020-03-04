name = "TEST-ENV"
location = "westeurope"
owner = "slm"
version = "1.44.0"

name_vnet = "Vnet"
adress_space = [ "10.0.0.0/16" ]


name_subnet = "SubnetTestMS"

ip_subnet = "10.0.0.0/24"

ip_range = {
    "0" = "10.0.0.1"
    "1" = "10.0.0.2" }

nameNsg = "testNsg"

allocation_method = "Static"
nameIpPub = "IPub"
nameIpPub2 = "IPub2"

nameNICConfig = "testNICConfig"

vm_size = "Standard_B1S"

name_vm = "VM1"
