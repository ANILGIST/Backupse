locals {
  old_item_in_queue_monitor_message = <<-EOT
    Old items in the emails queue. Check the workers and other related processes.
    Check the workers and other related processes like invoice generation, delegations, shipment notifications.
    https://app.datadoghq.eu/dashboard/9zg-w98-ruz/co-queue-sizes
  EOT
}
