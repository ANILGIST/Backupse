resource "datadog_monitor" "queue_oldest_item_monitor_payments_refund" {
  count = var.is_live && contains(var.enabled_queue_workers, "PaymentHandlerManager-refund") ? 1 : 0

  name = "${var.env}: Payments Queue payments_refund has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-warning"])
  })

  query = "logs(\"env:${var.env} @co.queueName:payments_refund @co.oldestItemDelta:>${var.monitor_thresholds.payments_refund_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

  monitor_thresholds {
    critical = 0
  }

  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 300
  no_data_timeframe   = 0
  notify_audit        = false
  include_tags        = true
  priority            = 2

  tags = concat(
    var.monitor_tags,
    [
      "team:payment"
    ]
  )
}

resource "datadog_monitor" "queue_oldest_item_monitor_payments_capture" {
  count = var.is_live && contains(var.enabled_queue_workers, "PaymentHandlerManager-capture") ? 1 : 0

  name = "${var.env}: Payments Queue payments_capture has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-warning"])
  })

  query = "logs(\"env:${var.env} @co.queueName:payments_capture @co.oldestItemDelta:>${var.monitor_thresholds.payments_capture_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

  monitor_thresholds {
    critical = 0
  }

  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 300
  no_data_timeframe   = 0
  notify_audit        = false
  include_tags        = true
  priority            = 2

  tags = concat(
    var.monitor_tags,
    [
      "team:payment"
    ]
  )
}

resource "datadog_monitor" "queue_oldest_item_monitor_payments_cancel" {
  count = var.is_live && contains(var.enabled_queue_workers, "PaymentHandlerManager-cancel") ? 1 : 0

  name = "${var.env}: Payments Queue payments_cancel has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-warning"])
  })

  query = "logs(\"env:${var.env} @co.queueName:payments_cancel @co.oldestItemDelta:>${var.monitor_thresholds.payments_cancel_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

  monitor_thresholds {
    critical = 0
  }

  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 300
  no_data_timeframe   = 0
  notify_audit        = false
  include_tags        = true
  priority            = 2

  tags = concat(
    var.monitor_tags,
    [
      "team:payment"
    ]
  )
}
