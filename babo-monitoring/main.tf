locals {
  datadog_bco_notification_email                    = "cc-babo-bco@aboutyou.com"
  datadog_slack_bco_notification_email              = "bco-k8s-infrastructur-aaaafm73jpybporkhkphqiudc4@aboutyou.slack.com"
  datadog_slack_bco_admin_api_notification_email    = "bco-admin-api-alerts-aaaalgvtyosgftnt7p23qq35vq@aboutyou.slack.com"
  datadog_slack_bco_external_api_notification_email = "bco-external-api-aler-aaaamalkuhlonmn67eq66sipcu@aboutyou.slack.com"
  datadog_slack_bco_unit_email                      = "circle-core-backbone-aaaaccyptsipppnis2refazwga@aboutyou.slack.com"
  datadog_sqs_warning_notification_email            = "bco-queue-alerts-aaaamcsxre2jlqjyqjkh3qptam@aboutyou.slack.com"
}

# ELASTICACHE MONITORS

resource "datadog_monitor" "elasticache_cpu_utilization" {
  name    = "Elasticache CPU Utilization on ${local.system_instance_key}"
  type    = "query alert"
  message = data.template_file.datadog_message_template.rendered
  query   = "avg(last_5m):avg:aws.elasticache.cpuutilization{system-instance-key:${local.system_instance_key}} by {name,environment,replication_group} > ${var.bco_datadog_elasticache_cpu_utilization_threshold}"

  monitor_thresholds {
    critical = var.bco_datadog_elasticache_cpu_utilization_threshold
  }
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
  "service:elasticache"]
}

resource "datadog_monitor" "max_age_of_oldest_message" {
  for_each = {
    for q_name, q_monitor_values in local.standardized_queue_monitors :
    q_name => q_monitor_values
    if q_monitor_values.max_age_of_oldest_message != null
  }
  name    = "Age of oldest message in ${each.key} on ${local.system_instance_key}"
  message = data.template_file.datadog_sqs_messages_template.rendered
  query   = "avg(last_30m):avg:aws.sqs.approximate_age_of_oldest_message{queuename:${local.system_instance_key}-${each.key}} > ${each.value.max_age_of_oldest_message}"
  type    = "query alert"
  monitor_thresholds {
    critical = each.value.max_age_of_oldest_message
    warning  = each.value.max_age_of_oldest_message * 0.7
  }
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:sqs"
  ]
}

resource "datadog_monitor" "messages_in_flight" {
  for_each = {
    for q_name, q_monitor_values in local.standardized_queue_monitors :
    q_name => q_monitor_values
    if q_monitor_values.number_of_messages_in_flight != null
  }
  name    = "Number of messages in flight in  ${each.key} on ${local.system_instance_key}"
  message = data.template_file.datadog_sqs_messages_template.rendered
  query   = "avg(last_1h):avg:aws.sqs.approximate_number_of_messages_not_visible{queuename:${local.system_instance_key}-${each.key}} > ${each.value.number_of_messages_in_flight}"
  type    = "query alert"
  monitor_thresholds {
    critical = each.value.number_of_messages_in_flight
    warning  = each.value.number_of_messages_in_flight * 0.7
  }
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:sqs"
  ]
}

resource "datadog_monitor" "max_messages_in_queue" {
  for_each = {
    for q_name, q_monitor_values in local.standardized_queue_monitors :
    q_name => q_monitor_values
    if q_monitor_values.max_messages != null
  }
  name    = "Number of messages available in ${each.key} on ${local.system_instance_key}"
  message = data.template_file.datadog_sqs_messages_template.rendered
  query   = "avg(last_30m):avg:aws.sqs.approximate_number_of_messages_visible{queuename:${local.system_instance_key}-${each.key}} > ${each.value.max_messages}"
  type    = "query alert"
  monitor_thresholds {
    critical = each.value.max_messages
    warning  = each.value.max_messages * 0.7
  }
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:sqs"
  ]
}

