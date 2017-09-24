require "yaml"

LOCATIONS = YAML.load <<EOD
- japaneast
- japaneast
- japanwest
- eastasia
- eastus
- westus
EOD

RG_NAME = "rgVnet"

# puts `az group create -n #{RG_NAME} -l japaneast`

LOCATIONS.each_with_index do |local, i|
  vnet_name = sprintf("vnet%03d",i+1)
  subnet_name = sprintf("subnet%03d",i+1)
  address = sprintf("10.%d.0.0",i+1)

  cmd = ["az network vnet create"]
  cmd << "-n"
  cmd << vnet_name
  cmd << "-g"
  cmd << RG_NAME
  cmd << "--address-prefixes"
  cmd << "#{address}/16"
  cmd << "-l"
  cmd << LOCATIONS[i]
  cmd << "--subnet-name"
  cmd << subnet_name
  cmd << "--subnet-prefix"
  cmd << "#{address}/24"

  # puts `#{cmd.join(" ")}`
  puts cmd.join(" ")
end





