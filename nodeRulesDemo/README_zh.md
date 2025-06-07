# node-rules

## 介绍

node-rules 是一个轻量级的正向链接规则引擎。

## 下载安装

1.如果已经安装好 nodejs 之后，输入以下命令。

```
ohpm install node-rules@7.2.0
```
对于OpenHarmony ohpm环境配置的详细信息，请参阅[OpenHarmony环境配置指南](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)。

2.在需要使用的页面导入 node-rules。

```
import RuleEngine from "node-rules"
```

## 使用说明

1.定义规则
规则将有条件及其相应的结果组成。

```
    class Rule {
      condition(R: ESObject) {
        R.when((this as ESObject).transactionTotal < 500);
      }

      consequence(R: ESObject) {
        (this as ESObject).result = false;
        (this as ESObject).reason = "The transaction was blocked as it was less than 500";
        R.stop();
      }
    }


    let rule = new Rule()
```

这里的优先级是一个可选参数，当有多个规则运行时，它将用于指定一个规则相对于其他规则的优先级。在上面的规则中，R.when 计算条件表达式并
R.stop 用于停止对事实的进一步处理，因为我们已经得到了一个结果。

函数 <span style="color:#ff6700">R.stop</span> <span style="color:#ff6700">R.when</span> <span style="color:#ff6700">
R.next</span> <span style="color:#ff6700">R.restart</span> 是流量控制 API 的一部分，允许用户控制引擎流量。

2.定义一个事实
事实是规则引擎应用其规则以获得结果的那些输入 json 值。根据您的决定，一个事实可以具有多个属性。

```
    let fact: ESObject = {
      name: "user4",
      application: "MOB2",
      transactionTotal: Number.parseInt(this.setValue),
      cardType: "Credit Card"
    }
```

3.使用规则引擎
下面的示例显示了如何使用规则引擎将示例规则应用于特定事实。规则可以作为规则数组或单个规则对象输入到规则引擎当中。

```
   let ruleEngine = new RuleEngine();

    class Rule {
      condition(ruleEngine: ESObject) {
        ruleEngine.when((this as ESObject).transactionTotal < 500);
      }

      consequence(ruleEngine: ESObject) {
        (this as ESObject).result = false;
        (this as ESObject).reason = "The transaction was blocked as it was less than 500";
        ruleEngine.stop();
      }
    }


    let rule = new Rule()


    ruleEngine.register(rule);


    let fact: ESObject = {
      name: "user4",
      application: "MOB2",
      transactionTotal: Number.parseInt(this.setValue),
      cardType: "Credit Card"
    }

    console.log("------" + this.setValue);

    ruleEngine.execute(fact, (data: ESObject) => {
      if (data.result) {
        console.log("Valid transaction:" + data.result); //满足规则
        this.resultStr = "Valid transaction:" + data.result;
      } else {
        console.log("Blocked Reason:" + data["reason"]); //不满足规则
        this.resultStr = "Blocked Reason:" + data["reason"];
      }

    })
```

4.控制在规则引擎上运行的规则
如果您正在寻找方法来指定将规则应用于事实的顺序，则可以通过使用 priority 参数来完成。

```
"priority": 4
```

## 接口说明
### Flow Control API

#### R.register

注册规则。

#### R.When

此函数用于传递我们要评估的条件表达式。在上面的表达式中，我们通过表达式来检查上下文中事实的 transactionTotal 属性是否低于
500.如果传递给的表达式 R.when 计算结果为真，则条件将执行。否则，规则引擎将移至下一条规则，或者如果没有规则可应用，则可能终止。

#### R.stop

该函数在结果函数中使用，以指示规则引擎停止处理事实。如果调用此函数，及时留下要应用的规则，规则引擎也不会对事实应用其余规则。它主要用于当我们对特定事实得出结论并且不需要对其进行任何进一步处理来生成结果时。

如上例所示，当事务小于 500 时，我们不在需要处理规则。因此将 false 存储在 result 属性中并在结果内立即调用 stop。

#### R.next

该函数在后果函数中使用。者用于指示规则引擎开始对事实应用下一个规则（如果有）。

#### R.restart

