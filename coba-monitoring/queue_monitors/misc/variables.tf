variable "env" {
  description = "Environment name"
  type        = string
}

variable "enabled_queue_workers" {
  description = "Whether to enable queue workers"
  type        = list(string)
  default     = []
}
variable "monitor_thresholds" {
  description = "Monitor thresholds"
  type = object({
    returns                               = number
    invoices                              = number
    sms                                   = number
    webhooks                              = number
    returns_oldest_item_delta_in_seconds  = number
    invoices_oldest_item_delta_in_seconds = number
    sms_oldest_item_delta_in_seconds      = number
    webhooks_oldest_item_delta_in_seconds = number
  })
}

variable "monitor_receiver_overrides" {
  description = "Reciever overrides"
  type        = list(string)
  default     = []
}

variable "monitor_tags" {
  description = "Monitor tags"
  type        = list(string)
}

variable "is_live" {
  description = "Is environment live"
  type        = bool
}
