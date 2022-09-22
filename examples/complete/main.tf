module "port_policy" {
  source  = "terraform-cisco-modules/policies-port/intersight"
  version = ">= 1.0.1"

  description      = "default Port Policy."
  device_model = "UCS-FI-6536"
  name         = "default"
  organization = "default"
  port_channel_ethernet_uplinks = [
    {
      ethernet_network_group_policy = "uplink_vg"
      flow_control_policy = "default"
      interfaces = [
        { port_id = 31 },
        { port_id = 32 }
      ]
      link_aggregation_policy = "default"
      link_control_policy = "default"
      pc_id = 31
    }
  ]
  port_channel_fc_uplinks = [
    {
      fill_pattern = "Arbff"
      interfaces = [
        {
          breakout_port_id = 33
          port_id = 1
        },
        {
          breakout_port_id = 34
          port_id = 1
        }
      ]
      pc_id = 133
    }
  ]
  port_modes = [
    {
      custom_mode = "BreakoutFibreChannel32G"
      port_list = [33, 36]
    }
  ]
  port_role_servers = [
    {
      port_list = "1-28"
    }
  ]
}

