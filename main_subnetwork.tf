resource "google_compute_subnetwork" "gke" {
  depends_on = [
    google_project_service.compute
  ]
  name          = "gke-subnetwork1"
  ip_cidr_range = "10.0.0.0/24"
  region        = local.region_name
  network       = "default"
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.0.1.0/24"
  }
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.0.2.0/23"
  }
}
