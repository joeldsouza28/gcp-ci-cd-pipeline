terraform {
  required_version = "1.13.3"
}

provider "google" {
  project = var.project_id
  region  = var.region
}


resource "google_cloud_run_service" "fastapi_service" {
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

resource "google_cloud_run_service_iam_member" "public_invoker" {
  service  = google_cloud_run_service.fastapi_service.name
  location = google_cloud_run_service.fastapi_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}



resource "google_artifact_registry_repository" "fastapi_repo" {
  provider      = google
  location      = var.region
  repository_id = "fastapi-repo"
  description   = "Docker repo for FastAPI CI/CD app"
  format        = "DOCKER"
}
