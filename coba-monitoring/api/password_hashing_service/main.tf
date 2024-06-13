resource "datadog_monitor" "owasp_service_internal_error_alert" {
  count   = var.is_live ? 1 : 0
  name    = "OWASP Hashing Service errors on ${var.system_instance_key}"
  type    = "query alert"
  message = <<EOM
The OWASP Hashing service is returning response status code 5xx on ${var.tenant_space}
---
System: ${var.system}
Tenant Space: ${var.tenant_space}
System Instance Key: ${var.system_instance_key}
---
{{#is_alert}}
  @${var.datadog_notification_email}
  @${var.datadog_slack_tc_notification_channel}
{{/is_alert}}
EOM
  query   = "sum(last_30m):default_zero(sum:coba_owasp_service_errors{env:*-production,statusCode:5*} by {env}.as_count()) > ${var.coba_datadog_owasp_service_internal_errors_threshold}"

  monitor_thresholds {
    critical = var.coba_datadog_owasp_service_internal_errors_threshold
  }
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${var.system}",
    "system_instance_key:${var.system_instance_key}",
    "tenant_space:${var.tenant_space}",
    "env:${var.environment}",
    "team:tc",
    "team:transactionCore",
  "service:owasp"]
}

resource "datadog_monitor" "owasp_service_timeout_alert" {
  count   = var.is_live ? 1 : 0
  name    = "OWASP Hashing Service timeouts on ${var.system_instance_key}"
  type    = "query alert"
  message = <<EOM
The OWASP Hashing service is returning response status code 0 (timeout) on ${var.tenant_space}
---
System: ${var.system}
Tenant Space: ${var.tenant_space}
System Instance Key: ${var.system_instance_key}
---
{{#is_alert}}
  @${var.datadog_notification_email}
  @${var.datadog_slack_tc_notification_channel}
{{/is_alert}}
EOM
  query   = "sum(last_30m):default_zero(sum:coba_owasp_service_errors{env:*-production,statusCode:0} by {env}.as_count()) > ${var.coba_datadog_owasp_service_timeouts_threshold}"

  monitor_thresholds {
    critical = var.coba_datadog_owasp_service_timeouts_threshold
  }
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${var.system}",
    "system_instance_key:${var.system_instance_key}",
    "tenant_space:${var.tenant_space}",
    "env:${var.environment}",
    "team:tc",
    "team:transactionCore",
  "service:owasp"]
}
