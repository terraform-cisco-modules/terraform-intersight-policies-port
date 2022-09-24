locals {
  #__________________________________________________________
  #
  # Port Policy > Port Roles > Appliance Section - Locals
  #__________________________________________________________

  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_appliances_loop_1 = [
    for v in var.port_role_appliances : {
      admin_speed                     = v.admin_speed
      breakout_port_id                = v.breakout_port_id
      ethernet_network_control_policy = v.ethernet_network_control_policy
      ethernet_network_group_policy   = v.ethernet_network_group_policy
      fec                             = v.fec
      mode                            = v.mode
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
        ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
      )
      priority = v.priority
      slot_id  = v.slot_id
      tags     = v.tags != null ? v.tags : var.tags
    }
  ]

  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_appliances_loop_2 = flatten([
    for v in local.port_role_appliances_loop_1 : [
      for s in v.port_list : {
        admin_speed                     = v.admin_speed
        breakout_port_id                = v.breakout_port_id
        ethernet_network_control_policy = v.ethernet_network_control_policy
        ethernet_network_group_policy   = v.ethernet_network_group_policy
        fec                             = v.fec
        mode                            = v.mode
        port_id                         = s
        priority                        = v.priority
        slot_id                         = v.slot_id
        tags                            = v.tags
      }
    ]
  ])

  port_role_appliances = {
    for v in local.port_role_appliances_loop_2 : "${v.slot_id}_${v.breakout_port_id}_${v.port_id}" => v
  }

  #_________________________________________________________________
  #
  # Port Policy > Port Roles > Ethernet Uplinks Section - Locals
  #_________________________________________________________________

  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_ethernet_uplinks_loop_1 = [
    for v in var.port_role_ethernet_uplinks : {
      admin_speed                   = v.admin_speed
      breakout_port_id              = v.breakout_port_id
      ethernet_network_group_policy = v.ethernet_network_group_policy
      fec                           = v.fec
      flow_control_policy           = v.flow_control_policy
      link_control_policy           = v.link_control_policy
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
        ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
      )
      slot_id = v.slot_id
      tags    = tags != null ? v.tags : var.tags
    }
  ]

  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_ethernet_uplinks_loop_2 = flatten([
    for v in local.port_role_ethernet_uplinks_loop_1 : [
      for s in v.port_list : {
        admin_speed                   = v.admin_speed
        breakout_port_id              = v.breakout_port_id
        ethernet_network_group_policy = v.ethernet_network_group_policy
        fec                           = v.fec
        flow_control_policy           = v.flow_control_policy
        link_control_policy           = v.link_control_policy
        port_id                       = s
        slot_id                       = v.slot_id
        tags                          = v.tags
      }
    ]
  ])

  port_role_ethernet_uplinks = {
    for v in local.port_role_ethernet_uplinks_loop_2 : "${v.slot_id}_${v.breakout_port_id}_${v.port_id}" => v
  }

  #______________________________________________________________________
  #
  # Port Policy > Port Roles > Fibre-Channel Storage Section - Locals
  #______________________________________________________________________

  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_fc_storage_loop_1 = [
    for v in var.port_role_fc_storage : {
      admin_speed      = v.admin_speed
      breakout_port_id = v.breakout_port_id
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
        ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
      )
      slot_id = v.slot_id
      tags    = tags != null ? v.tags : var.tags
      vsan_id = v.vsan_id
    }
  ]

  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fc_storage_loop_2 = flatten([
    for v in local.port_role_fc_storage_loop_1 : [
      for s in v.port_list : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        port_id          = s
        slot_id          = v.slot_id
        tags             = v.tags
        vsan_id          = v.vsan_id
      }
    ]
  ])

  port_role_fc_storage = {
    for v in local.port_role_fc_storage_loop_2 : "${v.slot_id}_${v.breakout_port_id}_${v.port_id}" => v
  }

  #______________________________________________________________________
  #
  # Port Policy > Port Roles > Fibre-Channel Uplinks Section - Locals
  #______________________________________________________________________

  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_fc_uplinks_loop_1 = [
    for v in var.port_role_fc_uplinks : {
      admin_speed      = v.admin_speed
      breakout_port_id = v.breakout_port_id
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
        ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
      )
      slot_id = v.slot_id
      tags    = tags != null ? v.tags : var.tags
      vsan_id = v.vsan_id
    }
  ]

  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fc_uplinks_loop_2 = flatten([
    for v in local.port_role_fc_uplinks_loop_1 : [
      for s in v.port_list : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        port_id          = s
        slot_id          = v.slot_id
        tags             = v.tags
        vsan_id          = v.vsan_id
      }
    ]
  ])

  port_role_fc_uplinks = {
    for v in local.port_role_fc_uplinks_loop_2 : "${v.slot_id}_${v.breakout_port_id}_${v.port_id}" => v
  }

  #_________________________________________________________________
  #
  # Port Policy > Port Roles > FCoE Uplinks Section - Locals
  #_________________________________________________________________

  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_fcoe_uplinks_loop_1 = [
    for v in var.port_role_fcoe_uplinks : {
      admin_speed         = v.admin_speed
      breakout_port_id    = v.breakout_port_id
      fec                 = v.fec
      link_control_policy = v.link_control_policy
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
        ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
      )
      slot_id = v.slot_id
      tags    = tags != null ? v.tags : var.tags
    }
  ]

  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fcoe_uplinks_loop_2 = flatten([
    for v in local.port_role_fcoe_uplinks_loop_1 : [
      for s in v.port_list : {
        admin_speed         = v.admin_speed
        breakout_port_id    = v.breakout_port_id
        fec                 = v.fec
        link_control_policy = v.link_control_policy
        port_id             = s
        slot_id             = v.slot_id
        tags                = v.tags
      }
    ]
  ])

  port_role_fcoe_uplinks = {
    for v in local.port_role_fcoe_uplinks_loop_2 : "${v.slot_id}_${v.breakout_port_id}_${v.port_id}" => v
  }

  #_________________________________________________________________
  #
  # Port Policy > Port Roles > FCoE Uplinks Section - Locals
  #_________________________________________________________________

  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_servers_loop_1 = [
    for v in var.port_role_servers : {
      breakout_port_id = v.breakout_port_id
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
        ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
      )
      slot_id = v.slot_id
      tags    = v.tags != null ? v.tags : length(var.tags) > 0 ? var.tags : []
    }
  ]

  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_servers_loop_2 = flatten([
    for v in local.port_role_servers_loop_1 : [
      for s in v.port_list : {
        breakout_port_id = v.breakout_port_id
        port_id          = s
        slot_id          = v.slot_id
        tags             = v.tags
      }
    ]
  ])

  port_role_servers = {
    for v in local.port_role_servers_loop_2 : "${v.slot_id}_${v.breakout_port_id}_${v.port_id}" => v
  }

  ethernet_network_control_policies = toset(compact(concat([
    for v in local.port_channel_appliances : v.ethernet_network_control_policy
    ], [for v in local.port_role_appliances : v.ethernet_network_control_policy]
  )))

  ethernet_network_group_policies = toset(compact(concat([
    for v in local.port_channel_appliances : v.ethernet_network_group_policy
    ], [for v in local.port_channel_ethernet_uplinks : v.ethernet_network_group_policy
    ], [for v in local.port_role_appliances : v.ethernet_network_group_policy
    ], [for v in local.port_role_ethernet_uplinks : v.ethernet_network_group_policy]
  )))

  flow_control_policies = toset(compact(concat([
    for v in local.port_channel_ethernet_uplinks : v.flow_control_policy
    ], [for v in local.port_role_ethernet_uplinks : v.flow_control_policy]
  )))

  link_aggregation_policies = toset(compact(concat([
    for v in local.port_channel_appliances : v.link_aggregation_policy
    ], [for v in local.port_channel_ethernet_uplinks : v.link_aggregation_policy
    ], [for v in local.port_channel_fcoe_uplinks : v.link_aggregation_policy]
  )))

  link_control_policies = toset(compact(concat([
    for v in local.port_channel_ethernet_uplinks : v.link_control_policy
    ], [for v in local.port_channel_fcoe_uplinks : v.link_control_policy
    ], [for v in local.port_role_ethernet_uplinks : v.link_control_policy
    ], [for v in local.port_role_fcoe_uplinks : v.link_control_policy]
  )))

}

