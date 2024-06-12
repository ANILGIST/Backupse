---
System: ${system}
Tenant Space: ${tenant_space}
System Instance Key: ${system_instance_key}
---

{{#is_alert}}
 ${alert_receivers}
{{/is_alert}}
{{#is_warning}}
 ${warning_receivers}
{{/is_warning}}
