#____________________________________________________________
#
# UCS Domain Port Policy Variables Section.
#____________________________________________________________

variable "description" {
  default     = ""
  description = "Description for the Policy."
  type        = string
}

variable "device_model" {
  default     = "UCS-FI-6454"
  description = <<-EOT
    This field specifies the device model template for the Port Policy.
      * UCS-FI-6454 - The standard 4th generation UCS Fabric Interconnect with 54 ports.
      * UCS-FI-64108 - The expanded 4th generation UCS Fabric Interconnect with 108 ports.
      * UCS-FI-6536 - The standard 5th generation UCS Fabric Interconnect with 36 ports.
      * unknown - Unknown device type, usage is TBD.
  EOT
  type        = string
}

variable "domain_profiles" {
  default     = {}
  description = "Map for Moid based Domain Profile Sources."
  type        = any
}

variable "moids" {
  default     = false
  description = "Flag to Determine if pools and policies should be data sources or if they already defined as a moid."
  type        = bool
}

variable "name" {
  default     = "port_policy"
  description = "Name for the Policy."
  type        = string
}

variable "organization" {
  default     = "default"
  description = "Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/."
  type        = string
}

variable "policies" {
  default     = {}
  description = "Map for Moid based Policies Sources."
  type        = any
}

variable "port_channel_appliances" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto: (default) - Admin configurable speed Auto.
      - 1Gbps - Admin configurable speed 1Gbps.
      - 10Gbps - Admin configurable speed 10Gbps.
      - 25Gbps - Admin configurable speed 25Gbps.
      - 40Gbps - Admin configurable speed 40Gbps.
      - 100Gbps - Admin configurable speed 100Gbps.
    * ethernet_network_control_policy: (required) - Name of the Ethernet Network Control policy.
    * ethernet_network_group_policy: (required) - Name of the Ethernet Network Group policy.
    * interfaces: (optional) - list of interfaces {breakout_port_id/port_id/slot_id} to assign to the Port-Channel Policy.
      - breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
      - port_id: (required) - Port ID to Assign to the LAN Port-Channel Policy.
      - slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * link_aggregation_policy: (optional) - Name of the Link Aggregation policy.
    * mode - Port mode to be set on the appliance Port-Channel.
      - access - Access Mode Switch Port Type.
      - trunk: (default) - Trunk Mode Switch Port Type.
    * pc_id: (required) - Number between 1-256.  Port-Channel Identifier to Assign to the Port-Channel.
    * priority: (optional) - The 'name' of the System QoS Class.
      - Best Effort: (default) - QoS Priority for Best-effort traffic.
      - Bronze - QoS Priority for Bronze traffic.
      - FC - QoS Priority for FC traffic.
      - Gold - QoS Priority for Gold traffic.
      - Platinum - QoS Priority for Platinum traffic.
      - Silver - QoS Priority for Silver traffic.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = list(object(
    {
      admin_speed                     = optional(string, "Auto")
      ethernet_network_control_policy = string
      ethernet_network_group_policy   = string
      interfaces = optional(list(object(
        {
          breakout_port_id = optional(number, 0)
          port_id          = number
          slot_id          = optional(number, 1)
        }
      )))
      mode     = optional(string, "trunk")
      pc_id    = number
      priority = optional(string, "Best Effort")
      tags     = optional(list(map(string)), [])
    }
  ))
}

variable "port_channel_ethernet_uplinks" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto: (default) - Admin configurable speed Auto.
      - 1Gbps - Admin configurable speed 1Gbps.
      - 10Gbps - Admin configurable speed 10Gbps.
      - 25Gbps - Admin configurable speed 25Gbps.
      - 40Gbps - Admin configurable speed 40Gbps.
      - 100Gbps - Admin configurable speed 100Gbps.
    * ethernet_network_group_policy: (optional) - Name of the Ethernet Network Group policy.
    * flow_control_policy: (optional) - Name of the Flow Control policy.
    * interfaces: (optional) - list of interfaces {breakout_port_id/port_id/slot_id} to assign to the Port-Channel Policy.
      - breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
      - port_id: (required) - Port ID to Assign to the LAN Port-Channel Policy.
      - slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * link_aggregation_policy: (optional) - Name of the Link Aggregation policy.
    * link_control_policy: (optional) - Name of the Link Control policy.
    * pc_id: (required) - Number between 1-256.  Port-Channel Identifier to Assign to the Port-Channel.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = list(object(
    {
      admin_speed                   = optional(string, "Auto")
      ethernet_network_group_policy = optional(string, "")
      flow_control_policy           = optional(string, "")
      interfaces = optional(list(object(
        {
          breakout_port_id = optional(number, 0)
          port_id          = number
          slot_id          = optional(number, 1)
        }
      )))
      link_aggregation_policy = optional(string, "")
      link_control_policy     = optional(string, "")
      pc_id                   = number
      tags                    = optional(list(map(string)), [])
    }
  ))
}

