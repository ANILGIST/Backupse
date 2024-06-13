resource "datadog_monitor" "queue_anomaly_monitor_transition_target_state_delegated" {
  count = var.is_live && contains(var.enabled_queue_workers, "OrderTransitionManager-Confirmed") ? 1 : 0

  name = "${var.env}: Drop in Transitions to Delegated"
  type = "query alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = <<-EOT
      Anomaly detected in the number of successful transitions to delegated on ${var.env}.
    EOT
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "avg(last_1d):anomalies(sum:ay_custom.checkout.order_transitions{env:${var.env},co.result.type:transition_successful,co.stateto:delegated}.as_count(), 'robust', 3, direction='below', interval=300, alert_window='last_1h', timezone='utc', count_default_zero='true', seasonality='daily') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  monitor_threshold_windows {
    trigger_window  = "last_1h"
    recovery_window = "last_15m"
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
      "muting:night"
    ]
  )
}

resource "datadog_monitor" "queue_anomaly_monitor_transition_target_state_shipped" {
  count = var.is_live && contains(var.enabled_queue_workers, "OrderTransitionManager-Delegated") ? 1 : 0

  name = "${var.env}: Drop in Transitions to Shipped"
  type = "query alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message = <<-EOT
      Anomaly detected in the number of successful transitions to shipped on ${var.env}.
    EOT
    alerting_receivers = coalescelist(
      var.monitor_receiver_overrides,
      ["slack-alerts-tc-emergency", "tc-cloud-emergency@aboutyou.com"]
    )
  })

  query = "avg(last_1w):anomalies(sum:ay_custom.checkout.order_transitions{env:${var.env},co.result.type:transition_successful,co.stateto:shipped}.as_count(), 'robust', 2, direction='below', interval=3600, alert_window='last_1d', count_default_zero='true', seasonality='weekly') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  monitor_threshold_windows {
    trigger_window  = "last_1d"
    recovery_window = "last_15m"
  }

  require_full_window = false
  notify_no_data      = true
  renotify_interval   = 0
  no_data_timeframe   = 1440
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

resource "datadog_monitor" "queue_anomaly_monitor_transition_target_state_invoiced" {
  count = var.is_live && contains(var.enabled_queue_workers, "OrderTransitionManager-Shipped") ? 1 : 0

  name = "${var.env}: Drop in Transitions to Invoiced"
  type = "query alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message = <<-EOT
      Anomaly detected in the number of successful transitions to invoiced on ${var.env}.
    EOT
    alerting_receivers = coalescelist(
      var.monitor_receiver_overrides,
      ["slack-alerts-tc-emergency", "tc-cloud-emergency@aboutyou.com"]
    )
  })

  query = "avg(last_1w):anomalies(sum:ay_custom.checkout.order_transitions{env:${var.env},co.result.type:transition_successful,co.stateto:invoiced}.as_count(), 'robust', 2, direction='below', interval=3600, alert_window='last_1d', seasonality='weekly', count_default_zero='true', timezone='utc') >= 1"

  monitor_thresholds {
    critical          = 1
    critical_recovery = 0
  }

  monitor_threshold_windows {
    trigger_window  = "last_1d"
    recovery_window = "last_15m"
  }

  require_full_window = false
  notify_no_data      = true
  renotify_interval   = 0
  no_data_timeframe   = 1440
  notify_audit        = false
  include_tags        = true
  priority            = 2

  tags = var.monitor_tags
}

resource "datadog_monitor" "queue_oldest_item_monitor_transition_target_state_delegated" {
  count = var.is_live && contains(var.enabled_queue_workers, "OrderTransitionManager-Confirmed") ? 1 : 0

  name = "${var.env}: Transition queue to Delegated has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-warning"])
  })

  query = "logs(\"env:${var.env} @co.targetState:Delegated @co.oldestItemDelta:>${var.monitor_thresholds.transition_target_state_delegated_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_transition_target_state_shipped" {
  count = var.is_live && contains(var.enabled_queue_workers, "OrderTransitionManager-Delegated") ? 1 : 0

  name = "${var.env}: Transition queue to Shipped has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-warning"])
  })

  query = "logs(\"env:${var.env} @co.targetState:Shipped @co.oldestItemDelta:>${var.monitor_thresholds.transition_target_state_shipped_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_transition_target_state_invoiced" {
  count = var.is_live && contains(var.enabled_queue_workers, "OrderTransitionManager-Shipped") ? 1 : 0

  name = "${var.env}: Transition queue to Invoiced has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.default_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-warning"])
  })

  query = "logs(\"env:${var.env} @co.targetState:Invoiced @co.oldestItemDelta:>${var.monitor_thresholds.transition_target_state_invoiced_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_transition_target_state_cancelled" {
  count = var.is_live && contains(var.enabled_queue_workers, "OrderTransitionManager-Aborted") ? 1 : 0

  name = "${var.env}: Transition queue to Cancelled has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.default_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-warning"])
  })

  query = "logs(\"env:${var.env} @co.targetState:Cancelled @co.oldestItemDelta:>${var.monitor_thresholds.transition_target_state_cancelled_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "order_confirmations_missing" {
  count = var.is_live ? 1 : 0

  name = "No order confirmations on ${var.env}"
  type = "metric alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message = local.no_order_confirmations_message
    alerting_receivers = concat(
      ["lars.ullrich@aboutyou.com"],
      coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-warning"])
    )
  })

  query = "sum(last_30m):default_zero(sum:ay_custom.checkout.order_confirmations{env:${var.env}}) == 0"

  monitor_thresholds {
    critical = 0
  }

  renotify_interval = 600
  no_data_timeframe = 20
  notify_no_data    = true
  priority          = 1

  tags = concat(
    var.monitor_tags,
    [
      "team:tc",
      "service:coba-api"
    ],
    contains(var.small_environments, var.env) ? ["muting:night"] : []
  )
}
