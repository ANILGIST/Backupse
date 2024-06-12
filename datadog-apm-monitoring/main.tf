module "standards" {
  source          = "git@gitlab.com:aboutyou/platform/terraform-modules/datadog-monitor-defaults.git?ref=task/add-templates"
  team            = var.team
  pagerduty_email = var.pagerduty_email
}


locals {
  all_monitor_tags       = setunion(var.tags, ["monitor:datadog-apm-monitor"])
  critical_alert_message = module.standards.critical_message
}

# APM elevated error rate
resource "datadog_monitor" "elevated_error_rate" {

  for_each = {
    for endpoint, config in var.endpoints :
    endpoint => config
    if contains(config.monitors, "elevated_error_rate")
  }

  name    = "${each.value.name} - Elevated error rate"
  type    = "query alert"
  query   = "avg(last_24h):anomalies(sum:trace.http.request.errors{${join(" OR ", each.value.where)}} by {env,resource_name}.as_count(), 'robust', 5, direction='above', interval=120, alert_window='last_30m', count_default_zero='true', seasonality='weekly', timezone='Europe/Berlin') >= 1"
  message = local.critical_alert_message
  tags    = setunion(local.all_monitor_tags, each.value.tags)

  monitor_thresholds {
    critical          = 1
    warning           = 0.9
    critical_recovery = 0
  }

  monitor_threshold_windows {
    trigger_window  = "last_30m"
    recovery_window = "last_15m"
  }

  priority         = 1
  evaluation_delay = 60
}

# APM elevated latency
resource "datadog_monitor" "elevated_latency" {
  for_each = {
    for endpoint, config in var.endpoints :
    endpoint => config
    if contains(config.monitors, "elevated_latency")
  }

  name    = "${each.value.name} - High p90 response time"
  type    = "query alert"
  query   = "avg(last_24h):anomalies(p90:trace.http.request{${join(" OR ", each.value.where)}} by {env,resource_name}, 'robust', 5, direction='above', interval=120, alert_window='last_30m', count_default_zero='true', seasonality='weekly', timezone='Europe/Berlin') >= 1"
  message = local.critical_alert_message
  tags    = setunion(local.all_monitor_tags, each.value.tags)

  monitor_thresholds {
    critical          = 1
    warning           = 0.9
    critical_recovery = 0
  }

  monitor_threshold_windows {
    trigger_window  = "last_30m"
    recovery_window = "last_15m"
  }

  evaluation_delay = 60
  priority         = 1
}