该函数用于结果函数内部，以指示规则引擎从头开始对事实应用规则。当事实对象被结果函数修改并且需要再次遍历所有的规则时，规则引擎也会在内部使用此函数。在初始化新规则引擎时使用该
ignoreFactChanges:true 选项将关闭此功能。

#### R.execute

执行并验证事实。

### Dynamic control

#### RuleEngine.turn(<state>,<filter>)
此函数用于动态激活或停用规则。此函数的语法如下例所示。
```
RuleEngine.turn("OFF", {
"id": "one"
});
```
这RuleEngine是规则引擎实例。传递给 turn 函数的第一个参数指示我们是否需要启用或禁用该规则。传递给该函数的第二个参数是一个过滤器。它应该是一个键，用于唯一地区分目标规则或规则集与规则引擎中运行的其他规则。此处，上述示例将停用所有id属性值为“one”的规则。

#### RuleEngine.prioritize(<priority>,<filter>)
此函数用于在规则引擎运行时动态更改规则的优先级。它的工作原理类似于 Turn 函数，不同之处在于，我们将传递一个优先级数值给该函数，而不是 ON/OFF 状态。请参阅下面的示例。
```
RuleEngine.prioritize(10, {
"id": "one"
});
上述prioritize调用将使 ID 为“one”的规则优先于所有优先级低于 10 的规则。
```

#### RuleEngine.register(<rules>)
我们知道，我们可以在创建规则引擎对象时将规则作为参数传递到规则引擎构造函数中，如下所示。
```
var RuleEngine = new RuleEngine(rules);
```
其中rules，可以是规则对象数组，也可以是单个数组。但是，如果我们稍后需要向规则引擎添加一些规则，该怎么办呢？可以随时使用 Register 将新规则添加到规则引擎中。它的用法如下：
```
var RuleEngine = new RuleEngine();
RuleEngine.register(newrule);
RuleEngine.register(newrule);
```

#### RuleEngine.findRules(<filter>)
此函数用于检索规则引擎上注册的规则，这些规则与我们传递的过滤器匹配。示例用法如下。
```
var rules = RuleEngine.findRules({"id": "one"});
```

#### RuleEngine.init()
此函数用于删除规则引擎上注册的所有规则。它主要用于内部函数的规则清理。示例用法如下。
```
var RuleEngine = new RuleEngine();
RuleEngine.register(badrule);
RuleEngine.init();//removes the bad rule and cleans up
RuleEngine.register(newrule);
```

## 接口说明
| 方法名                   | 参数内容                          | 接口描述                              |
|-------------------------|-------------------------------|-----------------------------------|
| RuleEngine.register()   | rules: Array<Rule> : Rule     | 注册规则                              |
| RuleEngine.When()       | outcome: boolean              | 此函数用于传递我们要评估的条件表达式                |
| RuleEngine.stop()       |                               | 该函数在结果函数中使用                       |
| RuleEngine.next()       |                               | 该函数在后果函数中使用                       |
| RuleEngine.restart()    |                               | 该函数用于结果函数内部，以指示规则引擎从头开始对事实应用规则    |
| RuleEngine.execute()    | fact:Object, callback:Function| 执行并验证事实                           |
| RuleEngine.init()       |                               | 此函数用于删除规则引擎上注册的所有规则               |
| RuleEngine.sync()       | fact:Object, callback:Function| 同步                                |
| RuleEngine.nextTick()   | callback:Function             | 下一个事件循环                           |
| RuleEngine.findRules()  | filter:Object                 | 此函数用于检索规则引擎上注册的规则，这些规则与我们传递的过滤器匹配 |
| RuleEngine.turn()       | state:string, filter:Object   | 此函数用于动态激活或停用规则                    |
| RuleEngine.prioritize() | priority:number, filter:Object| 在规则引擎运行时动态更改规则的优先级                |

## 约束与限制

在下述版本验证通过：适配DevEco Studio:4.1 Canary(4.1.3.317)，OpenHarmony SDK:API version 11 (4.1.0.36).

## 贡献代码

使用过程中发现任何问题都可以提交 [Issue](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们提交 [PR](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目遵循 [Apache License 2.0](https://gitcode.com/openharmony-tpc/openharmony_tpc_samples/blob/master/nodeRulesDemo/LICENSE)
