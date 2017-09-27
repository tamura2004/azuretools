require "yaml"
DEBUG = false

class Azure
  def initialize(cmd, **option)
    @cmd = cmd
    @debug = option.has_key?(:debug)
    option.delete(:debug)
    @option = option
  end

  def self.run(cmd, **option)
    new(cmd, option).exec
  end

  def exec
    option_string = @option.map do |key, value|
      dash = key.size == 1 ? "-" : "--"
      key = key.to_s.gsub(/_/,"-")
      value = value.inspect if key.to_s == "query"
      "#{dash}#{key} #{value}"
    end

    input_string = [@cmd, option_string].join(" ")

    puts input_string
    puts %x(#{input_string}) unless @debug
  end
end

# Azure.exec(cmd: "az group create", n: "rg-vnet", location: "eastus")
# Azure.run("az group list", o:"table")

# (1..3).each do |i|
#   Azure.exec(
#     cmd: "az network vnet create",
#     n: "vnet#{i}",
#     g: "rg-vnet",
#     address_prefixes: "10.#{i}.0.0/16",
#     location: "eastus",
#     subnet_name: "subnet#{i}",
#     subnet_prefix: "10.#{i}.0.0/24"
#   )
# end

# (1..3).each do |i|
#   Azure.exec(
#     cmd: "az network vnet delete",
#     n: "vnet#{i}",
#     g: "rg-vnet",
    # address_prefixes: "10.#{i}.0.0/16",
    # location: "eastus",
    # subnet_name: "subnet#{i}",
    # subnet_prefix: "10.#{i}.0.0/24"
#   )
# end

# Azure.run("az vm create", h: true)
# Azure.run("az network vnet list", o: "table")
# Azure.run(
#   "az network vnet list",
#   query: "[].{Location:location,Name:name,ResourceGroup:resourceGroup,AddressPrefix:addressSpace.addressPrefixes[0],SubnetName1:subnets[0].name,SubnetAddress1:subnets[0].addressPrefix,SubnetName2:subnets[1].name,SubnetAddress2:subnets[1].addressPrefix}",
#   o: "table"
# )

# Azure.run(
#   "az network vnet list",
#   query: "[].{Location:location,Name:name,AddressPrefix:addressSpace.addressPrefixes[0],SubnetName1:subnets[0].name,SubnetAddress1:subnets[0].addressPrefix,SubnetId1:subnets[0].id}",
#   o: "table"
# )

# subnet id
# Azure.run("az network vnet list",
#   query: "[].subnets[0].id",
#   o: "tsv"
# )

# Azure.run("az network vnet list",
#   o: "table"
# )

# (1..3).each do |i|
#   Azure.run("az network nic create",
#     n: "nic#{i}",
#     g: "rg-vnet",
#     subnet: "subnet#{i}",
#     vnet_name: "vnet#{i}"
#   )
# end

# Azure.run("az vm create",
#   n: "vm3",
#   g:  "tamura",
#   image: "UbuntuLTS",
#   l: "japanwest",
#   size: "Basic_A0",
#   storage_sku: "Standard_LRS",
#   generate_ssh_keys: "",
#   subnet: "/subscriptions/xxxx/resourceGroups/Mail-WJP_H/providers/Microsoft.Network/virtualNetworks/Mail-WJP_Vnet_H/subnets/Mail-WJP_Vnet-SN_H",
#   debug: true
# )  

# Azure.run("az network route-table create",
#   g: "Mail-EJP_H",
#   n: "Mail-EJP_RouteTable_H",
#   l: "japaneast"
# )

# Azure.run("az network route-table route list",
#   g: "Mail-EJP_H",
#   route_table_name: "Mail-EJP_RouteTable_H"
# )

# Azure.run("az network route-table route create",
#   g: "Mail-EJP_H",
#   n: "Mail-EJP_RouteToIpc_H",
#   route_table_name: "Mail-EJP_RouteTable_H",
#   address_prefix: "0.0.0.0/0",
#   next_hop_type: "internet"
# )

# Azure.run("az network vnet subnet update",
#   vnet_name: "Mail-EJP_Vnet_H",
#   n: "Mail-EJP_Vnet-SN_H",
#   route_table: "Mail-EJP_RouteTable_H"
# )

# Azure.run("az network route-table route list",
#   g: "Mail-EJP_H",
#   route_table_name: "Mail-EJP_RouteTable_H"
# )

Azure.run("az network express-route list-route-tables",
  n: "Expressroute-H",
  g: "Mail-EJP_H",
  peering_name: "AzurePrivatePeering",
  path: "primary"
)


