# jbox2d

## 简介

> 用于游戏开发，使物体的运动更加真实，让游戏场景看起来更具交互性，比如愤怒的小鸟

## 效果展示
<img src="screenshot/效果展示.gif"/>

## 下载安装

```shell
npm install @flyover/box2d --save
```

OpenHarmony
npm环境配置等更多内容，请参考 [如何安装OpenHarmony npm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_npm_usage.md) 。

## 使用说明

### 注意事项

> 1、依赖原库后，须在/entry/node_modules/@flyover/box2d/Build/Box2D/box2d.umd.js中修改 return `rgba(${r},${g},${b},${a})`为return `rgba(${Math.round(r)},${Math.round(g)},${Math.round(b)},${a})`,
修改 return `rgb(${r},${g},${b})`为return `rgb(${Math.round(r)},${Math.round(g)},${Math.round(b)})`以适配openharmony工程颜色渲染问题

> 2、/entry/node_modules/@flyover/box2d/Build/Box2D/box2d.umd.js中删除Pop()方法中if (element === null) { throw new Error(); }代码，解决部分效果崩溃问题

> 3、最新新版修复了问题2中问题,但原库作者没有在npm上发布最新版本,npm install的版本为1.0.1对应原库版本2.3.2。针对问题1在openharmony上颜色渲染问题及新版本npm发布问题，已提交Issues给作者。经过测试新版在openharmony上可以正常使用

### jbox2d使用

   ```
   import * as box2d from '@flyover/box2d'
   ...
   
  aboutToAppear() {
    selectArr = [];
    
    for (let i: number = 0; i < g_testEntries.length; ++i) {
      let o = {};
      o['value'] = g_testEntries[i].name;
      selectArr[i] = o;//初始化数据
    }
        //循环调用渲染
        this.init();
    }
    private init() {
        setTimeout(inits, timeStep);
    }
    const inits = function (time) {
      setTimeout(loop, timeStep);
    }
    
    const loop = function (time) {
      setTimeout(loop, timeStep);
      app.SimulationLoop(time);
    }

   ...
       //动画切换
       Select(selectArr)
              .selected(this.index)
              .value(selectArr[this.index].value)
              .font({ size: 20, weight: 200, family: 'serif', style: FontStyle.Normal })
              .selectedOptionFont({ size: 30, weight: 300, family: 'serif', style: FontStyle.Normal })
              .optionFont({ size: 20, weight: 200, family: 'serif', style: FontStyle.Normal })
              .onSelect((index: number) => {
                this.index = index;
                if (app) {
                  app.m_test_index = index;
                  //加载动画
                  app.LoadTest();
                }
              })
   ```

## 接口说明

## 约束与限制

在下述版本验证通过：

DevEco Studio 版本：3.1 Beta1(3.1.0.200)，SDK:API9 Beta5(3.2.10.6)

## 目录结构
````
|---- box2d
|     |---- entry  # 示例代码文件夹
|	    |----src
          |----main
              |----ets
                  |----pages
                      |----Index.ets #效果主页面
                  |----Testbed
                      |----Framework 
                           |----DebugDraw.ets #效果绘制具体实现
                           |----FullscreenUI.ts #全局页面初始化，是否启用粒子参数
                           |----Main.ets #效果绘制入口
                           |----ParticleEmitter.ts #粒子发射器
                           |----ParticleParameter.ts #粒子参数
                           |----Test.ets #canvas相关初始化设置
                      |----Tests #所有效果具体实现
                      |----Testbed.ts #对外接口
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/issues)
给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/pulls) 。

## 开源协议

本项目基于 [MIT License](https://gitee.com/openharmony-tpc/openharmony_tpc_samples/blob/master/LICENSE) ，请自由地享受和参与开源。

