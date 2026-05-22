resource "yandex_storage_bucket" "kittygram_media" {
  bucket = var.s3_bucket_name

  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }

  versioning {
    enabled = true
  }

  default_storage_class = "STANDARD"
}
