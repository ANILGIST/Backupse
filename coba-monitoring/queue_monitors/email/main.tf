resource "datadog_monitor" "queue_oldest_item_monitor_emails_customer_bank_account_update_mail" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-CustomerBankAccountUpdateMail") ? 1 : 0

  name = "${var.env}: Emails Queue emails_customer_bank_account_update_mail has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_customer_bank_account_update_mail @co.oldestItemDelta:>${var.monitor_thresholds.emails_customer_bank_account_update_mail_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_emails_customer_order_cancellation_mail" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-CustomerOrderCancellationMail") ? 1 : 0

  name = "${var.env}: Emails Queue emails_customer_order_cancellation_mail has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_customer_order_cancellation_mail @co.oldestItemDelta:>${var.monitor_thresholds.emails_customer_order_cancellation_mail_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_emails_customer_order_delegation_mail" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-CustomerOrderDelegationMail") ? 1 : 0

  name = "${var.env}: Emails Queue emails_customer_order_delegation_mail has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_customer_order_delegation_mail @co.oldestItemDelta:>${var.monitor_thresholds.emails_customer_order_delegation_mail_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_emails_customer_order_invoice_mail" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-CustomerOrderInvoiceMail") ? 1 : 0

  name = "${var.env}: Emails Queue emails_customer_order_invoice_mail has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_customer_order_invoice_mail @co.oldestItemDelta:>${var.monitor_thresholds.emails_customer_order_invoice_mail_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_emails_customer_order_product_return_mail" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-CustomerOrderProductReturnMail") ? 1 : 0

  name = "${var.env}: Emails Queue emails_customer_order_product_return_mail has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_customer_order_product_return_mail @co.oldestItemDelta:>${var.monitor_thresholds.emails_customer_order_product_return_mail_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_emails_customer_order_shipment_mail" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-CustomerOrderShipmentMail") ? 1 : 0

  name = "${var.env}: Emails Queue emails_customer_order_shipment_mail has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_customer_order_shipment_mail @co.oldestItemDelta:>${var.monitor_thresholds.emails_customer_order_shipment_mail_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_emails_customer_password_reset" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-CustomerPasswordReset") ? 1 : 0

  name = "${var.env}: Emails Queue emails_customer_password_reset has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_customer_password_reset @co.oldestItemDelta:>${var.monitor_thresholds.emails_customer_password_reset_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_emails_order_bank_account_update_mail" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-OrderBankAccountUpdateMail") ? 1 : 0

  name = "${var.env}: Emails Queue emails_order_bank_account_update_mail has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_customer_reminder_bank_account_mail @co.oldestItemDelta:>${var.monitor_thresholds.emails_order_bank_account_update_mail_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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

resource "datadog_monitor" "queue_oldest_item_monitor_emails_order_products_undeliverable_mail" {
  count = var.is_live && contains(var.enabled_queue_workers, "MailerManager-OrderProductsUndeliverableMail") ? 1 : 0

  name = "${var.env}: Emails Queue emails_order_products_undeliverable_mail has items older than {{threshold}}s in it"
  type = "log alert"

  message = templatefile("${path.module}/templates/message.tftpl", {
    message            = local.old_item_in_queue_monitor_message
    alerting_receivers = coalescelist(var.monitor_receiver_overrides, ["slack-alerts-tc-emergency"])
  })

  query = "logs(\"env:${var.env} @co.queueName:emails_order_products_undeliverable_mail @co.oldestItemDelta:>${var.monitor_thresholds.emails_order_products_undeliverable_mail_oldest_item_delta_in_seconds}\").index(\"*\").rollup(\"count\").last(\"1m\")>0"

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
