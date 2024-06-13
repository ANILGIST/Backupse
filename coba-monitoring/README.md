
# Coba Monitoring

Create and deploy Datadog monitors.

## Deployment Pipeline

1. The pipeline is triggered within this repo based on MR is merged and when MR is created.
2. The pipeline validates the terraform code using precommit hook configured in the repo.
3. After validating the Terraform code it will trigger downstream pipeline.
4. The Downstream pipeline enables developers to click and auto plan and apply Terraform code all environments and tenants.

**Note:** You don't need to update the version on `AYC Tenant Infra Live` repo anymore. The pipeline always deploys from Main branch, versioning or tags is not required.

## Precommit hooks:

Precommit hooks are configured to ensure that standard Terraform coding practices are applied.

You will need precommit hooks installed on your system to be able to work with this repo.

1. MacOS (`brew install pre-commit`) or using Linux/Python (`pip3 install pre-commit`)
2. Install precommit hook configrations using command `pre-commit install`.
3. The precommit hook automatically run per each commit you do. If you are running precommit after you made all commits then you can manually invoke it using command `pre-commit run --all-files`.

**Note:** The validation pipeline stage would fail until all the precommit hook errors are fixed.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0, < 5.0.0 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | ~> 3.36.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0, < 5.0.0 |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | ~> 3.36.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_password_hashing_service"></a> [api\_password\_hashing\_service](#module\_api\_password\_hashing\_service) | ./api/password_hashing_service | n/a |
| <a name="module_api_promotion_engine"></a> [api\_promotion\_engine](#module\_api\_promotion\_engine) | ./api/promotion_engine | n/a |
| <a name="module_queue_monitors_email"></a> [queue\_monitors\_email](#module\_queue\_monitors\_email) | ./queue_monitors/email | n/a |
| <a name="module_queue_monitors_misc"></a> [queue\_monitors\_misc](#module\_queue\_monitors\_misc) | ./queue_monitors/misc | n/a |
| <a name="module_queue_monitors_payment"></a> [queue\_monitors\_payment](#module\_queue\_monitors\_payment) | ./queue_monitors/payment | n/a |
| <a name="module_queue_monitors_return"></a> [queue\_monitors\_return](#module\_queue\_monitors\_return) | ./queue_monitors/return | n/a |
| <a name="module_queue_monitors_system"></a> [queue\_monitors\_system](#module\_queue\_monitors\_system) | ./queue_monitors/system | n/a |
| <a name="module_queue_monitors_transition"></a> [queue\_monitors\_transition](#module\_queue\_monitors\_transition) | ./queue_monitors/transition | n/a |

## Resources

| Name | Type |
|------|------|
| [datadog_service_level_objective.availability_slo](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/service_level_objective) | resource |
| [datadog_service_level_objective.duration_slo](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/service_level_objective) | resource |
| [datadog_service_level_objective.latency_slo](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/service_level_objective) | resource |
| [aws_ssm_parameter.datadog_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.datadog_app_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_coba_datadog_owasp_service_timeouts_threshold"></a> [coba\_datadog\_owasp\_service\_timeouts\_threshold](#input\_coba\_datadog\_owasp\_service\_timeouts\_threshold) | Threshold for OWASP password hashing service timeouts. | `number` | `15` | no |
| <a name="input_coba_datadog_promotion_engine_errors_threshold"></a> [coba\_datadog\_promotion\_engine\_errors\_threshold](#input\_coba\_datadog\_promotion\_engine\_errors\_threshold) | Threshold for promotion engine errors. | `number` | `10` | no |
| <a name="input_enabled_queue_workers"></a> [enabled\_queue\_workers](#input\_enabled\_queue\_workers) | List of enabled queue workers. Based on this list, monitors will be created only for queues that have workers enabled. | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of environment | `string` | n/a | yes |
| <a name="input_is_live"></a> [is\_live](#input\_is\_live) | Is environment live | `string` | `"false"` | no |
| <a name="input_monitor_receiver_overrides"></a> [monitor\_receiver\_overrides](#input\_monitor\_receiver\_overrides) | Default monitor receivers can be overridden using this variable (useful for testing) | `list(string)` | `[]` | no |
| <a name="input_queue_size_monitor_thresholds"></a> [queue\_size\_monitor\_thresholds](#input\_queue\_size\_monitor\_thresholds) | Threshold definitions for queue size monitors | <pre>object({<br>    transition_target_state_delegated                                       = optional(number, 800)<br>    transition_target_state_shipped                                         = optional(number, 1000)<br>    transition_target_state_invoiced                                        = optional(number, 500)<br>    transition_target_state_cancelled                                       = optional(number, 100)<br>    transition_target_state_delegated_oldest_item_delta_in_seconds          = optional(number, 600)<br>    transition_target_state_shipped_oldest_item_delta_in_seconds            = optional(number, 1200)<br>    transition_target_state_invoiced_oldest_item_delta_in_seconds           = optional(number, 3600)<br>    transition_target_state_cancelled_oldest_item_delta_in_seconds          = optional(number, 1200)<br>    payments_refund                                                         = optional(number, 100)<br>    payments_capture                                                        = optional(number, 100)<br>    payments_cancel                                                         = optional(number, 100)<br>    payments_refund_oldest_item_delta_in_seconds                            = optional(number, 3600)<br>    payments_capture_oldest_item_delta_in_seconds                           = optional(number, 3600)<br>    payments_cancel_oldest_item_delta_in_seconds                            = optional(number, 600)<br>    emails_customer_bank_account_update_mail                                = optional(number, 20)<br>    emails_customer_order_cancellation_mail                                 = optional(number, 20)<br>    emails_customer_order_delegation_mail                                   = optional(number, 20)<br>    emails_customer_order_invoice_mail                                      = optional(number, 120)<br>    emails_customer_order_product_return_mail                               = optional(number, 20)<br>    emails_customer_order_shipment_mail                                     = optional(number, 20)<br>    emails_customer_password_reset                                          = optional(number, 20)<br>    emails_customer_reminder_bank_account_mail                              = optional(number, 100)<br>    emails_order_bank_account_update_mail                                   = optional(number, 100)<br>    emails_order_products_undeliverable_mail                                = optional(number, 100)<br>    emails_customer_bank_account_update_mail_oldest_item_delta_in_seconds   = optional(number, 600)<br>    emails_customer_order_cancellation_mail_oldest_item_delta_in_seconds    = optional(number, 600)<br>    emails_customer_order_delegation_mail_oldest_item_delta_in_seconds      = optional(number, 600)<br>    emails_customer_order_invoice_mail_oldest_item_delta_in_seconds         = optional(number, 600)<br>    emails_customer_order_product_return_mail_oldest_item_delta_in_seconds  = optional(number, 600)<br>    emails_customer_order_shipment_mail_oldest_item_delta_in_seconds        = optional(number, 600)<br>    emails_customer_password_reset_oldest_item_delta_in_seconds             = optional(number, 600)<br>    emails_customer_reminder_bank_account_mail_oldest_item_delta_in_seconds = optional(number, 600)<br>    emails_order_bank_account_update_mail_oldest_item_delta_in_seconds      = optional(number, 600)<br>    emails_order_products_undeliverable_mail_oldest_item_delta_in_seconds   = optional(number, 600)<br>    returns                                                                 = optional(number, 100)<br>    composite_returns                                                       = optional(number, 100)<br>    invoices                                                                = optional(number, 400)<br>    sms                                                                     = optional(number, 100)<br>    webhooks                                                                = optional(number, 250)<br>    returns_oldest_item_delta_in_seconds                                    = optional(number, 1200)<br>    invoices_oldest_item_delta_in_seconds                                   = optional(number, 3600)<br>    sms_oldest_item_delta_in_seconds                                        = optional(number, 3600)<br>    webhooks_oldest_item_delta_in_seconds                                   = optional(number, 600)<br>  })</pre> | `{}` | no |
| <a name="input_small_environments"></a> [small\_environments](#input\_small\_environments) | List of small environments(e.g. fcb-live, sol-live) | `list(string)` | <pre>[<br>  "sol-live",<br>  "tomt-live",<br>  "depot-live",<br>  "mop-live",<br>  "dmg-live",<br>  "fim-live",<br>  "ags-live",<br>  "kns-live",<br>  "fcb-live"<br>]</pre> | no |
| <a name="input_system_monitor_thresholds"></a> [system\_monitor\_thresholds](#input\_system\_monitor\_thresholds) | Threshold definitions for the system queue monitors | <pre>object({<br>    too_many_db_connections = optional(number, 1)<br>  })</pre> | `{}` | no |
| <a name="input_tenant_short_key"></a> [tenant\_short\_key](#input\_tenant\_short\_key) | Short key of tenant | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
