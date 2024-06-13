<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [datadog_monitor.promotion_engine_alert](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_coba_datadog_promotion_engine_errors_threshold"></a> [coba\_datadog\_promotion\_engine\_errors\_threshold](#input\_coba\_datadog\_promotion\_engine\_errors\_threshold) | n/a | `number` | n/a | yes |
| <a name="input_datadog_notification_email"></a> [datadog\_notification\_email](#input\_datadog\_notification\_email) | n/a | `string` | n/a | yes |
| <a name="input_datadog_slack_tc_notification_channel"></a> [datadog\_slack\_tc\_notification\_channel](#input\_datadog\_slack\_tc\_notification\_channel) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_system"></a> [system](#input\_system) | n/a | `string` | n/a | yes |
| <a name="input_system_instance_key"></a> [system\_instance\_key](#input\_system\_instance\_key) | n/a | `string` | n/a | yes |
| <a name="input_tenant_space"></a> [tenant\_space](#input\_tenant\_space) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
