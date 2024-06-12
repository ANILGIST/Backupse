data "template_file" "datadog_message_template" {
  template = file("${path.module}/templates/message.tpl")

  vars = {

    system              = local.system
    tenant_space        = local.tenant_space
    system_instance_key = local.system_instance_key
    live_receivers      = <<-EOT
        @${local.datadog_bco_notification_email}
        @${local.datadog_slack_bco_notification_email}
    EOT
    test_receivers      = <<-EOT
        @${local.datadog_bco_notification_email}
        @${local.datadog_slack_bco_notification_email}
    EOT
    prev_receivers      = <<-EOT
        @${local.datadog_bco_notification_email}
        @${local.datadog_slack_bco_notification_email}
    EOT
    demo_receivers      = <<-EOT
        @${local.datadog_bco_notification_email}
        @${local.datadog_slack_bco_notification_email}
    EOT
    qa_receivers        = <<-EOT
        @${local.datadog_slack_bco_notification_email}
    EOT
    dev_receivers       = <<-EOT
        @${local.datadog_slack_bco_notification_email}
    EOT
  }
}

data "template_file" "datadog_admin_api_message_template" {
  template = file("${path.module}/templates/message.tpl")

  vars = {

    system              = local.system
    tenant_space        = local.tenant_space
    system_instance_key = local.system_instance_key
    live_receivers      = <<-EOT
        @${local.datadog_bco_notification_email}
        @${local.datadog_slack_bco_admin_api_notification_email}
    EOT
    test_receivers      = <<-EOT
        @${local.datadog_bco_notification_email}
        @${local.datadog_slack_bco_admin_api_notification_email}
    EOT
    prev_receivers      = <<-EOT
        @${local.datadog_bco_notification_email}
        @${local.datadog_slack_bco_admin_api_notification_email}
    EOT
    demo_receivers      = <<-EOT
        @${local.datadog_bco_notification_email}
        @${local.datadog_slack_bco_admin_api_notification_email}
    EOT
    qa_receivers        = <<-EOT
        @${local.datadog_slack_bco_notification_email}
        @${local.datadog_slack_bco_admin_api_notification_email}
    EOT
    dev_receivers       = <<-EOT
        @${local.datadog_slack_bco_notification_email}
        @${local.datadog_slack_bco_admin_api_notification_email}
    EOT
  }
}

data "template_file" "datadog_external_api_message_template" {
  template = file("${path.module}/templates/message.tpl")

  vars = {

    system              = local.system
    tenant_space        = local.tenant_space
    system_instance_key = local.system_instance_key
    live_receivers      = <<-EOT
        @${local.datadog_slack_bco_external_api_notification_email}
    EOT
    test_receivers      = <<-EOT
        @${local.datadog_slack_bco_external_api_notification_email}
    EOT
    prev_receivers      = <<-EOT
        @${local.datadog_slack_bco_external_api_notification_email}
    EOT
    demo_receivers      = <<-EOT
        @${local.datadog_slack_bco_external_api_notification_email}
    EOT
    qa_receivers        = <<-EOT
        @${local.datadog_slack_bco_external_api_notification_email}
    EOT
    dev_receivers       = <<-EOT
        @${local.datadog_slack_bco_external_api_notification_email}
    EOT
  }
}

data "template_file" "datadog_sqs_messages_template" {
  template = file("${path.module}/templates/sqs_message.tpl")
  vars = {

    system              = local.system
    tenant_space        = local.tenant_space
    system_instance_key = local.system_instance_key

    alert_receivers = <<-EOT
      @${local.datadog_slack_bco_unit_email}
    EOT

    warning_receivers = <<-EOT
      @${local.datadog_sqs_warning_notification_email}
    EOT
  }
}

data "template_file" "datadog_db_connection_spike_messages_template" {
  template = file("${path.module}/templates/db_connection_spike_message.tpl")
  vars = {

    system              = local.system
    tenant_space        = local.tenant_space
    system_instance_key = local.system_instance_key

    receivers = <<-EOT
      @${local.datadog_slack_bco_unit_email}
    EOT
  }
}

data "aws_ssm_parameter" "datadog_api_key" {
  name = "/ops/aycp/shared/DATADOG_API_KEY"
}

data "aws_ssm_parameter" "datadog_app_key" {
  name = "/ops/aycp/shared/DATADOG_APP_KEY"
}
