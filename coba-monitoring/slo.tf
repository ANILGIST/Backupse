locals {

  env = join("-", [var.tenant_short_key, var.environment])

  slos = {
    "Availability of Update Order Endpoint" : {
      type = "availability",
      resource_name : "put_order_orderid"
    }
    "Latency of Update Order Endpoint <600ms" : {
      type = "latency",
      resource_name : "put_order_orderid",
      threshold : 600 # ms
    }
    "Availability of Confirm Order Endpoint" : {
      type = "availability",
      resource_name : "put_order_orderid_confirm"
    }
    "Latency of Confirm Order Endpoint <500ms" : {
      type = "latency",
      resource_name : "put_order_orderid_confirm",
      threshold : 500 # ms
    }
    "Availability of Get Order Endpoint" : {
      type = "availability",
      resource_name : "get_order_orderid"
    }
    "Latency of Get Order Endpoint <500ms" : {
      type = "latency",
      resource_name : "get_order_orderid",
      threshold : 500 # ms
    }
    "Availability of Get Rule Data Endpoint" : {
      type = "availability",
      resource_name : "get_rule_data_order_orderid"
    }
    "Latency of Get Rule Data Endpoint <850ms" : {
      type = "latency",
      resource_name : "get_rule_data_order_orderid",
      threshold : 850 # ms
    }

    "Availability of Get Customer Recurrent Payment Methods Endpoint" : {
      type = "availability",
      resource_name : "get_payment_app_appid_customer_customerid_recurringpaymentmethodslist"
    }
    "Latency of Get Customer Recurrent Payment Methods Endpoint <100ms" : {
      type = "latency",
      resource_name : "get_payment_app_appid_customer_customerid_recurringpaymentmethodslist",
      threshold : 100 # ms
    }
    "Availability of Availability of Get Customer Endpoint" : {
      type = "availability",
      resource_name : "get_customer_customerid"
    }
    "Latency of Get Customer Endpoint <150ms" : {
      type = "latency",
      resource_name : "get_customer_customerid",
      threshold : 150 # ms
    }
    "Availability of Customer Login Endpoint" : {
      type = "availability",
      resource_name : "post_customer_login"
    }
    "Latency of Customer Login Endpoint <400ms" : {
      type = "latency",
      resource_name : "post_customer_login",
      threshold : 400 # ms
    }
    "Duration of Order Transition from Pended to Confirmed <120s" : {
      type = "duration",
      distribution : "ay_custom.checkout.webhooks_payload_deliveries.duration",
      resource_name : "co.webhookkey:order-confirmed",
      threshold : 120 # ms
    }
    "Duration of Order Transition from Confirmed to Delegated <600s" : {
      type = "duration",
      distribution : "ay_custom.checkout.webhooks_payload_deliveries.duration",
      resource_name : "co.webhookkey:order-delegated",
      threshold : 600 # ms
    }
    "Duration of Order Transition from Shipped to Invoiced <1200s" : {
      type = "duration",
      distribution : "ay_custom.checkout.webhooks_payload_deliveries.duration",
      resource_name : "co.webhookkey:order-invoiced",
      threshold : 600 # ms
    }
    #   "Duration of COBA Webhooks Sent <600s" : {
    #     type = "duration",
    #     resource_name : "FIXME",
    #     threshold : 600 # ms
    #   }
    #   "Duration of Email Sent <600s" : {
    #     type = "duration",
    #     resource_name : "FIXME",
    #     threshold : 600 # ms
    #   }
    #   "Duration of Voucher Code Pool Created <600s" : {
    #     type = "duration",
    #     resource_name : "FIXME",
    #     threshold : 600 # ms
    #   }
  }
}

resource "datadog_service_level_objective" "availability_slo" {

  for_each = { for name, slo in local.slos : name => slo if slo.type == "availability" && var.is_live == "true" }

  name = each.key
  type = "metric"
  query {
    numerator   = "sum:trace.web.request.hits{service:${local.service_name} AND resource_name:${each.value.resource_name} AND NOT (http.status_code:424 OR http.status_code:5*) AND env:${local.env}} by {env}.as_count()"
    denominator = "sum:trace.web.request.hits{service:${local.service_name} AND resource_name:${each.value.resource_name} AND env:${local.env}} by {env}.as_count()"
  }

  thresholds {
    timeframe = "7d"
    target    = 99.9
    warning   = 99.95
  }

  tags = local.common_monitor_tags
}

resource "datadog_service_level_objective" "latency_slo" {
  for_each = { for name, slo in local.slos : name => slo if slo.type == "latency" && var.is_live == "true" }

  name = each.key
  type = "metric"
  query {
    numerator   = "count(v: v<${each.value.threshold / 1000}):trace.web.request{service:${local.service_name} AND resource_name:${each.value.resource_name} AND env:${local.env}} by {env}.as_count()"
    denominator = "sum:trace.web.request.hits{service:${local.service_name} AND resource_name:${each.value.resource_name} AND env:${local.env}} by {env}.as_count()"
  }

  thresholds {
    timeframe = "7d"
    target    = 90
    warning   = 92
  }

  tags = local.common_monitor_tags
}

resource "datadog_service_level_objective" "duration_slo" {
  for_each = { for name, slo in local.slos : name => slo if slo.type == "duration" && var.is_live == "true" }

  name = each.key
  type = "metric"
  query {
    numerator   = "count(v: v<${each.value.threshold}):${each.value.distribution}{${each.value.resource_name} AND env:${local.env}} by {env}.as_count()"
    denominator = "sum:${each.value.distribution}{${each.value.resource_name} AND env:${local.env}} by {env}.as_count()"
  }

  thresholds {
    timeframe = "7d"
    target    = 90
    warning   = 95
  }

  tags = local.common_monitor_tags
}
