
resource "google_storage_bucket_iam_member" "service_account_weights_access" {
  count  = var.service_account_id != null ? 1 : 0
  bucket = google_storage_bucket.weights_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.service_account_id}@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "service_account_input_access" {
  count  = var.service_account_id != null ? 1 : 0
  bucket = google_storage_bucket.input_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.service_account_id}@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "service_account_output_access" {
  count  = var.service_account_id != null ? 1 : 0
  bucket = google_storage_bucket.output_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_id}@${var.project_id}.iam.gserviceaccount.com"
}