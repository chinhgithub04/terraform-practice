# Professional Terraform IaC Engineering Guide for AI Generators

This document defines the strict architectural and coding standards that must be adhered to when generating or refactoring Terraform Infrastructure as Code (IaC) within this repository. 

Follow these three core pillars to ensure maintainable, highly decoupled, and clean infrastructure.

---

## 1. Decoupling Environment-Specific vs. Invariant Parameters

To prevent bloated variable files and maintain clear architectural boundaries, parameters are categorized into two types: **Environment-Specific (Dynamic)** and **Environment-Invariant (Static)**.

### A. Environment-Specific Parameters (Dynamic)
* **Definition**: Any parameter that must change depending on the deployment target (e.g., `dev` vs. `prod`).
* **Enforcement**:
  1. Declare these variables in the root-level `variables.tf` of the environment.
  2. **CRITICAL**: Do **NOT** provide a `default` value in the variable definition. This forces the operator to explicitly define the value in the environment's `.tfvars` file, preventing accidental misconfigurations.
  3. Define the actual values in the environment's `terraform.tfvars`.
* **Typical Examples**:
  * Network Topologies: `vpc_cidr`, `public_subnet_cidrs`, `private_subnet_cidrs`, `availability_zones`.
  * Compute Scale & Performance: `min_size`, `max_size`, `desired_capacity`, `instance_type`, `ami_id`.
  * Database Sizing: `db_instance_class`, `db_allocated_storage`, `db_name`.
  * Container Orchestration: `ecs_service_desired_count`, `ecs_task_cpu`, `ecs_task_memory`, `ecs_task_memory_reservation`.
  * Identity & Naming: `project_name`, `tags` (environment-specific keys like `Environment` and `Owner`).

### B. Environment-Invariant Parameters (Static)
* **Definition**: Settings that remain identical across all environments and represent default configuration standards or engine requirements.
* **Enforcement**:
  1. **Hardcode** these values directly in the module resources (e.g., `modules/<name>/main.tf`).
  2. Do **NOT** declare them as variables in the module's `variables.tf` or the environment's `variables.tf`.
  3. This simplifies the module interface and keeps environment orchestrations clean.
* **Typical Examples**:
  * Application ports and protocols: Database port (`3306`), container/service port (`8080`), ALB port (`80`), listener protocol (`HTTP`).
  * Database settings: `db_engine = "mysql"`, `db_engine_version = "8.0.45"`, `db_username = "admin"`, `db_storage_type = "gp3"`.
  * ECR settings: `image_tag_mutability = "IMMUTABLE"`, `scan_on_push = true`.
  * ECS settings: `network_mode = "awsvpc"`, `managed_termination_protection = "ENABLED"`, `managed_scaling_status = "ENABLED"`, `target_capacity = 80`.
  * Launch Template storage defaults: `volume_size = 8`, `volume_type = "gp3"`, `delete_on_termination = true`, `encrypted = true`.
  * Target Group Health Checks: `healthy_threshold = 2`, `unhealthy_threshold = 2`, `timeout = 5`, `interval = 30`, `path = "/"`, `matcher = "200"`.

---

## 2. Centralized Tag Management

A clean tagging strategy prevents duplicate code and guarantees metadata consistency across AWS resources.

### A. Provider default_tags (Centralized)
Common, project-wide tags must be declared once at the root level using the AWS Provider's `default_tags` block inside the environment's `provider.tf`:

```hcl
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.tags["Environment"]
      Owner       = var.tags["Owner"]
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}
```

* **Outcome**: Standard AWS resources (VPC, Subnets, Security Groups, Load Balancers, Target Groups, ECS clusters/services, RDS databases, Secrets Manager, etc.) created by this provider automatically inherit these tags without any additional code.
* **Avoid**: Do **NOT** pass `tags` to child modules for these standard resources, and do **NOT** use `merge(..., var.tags)` on them.

### B. Resource-Specific Tags (Local)
For resource-specific naming, declare it directly on the resource `tags` block. The AWS Provider automatically merges these with the `default_tags`:

```hcl
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "${var.project_name}-vpc"
  }
}
```

### C. ASG/EC2 Tag Propagation (Special Exceptions)
AWS Auto Scaling Groups and EC2 Instances launched by ASG do not automatically inherit provider `default_tags`. Therefore, they must use explicit tag propagation:

1. Pass environment tags (`tags = var.tags`) into the ASG module block.
2. In the ASG module `main.tf`, define a local tag merge:
   ```hcl
   locals {
     name_tag = {
       Name = "${var.project_name}-asg"
     }
     merged_tags = merge(local.name_tag, var.tags)
   }
   ```
3. Attach `merged_tags` to `tag_specifications` inside `aws_launch_template`:
   ```hcl
   tag_specifications {
     resource_type = "instance"
     tags          = local.merged_tags
   }
   ```
4. Define dynamic tags in `aws_autoscaling_group` to propagate them to EC2 instances at launch:
   ```hcl
   dynamic "tag" {
     for_each = local.merged_tags
     content {
       key                 = tag.key
       value               = tag.value
       propagate_at_launch = true
     }
   }
   ```

---

## 3. Strict Verification Workflow

Before committing any Terraform changes:
1. **Formatting**: Run `terraform fmt -recursive` to enforce proper styling (canonical spacing and alignment).
2. **Validation**: Run `terraform validate` in the root of the targeted environment (`environments/dev` or `environments/prod`) to check syntactical correctness and resource dependencies.
