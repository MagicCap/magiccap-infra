// K8s cluster
resource "digitalocean_kubernetes_cluster" "k8s-prod" {
  name = "magiccap-k8s-nyc3-1"
  region = "nyc3"
  version = "1.15.3-do.2"

  node_pool {
    name = "magiccap-k8s-pool-nyc3-1"
    size = "s-1vcpu-2gb"
    node_count = 2
  }
}

// Release bucket + CDN
resource "digitaloean_spaces_bucket" "release-data" {
  name = "magiccap-spaces-nyc3-1"
  region = "nyc3"
  acl = "public-read"
}

resource "digitalocean_cdn" "release-cdn" {
  origin = "${digitaloean_spaces_bucket.release-data.bucket_domain_name}"
}

output "fqdn" {
  value = "${digitalocean_cdn.release-cdn.endpoint}"
}

// Database Cluster
resource "digitalocean_database_cluster" "postgres-prod" {
  name       = "magiccap-pg-nyc3-1"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc3"
  node_count = 1
}