#____________________________________________________________
#
# Intersight Organization Data Source
# GUI Location: Settings > Settings > Organizations > {Name}
#____________________________________________________________

data "intersight_organization_organization" "org_moid" {
  name = var.organization
}

#____________________________________________________________
#
# Intersight UCS Domain Profile(s) Data Source
# GUI Location: Profiles > UCS Domain Profiles > {Name}
#____________________________________________________________

data "intersight_fabric_switch_profile" "profiles" {
  for_each = { for v in var.profiles : v => v if length(var.profiles) > 0 }
  name     = each.value
}

#___________________________________________________________________
#
# Intersight Ethernet Network Control Policy Data Source
# GUI Location: Policies > Create Policy > Ethernet Network Control
#___________________________________________________________________

data "intersight_fabric_eth_network_control_policy" "ethernet_network_control" {
  for_each = { for v in local.ethernet_network_control_policies : v => v }
  name     = each.value
}

#___________________________________________________________________
#
# Intersight Ethernet Network Group Policy Data Source
# GUI Location: Policies > Create Policy > Ethernet Network Group
#___________________________________________________________________

data "intersight_fabric_eth_network_group_policy" "ethernet_network_group" {
  for_each = { for v in local.ethernet_network_group_policies : v => v }
  name     = each.value
}

