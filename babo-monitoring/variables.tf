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


# THRESHOLDS
variable "bco_datadog_rds_disk_space_threshold" {
  type        = number
  description = "BCO RDS DiskSpace Threshold"
  default     = 10
}

variable "bco_datadog_elasticache_cpu_utilization_threshold" {
  type        = number
  description = "BCO EC CPU Utilization Threshold"
  default     = 90.0
}

variable "bco_datadog_elasticache_evictions_threshold" {
  type        = number
  description = "BCO EC Evictions Threshold"
  default     = 100.0
}

variable "bco_datadog_elasticache_free_memory_threshold" {
  type        = number
  description = "BCO EC FreeMemory Threshold"
  default     = 10000000
}

variable "bco_datadog_elasticache_replication_delay_threshold" {
  type        = number
  description = "BCO EC Replication Delay Threshold"
  default     = 5
}

variable "bco_datadog_rds_cpu_utilization_threshold" {
  type        = number
  description = "BCO RDS CPU Utilization Threshold"
  default     = 90.0
}

variable "bco_rds_lag_warning_threshold" {
  type        = number
  description = "BCO RDS lag warning threshold"
  default     = 60
}

variable "bco_rds_lag_critical_threshold" {
  type        = number
  description = "BCO RDS lag critical threshold"
  default     = 90
}

variable "bco_rds_rds_connection_spikes_critical_threshold" {
  type        = number
  description = "BCO RDS connection spikes critical threshold"
  default     = 2000
}

variable "bco_rds_rds_connection_spikes_critical_recovery_threshold" {
  type        = number
  description = "BCO RDS connection spikes critical recovery threshold"
  default     = 100
}
