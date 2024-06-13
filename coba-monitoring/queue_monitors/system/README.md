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

| Name                                                                                                                                           | Type |
|------------------------------------------------------------------------------------------------------------------------------------------------|------|
| [datadog_monitor.too_many_queue_db_connections_monitor](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |

## Inputs

| Name | Description | Type                                                                            | Default | Required |
|------|-------------|---------------------------------------------------------------------------------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `string`                                                                        | n/a | yes |
| <a name="input_monitor_receiver_overrides"></a> [monitor\_receiver\_overrides](#input\_monitor\_receiver\_overrides) | n/a | `list(string)`                                                                  | `[]` | no |
| <a name="input_monitor_tags"></a> [monitor\_tags](#input\_monitor\_tags) | n/a | `list(string)`                                                                  | n/a | yes |
| <a name="input_monitor_thresholds"></a> [monitor\_thresholds](#input\_monitor\_thresholds) | n/a | <pre>object({<br>    too_many_queue_db_connections_monitor = number<br>})</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
