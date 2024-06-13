variable "env" {
  description = "Environment name"
  type        = string
}

variable "monitor_thresholds" {
  description = "Monitor thresholds"
  type = object({
    too_many_db_connections = number
  })
}

variable "monitor_tags" {
  description = "Monitor tags"
  type        = list(string)
}

variable "is_live" {
  description = "Is environment live"
  type        = bool
}
