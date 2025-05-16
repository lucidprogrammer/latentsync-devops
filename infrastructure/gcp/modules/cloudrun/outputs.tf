output "service_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_v2_service.service.uri
}

output "service_name" {
  description = "The name of the deployed Cloud Run service"
  value       = google_cloud_run_v2_service.service.name
}

output "region" {
  description = "The region where the service is deployed"
  value       = google_cloud_run_v2_service.service.location
}

output "gpu_type" {
  description = "Type of GPU attached to the service"
  value       = var.gpu_type
}

output "max_instances" {
  description = "Maximum number of instances"
  value       = var.max_instances
}