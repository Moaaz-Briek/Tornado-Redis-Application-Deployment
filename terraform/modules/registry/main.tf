# ------------------------------------------------------------------------------------------------- #
# --------------------------------------- Artifact Registry --------------------------------------- #
# ------------------------------------------------------------------------------------------------- #

resource "google_artifact_registry_repository" "docker_repository" {
  location      = var.region
  repository_id = var.repository_name
  format        = "DOCKER"
  description   = "Docker repository for container images"

  labels = {
    environment = var.environment
    managed-by  = "terraform"
  }
}