resource "datadog_monitor" "increase_in_dead_letter_queue_message" {
  for_each = local.combined_dead_letter_queues
  name     = "Number of messages increased in ${each.key} on ${local.system_instance_key}"
  message  = data.template_file.datadog_sqs_messages_template.rendered
  query    = "change(sum(last_4h),last_15m):sum:aws.sqs.number_of_messages_sent{queuename:${local.system_instance_key}-${each.key}}.as_count() > ${each.value.max_absolute_delta}"
  type     = "query alert"
  monitor_thresholds {
    critical = each.value.max_absolute_delta
    warning  = each.value.max_absolute_delta * 0.7
  }
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:sqs"
  ]
}

resource "datadog_monitor" "elasticache_evictions_alert" {
  name    = "Elasticache Evictions on ${local.system_instance_key}"
  type    = "query alert"
  message = data.template_file.datadog_message_template.rendered

  #query = "sum(last_30m):avg:aws.elasticache.evictions{system-instance-key:${local.system_instance_key}}.as_count() by {replication_group} > 5.0"
  query = "sum(last_30m):avg:aws.elasticache.evictions{system-instance-key:${local.system_instance_key}} by {name,environment,replication_group}.as_count() > ${var.bco_datadog_elasticache_evictions_threshold}"
  monitor_thresholds {
    critical = var.bco_datadog_elasticache_evictions_threshold
  }
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
  "service:elasticache"]
}

resource "datadog_monitor" "elasticache_free_memory_alert" {
  name    = "Elasticache Disk Space for ${local.system_instance_key}"
  type    = "metric alert"
  message = data.template_file.datadog_message_template.rendered

  query = "avg(last_10m):min:aws.elasticache.freeable_memory{system-instance-key:${local.system_instance_key}} by {name,environment,cacheclusterid} < ${var.bco_datadog_elasticache_free_memory_threshold}"

  monitor_thresholds {
    critical = var.bco_datadog_elasticache_free_memory_threshold
  }
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
  "service:elasticache"]
}

resource "datadog_monitor" "elasticache_replication_delay_alert" {
  name    = "ElastiCache Replication Delay on ${local.system_instance_key}"
  type    = "metric alert"
  message = data.template_file.datadog_message_template.rendered

  query = "avg(last_15m):avg:aws.elasticache.replication_lag{system-instance-key:${local.system_instance_key}} by {name,environment,cacheclusterid} > ${var.bco_datadog_elasticache_replication_delay_threshold}"

  monitor_thresholds {
    critical = var.bco_datadog_elasticache_replication_delay_threshold
  }
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
  "service:elasticache"]
}


# RDS MONITORS

resource "datadog_monitor" "rds_disk_space_alert" {
  name    = "RDS Disk Space on ${local.system_instance_key}"
  type    = "query alert"
  message = data.template_file.datadog_message_template.rendered

  query = "avg(last_5m):avg:aws.rds.free_storage_space{system-instance-key:${local.system_instance_key}} by {name,environment,dbinstanceidentifier} / avg:aws.rds.total_storage_space{system-instance-key:${local.system_instance_key}} by {dbinstanceidentifier} * 100 < ${var.bco_datadog_rds_disk_space_threshold}"
  monitor_thresholds {
    critical          = var.bco_datadog_rds_disk_space_threshold
    critical_recovery = var.bco_datadog_rds_disk_space_threshold + 1
  }
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
  "service:rds"]
}

resource "datadog_monitor" "rds_cpu_utilization_alert" {
  name    = "RDS CPU Utilization on ${local.system_instance_key}"
  type    = "query alert"
  message = data.template_file.datadog_message_template.rendered
  query   = "avg(last_30m):avg:aws.rds.cpuutilization{system-instance-key:${local.system_instance_key}} by {name,environment,dbinstanceidentifier} > ${var.bco_datadog_rds_cpu_utilization_threshold}"

  monitor_thresholds {
    critical = var.bco_datadog_rds_cpu_utilization_threshold
  }
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
  "service:rds"]
}

