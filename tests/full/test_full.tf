data "intersight_organization_organization" "org_moid" {
  name = "terratest"
}

module "ethernet_network_group" {
  source  = "terraform-cisco-modules/policies-ethernet-network-group/intersight"
  version = ">=1.0.2"

  allowed_vlans = "1-99"
  name          = var.name
  organization  = "terratest"
  native_vlan   = 1
}

module "flow_control" {
  source  = "terraform-cisco-modules/policies-flow-control/intersight"
  version = ">=1.0.2"

  name         = var.name
  organization = "terratest"
}

module "link_aggregation" {
  source  = "terraform-cisco-modules/policies-link-aggregation/intersight"
  version = ">=1.0.2"

  name         = var.name
  organization = "terratest"
}

module "link_control" {
  source  = "terraform-cisco-modules/policies-link-control/intersight"
  version = ">=1.0.2"

  name         = var.name
  organization = "terratest"
}

module "port" {
  source       = "../.."
  description  = "${var.name} Port Policy."
  device_model = "UCS-FI-6536"
  name         = var.name
  organization = "terratest"
  policies = {
    ethernet_network_group = {
      "${var.name}" = {
        moid = module.ethernet_network_group.moid
      }
    }
    flow_control = {
      "${var.name}" = {
        moid = module.flow_control.moid
      }
    }
    link_aggregation = {
      "${var.name}" = {
        moid = module.link_aggregation.moid
      }
    }
    link_control = {
      "${var.name}" = {
        moid = module.link_control.moid
      }
    }
  }
  port_channel_ethernet_uplinks = [
    {
      ethernet_network_group_policy = var.name
      flow_control_policy           = var.name
      interfaces = [
        { port_id = 31 },
        { port_id = 32 }
      ]
      link_aggregation_policy = var.name
      link_control_policy     = var.name
      pc_id                   = 31
    }
  ]
  port_channel_fc_uplinks = [
    {
      fill_pattern = "Arbff"
      interfaces = [
        {
          breakout_port_id = 33
          port_id          = 1
        },
        {
          breakout_port_id = 34
          port_id          = 1
        }
      ]
      pc_id   = 133
      vsan_id = 100
    }
  ]
  port_modes = [
    {
      custom_mode = "BreakoutFibreChannel32G"
      port_list   = [33, 36]
    }
  ]
  port_role_servers = [
    {
      port_list = "1-4"
    }
  ]
}

output "ethernet_network_group" {
  value = module.ethernet_network_group.moid
}

output "flow_control" {
  value = module.flow_control.moid
}

output "link_aggregation" {
  value = module.link_aggregation.moid
}

output "link_control" {
  value = module.link_control.moid
}

output "port_channel_ethernet_uplink" {
  value = module.port.port_channel_ethernet_uplinks[31].moid
}

output "port_channel_fc_uplink" {
  value = module.port.port_channel_fc_uplinks[133].moid
}

output "port_mode" {
  value = module.port.port_modes[33].moid
}

output "port_role_server" {
  value = module.port.port_role_servers[1].moid
}

