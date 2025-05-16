variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "project_prefix" {
  description = "Prefix to use for resource naming, typically organization or project name"
  type        = string
  default     = "latentsync"
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "gpu_type" {
  description = "GPU type to use for Cloud Run service"
  type        = string
  default     = "nvidia-l4"
  
  validation {
    condition     = contains(["nvidia-l4", "nvidia-a100-40gb"], var.gpu_type)
    error_message = "The gpu_type must be either 'nvidia-l4' or 'nvidia-a100-40gb'."
  }
}

variable "max_instances" {
  description = "Maximum number of instances to scale to"
  type        = number
  default     = 10  # Lower for stage environment
}

variable "gpu_zonal_redundancy_disabled" {
  description = "Disable GPU zonal redundancy"
  type        = bool
  default     = false
}