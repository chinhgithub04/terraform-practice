#!/bin/bash
# Đăng ký EC2 instance vào ECS Cluster
echo "ECS_CLUSTER=${ecs_cluster_name}" >> /etc/ecs/ecs.config
