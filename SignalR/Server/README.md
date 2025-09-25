# SignalR 服务器部署说明

## 需要复制的文件

将以下文件复制到服务器：
- `Program.cs`
- `ChatHub.cs`
- `StreamDataModel.cs`
- `signalr-server.csproj`
- `appsettings.json`
- `appsettings.Development.json`
- `Properties/launchSettings.json`

## 环境要求

安装 .NET 8.0 运行时：
```bash
# Ubuntu/Debian
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-runtime-8.0

# CentOS/RHEL
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
sudo yum install dotnet-runtime-8.0

# Windows
# 下载安装：https://dotnet.microsoft.com/download/dotnet/8.0
```

## 运行命令

```bash
# 进入项目目录
cd signalr-server

# 运行服务
dotnet run

# 或指定端口运行
dotnet run --urls="http://0.0.0.0:5000"
```

## 访问地址

- 服务地址：http://服务器IP:5000
- SignalR连接：http://服务器IP:5000/chatHub

## 后台运行

```bash
# 使用 nohup 后台运行
nohup dotnet run --urls="http://0.0.0.0:5000" > server.log 2>&1 &

# 或使用 systemd 服务
sudo nano /etc/systemd/system/signalr.service
```

systemd 服务配置：
```ini
[Unit]
Description=SignalR Server
After=network.target

[Service]
Type=notify
ExecStart=/usr/bin/dotnet run --urls="http://0.0.0.0:5000"
WorkingDirectory=/path/to/signalr-server
Restart=always
RestartSec=10
User=www-data

[Install]
WantedBy=multi-user.target
```

启动服务：
```bash
sudo systemctl enable signalr
sudo systemctl start signalr
sudo systemctl status signalr
```