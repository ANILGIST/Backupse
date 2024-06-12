locals {
  system = "bco"
  env    = join("-", [var.tenant_short_key, var.environment])
  system_instance_key = join("-", [
    var.tenant_short_key,
    var.environment,
    local.system
  ])
  tenant_space = join("-", [
    var.tenant_short_key,
    var.environment
  ])
  common_tags = [
    "system:${local.system}",
    "tenant-short-key:${var.tenant_short_key}",
    "env:${local.env}",
    "team:babo-bco",
    "unit:babo",
    "generated-by:terraform",
    "git-repository:https://gitlab.com/aboutyou/platform/monitoring/bco-monitoring"
  ]
}

locals {
  queue_monitors = {
    availability-calculation-queue-high = {
      max_messages              = 100000
      max_age_of_oldest_message = 300
    }

    availability-calculation-queue-default = {
      max_messages              = 100000
      max_age_of_oldest_message = 300
    }

    availability-calculation-queue-low = {
      max_messages              = 150000
      max_age_of_oldest_message = 360
    }

    shipment-checkout-queue = {
      max_messages              = 15000
      max_age_of_oldest_message = 1000
    }

    shipment-return-checkout-queue = {
      max_messages              = 2500
      max_age_of_oldest_message = 1000
    }

    webhook-stock-payload-builder-queue = {
      max_messages              = 1000
      max_age_of_oldest_message = 2400
    }

    webhook-availability-payload-builder-queue = {
      max_messages              = 1000
      max_age_of_oldest_message = 2400
    }

    webhook-generic-payload-builder-queue = {
      max_messages              = 10000
      max_age_of_oldest_message = 2400
    }

    webhook-calls-queue = {
      max_messages              = 10000
      max_age_of_oldest_message = 3600
    }

    base-query-products-main-job-queue = {
      max_messages              = 10000
      max_age_of_oldest_message = 60000
    }

    lr-application-category-tree-cache-queue = {
      max_messages              = 1000
      max_age_of_oldest_message = 1800
    }

    lr-bg-job-application-product-category-queue = {
      max_messages              = 20000
      max_age_of_oldest_message = 1800
    }

    lr-price-approval-background-job-queue = {
      max_messages              = 30000
      max_age_of_oldest_message = 1200
    }

    lr-state-evaluation-of-variants-queue = {
      max_messages              = 30000
      max_age_of_oldest_message = 1800
    }

    lr-bg-job-application-category-products-queue = {
      max_messages              = 20000
      max_age_of_oldest_message = 1800
    }

    recalculate-product-categories-queue = {
      max_messages              = 50000
      max_age_of_oldest_message = 10000
    }

  }

  standardized_queue_monitors = {
    for q_name, q_monitor_values in local.queue_monitors : q_name => merge(
      {
        max_messages                 = null
        max_age_of_oldest_message    = null
        number_of_messages_in_flight = 100000
      },
      q_monitor_values
    )
  }

  dead_letter_queue_monitors = {
    availability-calculation = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    product-import = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    stock-import = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    asset-import = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    shipment-import = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    translation-import = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    product-sorting = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    long-running-task = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    lr-background-job = {
      is_prioritized     = true
      max_absolute_delta = 1000
    }

    webhook-calls = {
      is_prioritized     = false
      max_absolute_delta = 1000
    }

    composite-pv-stock-post-processor = {
      is_prioritized     = false
      max_absolute_delta = 1000
    }

    recalculate-product-categories = {
      is_prioritized     = false
      max_absolute_delta = 100
    }

    base-query-products-main-job = {
      is_prioritized     = false
      max_absolute_delta = 1000
    }

    composite-pv-price-post-processor = {
      is_prioritized     = false
      max_absolute_delta = 1000
    }

    webhook-stock-payload-builder = {
      is_prioritized     = false
      max_absolute_delta = 1000
    }

    webhook-generic-payload-builder = {
      is_prioritized     = false
      max_absolute_delta = 1000
    }

    shipment-checkout = {
      is_prioritized     = false
      max_absolute_delta = 1000
    }

    shipment-return-checkout = {
      is_prioritized     = false
      max_absolute_delta = 1000
    }

  }

  prio_dead_letter_queue_configs = {
    for queue, q_flags in local.dead_letter_queue_monitors :
    queue => q_flags
    if q_flags.is_prioritized
  }

  non_prio_dead_letter_queue_configs = {
    for queue, q_flags in local.dead_letter_queue_monitors :
    "${queue}-queue-dead-letter" => q_flags
    if !q_flags.is_prioritized
  }

  exploded_prio_dead_letter_queue_configs = merge([
    for queue, q_flags in local.prio_dead_letter_queue_configs :
    {
      for prio in ["default", "high", "low"] :
      "${queue}-queue-${prio}-dead-letter" => q_flags
    }
  ]...)

  combined_dead_letter_queues = merge(local.exploded_prio_dead_letter_queue_configs, local.non_prio_dead_letter_queue_configs)

}
