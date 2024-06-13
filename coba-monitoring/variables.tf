variable "tenant_short_key" {
  description = "Short key of tenant"
  type        = string
}

variable "environment" {
  description = "Name of environment"
  type        = string
}

variable "is_live" {
  description = "Is environment live"
  type        = string
  default     = "false"
}

variable "enabled_queue_workers" {
  type        = list(string)
  description = "List of enabled queue workers. Based on this list, monitors will be created only for queues that have workers enabled."
  default     = []
}

variable "queue_size_monitor_thresholds" {
  type = object({
    transition_target_state_delegated                                       = optional(number, 800)
    transition_target_state_shipped                                         = optional(number, 1000)
    transition_target_state_invoiced                                        = optional(number, 500)
    transition_target_state_cancelled                                       = optional(number, 100)
    transition_target_state_delegated_oldest_item_delta_in_seconds          = optional(number, 600)
    transition_target_state_shipped_oldest_item_delta_in_seconds            = optional(number, 1200)
    transition_target_state_invoiced_oldest_item_delta_in_seconds           = optional(number, 3600)
    transition_target_state_cancelled_oldest_item_delta_in_seconds          = optional(number, 1200)
    payments_refund                                                         = optional(number, 100)
    payments_capture                                                        = optional(number, 100)
    payments_cancel                                                         = optional(number, 100)
    payments_refund_oldest_item_delta_in_seconds                            = optional(number, 3600)
    payments_capture_oldest_item_delta_in_seconds                           = optional(number, 3600)
    payments_cancel_oldest_item_delta_in_seconds                            = optional(number, 600)
    emails_customer_bank_account_update_mail                                = optional(number, 20)
    emails_customer_order_cancellation_mail                                 = optional(number, 20)
    emails_customer_order_delegation_mail                                   = optional(number, 20)
    emails_customer_order_invoice_mail                                      = optional(number, 120)
    emails_customer_order_product_return_mail                               = optional(number, 20)
    emails_customer_order_shipment_mail                                     = optional(number, 20)
    emails_customer_password_reset                                          = optional(number, 20)
    emails_customer_reminder_bank_account_mail                              = optional(number, 100)
    emails_order_bank_account_update_mail                                   = optional(number, 100)
    emails_order_products_undeliverable_mail                                = optional(number, 100)
    emails_customer_bank_account_update_mail_oldest_item_delta_in_seconds   = optional(number, 600)
    emails_customer_order_cancellation_mail_oldest_item_delta_in_seconds    = optional(number, 600)
    emails_customer_order_delegation_mail_oldest_item_delta_in_seconds      = optional(number, 600)
    emails_customer_order_invoice_mail_oldest_item_delta_in_seconds         = optional(number, 600)
    emails_customer_order_product_return_mail_oldest_item_delta_in_seconds  = optional(number, 600)
    emails_customer_order_shipment_mail_oldest_item_delta_in_seconds        = optional(number, 600)
    emails_customer_password_reset_oldest_item_delta_in_seconds             = optional(number, 600)
    emails_customer_reminder_bank_account_mail_oldest_item_delta_in_seconds = optional(number, 600)
    emails_order_bank_account_update_mail_oldest_item_delta_in_seconds      = optional(number, 600)
    emails_order_products_undeliverable_mail_oldest_item_delta_in_seconds   = optional(number, 600)
    returns                                                                 = optional(number, 100)
    composite_returns                                                       = optional(number, 100)
    invoices                                                                = optional(number, 400)
    sms                                                                     = optional(number, 100)
    webhooks                                                                = optional(number, 250)
    returns_oldest_item_delta_in_seconds                                    = optional(number, 1200)
    invoices_oldest_item_delta_in_seconds                                   = optional(number, 3600)
    sms_oldest_item_delta_in_seconds                                        = optional(number, 3600)
    webhooks_oldest_item_delta_in_seconds                                   = optional(number, 600)
  })
  description = "Threshold definitions for queue size monitors"
  default     = {}
}

variable "system_monitor_thresholds" {
  type = object({
    too_many_db_connections = optional(number, 1)
  })
  description = "Threshold definitions for the system queue monitors"
  default     = {}
}

variable "monitor_receiver_overrides" {
  type        = list(string)
  description = "Default monitor receivers can be overridden using this variable (useful for testing)"
  default     = []
}

variable "coba_datadog_promotion_engine_errors_threshold" {
  default     = 10
  description = "Threshold for promotion engine errors."
  type        = number
}

variable "coba_datadog_owasp_service_timeouts_threshold" {
  default     = 15
  description = "Threshold for OWASP password hashing service timeouts."
  type        = number
}

variable "small_environments" {
  description = "List of small environments(e.g. fcb-live, sol-live)"
  type        = list(string)
  default     = ["sol-live", "tomt-live", "depot-live", "mop-live", "dmg-live", "fim-live", "ags-live", "kns-live", "fcb-live"]
}
