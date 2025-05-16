variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for storage buckets"
  type        = string
  default     = "us-central1"
}

variable "bucket_names" {
  description = "Map of bucket purpose to name suffix"
  type        = map(string)
  default     = {
    weights = "latentsync-weights"
    input   = "latentsync-in"
    output  = "latentsync-out"
  }
}

variable "force_destroy" {
  description = "When true, buckets will be deleted even if they contain objects"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for output bucket"
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                   = optional(number)
      created_before        = optional(string)
      with_state            = optional(string)
      matches_storage_class = optional(list(string))
      num_newer_versions    = optional(number)
    })
  }))
  default = [
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 30 
      }
    }
  ]
}

variable "service_account_id" {
  description = "The ID of the service account to grant bucket access (if provided)"
  type        = string
  default     = null
}