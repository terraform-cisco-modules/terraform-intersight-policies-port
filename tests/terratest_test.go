package test

import (
	"fmt"
	"os"
	"testing"

	iassert "github.com/cgascoig/intersight-simple-go/assert"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFull(t *testing.T) {
	//========================================================================
	// Setup Terraform options
	//========================================================================

	// Generate a unique name for objects created in this test to ensure we don't
	// have collisions with stale objects
	uniqueId := random.UniqueId()
	instanceName := fmt.Sprintf("test-policies-port-%s", uniqueId)

	// Input variables for the TF module
	vars := map[string]interface{}{
		"apikey":        os.Getenv("IS_KEYID"),
		"secretkeyfile": os.Getenv("IS_KEYFILE"),
		"name":          instanceName,
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./full",
		Vars:         vars,
	})

	//========================================================================
	// Init and apply terraform module
	//========================================================================
	defer terraform.Destroy(t, terraformOptions) // defer to ensure that TF destroy happens automatically after tests are completed
	terraform.InitAndApply(t, terraformOptions)
	ethernet_network_group := terraform.Output(t, terraformOptions, "ethernet_network_group")
	flow_control := terraform.Output(t, terraformOptions, "flow_control")
	link_aggregation := terraform.Output(t, terraformOptions, "link_aggregation")
	link_control := terraform.Output(t, terraformOptions, "link_control")
	moid := terraform.Output(t, terraformOptions, "moid")
	port_channel_ethernet_uplink := terraform.Output(t, terraformOptions, "port_channel_ethernet_uplink")
	port_channel_fc_uplink := terraform.Output(t, terraformOptions, "port_channel_fc_uplink")
	port_mode := terraform.Output(t, terraformOptions, "port_mode")
	port_role_server := terraform.Output(t, terraformOptions, "port_role_server")
	assert.NotEmpty(t, ethernet_network_group, "TF module ethernet_network_group moid output should not be empty")
	assert.NotEmpty(t, flow_control, "TF module flow_control moid output should not be empty")
	assert.NotEmpty(t, link_aggregation, "TF module link_aggregation moid output should not be empty")
	assert.NotEmpty(t, link_control, "TF module link_control moid output should not be empty")
	assert.NotEmpty(t, moid, "TF module moid output should not be empty")
	assert.NotEmpty(t, port_channel_ethernet_uplink, "TF module port_channel_ethernet_uplink moid output should not be empty")
	assert.NotEmpty(t, port_channel_fc_uplink, "TF module port_channel_fc_uplink moid output should not be empty")
	assert.NotEmpty(t, port_mode, "TF module port_mode moid output should not be empty")
	assert.NotEmpty(t, port_role_server, "TF module port_role_server moid output should not be empty")

	// Input variables for the TF module
	vars2 := map[string]interface{}{
		"ethernet_network_group":       ethernet_network_group,
		"flow_control":                 flow_control,
		"link_aggregation":             link_aggregation,
		"link_control":                 link_control,
		"name":                         instanceName,
		"port_policy":                  moid,
		"port_channel_ethernet_uplink": port_channel_ethernet_uplink,
		"port_channel_fc_uplink":       port_channel_fc_uplink,
		"port_mode":                    port_mode,
		"port_role_server":             port_role_server,
	}

	//========================================================================
	// Make Intersight API call(s) to validate module worked
	//========================================================================

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expectedJSONTemplate := `
{
	"Name":        "{{ .name }}",
	"Description": "{{ .name }} Port Policy.",

	"DeviceModel": "UCS-FI-6454",
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/fabric/PortPolicies/%s", moid), expectedJSONTemplate, vars2)

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expected_ETHPC_Template := `
{
	"AdminSpeed": "Auto",
	"EthNetworkGroupPolicy": [
	  {
		"ClassId": "mo.MoRef",
		"Moid": "{{ .ethernet_network_group }}",
		"ObjectType": "fabric.EthNetworkGroupPolicy",
		"link": "https://www.intersight.com/api/v1/fabric/EthNetworkGroupPolicies/{{ .ethernet_network_group }}"
	  }
	],
	"FlowControlPolicy": {
	  "ClassId": "mo.MoRef",
	  "Moid": "{{ .flow_control }}",
	  "ObjectType": "fabric.FlowControlPolicy",
	  "link": "https://www.intersight.com/api/v1/fabric/FlowControlPolicies/{{ .flow_control }}"
	},
	"LinkAggregationPolicy": {
	  "ClassId": "mo.MoRef",
	  "Moid": "{{ .link_aggregation }}",
	  "ObjectType": "fabric.LinkAggregationPolicy",
	  "link": "https://www.intersight.com/api/v1/fabric/LinkAggregationPolicies/{{ .link_aggregation }}"
	},
	"LinkControlPolicy": {
	  "ClassId": "mo.MoRef",
	  "Moid": "{{ .link_control }}",
	  "ObjectType": "fabric.LinkControlPolicy",
	  "link": "https://www.intersight.com/api/v1/fabric/LinkControlPolicies/{{ .link_control }}"
	},
	"PcId": 31,
	"PortPolicy": {
		"ClassId": "mo.MoRef",
		"Moid": "{{ .port_policy }}",
		"ObjectType": "fabric.PortPolicy",
		"link": "https://www.intersight.com/api/v1/fabric/PortPolicies/{{ .port_policy }}"
	},
	"Ports": [
	  {
		"AggregatePortId": 0,
		"ClassId": "fabric.PortIdentifier",
		"ObjectType": "fabric.PortIdentifier",
		"PortId": 31,
		"SlotId": 1
	  },
	  {
		"AggregatePortId": 0,
		"ClassId": "fabric.PortIdentifier",
		"ObjectType": "fabric.PortIdentifier",
		"PortId": 32,
		"SlotId": 1
	  }
	]
  }
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/fabric/UplinkPcRoles/%s", port_channel_ethernet_uplink), expected_ETHPC_Template, vars2)

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expected_FCPC_Template := `
{
	"AdminSpeed": "32Gbps",
	"FillPattern": "Arbff",
	"PcId": 133,
	"PortPolicy": {
		"ClassId": "mo.MoRef",
		"Moid": "{{ .port_policy }}",
		"ObjectType": "fabric.PortPolicy",
		"link": "https://www.intersight.com/api/v1/fabric/PortPolicies/{{ .port_policy }}"
	},
	"Ports": [
        {
          "AggregatePortId": 33,
          "ClassId": "fabric.PortIdentifier",
          "ObjectType": "fabric.PortIdentifier",
          "PortId": 1,
          "SlotId": 1
        },
        {
          "AggregatePortId": 34,
          "ClassId": "fabric.PortIdentifier",
          "ObjectType": "fabric.PortIdentifier",
          "PortId": 1,
          "SlotId": 1
        }
	],
	"VsanId": 100
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/fabric/FcUplinkPcRoles/%s", port_channel_fc_uplink), expected_FCPC_Template, vars2)

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expected_PORTMODE_Template := `
{
	"PortIdEnd": 36,
	"PortIdStart": 33,
	"PortPolicy": {
	  "ClassId": "mo.MoRef",
	  "Moid": "{{ .port_policy }}",
	  "ObjectType": "fabric.PortPolicy",
	  "link": "https://www.intersight.com/api/v1/fabric/PortPolicies/{{ .port_policy }}"
	},
	"SlotId": 1
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/fabric/PortModes/%s", port_mode), expected_PORTMODE_Template, vars2)

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expected_SERVERS_Template := `
{
	"AggregatePortId": 0,
	"AutoNegotiationDisabled": false,
	"Fec": "Auto",
	"PortId": 1,
	"PortPolicy": {
		"ClassId": "mo.MoRef",
		"Moid": "{{ .port_policy }}",
		"ObjectType": "fabric.PortPolicy",
		"link": "https://www.intersight.com/api/v1/fabric/PortPolicies/{{ .port_policy }}"
	},
	"SlotId": 1
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/fabric/ServerRoles/%s", port_role_server), expected_SERVERS_Template, vars2)
}