# Monitor - If pod is ImagePullBackOff status
resource "datadog_monitor" "Pod_ImagePullBackOff" {
  name     = "Pod ImagePullBackOff on ${local.system_instance_key}"
  type     = "query alert"
  message  = data.template_file.datadog_message_template.rendered
  priority = var.environment == "live" ? 1 : 3
  query    = "max(last_10m):default_zero(max:kubernetes_state.container.status_report.count.waiting{reason:imagepullbackoff,kube_namespace:${local.tenant_space},kube_app_name:bco-*} by {pod_name}) >= 1"
  monitor_thresholds {
    critical          = 1
    critical_recovery = 0.2
  }

  require_full_window = false
  notify_no_data      = true
  evaluation_delay    = 900
  renotify_interval   = var.environment == "live" ? 360 : 1440
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true

  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:kubernetes"
  ]
}

# Monitor - If pod is CrashloopBackOff status
resource "datadog_monitor" "Pod_CrashloopBackOff" {
  name     = "Pod CrashloopBackOff on ${local.system_instance_key}"
  type     = "query alert"
  message  = data.template_file.datadog_message_template.rendered
  priority = var.environment == "live" ? 1 : 3
  query    = "max(last_10m):default_zero(max:kubernetes_state.container.status_report.count.waiting{reason:crashloopbackoff,kube_namespace:${local.tenant_space},kube_app_name:bco-*} by {pod_name}) >= 1"
  monitor_thresholds {
    critical          = 1
    critical_recovery = 0.2
  }

  require_full_window = false
  notify_no_data      = true
  evaluation_delay    = 900
  renotify_interval   = var.environment == "live" ? 360 : 1440
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true

  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:kubernetes"
  ]
}

# Monitor - If pod keeps Restarting
resource "datadog_monitor" "Pod_Restarting" {
  name     = "Pod Restarting on ${local.system_instance_key}"
  type     = "query alert"
  message  = data.template_file.datadog_message_template.rendered
  priority = var.environment == "live" ? 1 : 3
  query    = "change(max(last_10m),last_10m):exclude_null(sum:kubernetes.containers.restarts{kube_namespace:${local.tenant_space},kube_app_name:bco-*} by {pod_name}) > 10"
  monitor_thresholds {
    critical = 10
  }

  require_full_window = false
  notify_no_data      = true
  evaluation_delay    = 900
  renotify_interval   = var.environment == "live" ? 360 : 1440
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true

  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:kubernetes"
  ]
}

# Monitor - Deployments Replica's pods are down in Deployment
resource "datadog_monitor" "Deployment_Replicas_Down" {
  name     = "Deployments Replica's pods are down on ${local.system_instance_key}"
  type     = "query alert"
  message  = data.template_file.datadog_message_template.rendered
  priority = var.environment == "live" ? 1 : 3
  query    = "avg(last_10m):avg:kubernetes_state.deployment.replicas_desired{kube_namespace:${local.tenant_space},kube_deployment:bco-*,!kube_deployment:bco-job*} by {kube_deployment} - avg:kubernetes_state.deployment.replicas_available{kube_namespace:${local.tenant_space},kube_deployment:bco-*,!kube_deployment:bco-job*} by {kube_deployment} >= 2"
  monitor_thresholds {
    critical = 2
  }

  require_full_window = false
  notify_no_data      = true
  evaluation_delay    = 900
  renotify_interval   = var.environment == "live" ? 360 : 1440
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true

  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:kubernetes"
  ]
}

