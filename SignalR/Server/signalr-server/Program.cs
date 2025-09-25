using Microsoft.AspNetCore.SignalR;

var builder = WebApplication.CreateBuilder(args);

// 添加SignalR服务，配置优化的心跳设置
builder.Services.AddSignalR(options =>
{
    options.KeepAliveInterval = TimeSpan.FromSeconds(10); // 从15秒改为10秒
    options.ClientTimeoutInterval = TimeSpan.FromSeconds(25); // 相应调整客户端超时
});

// 添加CORS支持
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

// 使用CORS
app.UseCors("AllowAll");

// 映射SignalR Hub
app.MapHub<ChatHub>("/chatHub");

// 添加健康检查端点
app.MapGet("/", () => "SignalR Server is running!");

app.Run();
