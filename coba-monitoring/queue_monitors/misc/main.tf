resource "datadog_monitor" "queue_oldest_item_monitor_returns" {
  count = var.is_live && contains(var.enabled_queue_workers, "ReturnHandler") ? 1 : 0

  name = "${var.env}: Returns Queue has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(
      var.monitor_receiver_overrides, ["slack-payment-emergency", "slack-alerts-tc-emergency"]
    )
  })

  query = "logs(\"env:${var.env} @co.queueName:returns @co.oldestItemDelta:>${var.monitor_thresholds.returns_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_invoices" {
  count = var.is_live && contains(var.enabled_queue_workers, "InvoiceDocumentRendererManager") ? 1 : 0

  name = "${var.env}: Invoices Queue has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:invoices @co.oldestItemDelta:>${var.monitor_thresholds.invoices_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

  tags = var.monitor_tags
}

resource "datadog_monitor" "queue_oldest_item_monitor_sms" {
  count = var.is_live && contains(var.enabled_queue_workers, "SmsSender-CustomerBankAccountReminder") ? 1 : 0

  name = "${var.env}: SMS Queue has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:sms @co.oldestItemDelta:>${var.monitor_thresholds.sms_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

  tags = var.monitor_tags
}

resource "datadog_monitor" "queue_oldest_item_monitor_webhooks" {
  count = var.is_live && contains(var.enabled_queue_workers, "WebhookPendingDeliveryManager") ? 1 : 0

  name = "${var.env}: Webhooks Queue has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:webhooks @co.oldestItemDelta:>${var.monitor_thresholds.webhooks_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

  tags = var.monitor_tags
}
