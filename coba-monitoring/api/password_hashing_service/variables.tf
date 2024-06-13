variable "tenant_space" {
  description = "Tenant space"
  type        = string
}

variable "system" {
  description = "System name"
  type        = string
}

variable "system_instance_key" {
  description = "System instance key"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "datadog_notification_email" {
  description = "datadog notification email id"
  type        = string
}

variable "datadog_slack_tc_notification_channel" {
  description = "datadog notification TC slack channel"
  type        = string
}

variable "coba_datadog_owasp_service_internal_errors_threshold" {
  description = "Datadog owasp service error threshold"
  type        = number
}

variable "coba_datadog_owasp_service_timeouts_threshold" {
  description = "Datadog owasp service timeout threshold"
  type        = number
}

variable "is_live" {
  description = "Is environment live"
  type        = bool
}
