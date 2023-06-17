locals {
  env_config = jsondecode(file("config/env_config.${var.env}.json"))
}

locals {
  base_context = {
    profile    = local.env_config.config.profile
    aws_region = local.env_config.config.region
  }
}
