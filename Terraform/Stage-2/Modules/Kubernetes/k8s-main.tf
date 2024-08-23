
data "aws_eks_cluster_auth" "xxx" {
  name = var.Cluster-Name
}

provider "kubernetes" {
host = var.Cluster-Endpoint
token= data.aws_eks_cluster_auth.xxx.token
cluster_ca_certificate = base64decode(var.Cluster-Authority)
}

resource "kubernetes_namespace" "build" {
  metadata {
    name = "build"
  }
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}