variable "port_channel_fc_uplinks" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto - Admin configurable speed AUTO.
      - 8Gbps - Admin configurable speed 8Gbps.
      - 16Gbps - Admin configurable speed 16Gbps.
      - 32Gbps: (default) - Admin configurable speed 32Gbps.
    * fill_pattern: (optional) - Fill pattern to differentiate the configs in NPIV.
      - Arbff: (default) - Fc Fill Pattern type Arbff.
      - Idle - Fc Fill Pattern type Idle.
    * interfaces: (optional) - list of interfaces {breakout_port_id/port_id/slot_id} to assign to the Port-Channel Policy.
      - breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
      - port_id: (required) - Port ID to Assign to the LAN Port-Channel Policy.
      - slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * pc_id: (required) - Number between 1-256.  Port-Channel Identifier to Assign to the Port-Channel.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
    * vsan_id: (required) - VSAN to Assign to the Fibre-Channel Uplink.
  EOT
  type = list(object(
    {
      admin_speed  = optional(string, "32Gbps")
      fill_pattern = optional(string, "Arbff")
      interfaces = optional(list(object(
        {
          breakout_port_id = optional(number, 0)
          port_id          = number
          slot_id          = optional(number, 1)
        }
      )))
      pc_id   = number
      tags    = optional(list(map(string)), [])
      vsan_id = number
    }
  ))
}

variable "port_channel_fcoe_uplinks" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto: (default) - Admin configurable speed Auto.
      - 1Gbps - Admin configurable speed 1Gbps.
      - 10Gbps - Admin configurable speed 10Gbps.
      - 25Gbps - Admin configurable speed 25Gbps.
      - 40Gbps - Admin configurable speed 40Gbps.
      - 100Gbps - Admin configurable speed 100Gbps.
    * interfaces: (optional) - list of interfaces {breakout_port_id/port_id/slot_id} to assign to the Port-Channel Policy.
      - breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
      - port_id: (required) - Port ID to Assign to the LAN Port-Channel Policy.
      - slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * link_aggregation_policy: (optional) - Name of the Link Aggregation policy.
    * link_control_policy: (optional) - Name of the Link Control policy.
    * pc_id: (required) - Number between 1-256.  Port-Channel Identifier to Assign to the Port-Channel.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = list(object(
    {
      admin_speed = optional(string, "Auto")
      interfaces = optional(list(object(
        {
          breakout_port_id = optional(number, 0)
          port_id          = number
          slot_id          = optional(number, 1)
        }
      )))
      link_aggregation_policy = optional(string, "")
      link_control_policy     = optional(string, "")
      pc_id                   = number
      tags                    = optional(list(map(string)), [])
    }
  ))
}

variable "port_modes" {
  default     = []
  description = <<-EOT
    * custom_mode: (optional) - Custom Port Mode specified for the port range.
        - FibreChannel: (default) - Fibre Channel Port Types.
        - BreakoutEthernet10G - Breakout Ethernet 10G Port Type.
        - BreakoutEthernet25G - Breakout Ethernet 25G Port Type.
        - BreakoutFibreChannel8G - Breakout FibreChannel 8G Port Type.
        - BreakoutFibreChannel16G - Breakout FibreChannel 16G Port Type.
        - BreakoutFibreChannel32G - Breakout FibreChannel 32G Port Type.
    * port_list: (default is [1, 4]) - List of Ports to reconfigure the Port Mode for.  The list should be the begging port and the ending port.
    * slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = list(object(
    {
      custom_mode = optional(string, "FibreChannel")
      port_list   = list(number)
      slot_id     = optional(number, 1)
      tags        = optional(list(map(string)), [])
    }
  ))
}

