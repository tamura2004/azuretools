require "yaml"

rg_name = "multi_nic_vm"
location = "japaneast"

config = YAML.load <<"EOD"
-
  cmd: az group create
  options:
    name: #{rg_name}
    location: #{location}
-
  cmd: az network nic create
  options:
    "name": nic001
    "resource-group": #{rg_name}
    "location": #{location}
    "vnet-name": vnet001
    "subnet": subnet001
-
  cmd: az network nic create
  options:
    "name": nic002
    "resource-group": #{rg_name}
    "location": #{location}
    "vnet-name": vnet002
    "subnet": subnet002
EOD

config.each do |c|
  cmd = [c["cmd"], *c["options"].map{|k,v|"--%s %s" % [k,v]}].join(" ")
  puts cmd
  # puts `#{cmd}`
end

__END__

az group create -n rg001 -l japaneast
az vm create -n vm001 -g rg001 -l japaneast --image UbuntuLTS --generate-ssh-keys


az vm create \
--name $VmName \
--resource-group $RgName \
--image $OsImage \
--location $Location \
--size $VmSize \
--nics $Nic1Name $Nic2Name \
--admin-username $Username \
--ssh-key-value $SshKeyValue


# Create a VM and attach the two NICs.

VmName="WEB"

# Replace the value for the following **VmSize** variable with a value from the
# https://docs.microsoft.com/azure/virtual-machines/virtual-machines-linux-sizes article. Not all VM sizes support
# more than one NIC, so be sure to select a VM size that supports the number of NICs you want to attach to the VM.
# You must create the VM with at least two NICs if you want to add more after VM creation. If you create a VM with
# only one NIC, you can't add additional NICs to the VM after VM creation, regardless of how many NICs the VM supports.
# The VM size specified in the following variable supports two NICs.

VmSize="Standard_DS2"

# Replace the value for the OsImage variable value with a value for *urn* from the output returned by entering the
# az vm image list command.

OsImage="credativ:Debian:8:latest"

Username="adminuser"

# Replace the following value with the path to your public key file.

SshKeyValue="~/.ssh/id_rsa.pub"

# Before executing the following command, add variable names of additional NICs you may have added to the script that
# you want to attach to the VM. If creating a Windows VM, remove the **ssh-key-value** line and you'll be prompted for
# the password you want to configure for the VM.

az vm create \
--name $VmName \
--resource-group $RgName \
--image $OsImage \
--location $Location \
--size $VmSize \
--nics $Nic1Name $Nic2Name \
--admin-username $Username \
--ssh-key-value $SshKeyValue