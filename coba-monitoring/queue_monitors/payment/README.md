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
| [datadog_monitor.queue_size_monitor_payments_cancel](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.queue_size_monitor_payments_capture](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.queue_size_monitor_payments_refund](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.queue_oldest_item_monitor_payments_cancel](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.queue_oldest_item_monitor_payments_capture](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.queue_oldest_item_monitor_payments_refund](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled_queue_workers"></a> [enabled\_queue\_workers](#input\_enabled\_queue\_workers) | n/a | `list(string)` | `[]` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_monitor_receiver_overrides"></a> [monitor\_receiver\_overrides](#input\_monitor\_receiver\_overrides) | n/a | `list(string)` | `[]` | no |
| <a name="input_monitor_tags"></a> [monitor\_tags](#input\_monitor\_tags) | n/a | `list(string)` | n/a | yes |
| <a name="input_monitor_thresholds"></a> [monitor\_thresholds](#input\_monitor\_thresholds) | n/a | <pre>object({<br>    payments_refund                               = number<br>    payments_capture                              = number<br>    payments_cancel                               = number<br>    payments_refund_oldest_item_delta_in_seconds  = number<br>    payments_capture_oldest_item_delta_in_seconds = number<br>    payments_cancel_oldest_item_delta_in_seconds  = number<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
