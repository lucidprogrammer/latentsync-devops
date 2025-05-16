





resource "google_project_service" "required_services" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "pubsub.googleapis.com"
  ])
  
  project = var.project_id
  service = each.key
  
  disable_on_destroy = false
}
resource "google_artifact_registry_repository" "latentsync" {
  depends_on = [google_project_service.required_services]
  
  location      = var.region
  repository_id = "latentsync"
  description   = "Docker repository for LatentSync images"
  format        = "DOCKER"
}



module "latentsync_cloudrun" {
  source = "../../modules/cloudrun"
  depends_on = [google_artifact_registry_repository.latentsync]

  providers = {
    google-beta = google-beta
  }
  
  project_id            = var.project_id
  region                = var.region
  service_name          = "${var.project_prefix}-${local.environment}-worker"
  service_account_email = google_service_account.latentsync_worker.email
  image                 = "${var.region}-docker.pkg.dev/${var.project_id}/latentsync/worker:latest"
  
  gpu_zonal_redundancy_disabled = var.gpu_zonal_redundancy_disabled
  gpu_type              = var.gpu_type
  max_instances         = var.max_instances
  min_instances         = 0
  
 
  timeout               = 900
  concurrency           = 1
  
  
  weights_bucket        = module.storage.bucket_names.weights
  
}


resource "google_pubsub_topic" "latentsync_jobs" {
  name = "${var.project_prefix}-${local.environment}-latentsync-jobs"
}


resource "google_pubsub_subscription" "latentsync_worker_sub" {
  name  = "${var.project_prefix}-${local.environment}-latentsync-worker-sub"
  topic = google_pubsub_topic.latentsync_jobs.name
  
  
  ack_deadline_seconds = 600
  
  
  message_retention_duration = "604800s"
  
  
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"  
  }
  
  
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.latentsync_jobs_dead_letter.id
    max_delivery_attempts = 5
  }
}


resource "google_pubsub_topic" "latentsync_jobs_dead_letter" {
  name = "${var.project_prefix}-${local.environment}-latentsync-jobs-dead-letter"
}



