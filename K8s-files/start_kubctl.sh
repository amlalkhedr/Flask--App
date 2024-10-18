#!/bin/bash
aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster 

kubectl apply -f mysql_pv.yaml
kubectl apply -f mysql_pvc.yaml
kubectl apply -f mysql_deployment.yaml
kubectl apply -f mysql_Service.yaml
kubectl apply -f flask_app_deployment.yaml
kubectl apply -f flask_app_service.yaml