# Anomaly for elevated 5xx rate on bco-admin-api service
resource "datadog_monitor" "elevated_5xx_rate_alert" {
  count   = var.environment == "live" ? 1 : 0
  name    = "Elevated 5xx rate on ${local.system_instance_key}"
  type    = "query alert"
  message = data.template_file.datadog_admin_api_message_template.rendered

  query               = "avg(last_4h):anomalies(sum:trace.web.request.errors{service:bco-api-admin,env:${local.tenant_space}} by {http.status_code,env}.as_count(), 'basic', 2, direction='above', interval=60, alert_window='last_15m', count_default_zero='true', seasonality='daily') >= 1"
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = var.environment == "live" ? 360 : 1440
  evaluation_delay    = 900
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
  "service:kubernetes"]
}

# Anomaly for elevated response time on bco-admin-api service
resource "datadog_monitor" "elevated_response_time_alert" {
  count   = var.environment == "live" ? 1 : 0
  name    = "Elevated Admin API response time on ${local.system_instance_key}, endpoint {{resource_name.name}}"
  type    = "query alert"
  message = data.template_file.datadog_admin_api_message_template.rendered

  query               = "avg(last_1h):anomalies(avg:trace.web.request.duration{service:bco-api-admin,env:${local.tenant_space}} by {env,resource_name}.as_count(), 'basic', 2, direction='above', interval=60, alert_window='last_1h', count_default_zero='true', seasonality='daily') >= 1"
  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = var.environment == "live" ? 360 : 1440
  evaluation_delay    = 900
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
  "service:kubernetes"]
}

# Monitor - P95 responses above 5s of external API variant availability endpoint
resource "datadog_monitor" "elevated_response_time_alert_external_api_availability_endpoint" {
  count   = 1
  name    = "Elevated External API response time on ${local.system_instance_key}, endpoint {{resource_name.name}}"
  type    = "query alert"
  message = data.template_file.datadog_external_api_message_template.rendered

  query               = "avg(last_5m):p95:trace.web.request{service:bco-api-external,resource_name:externalapi.availabilityrestcontroller_index,env:${local.tenant_space}} > 5"
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = var.environment == "live" ? 5 : 240
  evaluation_delay    = 10
  notify_audit        = false
  timeout_h           = 0
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:kubernetes"
  ]
}

resource "datadog_monitor" "rds_replica_lag_alert" {
  name    = "RDS Replication Lag is high on ${local.tenant_space}"
  type    = "query alert"
  message = data.template_file.datadog_message_template.rendered
  query   = "avg(last_5m):avg:aws.rds.replica_lag{(env:${local.tenant_space} AND team:babo-bco)} by {dbinstanceidentifier} > ${var.bco_rds_lag_critical_threshold}"

  monitor_thresholds {
    critical = var.bco_rds_lag_critical_threshold
    warning  = var.bco_rds_lag_warning_threshold
  }

  new_group_delay     = 300
  require_full_window = false
  notify_no_data      = false
  evaluation_delay    = 900
  renotify_interval   = 360
  notify_audit        = false
  timeout_h           = 1
  include_tags        = true
  tags = [
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:rds"
  ]
}

resource "datadog_monitor" "rds_connection_spikes" {
  name    = "${var.environment}: DB Connections Spike on ${local.system_instance_key}"
  type    = "query alert"
  message = data.template_file.datadog_db_connection_spike_messages_template.rendered
  query   = "change(max(last_1h),last_5m):avg:aws.rds.database_connections{(env:${local.tenant_space} AND engine:mysql AND dbinstanceidentifier:*bco*)} by {dbinstanceidentifier} > ${var.bco_rds_rds_connection_spikes_critical_threshold}"

  monitor_thresholds {
    critical          = var.bco_rds_rds_connection_spikes_critical_threshold
    critical_recovery = var.bco_rds_rds_connection_spikes_critical_recovery_threshold
  }

  notify_audit      = false
  include_tags      = true
  new_group_delay   = 60
  renotify_interval = 0
  notify_no_data    = false
  evaluation_delay  = 900

  tags = [
    "team:babo-bco",
    "system:${local.system}",
    "system_instance_key:${local.system_instance_key}",
    "tenant_space:${local.tenant_space}",
    "env:${var.environment}",
    "service:rds"
  ]
}
