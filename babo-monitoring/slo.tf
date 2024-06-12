locals {

  slos = {
    "Availability of Read Endpoints" : {
      type = "availability",
      resource_name : "adminapi.get*"
      target : "99.99"
      warning : "99.995"
      service_name : "${local.system}-api-admin"
    }
    "Latency of Read Endpoints <5s" : {
      type = "latency",
      resource_name : "adminapi.get*",
      threshold : 300 # ms
      service_name : "${local.system}-api-admin"
    }
    "Availability of Write Endpoints" : {
      type = "availability",
      resource_name : "adminapi.* AND NOT resource_name:adminapi.get*"
      target : "99.9"
      warning : "99.95"
      service_name : "${local.system}-api-admin"
    }
    "Latency of Write Endpoints <5s" : {
      type = "latency",
      resource_name : "adminapi.* AND NOT resource_name:adminapi.get*"
      threshold : 300 # ms
      service_name : "${local.system}-api-admin"
    }
    "Availability of Variant Endpoints" : {
      type = "availability",
      resource_name : "externalapi.variantrestcontroller_show"
      target : "99.9"
      warning : "99.95"
      service_name : "${local.system}-api-external"
    }
    "Latency of Variant Endpoints <1s" : {
      type = "latency",
      resource_name : "externalapi.variantrestcontroller_show"
      threshold : 60 # ms
      service_name : "${local.system}-api-external"
    }
    "Availability of Quantity Blocker Endpoint" : {
      type = "availability",
      resource_name : "externalapi.availabilityrestcontroller_index"
      target : "99.9"
      warning : "99.95"
      service_name : "${local.system}-api-external"
    }
    "Latency of Quantity Blocker Endpoint <2s" : {
      type = "latency",
      resource_name : "externalapi.availabilityrestcontroller_index"
      threshold : 120 # ms
      service_name : "${local.system}-api-external"
    }
    "Availability of Order Endpoint" : {
      type = "availability",
      resource_name : "externalapi.order*"
      target : "99.9"
      warning : "99.95"
      service_name : "${local.system}-api-external"
    }
    "Latency of Order Endpoint <10s" : {
      type = "latency",
      resource_name : "externalapi.order*"
      threshold : 600 # ms
      service_name : "${local.system}-api-external"
    }
    "Availability of Miscellaneous Endpoints" : {
      type = "availability",
      resource_name : "externalapi.* AND NOT resource_name:externalapi.order* AND NOT resource_name:externalapi.availabilityrestcontroller_index AND NOT resource_name:externalapi.variantrestcontroller_show"
      target : "99.9"
      warning : "99.95"
      service_name : "${local.system}-api-external"
    }
    "Duration of Availability Queue Item Processing <5m" : {
      type = "duration",
      distribution : "aws.sqs.approximate_age_of_oldest_message",
      resource_name : "queuename:${local.env}-bco-availability-calculation-queue-high",
      service_name : "${local.system}-api-admin"
      threshold : 300 #seconds
    }
    "Duration of Admin API Webhooks Sent <100s" : {
      type = "duration",
      distribution : "aws.sqs.approximate_age_of_oldest_message",
      resource_name : "queuename:${local.env}-bco-webhook-calls-queue",
      service_name : "${local.system}-api-external"
      threshold : 100 #seconds
    }
  }
}

resource "datadog_service_level_objective" "availability_slo" {

  for_each = { for name, slo in local.slos : name => slo if slo.type == "availability" && var.is_live == "true" }

  name = each.key
  type = "metric"
  query {
    numerator   = "sum:trace.web.request.hits{service:${each.value.service_name} AND resource_name:${each.value.resource_name} AND NOT (http.status_code:424 OR http.status_code:5*) AND env:${local.env}} by {env}.as_count()"
    denominator = "sum:trace.web.request.hits{service:${each.value.service_name} AND resource_name:${each.value.resource_name} AND env:${local.env}} by {env}.as_count()"
  }

  thresholds {
    timeframe = "7d"
    target    = each.value.target
    warning   = each.value.warning
  }

  tags = concat(local.common_tags, formatlist("service:${each.value.service_name}"))
}

resource "datadog_service_level_objective" "latency_slo" {
  for_each = { for name, slo in local.slos : name => slo if slo.type == "latency" && var.is_live == "true" }

  name = each.key
  type = "metric"
  query {
    numerator   = "count(v: v<${each.value.threshold / 1000}):trace.web.request.hits{service:${each.value.service_name} AND resource_name:${each.value.resource_name} AND env:${local.env}} by {env}.as_count()"
    denominator = "sum:trace.web.request.hits{service:${each.value.service_name} AND resource_name:${each.value.resource_name} AND env:${local.env}} by {env}.as_count()"
  }

  thresholds {
    timeframe = "7d"
    target    = 95
    warning   = 97
  }

  tags = concat(local.common_tags, formatlist("service:${each.value.service_name}"))
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

  tags = concat(local.common_tags, formatlist("service:${each.value.service_name}"))
}
