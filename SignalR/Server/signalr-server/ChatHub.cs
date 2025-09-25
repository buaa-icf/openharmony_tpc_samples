using Microsoft.AspNetCore.SignalR;
using System.Collections.Concurrent;
using System.Runtime.CompilerServices;

public class ChatHub : Hub
{
    // 存储连接ID与用户名的映射
    private static readonly ConcurrentDictionary<string, string> ConnectedUsers = new();
    // 用户连接时调用
    public async Task UserConnected(string userName)
    {
        // 存储用户连接信息
        ConnectedUsers[Context.ConnectionId] = userName;
        
        await Groups.AddToGroupAsync(Context.ConnectionId, "ChatRoom");

        // 🔍 添加调试日志
        Console.WriteLine($"准备广播 UserJoined 事件给其他用户，用户名: {userName}");

        // 🧪 临时测试：同时向所有客户端（包括自己）发送
        await Clients.All.SendAsync("UserJoined", userName);
        Console.WriteLine($"已向所有客户端发送 UserJoined 事件");

        // 📝 保留原有的 Others 逻辑作为对比
        await Clients.Others.SendAsync("UserJoined", userName + "_Others");
        Console.WriteLine($"已向其他客户端发送 UserJoined_Others 事件");

        Console.WriteLine($"用户 {userName} 已连接，连接ID: {Context.ConnectionId}");
    }

    // 发送消息
    public async Task SendMessage(string user, string message)
    {
        Console.WriteLine($"收到消息 - 用户: {user}, 内容: {message}");
        await Clients.All.SendAsync("ReceiveMessage", user, message);
    }

    // 发送消息给特定组
    public async Task SendMessageToGroup(string groupName, string user, string message)
    {
        await Clients.Group(groupName).SendAsync("ReceiveMessage", user, message);
    }

    // 加入组
    public async Task JoinGroup(string groupName)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
        await Clients.Group(groupName).SendAsync("UserJoinedGroup", Context.User?.Identity?.Name, groupName);
    }

    // 离开组
    public async Task LeaveGroup(string groupName)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupName);
        await Clients.Group(groupName).SendAsync("UserLeftGroup", Context.User?.Identity?.Name, groupName);
    }

    // 流传输方法示例1：发送一系列数字
    public async IAsyncEnumerable<int> StreamData(
        int count,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        for (var i = 0; i < count; i++)
        {
            // 检查取消令牌
            cancellationToken.ThrowIfCancellationRequested();

            yield return i;

            // 模拟异步延迟
            await Task.Delay(1000, cancellationToken);
        }
    }

    // 流传输方法示例2：发送时间戳流
    public async IAsyncEnumerable<string> StreamTimestamps(
        int durationInSeconds,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        var endTime = DateTime.Now.AddSeconds(durationInSeconds);

        while (DateTime.Now < endTime)
        {
            cancellationToken.ThrowIfCancellationRequested();

            yield return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");

            await Task.Delay(500, cancellationToken); // 每500ms发送一次
        }
    }

    // 流传输方法示例3：发送复杂对象流
    public async IAsyncEnumerable<StreamDataModel> StreamComplexData(
        int count,
        [EnumeratorCancellation] CancellationToken cancellationToken)
    {
        var random = new Random();

        for (var i = 0; i < count; i++)
        {
            cancellationToken.ThrowIfCancellationRequested();

            yield return new StreamDataModel
            {
                Id = i,
                Message = $"Stream message {i}",
                Timestamp = DateTime.Now,
                Value = random.NextDouble() * 100
            };

            await Task.Delay(800, cancellationToken);
        }
    }

    // 用户断开连接时调用
    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        // 获取断开连接的用户名
        if (ConnectedUsers.TryRemove(Context.ConnectionId, out string? userName))
        {
            // 向其他客户端广播用户离开消息
            await Clients.Others.SendAsync("UserLeft", userName);
            Console.WriteLine($"已向其他客户端发送 UserLeft 事件，用户名: {userName}");
        }
        
        Console.WriteLine($"用户断开连接，连接ID: {Context.ConnectionId}");
        if (exception != null)
        {
            Console.WriteLine($"断开连接异常: {exception.Message}");
        }
        await base.OnDisconnectedAsync(exception);
    }
}
