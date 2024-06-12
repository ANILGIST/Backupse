variable "tags" {
  type        = set(string)
  description = "Tags to add to all monitors"
  default     = []
}

variable "endpoints" {
  type = map(object({
    name     = string
    where    = set(string)
    tags     = set(string)
    monitors = set(string)
  }))
  description = "Map of endpoints to monitor. Each key is a monitor, each value is an object."
  default     = {}
}
variable "team" {
  type        = string
  description = "Team to assign to all monitors."
  validation {
    condition     = length(var.team) > 0
    error_message = "Team is required"
  }
}
variable "pagerduty_email" {
  description = "Email address to send alerts to."
  type        = string
  validation {
    # should be an email address
    condition     = can(regex("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$", var.pagerduty_email))
    error_message = "Pagerduty email is required and must be a valid email address"
  }
}
