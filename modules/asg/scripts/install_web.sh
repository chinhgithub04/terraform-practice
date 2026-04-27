#!/bin/bash
# Cập nhật các gói phần mềm
yum update -y

# Cài đặt Apache Web Server (dùng cho Amazon Linux 2/2023)
yum install -y httpd

# Khởi động và cấu hình Apache tự chạy khi reboot
systemctl start httpd
systemctl enable httpd

# Tạo file HTML trực quan
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>EC2 Test Page</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; background-color: #f4f4f4; }
        .container { border: 2px solid #232f3e; display: inline-block; padding: 20px; background: white; border-radius: 10px; }
        h1 { color: #ff9900; }
        p { font-size: 1.2em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Server is UP and Running! 🚀</h1>
        <p>Hello from <b>$(hostname -f)</b></p>
        <p>Project: <b>${project_name}</b></p>
    </div>
</body>
</html>
EOF