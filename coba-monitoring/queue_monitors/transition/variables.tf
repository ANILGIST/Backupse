variable "env" {
  description = "environment"
  type        = string
}

variable "enabled_queue_workers" {
  description = "Whether to enable queue workers"
  type        = list(string)
  default     = []
}

variable "monitor_thresholds" {
  description = "Monitoring thresholds"
  type = object({
    transition_target_state_delegated                              = number
    transition_target_state_shipped                                = number
    transition_target_state_invoiced                               = number
    transition_target_state_cancelled                              = number
    transition_target_state_delegated_oldest_item_delta_in_seconds = number
    transition_target_state_shipped_oldest_item_delta_in_seconds   = number
    transition_target_state_invoiced_oldest_item_delta_in_seconds  = number
    transition_target_state_cancelled_oldest_item_delta_in_seconds = number
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

variable "small_environments" {
  description = "List of small environments(e.g. fcb-live, sol-live)"
  type        = list(string)
}

variable "is_live" {
  description = "Is environment live"
  type        = bool
}
