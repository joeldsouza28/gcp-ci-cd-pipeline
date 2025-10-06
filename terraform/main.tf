terraform {
  required_version = "1.13.3"
}

provider "google" {
  project = var.project_id
  region  = var.region
}


resource "google_cloud_run_service" "default" {
  name     = "fastapi-service"
  location = var.region

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/${var.project_id}/fastapi-repo/fastapi-repo:latest"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_artifact_registry_repository.fastapi_repo]
}


resource "google_artifact_registry_repository" "fastapi_repo" {
  provider      = google
  location      = var.region
  repository_id = "fastapi-service"
  description   = "Docker repo for FastAPI CI/CD app"
  format        = "DOCKER"
}
