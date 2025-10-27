# ISO9797 MAC Demo - 示例工程

这是一个完整的鸿蒙应用示例，展示了 `bc_ohos` library 库中 ISO9797Alg3Mac 的所有功能和接口。

## 功能展示

### 标签页 1: 基本 MAC 计算
- ✅ 使用双长度密钥（16字节）
- ✅ ISO7816-4 填充模式
- ✅ 字符串数据输入
- ✅ 实时计算和结果显示

**默认测试数据：**
```
输入数据: Hello World!
密钥: 7CA110454A1A6E570131D9619DC1376E (32位十六进制)
```

### 标签页 2: 带 IV 的 MAC 计算
- ✅ 支持初始化向量（IV）
- ✅ 十六进制数据输入
- ✅ 完整的 ParametersWithIV 接口演示

**默认测试数据：**
```
输入数据: 84E400800F4F05474D504B49 (十六进制)
密钥: 319CD05D11BB06729BE23DA19B80E6A3
IV: A097994108D06F1B (8字节)
```

### 标签页 3: 运行所有示例
一键运行 7 个完整示例，展示所有功能：

1. **基本 MAC 计算**
   - ISO7816-4 填充
   - 双长度密钥

2. **带 IV 的 MAC**
   - ParametersWithIV 接口
   - 十六进制数据处理

3. **三长度密钥**
   - 24字节密钥
   - K1, K2, K3 独立分解
   - 密钥分解结果展示

4. **自定义 MAC 长度**
   - 4字节 MAC 输出
   - getMacSize() 方法演示
   - getAlgorithmName() 方法演示

5. **零填充模式**
   - ZeroPadding 类使用
   - 与默认填充对比
   - 填充模式差异验证

6. **逐字节更新**
   - updateByte() 方法演示
   - 单字节处理能力

7. **重置和重用**
   - reset() 功能验证
   - MAC 实例重用
   - 多次计算对比

## 界面特性

### 交互功能
- ✅ 可编辑输入框（支持修改测试数据）
- ✅ 实时结果显示
- ✅ Toast 提示信息
- ✅ 错误处理和提示
- ✅ 结果可复制（长按复制）

### UI 设计
- 📱 多标签页设计
- 🎨 清晰的视觉层次
- 📊 结果高亮显示
- 🔄 加载状态指示
- 📋 滚动视图支持

## 代码结构

```typescript
Index.ets
├── 状态管理
│   ├── message (页面标题)
│   ├── selectedTab (当前标签)
│   ├── result (全局结果)
│   ├── isProcessing (处理状态)
│   └── exampleX... (各示例数据)
│
├── UI 构建器
│   ├── example1View() - 基本 MAC
│   ├── example2View() - 带 IV
│   └── allExamplesView() - 运行所有
│
├── 执行方法
│   ├── runExample1() - 示例1执行
│   ├── runExample2() - 示例2执行
│   └── runAllExamples() - 全部执行
│
└── 工具方法
    ├── hexToBytes() - 十六进制转字节
    └── bytesToHex() - 字节转十六进制
```

## 使用的库接口

### 核心类
```typescript
import { 
  ISO9797Alg3Mac,      // 主MAC类
  KeyParameter,         // 密钥参数
  ParametersWithIV,     // 带IV参数
  ISO7816d4Padding,     // ISO7816-4填充
  ZeroPadding           // 零填充
} from 'library'
```

### API 调用示例

#### 基本用法
```typescript
const mac = new ISO9797Alg3Mac(new ISO7816d4Padding())
mac.init({ key: keyBytes })
mac.update(data, 0, data.length)
const output = new Uint8Array(8)
mac.doFinal(output, 0)
```

#### 带 IV
```typescript
const params: ParametersWithIV = {
  parameters: { key: keyBytes },
  iv: ivBytes
}
mac.init(params)
```

#### 自定义 MAC 长度
```typescript
const mac = new ISO9797Alg3Mac(32, new ISO7816d4Padding()) // 4字节
```

#### 零填充
```typescript
const mac = new ISO9797Alg3Mac(new ZeroPadding())
// 或
const mac = new ISO9797Alg3Mac() // 默认零填充
```

