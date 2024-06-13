resource "datadog_monitor" "too_many_queue_db_connections_monitor" {
  count = var.is_live ? 1 : 0

  name = "${var.env}: Too many database connections, threshold >= {{threshold}}"
  type = "query alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.default_monitor_message
    alerting_receivers = coalescelist(["slack-alerts-tc-emergency"])
  })

  query = "avg(last_10m):avg:ay_custom.checkout.too_many_db_connections{env:${var.env}} > ${var.monitor_thresholds.too_many_db_connections}"

  monitor_thresholds {
    critical = var.monitor_thresholds.too_many_db_connections
  }

  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0
  no_data_timeframe   = 0
  notify_audit        = false
  include_tags        = true
  priority            = 3

  tags = var.monitor_tags
}
