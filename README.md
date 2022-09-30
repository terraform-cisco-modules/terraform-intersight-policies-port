<!-- BEGIN_TF_DOCS -->
# Terraform Intersight Policies - Port
Manages Intersight Port Policies

Location in GUI:
`Policies` » `Create Policy` » `Port`

## Example

### main.tf
```hcl
module "port_policy" {
  source  = "terraform-cisco-modules/policies-port/intersight"
  version = ">= 1.0.1"

  description  = "default Port Policy."
  device_model = "UCS-FI-6536"
  name         = "default"
  organization = "default"
  port_channel_ethernet_uplinks = [
    {
      ethernet_network_group_policy = "uplink_vg"
      flow_control_policy           = "default"
      interfaces = [
        { port_id = 31 },
        { port_id = 32 }
      ]
      link_aggregation_policy = "default"
      link_control_policy     = "default"
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
      pc_id = 133
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
      port_list = "1-28"
    }
  ]
}
```

### provider.tf
```hcl
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.32"
    }
  }
  required_version = ">=1.3.0"
}

provider "intersight" {
  apikey    = var.apikey
  endpoint  = var.endpoint
  secretkey = var.secretkey
}
```

### variables.tf
```hcl
variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "endpoint" {
  default     = "https://intersight.com"
  description = "Intersight URL."
  type        = string
}

variable "secretkey" {
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}
```

## Environment Variables

### Terraform Cloud/Enterprise - Workspace Variables
- Add variable apikey with value of [your-api-key]
- Add variable secretkey with value of [your-secret-file-content]

### Linux
```bash
export TF_VAR_apikey="<your-api-key>"
export TF_VAR_secretkey=`cat <secret-key-file-location>`
```

