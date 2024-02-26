#!/bin/bash
kubectl apply -f 01_namespace.yaml
kubectl apply -f 02_secret.yaml
kubectl apply -f 03_deployment.yaml
kubectl apply -f 04_service.yaml