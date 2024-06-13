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
    emails_customer_bank_account_update_mail                                = number
    emails_customer_order_cancellation_mail                                 = number
    emails_customer_order_delegation_mail                                   = number
    emails_customer_order_invoice_mail                                      = number
    emails_customer_order_product_return_mail                               = number
    emails_customer_order_shipment_mail                                     = number
    emails_customer_password_reset                                          = number
    emails_customer_reminder_bank_account_mail                              = number
    emails_order_bank_account_update_mail                                   = number
    emails_order_products_undeliverable_mail                                = number
    emails_customer_bank_account_update_mail_oldest_item_delta_in_seconds   = number
    emails_customer_order_cancellation_mail_oldest_item_delta_in_seconds    = number
    emails_customer_order_delegation_mail_oldest_item_delta_in_seconds      = number
    emails_customer_order_invoice_mail_oldest_item_delta_in_seconds         = number
    emails_customer_order_product_return_mail_oldest_item_delta_in_seconds  = number
    emails_customer_order_shipment_mail_oldest_item_delta_in_seconds        = number
    emails_customer_password_reset_oldest_item_delta_in_seconds             = number
    emails_customer_reminder_bank_account_mail_oldest_item_delta_in_seconds = number
    emails_order_bank_account_update_mail_oldest_item_delta_in_seconds      = number
    emails_order_products_undeliverable_mail_oldest_item_delta_in_seconds   = number
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
