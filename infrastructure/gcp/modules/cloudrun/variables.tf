variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the Cloud Run service"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "service_account_email" {
  description = "Email of the service account to run the Cloud Run service"
  type        = string
}

variable "image" {
  description = "Docker image to deploy (including tag)"
  type        = string
}

variable "gpu_type" {
  description = "Type of GPU to attach to the Cloud Run service"
  type        = string
  
  validation {
    condition     = contains(["nvidia-l4", "nvidia-a100-40gb"], var.gpu_type)
    error_message = "The gpu_type must be either 'nvidia-l4' or 'nvidia-a100-40gb'."
  }
}

variable "max_instances" {
  description = "Maximum number of instances to scale to"
  type        = number
}

variable "min_instances" {
  description = "Minimum number of instances to keep running"
  type        = number
  default     = 0
}

variable "cpu" {
  description = "Number of CPUs to allocate (if not specified, will be determined based on GPU type)"
  type        = number
  default     = null
}

variable "memory" {
  description = "Memory to allocate (if not specified, will be determined based on GPU type)"
  type        = string
  default     = null
}

variable "timeout" {
  description = "Maximum time in seconds a request can take before timing out"
  type        = number
  default     = 900  # 15 minutes
}

variable "concurrency" {
  description = "Maximum number of concurrent requests per instance"
  type        = number
  default     = 1
}

variable "environment_variables" {
  description = "Environment variables to set in the container"
  type        = map(string)
  default     = {}
}

variable "execution_environment" {
  description = "Execution environment for the Cloud Run service"
  type        = string
  default     = "EXECUTION_ENVIRONMENT_GEN2"  
  
  validation {
    condition     = contains(["EXECUTION_ENVIRONMENT_GEN1", "EXECUTION_ENVIRONMENT_GEN2", ""], var.execution_environment)
    error_message = "The execution_environment must be one of: EXECUTION_ENVIRONMENT_GEN1, EXECUTION_ENVIRONMENT_GEN2, or empty string."
  }
}

variable "weights_bucket" {
  description = "Name of the GCS bucket containing model weights"
  type        = string
}

variable "gpu_zonal_redundancy_disabled" {
  description = "Disable GPU zonal redundancy"
  type        = bool
  default     = false
}

