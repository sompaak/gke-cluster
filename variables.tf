variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in (optional if zonal cluster / required if regional)"
  default     = "us-central1"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster (required)"
  default     = "helming-cluster"
}

variable "node_pool_name" {
  type        = string
  description = "The name of the node-pool"
  default     = "node-pool"
}

variable "node_pool_names" {
  type        = list(string)
  description = "the names of the node-pools"
  default     = ["node-pool-1", "node-pool-2", "node-pool-3"]
}
variable "helm_chart_name" {
  type        = string
  description = "The name of the helm chart"
  default     = "helm-chart"
}

variable "helm_chart_path" {
  type        = string
  description = "The path of the helm chart"
  default     = "./helm-chart"
}

variable "nginx_ingress_chart_name" {
  type        = string
  description = "The name of the nginx ingress controller helm chart"
  default     = "nginx-ingress-chart"
}

variable "nginx_ingress_chart_path" {
  type        = string
  description = "The path of the nginx ingress controller helm chart"
  default     = "./nginx-ingress-helm-chart"
}