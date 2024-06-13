resource "datadog_monitor" "queue_size_monitor_number_of_returns_in_queue" {
  count = var.is_live && contains(var.enabled_queue_workers, "ReturnHandlerManager") ? 1 : 0

  name = "${var.env}: [IGNORE1] parent: \"Number of returns in queue exceeds\""
  type = "log alert"

  query = "logs(\"@co.queueName:returns -@co.queueSize:0 env:${var.env}\").index(\"*\").rollup(\"count\").last(\"5m\") > ${var.monitor_thresholds.composite_returns}"

  message = "${var.env}: Number of returns exceeds ${var.monitor_thresholds.composite_returns}"

  monitor_thresholds {
    critical = var.monitor_thresholds.composite_returns
  }

  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0
  no_data_timeframe   = 60
  notify_audit        = false
  include_tags        = true
  priority            = 2

  tags = concat(
    var.monitor_tags,
    [
      "team:tc",
      "team:co-coba",
      "team:checkout"
    ]
  )
}

resource "datadog_monitor" "queue_size_monitor_number_of_return_workers" {
  count = var.is_live && contains(var.enabled_queue_workers, "ReturnHandlerManager") ? 1 : 0

  name = "${var.env}:[IGNORE2] parent: \"Number of returns in queue exceeds\""
  type = "log alert"

  query = "logs(\"@co.api:returnhandler env:${var.env}\").index(\"*\").rollup(\"count\").last(\"5m\") <= 0"

  message = "${var.env}: No returns workers running"

  monitor_thresholds {
    critical = 0
  }

  require_full_window = false
  notify_no_data      = true
  renotify_interval   = 0
  no_data_timeframe   = 60
  notify_audit        = false
  include_tags        = true
  priority            = 2

  tags = concat(
    var.monitor_tags,
    [
      "team:tc",
      "team:co-coba",
      "team:checkout"
    ]
  )
}

resource "datadog_monitor" "queue_size_composite_monitor_returns" {
  count = var.is_live && contains(var.enabled_queue_workers, "ReturnHandlerManager") ? 1 : 0

  name = "${var.env}: Number of returns in queue exceeds {{threshold}}"
  type = "composite"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.default_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "${datadog_monitor.queue_size_monitor_number_of_returns_in_queue[count.index].id} && ${datadog_monitor.queue_size_monitor_number_of_return_workers[count.index].id}"

  require_full_window = false
  notify_no_data      = true
  renotify_interval   = 0
  no_data_timeframe   = 60
  notify_audit        = false
  include_tags        = true
  priority            = 2

  tags = concat(
    var.monitor_tags,
    [
      "team:tc",
      "team:co-coba",
      "team:checkout"
    ]
  )
}
