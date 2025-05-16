output "environment" {
  description = "The environment name"
  value       = local.environment
}

output "service_account_email" {
  description = "Email of the service account for the LatentSync worker"
  value       = google_service_account.latentsync_worker.email
}

output "storage_buckets" {
  description = "Storage bucket information"
  value = {
    names = module.storage.bucket_names
    urls  = module.storage.bucket_urls
  }
}

output "cloud_run_service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = module.latentsync_cloudrun.service_url
}
output "cloud_run_service_name" {
  description = "Name of the deployed Cloud Run service"
  value       = module.latentsync_cloudrun.service_name
}
output "cloud_run_region" {
  description = "Region where the Cloud Run service is deployed"
  value       = module.latentsync_cloudrun.region
}
output "cloud_run_gpu_type" {
  description = "Type of GPU attached to the Cloud Run service"
  value       = module.latentsync_cloudrun.gpu_type
}
output "cloud_run_max_instances" {
  description = "Maximum number of instances for the Cloud Run service"
  value       = module.latentsync_cloudrun.max_instances
}