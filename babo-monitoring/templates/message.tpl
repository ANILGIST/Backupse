---
System: ${system}
Tenant Space: ${tenant_space}
System Instance Key: ${system_instance_key}
---



{{#is_match "env" "live"}}
  ${live_receivers}
{{/is_match}}
{{#is_match "env" "test"}}
  ${test_receivers}
{{/is_match}}
{{#is_match "env" "prev"}}
  ${prev_receivers}
{{/is_match}}
{{#is_match "env" "demo"}}
  ${demo_receivers}
{{/is_match}}
{{#is_match "env" "qa"}}
  ${qa_receivers}
{{/is_match}}
{{#is_match "env" "dev"}}
  ${dev_receivers}
{{/is_match}}
