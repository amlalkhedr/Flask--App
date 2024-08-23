variable "Cluster" {
  description = "eks cluster managing the node groups "
  type  = string
  
}

variable "Node-Group" {
  description = "Node Group to monitor "
  type  = string
  
}

resource "aws_sns_topic" "alerts" {
  name = "alerts-topic"
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  dimensions = {
  ClusterName    = var.Cluster
  NodegroupName  = var.Node-Group
  }
}
