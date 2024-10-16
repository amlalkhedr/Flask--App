# IAM Role for the EKS cluster (Cluster-main)
resource "aws_iam_role" "Cluster-main" {
  name = "Cluster-main"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# Attach required policies to the Cluster-main IAM Role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.Cluster-main.name
}

# Optional: Attach additional policies for the EKS Cluster Role (if needed)
resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.Cluster-main.name
}


# IAM Role for EKS Worker Nodes (Node Group)
resource "aws_iam_role" "WorkerNode" {
  name = "WorkerNode"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach required policies to Node Group role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.WorkerNode.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.WorkerNode.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr_read_only_policy" {
  role       = aws_iam_role.WorkerNode.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Policy to access EBS (for persistent volumes)
resource "aws_iam_role_policy_attachment" "eks_ebs_policy" {
  role       = aws_iam_role.WorkerNode.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
