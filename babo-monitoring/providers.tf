provider "datadog" {
  api_url = "https://api.datadoghq.eu"
  api_key = data.aws_ssm_parameter.datadog_api_key.value
  app_key = data.aws_ssm_parameter.datadog_app_key.value
}
