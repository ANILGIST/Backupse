locals {
  old_item_in_queue_monitor_message = <<-EOT
    There are unprocessed items in the queue!
    Please check the queue entries and worker processes to make sure everything is ok.
  EOT
}
