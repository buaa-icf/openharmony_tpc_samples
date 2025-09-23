// 流数据模型
public class StreamDataModel
{
    public int Id { get; set; }
    public string Message { get; set; } = string.Empty;
    public DateTime Timestamp { get; set; }
    public double Value { get; set; }
}