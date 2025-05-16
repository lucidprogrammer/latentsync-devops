
resource "google_storage_bucket" "weights_bucket" {
  name          = "${var.project_id}-${var.bucket_names.weights}"
  location      = var.region
  force_destroy = var.force_destroy


  storage_class = "STANDARD"


  uniform_bucket_level_access = true


  versioning {
    enabled = true
  }
}


resource "google_storage_bucket" "input_bucket" {
  name          = "${var.project_id}-${var.bucket_names.input}"
  location      = var.region
  force_destroy = var.force_destroy


  storage_class = "STANDARD"


  uniform_bucket_level_access = true


  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 7
    }
  }
}


resource "google_storage_bucket" "output_bucket" {
  name          = "${var.project_id}-${var.bucket_names.output}"
  location      = var.region
  force_destroy = var.force_destroy


  storage_class = "STANDARD"


  uniform_bucket_level_access = true


  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lifecycle_rule.value.action.storage_class
      }
      condition {
        age                   = lifecycle_rule.value.condition.age
        created_before        = lifecycle_rule.value.condition.created_before
        with_state            = lifecycle_rule.value.condition.with_state
        matches_storage_class = lifecycle_rule.value.condition.matches_storage_class
        num_newer_versions    = lifecycle_rule.value.condition.num_newer_versions
      }
    }
  }
}
