module "queue_monitors_transition" {
  source = "./queue_monitors/transition"

  env                        = local.tenant_space
  enabled_queue_workers      = var.enabled_queue_workers
  monitor_thresholds         = var.queue_size_monitor_thresholds
  monitor_receiver_overrides = var.monitor_receiver_overrides
  monitor_tags               = local.common_monitor_tags
  small_environments         = var.small_environments
  is_live                    = var.is_live == "true"
}

module "queue_monitors_email" {
  source = "./queue_monitors/email"

  env                        = local.tenant_space
  enabled_queue_workers      = var.enabled_queue_workers
  monitor_thresholds         = var.queue_size_monitor_thresholds
  monitor_receiver_overrides = var.monitor_receiver_overrides
  monitor_tags               = local.common_monitor_tags
  is_live                    = var.is_live == "true"
}

module "queue_monitors_payment" {
  source = "./queue_monitors/payment"

  env                        = local.tenant_space
  enabled_queue_workers      = var.enabled_queue_workers
  monitor_thresholds         = var.queue_size_monitor_thresholds
  monitor_receiver_overrides = var.monitor_receiver_overrides
  monitor_tags               = local.common_monitor_tags
  is_live                    = var.is_live == "true"
}

module "queue_monitors_misc" {
  source = "./queue_monitors/misc"

  env                        = local.tenant_space
  enabled_queue_workers      = var.enabled_queue_workers
  monitor_thresholds         = var.queue_size_monitor_thresholds
  monitor_receiver_overrides = var.monitor_receiver_overrides
  monitor_tags               = local.common_monitor_tags
  is_live                    = var.is_live == "true"
}

module "queue_monitors_system" {
  source = "./queue_monitors/system"

  env                = local.tenant_space
  monitor_thresholds = var.system_monitor_thresholds
  monitor_tags       = local.common_monitor_tags
  is_live            = var.is_live == "true"
}

module "queue_monitors_return" {
  source = "./queue_monitors/return"

  env                        = local.tenant_space
  enabled_queue_workers      = var.enabled_queue_workers
  monitor_thresholds         = var.queue_size_monitor_thresholds
  monitor_receiver_overrides = var.monitor_receiver_overrides
  monitor_tags               = local.common_monitor_tags
  is_live                    = var.is_live == "true"
}

module "api_promotion_engine" {
  source = "./api/promotion_engine"

  tenant_space                                   = local.tenant_space
  system                                         = local.system
  system_instance_key                            = local.system_instance_key
  environment                                    = var.environment
  datadog_notification_email                     = local.datadog_notification_email
  datadog_slack_tc_notification_channel          = local.datadog_slack_tc_notification_channel
  coba_datadog_promotion_engine_errors_threshold = var.coba_datadog_promotion_engine_errors_threshold
  is_live                                        = var.is_live == "true"
}

module "api_password_hashing_service" {
  source = "./api/password_hashing_service"

  tenant_space                                         = local.tenant_space
  system                                               = local.system
  system_instance_key                                  = local.system_instance_key
  environment                                          = var.environment
  datadog_notification_email                           = local.datadog_notification_email
  datadog_slack_tc_notification_channel                = local.datadog_slack_tc_notification_channel
  coba_datadog_owasp_service_internal_errors_threshold = var.coba_datadog_promotion_engine_errors_threshold
  coba_datadog_owasp_service_timeouts_threshold        = var.coba_datadog_owasp_service_timeouts_threshold
  is_live                                              = var.is_live == "true"
}
