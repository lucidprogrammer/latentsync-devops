locals {
  environment = "stage"
  
  # Any environment-specific local variables
  resource_prefix = "${var.project_prefix}-${local.environment}"
}