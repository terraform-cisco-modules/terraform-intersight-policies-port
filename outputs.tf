#_____________________________________________________________
#
# Collect the moid of the UCS Domain Port Policy as an Output
#_____________________________________________________________

output "moid" {
  description = "UCS Domain Port Policy Managed Object ID (moid)."
  value       = intersight_fabric_port_policy.port.moid
}

output "port_channel_appliances" {
  description = "Port Policy - Appliance Port-Channels Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_appliance_pc_role.port_channel_appliances)
    ) : v => intersight_fabric_appliance_pc_role.port_channel_appliances[v].moid
  }
}

output "port_channel_ethernet_uplinks" {
  description = "Port Policy - Ethernet Port-Channel Uplinks Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_uplink_pc_role.port_channel_ethernet_uplinks)
    ) : v => intersight_fabric_uplink_pc_role.port_channel_ethernet_uplinks[v].moid
  }
}

output "port_channel_fc_uplinks" {
  description = "Port Policy - Fibre-Channel Port-Channel Uplinks Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_fc_uplink_pc_role.port_channel_fc_uplinks)
    ) : v => intersight_fabric_fc_uplink_pc_role.port_channel_fc_uplinks[v].moid
  }
}

output "port_channel_fcoe_uplinks" {
  description = "Port Policy - FCoE Port-Channel(s) Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_fcoe_uplink_pc_role.port_channel_fcoe_uplinks)
    ) : v => intersight_fabric_fcoe_uplink_pc_role.port_channel_fcoe_uplinks[v].moid
  }
}

output "port_modes" {
  description = "Port Policy - Port Mode Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_port_mode.port_modes)
    ) : v => intersight_fabric_port_mode.port_modes[v].moid
  }
}

output "port_role_appliances" {
  description = "Port Policy - Port Role Appliance Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_appliance_role.port_role_appliances)
    ) : v => intersight_fabric_appliance_role.port_role_appliances[v].moid
  }
}

output "port_role_ethernet_uplinks" {
  description = "Port Policy - Port Role Ethernet Uplinks Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_uplink_role.port_role_ethernet_uplinks)
    ) : v => intersight_fabric_uplink_role.port_role_ethernet_uplinks[v].moid
  }
}

output "port_role_fc_storage" {
  description = "Port Policy - Port Role Fibre-Channel Storage Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_fc_storage_role.port_role_fc_storage)
    ) : v => intersight_fabric_fc_storage_role.port_role_fc_storage[v].moid
  }
}

output "port_role_fc_uplinks" {
  description = "Port Policy - Port Role Fibre-Channel Uplink Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_fc_uplink_role.port_role_fc_uplinks)
    ) : v => intersight_fabric_fc_uplink_role.port_role_fc_uplinks[v].moid
  }
}

output "port_role_fcoe_uplinks" {
  description = "Port Policy - Port Role FCoE Uplinks Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_fcoe_uplink_role.port_role_fcoe_uplinks)
    ) : v => intersight_fabric_fcoe_uplink_role.port_role_fcoe_uplinks[v].moid
  }
}

output "port_role_servers" {
  description = "Port Policy - Port Role Servers Moid(s)."
  value = {
    for v in sort(keys(intersight_fabric_server_role.port_role_servers)
    ) : v => intersight_fabric_server_role.port_role_servers[v].moid
  }
}
