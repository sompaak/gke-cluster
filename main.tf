# accesses the configuration of the Google Cloud provider
data "google_client_config" "provider" {}

# Get info about a GKE cluster. 
data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = var.region
}

# Provider for Helm
provider "helm" {
  # Gets GKE Cluster Auth Info
  kubernetes {
    load_config_file = false
    host             = "https://${data.google_container_cluster.primary.endpoint}"
    token            = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }
}

# Creates a GKE cluster
# Removes the default pool as node pools will be created in the next resource.
resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
}

# Creates GKE node pools
resource "google_container_node_pool" "node_pool" {
  #  Provisioning multiple node-pools using count
  count = 3
  name  = "${var.node_pool_name}-${count.index + 1}"
  # Provisioning mulitple node-pools using for_each:
  # for_each = toset(var.node_pool_names)
  # name     = each.value
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

# Deploys Helm Charts Into The GKE Cluster
resource "helm_release" "local" {
  name  = var.helm_chart_name
  chart = var.helm_chart_path
  depends_on = [
    google_container_node_pool.node_pool
  ]
}


resource "helm_release" "nginx-ingress" {
  name  = var.nginx_ingress_chart_name
  chart = var.nginx_ingress_chart_path
  depends_on = [
    google_container_node_pool.node_pool
  ]
}