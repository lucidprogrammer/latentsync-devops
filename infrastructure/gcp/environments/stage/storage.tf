


# Create the service account for the Cloud Run service
resource "google_service_account" "latentsync_worker" {
  account_id   = "${local.resource_prefix}-worker"
  display_name = "LatentSync Worker Service Account (${local.environment})"
  description  = "Service account for LatentSync Cloud Run worker in ${local.environment} environment"
}

# Storage buckets
module "storage" {
  source = "../../modules/storage"
  
  project_id       = var.project_id
  region           = var.region
  service_account_id = google_service_account.latentsync_worker.account_id
  
  # Use environment-specific bucket names
  bucket_names = {
    weights = "${var.project_prefix}-${local.environment}-latentsync-weights"
    input   = "${var.project_prefix}-${local.environment}-latentsync-in"
    output  = "${var.project_prefix}-${local.environment}-latentsync-out"
  }
  
  # Stage-specific lifecycle rules if needed
  lifecycle_rules = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 14 # Shorter retention for stage environment
      }
    }
  ]
}