### Windows
```bash
$env:TF_VAR_apikey="<your-api-key>"
$env:TF_VAR_secretkey="<secret-key-file-location>"
```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.32 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apikey"></a> [apikey](#input\_apikey) | Intersight API Key. | `string` | n/a | yes |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | Intersight URL. | `string` | `"https://intersight.com"` | no |
| <a name="input_secretkey"></a> [secretkey](#input\_secretkey) | Intersight Secret Key. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description for the Policy. | `string` | `""` | no |
| <a name="input_device_model"></a> [device\_model](#input\_device\_model) | This field specifies the device model template for the Port Policy.<br>  * UCS-FI-6454 - The standard 4th generation UCS Fabric Interconnect with 54 ports.<br>  * UCS-FI-64108 - The expanded 4th generation UCS Fabric Interconnect with 108 ports.<br>  * UCS-FI-6536 - The standard 5th generation UCS Fabric Interconnect with 36 ports.<br>  * unknown - Unknown device type, usage is TBD. | `string` | `"UCS-FI-6454"` | no |
| <a name="input_domain_profiles"></a> [domain\_profiles](#input\_domain\_profiles) | Map for Moid based Domain Profile Sources. | `any` | `{}` | no |
| <a name="input_moids"></a> [moids](#input\_moids) | Flag to Determine if pools and policies should be data sources or if they already defined as a moid. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Policy. | `string` | `"port_policy"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Intersight Organization Name to Apply Policy to.  https://intersight.com/an/settings/organizations/. | `string` | `"default"` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Map for Moid based Policies Sources. | `any` | `{}` | no |
| <a name="input_port_channel_appliances"></a> [port\_channel\_appliances](#input\_port\_channel\_appliances) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto: (default) - Admin configurable speed Auto.<br>  - 1Gbps - Admin configurable speed 1Gbps.<br>  - 10Gbps - Admin configurable speed 10Gbps.<br>  - 25Gbps - Admin configurable speed 25Gbps.<br>  - 40Gbps - Admin configurable speed 40Gbps.<br>  - 100Gbps - Admin configurable speed 100Gbps.<br>* ethernet\_network\_control\_policy: (required) - Name of the Ethernet Network Control policy.<br>* ethernet\_network\_group\_policy: (required) - Name of the Ethernet Network Group policy.<br>* interfaces: (optional) - list of interfaces {breakout\_port\_id/port\_id/slot\_id} to assign to the Port-Channel Policy.<br>  - breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>  - port\_id: (required) - Port ID to Assign to the LAN Port-Channel Policy.<br>  - slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* link\_aggregation\_policy: (optional) - Name of the Link Aggregation policy.<br>* mode - Port mode to be set on the appliance Port-Channel.<br>  - access - Access Mode Switch Port Type.<br>  - trunk: (default) - Trunk Mode Switch Port Type.<br>* pc\_id: (required) - Number between 1-256.  Port-Channel Identifier to Assign to the Port-Channel.<br>* priority: (optional) - The 'name' of the System QoS Class.<br>  - Best Effort: (default) - QoS Priority for Best-effort traffic.<br>  - Bronze - QoS Priority for Bronze traffic.<br>  - FC - QoS Priority for FC traffic.<br>  - Gold - QoS Priority for Gold traffic.<br>  - Platinum - QoS Priority for Platinum traffic.<br>  - Silver - QoS Priority for Silver traffic.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy. | <pre>list(object(<br>    {<br>      admin_speed                     = optional(string, "Auto")<br>      ethernet_network_control_policy = string<br>      ethernet_network_group_policy   = string<br>      interfaces = optional(list(object(<br>        {<br>          breakout_port_id = optional(number, 0)<br>          port_id          = number<br>          slot_id          = optional(number, 1)<br>        }<br>      )))<br>      mode     = optional(string, "trunk")<br>      pc_id    = number<br>      priority = optional(string, "Best Effort")<br>      tags     = optional(list(map(string)), [])<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_channel_ethernet_uplinks"></a> [port\_channel\_ethernet\_uplinks](#input\_port\_channel\_ethernet\_uplinks) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto: (default) - Admin configurable speed Auto.<br>  - 1Gbps - Admin configurable speed 1Gbps.<br>  - 10Gbps - Admin configurable speed 10Gbps.<br>  - 25Gbps - Admin configurable speed 25Gbps.<br>  - 40Gbps - Admin configurable speed 40Gbps.<br>  - 100Gbps - Admin configurable speed 100Gbps.<br>* ethernet\_network\_group\_policy: (optional) - Name of the Ethernet Network Group policy.<br>* flow\_control\_policy: (optional) - Name of the Flow Control policy.<br>* interfaces: (optional) - list of interfaces {breakout\_port\_id/port\_id/slot\_id} to assign to the Port-Channel Policy.<br>  - breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>  - port\_id: (required) - Port ID to Assign to the LAN Port-Channel Policy.<br>  - slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* link\_aggregation\_policy: (optional) - Name of the Link Aggregation policy.<br>* link\_control\_policy: (optional) - Name of the Link Control policy.<br>* pc\_id: (required) - Number between 1-256.  Port-Channel Identifier to Assign to the Port-Channel.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy. | <pre>list(object(<br>    {<br>      admin_speed                   = optional(string, "Auto")<br>      ethernet_network_group_policy = optional(string, "")<br>      flow_control_policy           = optional(string, "")<br>      interfaces = optional(list(object(<br>        {<br>          breakout_port_id = optional(number, 0)<br>          port_id          = number<br>          slot_id          = optional(number, 1)<br>        }<br>      )))<br>      link_aggregation_policy = optional(string, "")<br>      link_control_policy     = optional(string, "")<br>      pc_id                   = number<br>      tags                    = optional(list(map(string)), [])<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_channel_fc_uplinks"></a> [port\_channel\_fc\_uplinks](#input\_port\_channel\_fc\_uplinks) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto - Admin configurable speed AUTO.<br>  - 8Gbps - Admin configurable speed 8Gbps.<br>  - 16Gbps - Admin configurable speed 16Gbps.<br>  - 32Gbps: (default) - Admin configurable speed 32Gbps.<br>* fill\_pattern: (optional) - Fill pattern to differentiate the configs in NPIV.<br>  - Arbff: (default) - Fc Fill Pattern type Arbff.<br>  - Idle - Fc Fill Pattern type Idle.<br>* interfaces: (optional) - list of interfaces {breakout\_port\_id/port\_id/slot\_id} to assign to the Port-Channel Policy.<br>  - breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>  - port\_id: (required) - Port ID to Assign to the LAN Port-Channel Policy.<br>  - slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* pc\_id: (required) - Number between 1-256.  Port-Channel Identifier to Assign to the Port-Channel.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.<br>* vsan\_id: (required) - VSAN to Assign to the Fibre-Channel Uplink. | <pre>list(object(<br>    {<br>      admin_speed  = optional(string, "32Gbps")<br>      fill_pattern = optional(string, "Arbff")<br>      interfaces = optional(list(object(<br>        {<br>          breakout_port_id = optional(number, 0)<br>          port_id          = number<br>          slot_id          = optional(number, 1)<br>        }<br>      )))<br>      pc_id   = number<br>      tags    = optional(list(map(string)), [])<br>      vsan_id = number<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_channel_fcoe_uplinks"></a> [port\_channel\_fcoe\_uplinks](#input\_port\_channel\_fcoe\_uplinks) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto: (default) - Admin configurable speed Auto.<br>  - 1Gbps - Admin configurable speed 1Gbps.<br>  - 10Gbps - Admin configurable speed 10Gbps.<br>  - 25Gbps - Admin configurable speed 25Gbps.<br>  - 40Gbps - Admin configurable speed 40Gbps.<br>  - 100Gbps - Admin configurable speed 100Gbps.<br>* interfaces: (optional) - list of interfaces {breakout\_port\_id/port\_id/slot\_id} to assign to the Port-Channel Policy.<br>  - breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>  - port\_id: (required) - Port ID to Assign to the LAN Port-Channel Policy.<br>  - slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* link\_aggregation\_policy: (optional) - Name of the Link Aggregation policy.<br>* link\_control\_policy: (optional) - Name of the Link Control policy.<br>* pc\_id: (required) - Number between 1-256.  Port-Channel Identifier to Assign to the Port-Channel.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy. | <pre>list(object(<br>    {<br>      admin_speed = optional(string, "Auto")<br>      interfaces = optional(list(object(<br>        {<br>          breakout_port_id = optional(number, 0)<br>          port_id          = number<br>          slot_id          = optional(number, 1)<br>        }<br>      )))<br>      link_aggregation_policy = optional(string, "")<br>      link_control_policy     = optional(string, "")<br>      pc_id                   = number<br>      tags                    = optional(list(map(string)), [])<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_modes"></a> [port\_modes](#input\_port\_modes) | * custom\_mode: (optional) - Custom Port Mode specified for the port range.<br>    - FibreChannel: (default) - Fibre Channel Port Types.<br>    - BreakoutEthernet10G - Breakout Ethernet 10G Port Type.<br>    - BreakoutEthernet25G - Breakout Ethernet 25G Port Type.<br>    - BreakoutFibreChannel8G - Breakout FibreChannel 8G Port Type.<br>    - BreakoutFibreChannel16G - Breakout FibreChannel 16G Port Type.<br>    - BreakoutFibreChannel32G - Breakout FibreChannel 32G Port Type.<br>* port\_list: (default is [1, 4]) - List of Ports to reconfigure the Port Mode for.  The list should be the begging port and the ending port.<br>* slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy. | <pre>list(object(<br>    {<br>      custom_mode = optional(string, "FibreChannel")<br>      port_list   = list(number)<br>      slot_id     = optional(number, 1)<br>      tags        = optional(list(map(string)), [])<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_role_appliances"></a> [port\_role\_appliances](#input\_port\_role\_appliances) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto: (default) - Admin configurable speed Auto.<br>  - 1Gbps - Admin configurable speed 1Gbps.<br>  - 10Gbps - Admin configurable speed 10Gbps.<br>  - 25Gbps - Admin configurable speed 25Gbps.<br>  - 40Gbps - Admin configurable speed 40Gbps.<br>  - 100Gbps - Admin configurable speed 100Gbps.<br>* breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>* ethernet\_network\_control\_policy: (required) - Name of the Ethernet Network Control policy.<br>* ethernet\_network\_group\_policy: (required) - Name of the Ethernet Network Group policy.<br>* fec - Forward error correction configuration for the port.<br>  - Auto: (default) - Forward error correction option 'Auto'.<br>  - Cl91 - Forward error correction option 'cl91'.<br>  - Cl74 - Forward error correction option 'cl74'.<br>* mode - Port mode to be set on the appliance Port-Channel.<br>  - access - Access Mode Switch Port Type.<br>  - trunk: (default) - Trunk Mode Switch Port Type.<br>- port\_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.<br>* priority: (optional) - The 'name' of the System QoS Class.<br>  - Best Effort: (default) - QoS Priority for Best-effort traffic.<br>  - Bronze - QoS Priority for Bronze traffic.<br>  - FC - QoS Priority for FC traffic.<br>  - Gold - QoS Priority for Gold traffic.<br>  - Platinum - QoS Priority for Platinum traffic.<br>  - Silver - QoS Priority for Silver traffic.<br>* slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy. | <pre>list(object(<br>    {<br>      admin_speed                     = optional(string, "Auto")<br>      breakout_port_id                = optional(number, 0)<br>      ethernet_network_control_policy = string<br>      ethernet_network_group_policy   = string<br>      fec                             = optional(string, "Auto")<br>      mode                            = optional(string, "trunk")<br>      port_list                       = string<br>      priority                        = optional(string, "Best Effort")<br>      slot_id                         = optional(number, 1)<br>      tags                            = optional(list(map(string)), [])<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_role_ethernet_uplinks"></a> [port\_role\_ethernet\_uplinks](#input\_port\_role\_ethernet\_uplinks) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto: (default) - Admin configurable speed Auto.<br>  - 1Gbps - Admin configurable speed 1Gbps.<br>  - 10Gbps - Admin configurable speed 10Gbps.<br>  - 25Gbps - Admin configurable speed 25Gbps.<br>  - 40Gbps - Admin configurable speed 40Gbps.<br>  - 100Gbps - Admin configurable speed 100Gbps.<br>* breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>* ethernet\_network\_group\_policy: (optional) - Name of the Ethernet Network Group policy.<br>* fec - Forward error correction configuration for the port.<br>  - Auto: (default) - Forward error correction option 'Auto'.<br>  - Cl91 - Forward error correction option 'cl91'.<br>  - Cl74 - Forward error correction option 'cl74'.<br>* flow\_control\_policy: (optional) - Name of the Flow Control policy.<br>* link\_control\_policy: (optional) - Name of the Link Control policy.<br>* port\_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.<br>* slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy. | <pre>list(object(<br>    {<br>      admin_speed                   = optional(string, "Auto")<br>      breakout_port_id              = optional(number, 0)<br>      ethernet_network_group_policy = optional(string, "")<br>      fec                           = optional(string, "Auto")<br>      flow_control_policy           = optional(string, "")<br>      link_aggregation_policy       = optional(string, "")<br>      link_control_policy           = optional(string, "")<br>      port_list                     = string<br>      slot_id                       = optional(number, 1)<br>      tags                          = optional(list(map(string)), [])<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_role_fc_storage"></a> [port\_role\_fc\_storage](#input\_port\_role\_fc\_storage) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto - Admin configurable speed AUTO.<br>  - 8Gbps - Admin configurable speed 8Gbps.<br>  - 16Gbps: (default) - Admin configurable speed 16Gbps.<br>  - 32Gbps - Admin configurable speed 32Gbps.<br>* breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>* port\_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.<br>* slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.<br>* vsan\_id: (required) - VSAN to Assign to the Fibre-Channel Uplink. | <pre>list(object(<br>    {<br>      admin_speed      = optional(string, "16Gbps")<br>      breakout_port_id = optional(number, 0)<br>      port_list        = string<br>      slot_id          = optional(number, 1)<br>      tags             = optional(list(map(string)), [])<br>      vsan_id          = number<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_role_fc_uplinks"></a> [port\_role\_fc\_uplinks](#input\_port\_role\_fc\_uplinks) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto - Admin configurable speed AUTO.<br>  - 8Gbps - Admin configurable speed 8Gbps.<br>  - 16Gbps - Admin configurable speed 16Gbps.<br>  - 32Gbps: (default) - Admin configurable speed 32Gbps.<br>* breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>* fill\_pattern: (optional) - Fill pattern to differentiate the configs in NPIV.<br>  - Arbff: (default) - Fc Fill Pattern type Arbff.<br>  - Idle - Fc Fill Pattern type Idle.<br>* port\_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.<br>* slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy.<br>* vsan\_id: (required) - VSAN to Assign to the Fibre-Channel Uplink. | <pre>list(object(<br>    {<br>      admin_speed      = optional(string, "32Gbps")<br>      breakout_port_id = optional(number, 0)<br>      fill_pattern     = optional(string, "Arbff")<br>      port_list        = string<br>      slot_id          = optional(number, 1)<br>      tags             = optional(list(map(string)), [])<br>      vsan_id          = number<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_role_fcoe_uplinks"></a> [port\_role\_fcoe\_uplinks](#input\_port\_role\_fcoe\_uplinks) | * admin\_speed: (optional) - Admin configured speed for the port.<br>  - Auto: (default) - Admin configurable speed Auto.<br>  - 1Gbps - Admin configurable speed 1Gbps.<br>  - 10Gbps - Admin configurable speed 10Gbps.<br>  - 25Gbps - Admin configurable speed 25Gbps.<br>  - 40Gbps - Admin configurable speed 40Gbps.<br>  - 100Gbps - Admin configurable speed 100Gbps.<br>* breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>* fec - Forward error correction configuration for the port.<br>  - Auto: (default) - Forward error correction option 'Auto'.<br>  - Cl91 - Forward error correction option 'cl91'.<br>  - Cl74 - Forward error correction option 'cl74'.<br>* link\_control\_policy: (optional) - Name of the Link Control policy.<br>* port\_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.<br>* slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy. | <pre>list(object(<br>    {<br>      admin_speed             = optional(string, "Auto")<br>      breakout_port_id        = optional(number, 0)<br>      fec                     = optional(string, "Auto")<br>      link_aggregation_policy = optional(string, "")<br>      link_control_policy     = optional(string, "")<br>      port_list               = string<br>      slot_id                 = optional(number, 1)<br>      tags                    = optional(list(map(string)), [])<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_port_role_servers"></a> [port\_role\_servers](#input\_port\_role\_servers) | * breakout\_port\_id: (default is 0) - Breakout port Identifier of the Switch Interface.  When a port is not configured as a breakout port, the aggregatePortId is set to 0, and unused.  When a port is configured as a breakout port, the 'aggregatePortId' port number as labeled on the equipment, e.g. the id of the port on the switch.<br>* port\_list: (required) - Ports to Assign.  Value can be single port `1` or a list of ports `1-10,15-25`.<br>* slot\_id: (default is 1) - Slot Identifier of the Switch/FEX/Chassis Interface.<br>* tags: (optional) - List of Key/Value Pairs to Assign as Attributes to the Policy. | <pre>list(object(<br>    {<br>      breakout_port_id = optional(number, 0)<br>      port_list        = string<br>      slot_id          = optional(number, 1)<br>      tags             = optional(list(map(string)), [])<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | List of UCS Domain Profile Moids to Assign to the Policy. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of Tag Attributes to Assign to the Policy. | `list(map(string))` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_moid"></a> [moid](#output\_moid) | UCS Domain Port Policy Managed Object ID (moid). |
## Resources

| Name | Type |
|------|------|
| [intersight_fabric_appliance_pc_role.port_channel_appliances](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_appliance_pc_role) | resource |
| [intersight_fabric_appliance_role.port_role_appliances](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_appliance_role) | resource |
| [intersight_fabric_fc_storage_role.port_role_fc_storage](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_storage_role) | resource |
| [intersight_fabric_fc_uplink_pc_role.port_channel_fc_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_uplink_pc_role) | resource |
| [intersight_fabric_fc_uplink_role.port_role_fc_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_uplink_role) | resource |
| [intersight_fabric_fcoe_uplink_pc_role.port_channel_fcoe_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fcoe_uplink_pc_role) | resource |
| [intersight_fabric_fcoe_uplink_role.port_role_fcoe_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fcoe_uplink_role) | resource |
| [intersight_fabric_port_mode.port_modes](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_mode) | resource |
| [intersight_fabric_port_policy.port](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_policy) | resource |
| [intersight_fabric_server_role.port_role_servers](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_server_role) | resource |
| [intersight_fabric_uplink_pc_role.port_channel_ethernet_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_uplink_pc_role) | resource |
| [intersight_fabric_uplink_role.port_role_ethernet_uplinks](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_uplink_role) | resource |
| [intersight_fabric_eth_network_control_policy.ethernet_network_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_eth_network_control_policy) | data source |
| [intersight_fabric_eth_network_group_policy.ethernet_network_group](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_eth_network_group_policy) | data source |
| [intersight_fabric_flow_control_policy.flow_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_flow_control_policy) | data source |
| [intersight_fabric_link_aggregation_policy.link_aggregation](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_link_aggregation_policy) | data source |
| [intersight_fabric_link_control_policy.link_control](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_link_control_policy) | data source |
| [intersight_fabric_switch_profile.profiles](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/fabric_switch_profile) | data source |
| [intersight_organization_organization.org_moid](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/organization_organization) | data source |
<!-- END_TF_DOCS -->