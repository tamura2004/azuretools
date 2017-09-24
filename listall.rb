require "yaml"

CMDS = YAML.load <<EOD
resourceGroup:
  - az group list -o table
virtualNetwork:
  - az network vnet list --query "[].{Location:location,Name:name,AddressPrefix:addressSpace.addressPrefixes[0],SubnetName1:subnets[0].name,SubnetAddress1:subnets[0].addressPrefix,SubnetName2:subnets[1].name,SubnetAddress2:subnets[1].addressPrefix}" -o table
  - az network nic list -o table
  - az network nsg list -o table
virtualMachine:
  - az vm list -o table -d
  - az vm list-ip-addresses -o table
  # - az vm get-instance-view --ids $(az vm list --query "[].id" -o tsv) -o table
EOD

CMDS.each do |key,values|
  puts "#" * 80
  printf("# %-77s#\n",key)
  puts "#" * 80
  values.each do |cmd|
    puts cmd
    puts
    puts `#{cmd}`
    puts
  end
end

