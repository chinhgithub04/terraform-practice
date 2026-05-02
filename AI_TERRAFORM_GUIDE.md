# AI Terraform Writing Guide

Hướng dẫn này nhằm hướng dẫn AI viết Terraform code đúng chuẩn cho dự án này.

---

## Cấu Trúc Dự Án

```
terraform/
├── main.tf              # Root module - gọi các modules
├── variables.tf         # Khai báo biến root level
├── outputs.tf           # Expose output từ các modules
├── terraform.tfvars     # Giá trị cụ thể cho biến root
├── provider.tf          # Cấu hình provider AWS
├── AI_TERRAFORM_GUIDE.md # Hướng dẫn này
└── modules/
    ├── vpc/             # VPC, subnets, internet gateway
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── asg/             # Auto Scaling Group, launch templates
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── scripts/
    │       └── install_web.sh
    └── ...              # Các modules khác
```

---

## Nguyên Tắc Lõi

### 1. **Không Hardcode Giá Trị**

- ❌ **Sai**: `cidr_block = "10.0.0.0/16"` trực tiếp trong module
- ✅ **Đúng**: `cidr_block = var.vpc_cidr` (biến được truyền từ root)

### 2. **Biến Phải Từ `terraform.tfvars`**

- Tất cả giá trị cần thay đổi phải được khai báo trong `terraform.tfvars` ở root level
- Modules chỉ khai báo biến và nhận giá trị từ root `main.tf`
- Tránh sử dụng `default` value trong variables

### 3. **Output Phải Rõ Ràng và Có Ý Nghĩa**

- Output name phải mô tả rõ ràng nó là gì
- **Ví dụ đúng**:
  - `app_server_iam_instance_profile_name` (thay vì `instance_profile_name`)
  - `rds_db_endpoint_address` (thay vì `endpoint`)
  - `public_subnet_ids` (thay vì `subnet_ids`)
- Luôn thêm `description` cho mỗi output
- Output nên mô tả đầy đủ mục đích sử dụng

### 4. **Variables Phải Có Description và Type**

- **Bắt buộc**: mỗi variable phải có `description` và `type`
- Hạn chế sử dụng `default` - chỉ dùng khi thực sự cần
- Description nên rõ ràng, mô tả giá trị mong đợi bằng tiếng Việt

**Ví dụ đúng**:

```terraform
variable "vpc_cidr" {
  description = "Dải IP CIDR của VPC"
  type        = string
}
```

---

## Quy Trình Viết Resource Terraform

### 1. Xác định thêm vào module hiện tại hay tạo module mới trong `modules/`.

### 2: Khai báo variables trong `modules/<module>/variables.tf`.

### 3: Tạo Resources vào `modules/<module>/main.tf`.

Quy tắc viết:

- Sử dụng `var.<variable_name>` cho tất cả biến
- Thêm tags cho tất cả resources hỗ trợ:
  ```terraform
  tags = {
    Name      = "${var.project_name}-resource-name"
    ManagedBy = "Terraform"
  }
  ```
- Dùng `count` hoặc `for_each` khi cần tạo multiple resources

### 4: Expose output trong `modules/<module>/outputs.tf`.

Quy tắc:

- **Mỗi output phải có**: `description` + `value`
- **Naming convention**: `<module_context>_<resource_type>_<attribute>`
  - Ví dụ: `app_server_iam_instance_profile_name` (không phải `instance_profile`)
- **Khuyến nghị**: không output mọi thứ, chỉ output những gì sẽ được dùng

### 5: Wiring tại root `main.tf` + `variables.tf` + `outputs.tf` nếu cần.

### 6: Wiring tại `terraform.tfvars`

## Chú Ý Quan Trọng

1. **Passwords**: Không hardcode passwords trong `terraform.tfvars`, dùng environment variables hoặc AWS Secrets Manager
   ```bash
   export TF_VAR_db_master_password="your-password"
   ```
2. **Sensitive Data**: Đánh dấu `sensitive = true` cho passwords/tokens
3. **Naming Convention**: Luôn sử dụng `${var.project_name}` trong resource names
4. **Best Practices**:
   - Sử dụng `count` cho multiple similar resources
   - Sử dụng `for_each` cho complex iterations
   - Thêm comments cho logic phức tạp
   - Test với `terraform plan` trước khi apply
