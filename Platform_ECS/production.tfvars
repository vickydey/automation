# remote state
remote_state_key = "PROD/infrastructure.tfstate"
remote_state_bucket = "ecs-fargate-terraform-remote"

ecs_domain_name = "YOUR_ROUTE53_DOMAIN"
ecs_cluster_name = "Production-ECS-Cluster"
internet_cidr_block = "0.0.0.0/0"