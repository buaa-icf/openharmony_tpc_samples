# js-tokens

### 介绍

js-tokens 是一个微型JavaScript的分词器。小巧的、正则表达式驱动的、宽松的、几乎符合规范的 JavaScript 标记器

### 下载安装

1.如果已安装好nodejs后，输入以下命令
```
ohpm install js-tokens
```

2.在需要使用的页面导入js-tokens

```
import jsTokens from 'js-tokens'
```

### 使用说明

1. 简单使用

按照已约定的规则进行分词，分完词后会给出类型和值，Key-Value形式存在

```
const jsString = '(1，23@45%6789)'
var tokenStr = Array.from(jsTokens(jsString));

```

还可以给字符串添加分歌词或分割线

```
const jsString = '(1，23@45%6789)'
var tokenStr = Array.from(jsTokens(jsString),(token) => token.value).join("|");
结果:(|1|， |23|@|45|%6789|)
```

2.介绍分词类型规则

##### 字符串字面量

规范：StringLiteral

例子：

```
"string"
'string'
""
''
"\"
'\''
"valid: \u00a0, invalid: \u"
'valid: \u00a0, invalid: \u'
"multi-\
line"
'multi-\
line'
" unclosed
' unclosed
```

##### NoSubstitutionTemplate / TemplateHead / TemplateMiddle / TemplateTail

规范: NoSubstitutionTemplate / TemplateHead / TemplateMiddle / TemplateTail

没有插值的模板按原样匹配。例如：

`abc`：  无替代模板

`abc: NoSubstitutionTemplate withclosed: false

带有插值的模板匹配尽可能的标记。例如，`head${1}middle${2}tail`匹配如下（除了两个 NumericLiterals）：

`head${: 模板头 }middle${: 模板中间 }tail`:模板尾

TemplateMiddle 是可选的，TemplateTail 可以不关闭。例如，`head${1}tail (注意缺少的结尾)`:

`head${:模板头 }tail: TemplateTail 与closed: false 模板可以包含未转义的换行符，因此未闭合的模板继续到输末尾。

就像 StringLiteral 一样，模板也可以包含无效的转义。`\u` 匹配为NoSubstitutionTemplate 即使它包含无效的转义。另请注意，在标记模板中，无效模板中，无效转义不是语法错误:x`\u`是语法上有效的
JavaScript。

##### 正则表达式

规范：RegularExpressionLiteral

例子：

```
/a/
/a/gimsuy
/a/Inva1id
/+/
/[/]\//
```

##### 多行注释

规范：MultiLineComment

例子：

```
/* comment */
/* console.log(
    "commented", out + code);
    */
/**/
/* unclosed
```

##### 单行注释

规范：SingleLineComment
例子：
```
// comment
// console.log("commented", out + code);
//
```

##### 标识符名称

规范:IdentifierName

例子：

```
if
for
var
instanceof
package
null
true
false
Infinity
undefined
NaN
$variab1e_name
π
℮
ಠ_ಠ
\u006C\u006F\u006C\u0077\u0061\u0074
```

##### 私有标识符

规范：PrivateIdentifier

Examples:

```
#if
#for
#var
#instanceof
#package
#null
#true
#false
#Infinity
#undefined
#NaN
#$variab1e_name
#π
#℮
#ಠ_ಠ
#\u006C\u006F\u006C\u0077\u0061\u0074
```

##### 
规范：NumericLiteral

例子：
```
0
1.5
1
1_000
12e9
0.123e-32
0xDead_beef
0b110
12n
07
09.5
```

##### 标点符号

规范：Punctuator + DivPunctuator + RightBracePunctuator

例子：
```
&&  ||  ??
--  ++
.   ?.
<   <=   >   >=
!=  !==  ==  ===
   +   -   %   &   |   ^   /   *   **   <<   >>   >>>
=  +=  -=  %=  &=  |=  ^=  /=  *=  **=  <<=  >>=  >>>=
(  )  [  ]  {  }
!  ?  :  ;  ,  ~  ...  =>
```

##### 空格

规范: WhiteSpace

例子： 空格
```

```

##### Invalid

规范: Invalid

例子：
```
#
@
💩
```

##### LineTerminatorSequence

规范：LineTerminatorSequence

CR, LF 和 CRLF, 加上 \u2028 和 \u2029.

### 接口说明

1，jsTokens(jsString);

将需要字符串或标识符等传入

### 约束与限制
在下述版本验证通过：

[DevEco Studio](https://developer.harmonyos.com/cn/develop/deveco-studio#download) :3.1 Beta1(3.1.0.200)，SDK:API9 Beta5(3.2.10.6)

### 软件架构

```
|-ets
|   |-Application
|           |-AbilityStage.ts
|   |-MainAbility
|           |-MainAbility.ts
|   |-pages
|           |-index.ets            #主页demo
```

### 版本

当前版本

```
1.0.0
```

版本日志请查看[CHANGELOG.md](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-tokens/CHANGELOG.md)

### 贡献代码

使用过程中发现任何问题都可以提[Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发[PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls)

### 开源协议

本项目基于[MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/js-tokens/LICENSE),请自由的享受和参与开源