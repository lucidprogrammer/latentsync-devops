

locals {
  
  gpu_configs = {
    "nvidia-l4" = {
      cpu      = 4
      memory   = "16Gi"
      gpus     = 1
    }
    "nvidia-a100-40gb" = {
      cpu      = 8
      memory   = "32Gi"
      gpus     = 1
    }
  }
  
  
  cpu     = var.cpu != null ? var.cpu : local.gpu_configs[var.gpu_type].cpu
  memory  = var.memory != null ? var.memory : local.gpu_configs[var.gpu_type].memory
}


resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region
  provider = google-beta
  deletion_protection = false
  
  template {
    gpu_zonal_redundancy_disabled = var.gpu_zonal_redundancy_disabled
    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }
    
    timeout = "${var.timeout}s"
    
    max_instance_request_concurrency = var.concurrency
    
    execution_environment = var.execution_environment
    
    service_account = var.service_account_email
    
    containers {
      image = var.image
      
      resources {
        limits = {
          cpu    = "${local.cpu}"
          memory = local.memory
          "nvidia.com/gpu"    = "${local.gpu_configs[var.gpu_type].gpus}"
        }
      }
      
      env {
        name  = "PROJECT"
        value = var.project_id
      }
      
      env {
        name  = "WEIGHTS_BUCKET"
        value = var.weights_bucket
      }
      
      
      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.key
          value = env.value
        }
      }
    }
    
    annotations = {
      "run.googleapis.com/gpu-type"        = var.gpu_type
      "run.googleapis.com/cpu-throttling"  = "false"
      "run.googleapis.com/startup-cpu-boost" = "true"   
      "run.googleapis.com/execution-environment" = var.execution_environment
      
    }
  }
}