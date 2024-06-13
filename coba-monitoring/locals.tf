locals {
  system = "coba"

  system_instance_key = join("-", [
    var.tenant_short_key,
    var.environment,
  local.system])

  tenant_space = join("-", [
    var.tenant_short_key,
  var.environment])

  datadog_notification_email            = " "
  datadog_slack_tc_notification_channel = "slack-alerts-tc-warning"

  service_name = "${local.system}-api-co"

  common_monitor_tags = [
    "service:${local.service_name}",
    "system:${local.system}",
    "env:${local.tenant_space}",
    "team:tc"
  ]
}
