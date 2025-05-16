output "bucket_names" {
  description = "The names of the created buckets"
  value = {
    weights = google_storage_bucket.weights_bucket.name
    input   = google_storage_bucket.input_bucket.name
    output  = google_storage_bucket.output_bucket.name
  }
}

output "bucket_urls" {
  description = "The GCS URLs of the created buckets"
  value = {
    weights = "gs://${google_storage_bucket.weights_bucket.name}"
    input   = "gs://${google_storage_bucket.input_bucket.name}"
    output  = "gs://${google_storage_bucket.output_bucket.name}"
  }
}