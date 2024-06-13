locals {
  default_monitor_message = <<-EOT
    Please check the queue entries and worker processes to make sure everything is ok.
    This does not take into account the automatic refund blocking at the end of each month.
    There is a separate alert that checks for the combination of this alert and the alert for the refund blocking starting.
  EOT

  old_item_in_queue_monitor_message = <<-EOT
    There are unprocessed items in the queue!
    Please check the queue entries and worker processes to make sure everything is ok.
  EOT

  no_order_confirmations_message = <<-EOT
    No order confirmations on {{env.name}}.

    General CO Runbook: https://app.datadoghq.eu/notebook/24870/co-runbook-general-v1
  EOT
}