## 运行方式

### 使用 DevEco Studio

1. 打开项目根目录 `bc_ohos`
2. 等待依赖同步完成
3. 连接鸿蒙设备或启动模拟器
4. 点击 Run 按钮

### 使用命令行

```bash
cd bc_ohos
hvigorw assembleHap
```

## 测试建议

### 基础功能测试
1. 切换到"基本 MAC"标签
2. 点击"计算 MAC"按钮
3. 验证 MAC 结果是否正确显示

### IV 功能测试
1. 切换到"带 IV"标签
2. 修改 IV 值
3. 验证不同 IV 产生不同的 MAC

### 完整功能测试
1. 切换到"运行所有"标签
2. 点击"运行所有示例"按钮
3. 查看所有 7 个示例的执行结果

### 错误处理测试
1. 输入无效的密钥（长度错误）
2. 输入无效的十六进制字符
3. 验证错误提示是否正确显示

## 预期输出

### 示例 1（基本 MAC）
```
输入: Hello World!
密钥: 7CA110454A1A6E570131D9619DC1376E
MAC: [16位十六进制字符]
```

### 示例 2（带 IV）
```
输入: 84E400800F4F05474D504B49
IV: A097994108D06F1B
MAC: [16位十六进制字符]
```

### 所有示例执行结果
```
=== ISO9797 完整功能演示 ===

[示例1] 基本 MAC
MAC: XXXXXXXXXXXXXXXX

[示例2] 带IV
MAC: XXXXXXXXXXXXXXXX

[示例3] 三长度密钥
K1: XXXXXXXXXXXXXXXX
K2: XXXXXXXXXXXXXXXX
K3: XXXXXXXXXXXXXXXX
MAC: XXXXXXXXXXXXXXXX

[示例4] 4字节MAC
MAC: XXXXXXXX (4字节)

[示例5] 零填充
零填充1: XXXXXXXXXXXXXXXX
零填充2: XXXXXXXXXXXXXXXX
结果一致: true

[示例6] 逐字节更新
MAC: XXXXXXXXXXXXXXXX

[示例7] 重置和重用
MAC1: XXXXXXXXXXXXXXXX
MAC2: XXXXXXXXXXXXXXXX

=== 所有示例执行完成 ===
```

## 技术要点

### 1. 类型安全
- ✅ 所有变量使用显式类型
- ✅ 避免使用 any 类型
- ✅ 使用 ESObject 代替未知类型

### 2. 错误处理
- ✅ try-catch 包裹所有 MAC 计算
- ✅ Toast 提示用户错误信息
- ✅ 详细的错误消息

### 3. 性能优化
- ✅ 使用 setTimeout 避免 UI 阻塞
- ✅ 异步处理大量计算
- ✅ 加载状态指示

### 4. 用户体验
- ✅ 清晰的标签分类
- ✅ 即时反馈
- ✅ 可编辑的测试数据
- ✅ 结果可复制

## 常见问题

### Q1: 如何修改测试数据？
**A:** 直接在输入框中编辑即可，修改后点击计算按钮。

### Q2: MAC 结果如何复制？
**A:** 长按 MAC 结果区域即可复制（支持 InApp 复制）。

### Q3: 为什么"运行所有"需要一点时间？
**A:** 为了避免 UI 阻塞，使用了 setTimeout 异步执行，确保界面流畅。

### Q4: 如何验证结果正确性？
**A:** 可以与 Android 版本的结果对比，相同输入应产生相同的 MAC 值。

## 扩展建议

### 添加更多功能
1. 保存历史计算记录
2. 导入/导出测试数据
3. 批量测试功能
4. 性能测试统计

### UI 增强
1. 深色模式支持
2. 自定义主题
3. 动画效果
4. 更多可视化图表

## 参考资料

- [ISO 9797-1 标准](https://www.iso.org/standard/50375.html)
- [ANSI X9.19 Retail MAC](https://www.ansi.org/)
- [鸿蒙开发文档](https://developer.harmonyos.com/)
- [library README](../library/README.md)
- [API 对照文档](../library/API_MAPPING.md)

## 许可证

MIT License
