data "aws_ssm_parameter" "datadog_api_key" {
  name = "/ops/aycp/shared/DATADOG_API_KEY"
}

data "aws_ssm_parameter" "datadog_app_key" {
  name = "/ops/aycp/shared/DATADOG_APP_KEY"
}
