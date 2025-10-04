terraform {
  required_version = "1.13.3"
}

provider "google" {
  project = var.project_id
  region  = var.region
}



resource "google_artifact_registry_repository" "fastapi_repo" {
  provider      = google
  location      = var.region
  repository_id = "fastapi-cicd"
  description   = "Docker repo for FastAPI CI/CD app"
  format        = "DOCKER"
}
