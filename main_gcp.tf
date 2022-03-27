provider "google" {
  project = local.project_name
  region  = local.region_name
}

resource "google_project_service" "compute" {
  project = local.project_name
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_project_service" "container" {
  project = local.project_name
  service = "container.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}
