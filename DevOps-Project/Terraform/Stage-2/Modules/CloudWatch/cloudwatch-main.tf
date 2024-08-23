resource "aws_cloudwatch_log_group" "EC2-Logs" {
  name              = "Ec2-log-group"
  retention_in_days = 7  # Replace with the number of days you want to retain the logs
}


resource "kubernetes_config_map" "cloudwatch-agent_config-map" {
  metadata {
    name      = "cloudwatch.agent-config.map"
    namespace = "kube-system"
  }

  data = {
    "cwagentconfig.json" = jsonencode({
      logs = {
        metrics_collected = {
          cpu = {
            measurement = [
              "cpu_usage_idle",
              "cpu_usage_user",
              "cpu_usage_system"
            ],
            resources = [
              "*"
            ]
          }
        }
      }
    })
  }
}

resource "kubernetes_daemon_set_v1" "cloudwatch_agent" {
  metadata {
    name      = "cloudwatch-agent"
    namespace = "kube-system"
  }

  spec {
    selector {
      match_labels = {
        name = "cloudwatch-agent"
      }
    }

    template {
      metadata {
        labels = {
          name = "cloudwatch-agent"
        }
      }

      spec {
        service_account_name = "cloudwatch-agent"

        container {
          name  = "cloudwatch-agent"
          image = "amazon/cloudwatch-agent:latest"

          resources {
            limits = {
              memory = "200Mi"
              cpu    = "200m"
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/cloudwatch-agent-config.json"
            sub_path   = "cloudwatch-agent-config.json"
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.cloudwatch-agent_config-map.metadata[0].name
          }
        }
      }
    }
  }
}