variable "port_role_appliances" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto: (default) - Admin configurable speed Auto.
      - 1Gbps - Admin configurable speed 1Gbps.
      - 10Gbps - Admin configurable speed 10Gbps.
      - 25Gbps - Admin configurable speed 25Gbps.
      - 40Gbps - Admin configurable speed 40Gbps.
      - 100Gbps - Admin configurable speed 100Gbps.
    * breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
    * ethernet_network_control_policy: (required) - Name of the Ethernet Network Control policy.
    * ethernet_network_group_policy: (required) - Name of the Ethernet Network Group policy.
    * fec - Forward error correction configuration for the port.
      - Auto: (default) - Forward error correction option 'Auto'.
      - Cl91 - Forward error correction option 'cl91'.
      - Cl74 - Forward error correction option 'cl74'.
    * mode - Port mode to be set on the appliance Port-Channel.
      - access - Access Mode Switch Port Type.
      - trunk: (default) - Trunk Mode Switch Port Type.
    - port_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.
    * priority: (optional) - The 'name' of the System QoS Class.
      - Best Effort: (default) - QoS Priority for Best-effort traffic.
      - Bronze - QoS Priority for Bronze traffic.
      - FC - QoS Priority for FC traffic.
      - Gold - QoS Priority for Gold traffic.
      - Platinum - QoS Priority for Platinum traffic.
      - Silver - QoS Priority for Silver traffic.
    * slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = list(object(
    {
      admin_speed                     = optional(string, "Auto")
      breakout_port_id                = optional(number, 0)
      ethernet_network_control_policy = string
      ethernet_network_group_policy   = string
      fec                             = optional(string, "Auto")
      mode                            = optional(string, "trunk")
      port_list                       = string
      priority                        = optional(string, "Best Effort")
      slot_id                         = optional(number, 1)
      tags                            = optional(list(map(string)), [])
    }
  ))
}

variable "port_role_ethernet_uplinks" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto: (default) - Admin configurable speed Auto.
      - 1Gbps - Admin configurable speed 1Gbps.
      - 10Gbps - Admin configurable speed 10Gbps.
      - 25Gbps - Admin configurable speed 25Gbps.
      - 40Gbps - Admin configurable speed 40Gbps.
      - 100Gbps - Admin configurable speed 100Gbps.
    * breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
    * ethernet_network_group_policy: (optional) - Name of the Ethernet Network Group policy.
    * fec - Forward error correction configuration for the port.
      - Auto: (default) - Forward error correction option 'Auto'.
      - Cl91 - Forward error correction option 'cl91'.
      - Cl74 - Forward error correction option 'cl74'.
    * flow_control_policy: (optional) - Name of the Flow Control policy.
    * link_control_policy: (optional) - Name of the Link Control policy.
    * port_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.
    * slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = list(object(
    {
      admin_speed                   = optional(string, "Auto")
      breakout_port_id              = optional(number, 0)
      ethernet_network_group_policy = optional(string, "")
      fec                           = optional(string, "Auto")
      flow_control_policy           = optional(string, "")
      link_aggregation_policy       = optional(string, "")
      link_control_policy           = optional(string, "")
      port_list                     = string
      slot_id                       = optional(number, 1)
      tags                          = optional(list(map(string)), [])
    }
  ))
}

variable "port_role_fc_storage" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto - Admin configurable speed AUTO.
      - 8Gbps - Admin configurable speed 8Gbps.
      - 16Gbps: (default) - Admin configurable speed 16Gbps.
      - 32Gbps - Admin configurable speed 32Gbps.
    * breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
    * port_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.
    * slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
    * vsan_id: (required) - VSAN to Assign to the Fibre-Channel Uplink.
  EOT
  type = list(object(
    {
      admin_speed      = optional(string, "16Gbps")
      breakout_port_id = optional(number, 0)
      port_list        = string
      slot_id          = optional(number, 1)
      tags             = optional(list(map(string)), [])
      vsan_id          = number
    }
  ))
}

