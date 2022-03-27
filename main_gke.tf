module "gke" {
  depends_on = [
    google_project_service.container,
    google_compute_subnetwork.gke
  ]
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = local.project_name
  name                       = "gke-test-1"
  region                     = local.region_name
  zones                      = ["europe-central2-a", "europe-central2-b", "europe-central2-c"]
  network                    = "default" /* data.google_compute_network.default-vpc.name */
  subnetwork                 = "gke-subnetwork1"
  ip_range_pods              = "gke-pods"
  ip_range_services          = "gke-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true
  remove_default_node_pool	 = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-standard-2"
      node_locations     = "europe-central2-a,europe-central2-b,europe-central2-c"
      min_count          = 1
      max_count          = 3
      max_pods_per_node  = 32
      local_ssd_count    = 0
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      initial_node_count = 1
    },
    {
      name               = "es-node-pool"
      machine_type       = "e2-standard-4"
      node_locations     = "europe-central2-a,europe-central2-b,europe-central2-c"
      min_count          = 0
      max_count          = 3
      max_pods_per_node  = 16
      local_ssd_count    = 0
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 0
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    es-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }

    es-node-pool = {
      es-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

    es-node-pool = [
      {
        key    = "es-node-pool"
        value  = true
        effect = "NO_SCHEDULE"
      }
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

output "cluster_outputs" {
  value     = module.gke
  sensitive = true
}