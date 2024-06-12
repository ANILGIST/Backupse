---
System: ${system}
Tenant Space: ${tenant_space}
System Instance Key: ${system_instance_key}
---

{{#is_alert}}The number of DB connections spiked on {{dbinstanceidentifier.name}}.{{/is_alert}}

{{#is_recovery}}The number of DB connections is back to normal on {{dbinstanceidentifier.name}}.{{/is_recovery}} ${receivers}