variable "port_role_fc_uplinks" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto - Admin configurable speed AUTO.
      - 8Gbps - Admin configurable speed 8Gbps.
      - 16Gbps - Admin configurable speed 16Gbps.
      - 32Gbps: (default) - Admin configurable speed 32Gbps.
    * breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
    * fill_pattern: (optional) - Fill pattern to differentiate the configs in NPIV.
      - Arbff: (default) - Fc Fill Pattern type Arbff.
      - Idle - Fc Fill Pattern type Idle.
    * port_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.
    * slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
    * vsan_id: (required) - VSAN to Assign to the Fibre-Channel Uplink.
  EOT
  type = list(object(
    {
      admin_speed      = optional(string, "32Gbps")
      breakout_port_id = optional(number, 0)
      fill_pattern     = optional(string, "Arbff")
      port_list        = string
      slot_id          = optional(number, 1)
      tags             = optional(list(map(string)), [])
      vsan_id          = number
    }
  ))
}

variable "port_role_fcoe_uplinks" {
  default     = []
  description = <<-EOT
    * admin_speed: (optional) - Admin configured speed for the port.
      - Auto: (default) - Admin configurable speed Auto.
      - 1Gbps - Admin configurable speed 1Gbps.
      - 10Gbps - Admin configurable speed 10Gbps.
      - 25Gbps - Admin configurable speed 25Gbps.
      - 40Gbps - Admin configurable speed 40Gbps.
      - 100Gbps - Admin configurable speed 100Gbps.
    * breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
    * fec - Forward error correction configuration for the port.
      - Auto: (default) - Forward error correction option 'Auto'.
      - Cl91 - Forward error correction option 'cl91'.
      - Cl74 - Forward error correction option 'cl74'.
    * link_control_policy: (optional) - Name of the Link Control policy.
    * port_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.
    * slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = list(object(
    {
      admin_speed             = optional(string, "Auto")
      breakout_port_id        = optional(number, 0)
      fec                     = optional(string, "Auto")
      link_aggregation_policy = optional(string, "")
      link_control_policy     = optional(string, "")
      port_list               = string
      slot_id                 = optional(number, 1)
      tags                    = optional(list(map(string)), [])
    }
  ))
}

variable "port_role_servers" {
  default     = []
  description = <<-EOT
    * auto_negotation: (default is false) - Auto negotiation configuration for server port. This configuration is required only for FEX Model N9K-C93180YC-FX3 connected with 100G speed port on UCS-FI-6536 and should be set as true.
    * breakout_port_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.
    * connected_device_type: (default is Auto) - Device type for which preferred ID to be configured. If the actual connected device does not match the specified device type, the system ignores the 'PreferredDeviceId' property.
      - Auto - Preferred Id will be ignored if specified with this type.
      - Chassis - Connected device type is Chassis.
      - RackServer - Connected device type is Rack Unit Server.
    * device_number: (defautl is null) - Preferred device ID to be configured by user for the connected device. This ID must be specified together with the 'PreferredDeviceType' property. This ID will only takes effect if the actual connected device matches the 'PreferredDeviceType'. If the preferred ID is not available, the ID is automatically allocated and assigned by the system. If different preferred IDs are specified for the ports connected to the same device, only the preferred ID (if specified) of the port that is discovered first will be considered.
    * fec: (default is Auto) - Forward error correction configuration for server port. This configuration is required only for FEX Model N9K-C93180YC-FX3 connected with 25G speed ports on UCS-FI-6454/UCS-FI-64108 and should be set as Cl74.
      - Auto - Forward error correction option 'Auto'.
      - Cl91 - Forward error correction option 'cl91'.
      - Cl74 - Forward error correction option 'cl74'.
    * port_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.
    * slot_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.
    * tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = list(object(
    {
      auto_negotiation      = optional(bool, false)
      breakout_port_id      = optional(number, 0)
      connected_device_type = optional(string, "Auto")
      device_number         = optional(number, null)
      fec                   = optional(string, "Auto")
      port_list             = string
      slot_id               = optional(number, 1)
      tags                  = optional(list(map(string)), [])
    }
  ))
}

variable "profiles" {
  default     = []
  description = "List of UCS Domain Profile Moids to Assign to the Policy."
  type        = list(string)
}

variable "tags" {
  default     = []
  description = "List of Tag Attributes to Assign to the Policy."
  type        = list(map(string))
}
