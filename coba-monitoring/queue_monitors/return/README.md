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
| [datadog_monitor.queue_size_monitor_number_of_returns_in_queue](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.queue_size_monitor_number_of_return_workers](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.queue_size_composite_monitor_returns](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled_queue_workers"></a> [enabled\_queue\_workers](#input\_enabled\_queue\_workers) | n/a | `list(string)` | `[]` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_monitor_receiver_overrides"></a> [monitor\_receiver\_overrides](#input\_monitor\_receiver\_overrides) | n/a | `list(string)` | `[]` | no |
| <a name="input_monitor_tags"></a> [monitor\_tags](#input\_monitor\_tags) | n/a | `list(string)` | n/a | yes |
| <a name="input_monitor_thresholds"></a> [monitor\_thresholds](#input\_monitor\_thresholds) | n/a | <pre>object({<br>    composite_returns  = number<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