#___________________________________________________________________
#
# Intersight Flow Control Policy Data Source
# GUI Location: Policies > Create Policy > Flow Control
#___________________________________________________________________

data "intersight_fabric_flow_control_policy" "flow_control" {
  for_each = { for v in local.flow_control_policies : v => v }
  name     = each.value
}

#___________________________________________________________________
#
# Intersight Link Aggregation Policy Data Source
# GUI Location: Policies > Create Policy > Link Aggregation
#___________________________________________________________________

data "intersight_fabric_link_aggregation_policy" "link_aggregation" {
  for_each = { for v in local.link_aggregation_policies : v => v }
  name     = each.value
}

#___________________________________________________________________
#
# Intersight Link Control Policy Data Source
# GUI Location: Policies > Create Policy > Link Control
#___________________________________________________________________

data "intersight_fabric_link_control_policy" "link_control" {
  for_each = { for v in local.link_control_policies : v => v }
  name     = each.value
}

#__________________________________________________________________
#
# Intersight Port Policy
# GUI Location: Policies > Create Policy > Port
#__________________________________________________________________

resource "intersight_fabric_port_policy" "port_policy" {
  depends_on = [
    data.intersight_fabric_eth_network_control_policy.ethernet_network_control,
    data.intersight_fabric_eth_network_group_policy.ethernet_network_group,
    data.intersight_fabric_flow_control_policy.flow_control,
    data.intersight_fabric_link_aggregation_policy.link_aggregation,
    data.intersight_fabric_link_control_policy.link_control
  ]
  description  = var.description != "" ? var.description : "${var.name} Port Policy."
  device_model = var.device_model
  name         = var.name
  organization {
    moid        = data.intersight_organization_organization.org_moid.results[0].moid
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = { for v in var.profiles : v => v }
    content {
      moid        = data.intersight_fabric_switch_profile.profiles[profiles.value].results[0].moid
      object_type = "fabric.SwitchProfile"
    }
  }
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#________________________________________________________________________________________________
#
# Intersight Port Policy - Port Role - Appliance
# GUI Location: Policies > Create Policy > Port > Port Roles > Configure > Port Role - Appliance
#________________________________________________________________________________________________

resource "intersight_fabric_appliance_pc_role" "port_channel_appliances" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each    = { for v in var.port_channel_appliances : v.pc_id => v }
  admin_speed = each.value.admin_speed
  # aggregate_port_id = each.value.breakout_port_id
  mode     = each.value.mode
  pc_id    = each.value.pc_id
  priority = each.value.priority
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "eth_network_control_policy" {
    for_each = toset(compact([each.value.ethernet_network_control_policy]))
    content {
      moid = data.intersight_fabric_eth_network_control_policy.ethernet_network_control[
        eth_network_control_policy.value].results[0
      ].moid
    }
  }
  dynamic "eth_network_group_policy" {
    for_each = toset(compact([each.value.ethernet_network_group_policy]))
    content {
      moid = data.intersight_fabric_eth_network_group_policy.ethernet_network_group[
        eth_network_group_policy.value].results[0
      ].moid
    }
  }
  dynamic "link_aggregation_policy" {
    for_each = toset(compact([each.value.link_aggregation_policy]))
    content {
      moid = data.intersight_fabric_link_aggregation_policy.link_aggregation[
        link_aggregation_policy.value].results[0
      ].moid
    }
  }
  dynamic "ports" {
    for_each = each.value.interfaces
    content {
      aggregate_port_id = ports.value.breakout_port_id
      port_id           = ports.value.port_id
      slot_id           = ports.value.slot_id
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#______________________________________________________________________________________________________________________
#
# Intersight Port Policy - Ethernet Uplink Port Channel
# GUI Location: Policies > Create Policy > Port > Port Channels > Create a Port Channel > Ethernet Uplink Port Channel
#______________________________________________________________________________________________________________________

resource "intersight_fabric_uplink_pc_role" "port_channel_ethernet_uplinks" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each    = { for v in var.port_channel_ethernet_uplinks : v.pc_id => v }
  admin_speed = each.value.admin_speed
  pc_id       = each.value.pc_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "eth_network_group_policy" {
    for_each = toset(compact([each.value.ethernet_network_group_policy]))
    content {
      moid = data.intersight_fabric_eth_network_group_policy.ethernet_network_group[
        eth_network_group_policy.value].results[0
      ].moid
    }
  }
  dynamic "flow_control_policy" {
    for_each = toset(compact([each.value.flow_control_policy]))
    content {
      moid = data.intersight_fabric_flow_control_policy.flow_control[
        flow_control_policy.value].results[0
      ].moid
    }
  }
  dynamic "link_aggregation_policy" {
    for_each = toset(compact([each.value.link_aggregation_policy]))
    content {
      moid = data.intersight_fabric_link_aggregation_policy.link_aggregation[
        link_aggregation_policy.value].results[0
      ].moid
    }
  }
  dynamic "link_control_policy" {
    for_each = toset(compact([each.value.link_control_policy]))
    content {
      moid = data.intersight_fabric_link_control_policy.link_control[
        link_control_policy.value].results[0
      ].moid
    }
  }
  dynamic "ports" {
    for_each = each.value.interfaces
    content {
      aggregate_port_id = ports.value.breakout_port_id
      port_id           = ports.value.port_id
      slot_id           = ports.value.slot_id
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#________________________________________________________________________________________________________________
#
# Intersight Port Policy - FC Uplink Port Channel
# GUI Location: Policies > Create Policy > Port > Port Channels > Create a Port Channel > FC Uplink Port Channel
#________________________________________________________________________________________________________________

resource "intersight_fabric_fc_uplink_pc_role" "port_channel_fc_uplinks" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each    = { for v in var.port_channel_fc_uplinks : v.pc_id => v }
  admin_speed = each.value.admin_speed
  pc_id       = each.value.pc_id
  vsan_id     = each.value.vsan_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "ports" {
    for_each = each.value.interfaces
    content {
      aggregate_port_id = ports.value.breakout_port_id
      port_id           = ports.value.port_id
      slot_id           = ports.value.slot_id
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#______________________________________________________________________________________________________________________
#
# Intersight Port Policy - FCoE Uplink Port Channel
# GUI Location: Policies > Create Policy > Port > Port Channels > Create a Port Channel > FCoE Uplink Port Channel
#______________________________________________________________________________________________________________________

resource "intersight_fabric_fcoe_uplink_pc_role" "port_channel_fcoe_uplinks" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each    = { for v in var.port_channel_fcoe_uplinks : v.pc_id => v }
  admin_speed = each.value.admin_speed
  pc_id       = each.value.pc_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "link_aggregation_policy" {
    for_each = toset(compact([each.value.link_aggregation_policy]))
    content {
      moid = data.intersight_fabric_link_aggregation_policy.link_aggregation[
        link_aggregation_policy.value].results[0
      ].moid
    }
  }
  dynamic "link_control_policy" {
    for_each = toset(compact([each.value.link_control_policy]))
    content {
      moid = data.intersight_fabric_link_control_policy.link_control[
        link_control_policy.value].results[0
      ].moid
    }
  }
  dynamic "ports" {
    for_each = each.value.interfaces
    content {
      aggregate_port_id = ports.value.breakout_port_id
      port_id           = ports.value.port_id
      slot_id           = ports.value.slot_id
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#__________________________________________________________________
#
# Intersight Port Policy - Move the Slider for Port mode
# GUI Location: Policies > Create Policy > Port > Move the Slider
#__________________________________________________________________

resource "intersight_fabric_port_mode" "port_modes" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each      = { for v in var.port_modes : element(v.port_list, 0) => v }
  custom_mode   = each.value.custom_mode
  port_id_end   = element(each.value.port_list, 1)
  port_id_start = element(each.value.port_list, 0)
  slot_id       = each.value.slot_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#________________________________________________________________________________________________
#
# Intersight Port Policy - Port Role - Appliance
# GUI Location: Policies > Create Policy > Port > Port Roles > Configure > Port Role - Appliance
#________________________________________________________________________________________________

resource "intersight_fabric_appliance_role" "port_role_appliances" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each          = local.port_role_appliances
  admin_speed       = each.value.admin_speed
  aggregate_port_id = each.value.breakout_port_id
  fec               = each.value.fec
  mode              = each.value.mode
  port_id           = each.value.port_id
  priority          = each.value.priority
  slot_id           = each.value.slot_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "eth_network_control_policy" {
    for_each = toset(compact([each.value.ethernet_network_control_policy]))
    content {
      moid = data.intersight_fabric_eth_network_control_policy.ethernet_network_control[
        eth_network_control_policy.value].results[0
      ].moid
    }
  }
  dynamic "eth_network_group_policy" {
    for_each = toset(compact([each.value.ethernet_network_group_policy]))
    content {
      moid = data.intersight_fabric_eth_network_group_policy.ethernet_network_group[
        eth_network_group_policy.value].results[0
      ].moid
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#__________________________________________________________________________________________
#
# Intersight Port Policy - Ethernet Uplink
# GUI Location: Policies > Create Policy > Port > Port Roles > Configure > Ethernet Uplink
#__________________________________________________________________________________________

resource "intersight_fabric_uplink_role" "port_role_ethernet_uplinks" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each          = local.port_role_ethernet_uplinks
  admin_speed       = each.value.admin_speed
  aggregate_port_id = each.value.breakout_port_id
  fec               = each.value.fec
  port_id           = each.value.port_id
  slot_id           = each.value.slot_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "eth_network_group_policy" {
    for_each = toset(compact([each.value.ethernet_network_group_policy]))
    content {
      moid = data.intersight_fabric_eth_network_group_policy.ethernet_network_group[
        eth_network_group_policy.value].results[0
      ].moid
    }
  }
  dynamic "flow_control_policy" {
    for_each = toset(compact([each.value.flow_control_policy]))
    content {
      moid = data.intersight_fabric_flow_control_policy.flow_control[
        flow_control_policy.value].results[0
      ].moid
    }
  }
  dynamic "link_control_policy" {
    for_each = toset(compact([each.value.link_control_policy]))
    content {
      moid = data.intersight_fabric_link_control_policy.link_control[
        link_control_policy.value].results[0
      ].moid
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#________________________________________________________________________
#
# Intersight Port Policy - FC Uplink
# GUI Location: Policies > Create Policy > Port > Port Roles > FC Uplink
#________________________________________________________________________

resource "intersight_fabric_fc_storage_role" "port_role_fc_storage" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each          = local.port_role_fc_storage
  admin_speed       = each.value.admin_speed
  aggregate_port_id = each.value.breakout_port_id
  port_id           = each.value.port_id
  slot_id           = each.value.slot_id
  vsan_id           = each.value.vsan_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#________________________________________________________________________
#
# Intersight Port Policy - FC Uplink
# GUI Location: Policies > Create Policy > Port > Port Roles > FC Uplink
#________________________________________________________________________

resource "intersight_fabric_fc_uplink_role" "port_role_fc_uplinks" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each          = local.port_role_fc_uplinks
  admin_speed       = each.value.admin_speed
  aggregate_port_id = each.value.breakout_port_id
  fill_pattern      = each.value.fill_pattern
  port_id           = each.value.port_id
  slot_id           = each.value.slot_id
  vsan_id           = each.value.vsan_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#__________________________________________________________________________________________
#
# Intersight Port Policy - Ethernet Uplink
# GUI Location: Policies > Create Policy > Port > Port Roles > Configure > Ethernet Uplink
#__________________________________________________________________________________________

resource "intersight_fabric_fcoe_uplink_role" "port_role_fcoe_uplinks" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each          = local.port_role_fcoe_uplinks
  admin_speed       = each.value.admin_speed
  aggregate_port_id = each.value.breakout_port_id
  fec               = each.value.fec
  port_id           = each.value.port_id
  slot_id           = each.value.slot_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "link_control_policy" {
    for_each = toset(compact([each.value.link_control_policy]))
    content {
      moid = data.intersight_fabric_link_control_policy.link_control[
        link_control_policy.value].results[0
      ].moid
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#_____________________________________________________________________
#
# Intersight Port Policy - Server Ports
# GUI Location: Policies > Create Policy > Port > Port Roles > Server
#_____________________________________________________________________

resource "intersight_fabric_server_role" "port_role_servers" {
  depends_on = [
    intersight_fabric_port_policy.port_policy
  ]
  for_each          = local.port_role_servers
  aggregate_port_id = each.value.breakout_port_id
  port_id           = each.value.port_id
  slot_id           = each.value.slot_id
  port_policy {
    moid = intersight_fabric_port_policy.port_policy.moid
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
