/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  Yoga,
  YogaNode,
  YogaDirection,
  YogaEdge,
  YogaFlexDirection,
  YogaJustify,
  YogaGutter,
  YogaConstants,
  YogaAlign,
  YogaPositionType,
  YogaWrap,
  YogaOverflow,
  YogaDisplay,
  YogaBoxSizing,
  YogaMeasureMode,
  YogaMeasureOutput,
  YogaErrata,
  YogaExperimentalFeature
} from '@ohos/yoga';
import { systemDateTime } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State logOutput: string = '';
  @State showLogs: boolean = false;
  
  private logAndDisplay(...args: (string | number | Object)[]): void {
    // 将参数转换为字符串
    const messages: string[] = [];
    args.forEach(arg => {
      if (typeof arg === 'object' && arg !== null) {
        try {
          messages.push(JSON.stringify(arg));
        } catch {
          messages.push(String(arg));
        }
      } else {
        messages.push(String(arg));
      }
    });
    
    // 添加到页面显示
    const logMessage = messages.join(' ');
    console.log(logMessage);
    this.logOutput = this.logOutput + logMessage + '\n';
  }

  /**
   * 获取基线函数 - 返回高度的一半作为基线
   */
  getBaselineFunc() {
    return (node: YogaNode, width: number, height: number) => {
      return height / 2;
    };
  }

  aboutToAppear() {
    this.logOutput = '';
    this.showLogs = false;
    
    setTimeout(() => {
      this.runAllTests();
      this.showLogs = true;
    }, 100);
  }
  
  private runAllTests(): void {
    this.testYogaBasic();
    this.testYogaAlignment();
    this.testYogaPositionAndFlex();
    this.testYogaPercentageAndAutoValues();
    this.testYogaComplexLayout();
    this.testYogaCopyAndClone();
    this.testYogaMeasureSimple();
    this.testMeasureWithConstraints();
    this.testSimpleBaselineFunction();
    this.testAlignBaselineParentUsingChildInColumnAsReference();
    this.testAlignBaselineWithExtendedFeatures();
    this.testUseWebDefaultsAndTestPointScaleFactor();
    this.testErrataFunctionality();
    this.testInterfacePerformance();
  }

  /**
   * 测试基本功能
   */
  testYogaBasic(): void {
    this.logAndDisplay("==== testYogaBasic ====");
    const root = Yoga.createNode();
    root.setWidth(500);
    root.setHeight(300);
    // 创建子节点
    const child1 = Yoga.createNode();
    child1.setWidth(100);
    child1.setHeight(200);
    child1.setMargin(YogaEdge.ALL, 10);
    const child2 = Yoga.createNode();
    child2.setFlex(1);
    child2.setMinWidth(50);
    child2.setMaxWidth(200);
    child2.setPadding(YogaEdge.VERTICAL, 20);
    // 创建克隆节点
    const child1Clone = child1.clone();
    child1Clone.setWidth(150);
    // 构建节点树
    root.insertChild(child1, 0);
    root.insertChild(child2, 1);
    root.insertChild(child1Clone, 2);
    // 设置布局属性
    root.setDirection(YogaDirection.LTR);
    root.setFlexDirection(YogaFlexDirection.ROW);
    root.setJustifyContent(YogaJustify.CENTER);
    root.setFlex(1);
    root.setGap(YogaGutter.COLUMN, 10);
    // 验证布局属性获取
    this.logAndDisplay("root.direction: ", root.getStyleDirection());
    this.logAndDisplay("root.flexDirection: ", root.getFlexDirection());
    this.logAndDisplay("root.justifyContent: ", root.getJustifyContent());
    this.logAndDisplay("root.flex: ", root.getFlex());
    this.logAndDisplay("root.gap:", root.getGap(YogaGutter.COLUMN).toString());
    // 测试样式复制
    const styleCopyNode = Yoga.createNode();
    styleCopyNode.copyStyle(root);
    this.logAndDisplay("root.Width: ", root.getWidth().toString());
    this.logAndDisplay("styleCopyNode.Width: ", styleCopyNode.getWidth().toString(), "== root.Width");
    // 设置边缘属性
    child1.setPosition(YogaEdge.LEFT, 5);
    child1.setMargin(YogaEdge.TOP, 10);
    this.logAndDisplay("child1.Position: ", child1.getPosition(YogaEdge.LEFT).toString());
    this.logAndDisplay("child1.Margin: ", child1.getMargin(YogaEdge.TOP).toString());
    // 计算并验证布局
    root.calculateLayout(500, 300);
    this.logAndDisplay("Layout-Root - X: ", root.getLayoutX(), " Y: ", root.getLayoutY(),
      " Width: ", root.getLayoutWidth(), " Height:", root.getLayoutHeight());
    this.logAndDisplay("Layout-Child1 - X: ", child1.getLayoutX(), " Y: ", child1.getLayoutY(),
      " Width: ", child1.getLayoutWidth(), " Height: ", child1.getLayoutHeight());
  }

  /**
   * 测试对齐相关功能
   */
  testYogaAlignment(): void {
    this.logAndDisplay("==== testYogaAlignment ====");
    
    const root = Yoga.createNode();
    root.setAlignContent(YogaAlign.CENTER);
    root.setAlignItems(YogaAlign.FLEX_END);
    
    const child = Yoga.createNode();
    child.setAlignSelf(YogaAlign.FLEX_START);
    
    this.logAndDisplay("AlignContent:", root.getAlignContent());
    this.logAndDisplay("AlignItems:", root.getAlignItems());
    this.logAndDisplay("AlignSelf:", child.getAlignSelf());
  }

  /**
   * 测试定位和弹性布局属性
   */
  testYogaPositionAndFlex(): void {
    this.logAndDisplay("==== testYogaPositionAndFlex ====");
    
    const root = Yoga.createNode();
    root.setFlexWrap(YogaWrap.WRAP);
    root.setOverflow(YogaOverflow.HIDDEN);
    root.setBoxSizing(YogaBoxSizing.BORDER_BOX);
    
    const child = Yoga.createNode();
    child.setPositionType(YogaPositionType.ABSOLUTE);
    child.setFlexGrow(2);
    child.setFlexShrink(0.5);
    child.setFlexBasis(100);
    child.setDisplay(YogaDisplay.NONE);
    
    this.logAndDisplay("PositionType:", child.getPositionType());
    this.logAndDisplay("FlexGrow:", child.getFlexGrow());
    this.logAndDisplay("FlexShrink:", child.getFlexShrink());
    this.logAndDisplay("FlexBasis:", child.getFlexBasis().toString());
    this.logAndDisplay("FlexWrap:", root.getFlexWrap());
    this.logAndDisplay("Overflow:", root.getOverflow());
    this.logAndDisplay("Display:", child.getDisplay());
    this.logAndDisplay("BoxSizing:", root.getBoxSizing());
  }

  /**
   * 测试百分比和自动值功能
   */
  testYogaPercentageAndAutoValues(): void {
    this.logAndDisplay("==== testYogaPercentageAndAutoValues ====");
    
    const child1 = Yoga.createNode();
    child1.setWidthPercent(50);
    child1.setHeightPercent(30);
    child1.setMarginPercent(YogaEdge.LEFT, 5);
    child1.setPaddingPercent(YogaEdge.HORIZONTAL, 3);
    
    const child2 = Yoga.createNode();
    child2.setMinWidthPercent(20);
    child2.setMaxHeightPercent(80);
    
    const child3 = Yoga.createNode();
    child3.setWidthAuto();
    child3.setHeightAuto();
    child3.setFlexBasisAuto();
    child3.setPositionPercent(YogaEdge.LEFT, 10);
    child3.setPositionAuto(YogaEdge.TOP);
    child3.setMarginAuto(YogaEdge.RIGHT);
    
    // 验证百分比值
    this.logAndDisplay("WidthPercent:", child1.getWidth().toString());
    this.logAndDisplay("HeightPercent:", child1.getHeight().toString());
    this.logAndDisplay("MarginPercent:", child1.getMargin(YogaEdge.LEFT).toString());
    this.logAndDisplay("PaddingPercent:", child1.getPadding(YogaEdge.HORIZONTAL).toString());
    
    // 验证自动值
    this.logAndDisplay("WidthAuto:", child3.getWidth().toString());
    this.logAndDisplay("HeightAuto:", child3.getHeight().toString());
    this.logAndDisplay("PositionAuto:", child3.getPosition(YogaEdge.TOP).toString());
    this.logAndDisplay("MarginAuto:", child3.getMargin(YogaEdge.RIGHT).toString());
  }

  /**
   * 测试复杂布局交互场景
   */
  testYogaComplexLayout(): void {
    this.logAndDisplay("==== testYogaComplexLayout ====");
    const root = Yoga.createNode();
    root.setWidth(500);
    root.setHeight(300);
    root.setFlexDirection(YogaFlexDirection.COLUMN);
    root.setJustifyContent(YogaJustify.FLEX_START);
    root.setAlignItems(YogaAlign.CENTER);
    root.setGapPercent(YogaGutter.ROW, 2);
    
    const child1 = Yoga.createNode();
    child1.setPositionType(YogaPositionType.RELATIVE);
    child1.setFlexGrow(1);
    child1.setWidthPercent(80);
    child1.setHeight(50);
    child1.setMargin(YogaEdge.ALL, 10);
    
    const child2 = Yoga.createNode();
    child2.setFlexShrink(1);
    child2.setMinWidthPercent(50);
    child2.setMaxHeight(100);
    
    const child3 = Yoga.createNode();
    child3.setPositionType(YogaPositionType.ABSOLUTE);
    child3.setPosition(YogaEdge.RIGHT, 0);
    child3.setPosition(YogaEdge.BOTTOM, 0);
    child3.setWidth(50);
    child3.setHeight(50);
    
    const child4 = Yoga.createNode();
    child4.setDisplay(YogaDisplay.FLEX);
    child4.setFlex(1);
    child4.setWidthAuto();
    // 构建节点树
    root.insertChild(child1, 0);
    root.insertChild(child2, 1);
    root.insertChild(child3, 2);
    root.insertChild(child4, 3);
    // 计算布局
    root.calculateLayout(500, 300);
    this.logAndDisplay("Root布局 - X:", root.getLayoutX(), "Y:", root.getLayoutY(),
      "Width:", root.getLayoutWidth(), "Height:", root.getLayoutHeight());
    this.logAndDisplay("Child1布局 - X:", child1.getLayoutX(), "Y:", child1.getLayoutY());
    this.logAndDisplay("Child3布局(绝对定位) - X:", child3.getLayoutX(), "Y:", child3.getLayoutY());
  }

  /**
   * 测试样式复制和克隆功能
   */
  testYogaCopyAndClone(): void {
    this.logAndDisplay("==== testYogaCopyAndClone ====");
    const originalNode = Yoga.createNode();
    originalNode.setPositionType(YogaPositionType.ABSOLUTE);
    originalNode.setWidthPercent(50);
    originalNode.setHeight(100);
    // 测试样式复制
    const copiedNode = Yoga.createNode();
    copiedNode.copyStyle(originalNode);
    this.logAndDisplay("复制节点PositionType:", copiedNode.getPositionType());
    this.logAndDisplay("复制节点WidthPercent:", copiedNode.getWidth().toString());
    this.logAndDisplay("复制节点Height:", copiedNode.getHeight().toString());
    // 测试克隆功能
    const clonedNode = originalNode.clone();
    this.logAndDisplay("克隆节点PositionType:", clonedNode.getPositionType());
    this.logAndDisplay("克隆节点WidthPercent:", clonedNode.getWidth().toString());
    this.logAndDisplay("克隆节点Height:", clonedNode.getHeight().toString());
  }

  /**
   * 测试测量功能 - 验证Yoga节点的测量函数是否能正确处理整数和浮点数尺寸
   */
  testYogaMeasureSimple(): void {
    this.logAndDisplay("==== testYogaMeasureSimple ====");
    const node = Yoga.createNode();
    node.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode, height: number, heightMode: YogaMeasureMode) => {
      return YogaMeasureOutput.make(100, 100);
    });
    node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
    this.logAndDisplay("整数测量结果 - 宽度: ", node.getLayoutWidth(), "高度: ", node.getLayoutHeight());

    const node1 = Yoga.createNode();
    node1.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode, height: number, heightMode: YogaMeasureMode) => {
      return YogaMeasureOutput.make(100.5, 100.5);
    });
    node1.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
    this.logAndDisplay("浮点数测量结果 - 宽度: ", node1.getLayoutWidth(), "高度: ", node1.getLayoutHeight());
  }

  /**
   * 测试不同约束条件下的测量
   */
  testMeasureWithConstraints(): void {
    this.logAndDisplay("==== testMeasureWithConstraints ====");
    const node = Yoga.createNode();
    node.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode, height: number, heightMode: YogaMeasureMode) => {
      let measuredWidth = 100;
      let measuredHeight = 50;

      if (widthMode === YogaMeasureMode.EXACTLY) {
        measuredWidth = width;
      } else if (widthMode === YogaMeasureMode.AT_MOST) {
        measuredWidth = Math.min(measuredWidth, width);
      }

      if (heightMode === YogaMeasureMode.EXACTLY) {
        measuredHeight = height;
      } else if (heightMode === YogaMeasureMode.AT_MOST) {
        measuredHeight = Math.min(measuredHeight, height);
      }

      return YogaMeasureOutput.make(measuredWidth, measuredHeight);
    });

    node.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
    this.logAndDisplay("无约束 - 宽度:", node.getLayoutWidth(), "高度: ", node.getLayoutHeight());

    node.calculateLayout(150, YogaConstants.UNDEFINED);
    this.logAndDisplay("固定宽度150 - 宽度:", node.getLayoutWidth(), "高度: ", node.getLayoutHeight());

    node.calculateLayout(YogaConstants.UNDEFINED, 80);
    this.logAndDisplay("固定高度80 - 宽度:", node.getLayoutWidth(), "高度: ", node.getLayoutHeight());

    node.calculateLayout(200, 100);
    this.logAndDisplay("固定200x100 - 宽度:", node.getLayoutWidth(), "高度: ", node.getLayoutHeight());
  }

  /**
   * 简单的基线函数测试
   */
  testSimpleBaselineFunction(): void {
    this.logAndDisplay("==== testSimpleBaselineFunction ====");
    const parent = Yoga.createNode();
    parent.setFlexDirection(YogaFlexDirection.ROW);
    parent.setWidth(300);
    parent.setHeight(200);
    parent.setAlignItems(YogaAlign.BASELINE);

    const child1 = Yoga.createNode();
    child1.setWidth(100);
    child1.setHeight(100);
    parent.insertChild(child1, 0);

    const child2 = Yoga.createNode();
    child2.setWidth(100);
    child2.setHeight(80);
    child2.setBaselineFunction((node: YogaNode, width: number, height: number) => {
      // 基线在距离顶部60px处
      return 40;
    });
    parent.insertChild(child2, 1);
    parent.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
    this.logAndDisplay("child1: x= ", child1.getLayoutX(), ", y= ", child1.getLayoutY());
    this.logAndDisplay("child2: x= ", child2.getLayoutX(), ", y= ", child2.getLayoutY());
  }

  /**
   * 测试基线对齐：父节点使用列布局中的子节点作为参考
   * 验证在复杂嵌套布局中基线对齐功能的正确性
   */
  testAlignBaselineParentUsingChildInColumnAsReference(): void {
    this.logAndDisplay("==== testAlignBaselineParentUsingChildInColumnAsReference ====");
    // 创建根节点 (ROW, 1000x1000)
    const root = Yoga.createNode();
    root.setFlexDirection(YogaFlexDirection.ROW);
    root.setWidth(1000);
    root.setHeight(1000);
    root.setAlignItems(YogaAlign.BASELINE); // 设置基线对齐
    // 创建第一个子节点 (COLUMN, 500x600)
    const rootChild0 = Yoga.createNode();
    rootChild0.setFlexDirection(YogaFlexDirection.COLUMN);
    rootChild0.setWidth(500);
    rootChild0.setHeight(600);
    root.insertChild(rootChild0, 0);
    // 创建第二个子节点 (COLUMN, 500x800)
    const rootChild1 = Yoga.createNode();
    rootChild1.setFlexDirection(YogaFlexDirection.COLUMN);
    rootChild1.setWidth(500);
    rootChild1.setHeight(800);
    root.insertChild(rootChild1, 1);
    // 在第二个子节点中添加子节点0 (500x300)
    const rootChild1Child0 = Yoga.createNode();
    rootChild1Child0.setFlexDirection(YogaFlexDirection.COLUMN);
    rootChild1Child0.setWidth(500);
    rootChild1Child0.setHeight(300);
    rootChild1.insertChild(rootChild1Child0, 0);
    // 在第二个子节点中添加子节点1 (500x400)，并设置基线函数
    const rootChild1Child1 = Yoga.createNode();
    rootChild1Child1.setFlexDirection(YogaFlexDirection.COLUMN);
    rootChild1Child1.setWidth(500);
    rootChild1Child1.setHeight(400);
    rootChild1Child1.setBaselineFunction(this.getBaselineFunc()); // 设置基线函数
    rootChild1.insertChild(rootChild1Child1, 1);
    // 计算布局
    root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
    // 验证布局结果
    this.logAndDisplay("rootChild0: x= ", rootChild0.getLayoutX(), ", y= ", rootChild0.getLayoutY());
    this.logAndDisplay("rootChild1: x= ", rootChild1.getLayoutX(), ", y= ", rootChild1.getLayoutY());
    this.logAndDisplay("rootChild1Child0: x= ", rootChild1Child0.getLayoutX(), ", y= ", rootChild1Child0.getLayoutY());
    this.logAndDisplay("rootChild1Child1: x= ", rootChild1Child1.getLayoutX(), ", y= ", rootChild1Child1.getLayoutY());
  }

  /**
   * 测试基线对齐及相关扩展接口
   */
  testAlignBaselineWithExtendedFeatures(): void {
    this.logAndDisplay("==== testAlignBaselineWithExtendedFeatures ====");
    // 创建根节点 (ROW, 1000x1000)
    const root = Yoga.createNode();
    root.setFlexDirection(YogaFlexDirection.ROW);
    root.setWidth(1000);
    root.setHeight(1000);
    root.setAlignItems(YogaAlign.BASELINE); // 设置基线对齐
    // 创建第一个子节点 (COLUMN, 500x600)
    const rootChild0 = Yoga.createNode();
    rootChild0.setFlexDirection(YogaFlexDirection.COLUMN);
    rootChild0.setWidth(500);
    rootChild0.setHeight(600);
    root.insertChild(rootChild0, 0);
    // 创建第二个子节点 (ROW, 500x800) 并设置基线对齐
    const rootChild1 = Yoga.createNode();
    rootChild1.setFlexDirection(YogaFlexDirection.ROW);
    rootChild1.setWidth(500);
    rootChild1.setHeight(800);
    rootChild1.setAlignItems(YogaAlign.BASELINE); // 第二个子节点也设置基线对齐
    root.insertChild(rootChild1, 1);
    // 在第二个子节点中添加子节点0 (500x500)
    const rootChild1Child0 = Yoga.createNode();
    rootChild1Child0.setFlexDirection(YogaFlexDirection.COLUMN);
    rootChild1Child0.setWidth(500);
    rootChild1Child0.setHeight(500);
    rootChild1.insertChild(rootChild1Child0, 0);
    // 在第二个子节点中添加子节点1 (500x400)
    const rootChild1Child1 = Yoga.createNode();
    rootChild1Child1.setFlexDirection(YogaFlexDirection.COLUMN);
    rootChild1Child1.setWidth(500);
    rootChild1Child1.setHeight(400);
    // 设置基线函数
    rootChild1Child1.setBaselineFunction(this.getBaselineFunc());
    // 测试测试扩展接口
    rootChild1Child1.setIsReferenceBaseline(true);
    rootChild1Child1.setAlwaysFormsContainingBlock(true);
    rootChild1.insertChild(rootChild1Child1, 1);
    // 计算布局
    root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
    // 验证布局结果
    this.logAndDisplay("rootChild0: x= ", rootChild0.getLayoutX(), "y= ", rootChild0.getLayoutY());
    this.logAndDisplay("rootChild1: x= ", rootChild1.getLayoutX(), "y= ", rootChild1.getLayoutY());
    this.logAndDisplay("rootChild1Child0: x= ", rootChild1Child0.getLayoutX(), "y= ", rootChild1Child0.getLayoutY());
    this.logAndDisplay("rootChild1Child1: x= ", rootChild1Child1.getLayoutX(), "y= ", rootChild1Child1.getLayoutY());
  }

  /**
   * 测试Web默认配置和点缩放因子功能
   * 验证Web默认值和点缩放因子设置是否生效
   */
  testUseWebDefaultsAndTestPointScaleFactor(): void {
    this.logAndDisplay("==== testUseWebDefaultsAndTestPointScaleFactor ====");
    // 测试Web默认配置
    const config = Yoga.createConfig();
    config.setUseWebDefaults(true);
    const node = Yoga.createNode(config);
    const nodeCompare = Yoga.createNode();
    this.logAndDisplay("Web默认方向:", node.getFlexDirection());
    this.logAndDisplay("默认方向:", nodeCompare.getFlexDirection());
    // 测试点缩放因子
    const config1 = Yoga.createConfig();
    const scaleFactor = 2.5;
    config1.setPointScaleFactor(scaleFactor);
    const node1 = Yoga.createNode(config);
    node1.setWidth(100);
    node1.setHeight(100);
    node1.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);
    this.logAndDisplay("缩放后宽度:", node1.getLayoutWidth());
    this.logAndDisplay("缩放后高度:", node1.getLayoutHeight());
  }

  /**
   * 测试Errata功能
   * 验证不同Errata配置对布局计算的影响
   */
  testErrataFunctionality(): void {
    this.logAndDisplay("==== testErrataFunctionality ====");
    const defaultConfig = Yoga.createConfig();
    this.logAndDisplay("默认 Errata 是否为 NONE:", defaultConfig.getErrata() === 0);
    // 测试设置和获取不同的 Errata 值
    const config = Yoga.createConfig();
    config.setErrata(YogaErrata.STRETCH_FLEX_BASIS);
    this.logAndDisplay("STRETCH_FLEX_BASIS:", config.getErrata() === 1);

    config.setErrata(YogaErrata.ABSOLUTE_POSITION_WITHOUT_INSETS_EXCLUDES_PADDING);
    this.logAndDisplay("ABSOLUTE_POSITION_WITHOUT_INSETS_EXCLUDES_PADDING:", config.getErrata() === 2);

    config.setErrata(YogaErrata.ALL);
    this.logAndDisplay("ALL:", config.getErrata() === 2147483647);
    // 测试 Errata 在节点布局中的应用
    const errataConfig = Yoga.createConfig();
    errataConfig.setErrata(YogaErrata.STRETCH_FLEX_BASIS);

    const root = Yoga.createNode(errataConfig);
    root.setWidth(100);
    root.setHeight(100);
    root.setMargin(YogaEdge.START, 1);
    root.setMargin(YogaEdge.END, 2);
    root.setMargin(YogaEdge.TOP, 3);
    root.setMargin(YogaEdge.BOTTOM, 4);
    root.setPadding(YogaEdge.START, 1);
    root.setPadding(YogaEdge.END, 2);
    root.setPadding(YogaEdge.TOP, 3);
    root.setPadding(YogaEdge.BOTTOM, 4);
    root.setBorder(YogaEdge.START, 1);
    root.setBorder(YogaEdge.END, 2);
    root.setBorder(YogaEdge.TOP, 3);
    root.setBorder(YogaEdge.BOTTOM, 4);
    root.setDirection(YogaDirection.RTL);

    const child = Yoga.createNode(errataConfig);
    child.setWidth(50);
    child.setHeight(50);
    root.insertChild(child, 0);

    root.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

    this.logAndDisplay("Root 布局 - Width:", root.getLayoutWidth(), "Height:", root.getLayoutHeight());
    this.logAndDisplay("Child 布局 - X:", child.getLayoutX(), "Y:", child.getLayoutY());

    // 测试重置功能对 Errata 的影响
    const resetConfig = Yoga.createConfig();
    resetConfig.setErrata(YogaErrata.ABSOLUTE_PERCENT_AGAINST_INNER_SIZE);

    const resetNode = Yoga.createNode(resetConfig);
    resetNode.setWidth(100);
    resetNode.setHeight(100);
    resetNode.markLayoutSeen();
    resetNode.reset();

    this.logAndDisplay("ABSOLUTE_PERCENT_AGAINST_INNER_SIZE:", resetConfig.getErrata() === 4);

    // 测试多个配置对象的独立性
    const config1 = Yoga.createConfig();
    const config2 = Yoga.createConfig();

    config1.setErrata(YogaErrata.STRETCH_FLEX_BASIS);
    config2.setErrata(YogaErrata.ABSOLUTE_POSITION_WITHOUT_INSETS_EXCLUDES_PADDING);
    this.logAndDisplay("Config1 是否为 STRETCH_FLEX_BASIS:", config1.getErrata() === 1);
    this.logAndDisplay("Config2 是否为 ABSOLUTE_POSITION_WITHOUT_INSETS_EXCLUDES_PADDING:", config2.getErrata() === 2);

    // 测试 CLASSIC 模式
    const classicConfig = Yoga.createConfig();
    classicConfig.setErrata(YogaErrata.CLASSIC);
    this.logAndDisplay("是否正确设置为 CLASSIC:", classicConfig.getErrata() === 2147483646);

    // 测试在复杂布局中使用 Errata
    const complexConfig = Yoga.createConfig();
    complexConfig.setErrata(YogaErrata.STRETCH_FLEX_BASIS);

    const complexRoot = Yoga.createNode(complexConfig);
    complexRoot.setFlexDirection(YogaFlexDirection.ROW);
    complexRoot.setWidth(1000);
    complexRoot.setHeight(1000);
    complexRoot.setAlignItems(YogaAlign.BASELINE);

    const child1 = Yoga.createNode(complexConfig);
    child1.setFlexDirection(YogaFlexDirection.COLUMN);
    child1.setWidth(500);
    child1.setHeight(600);
    complexRoot.insertChild(child1, 0);

    const child2 = Yoga.createNode(complexConfig);
    child2.setFlexDirection(YogaFlexDirection.COLUMN);
    child2.setWidth(500);
    child2.setHeight(800);
    complexRoot.insertChild(child2, 1);

    complexRoot.calculateLayout(YogaConstants.UNDEFINED, YogaConstants.UNDEFINED);

    this.logAndDisplay("复杂布局计算完成");
    this.logAndDisplay("Child1 布局 - X:", child1.getLayoutX(), "Y:", child1.getLayoutY());
    this.logAndDisplay("Child2 布局 - X:", child2.getLayoutX(), "Y:", child2.getLayoutY());
  }

  /**
   * 测试YogaNode和YogaConfig主要接口的
   */
  testInterfacePerformance(): void {
    this.logAndDisplay("==== testInterfacePerformance ====");
    this.testYogaNodeInterfacePerformance();
    this.testYogaConfigInterfacePerformance();
  }

  /**
   * 测试YogaNode主要接口
   */
  private testYogaNodeInterfacePerformance(): void {
    let startTime: number  = Number(systemDateTime.getTime(true)) / 1000;
    const node = Yoga.createNode();
    let endTime: number  = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("createNode:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setWidth(100);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setWidth:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setHeight(100);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setHeight:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setFlexDirection(YogaFlexDirection.ROW);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setFlexDirection:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setAlignItems(YogaAlign.CENTER);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setAlignItems:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setJustifyContent(YogaJustify.FLEX_START);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setJustifyContent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const width = node.getWidth();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getWidth:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const height = node.getHeight();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getHeight:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const flexDirection = node.getFlexDirection();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getFlexDirection:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const alignItems = node.getAlignItems();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getAlignItems:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const justifyContent = node.getJustifyContent();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getJustifyContent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const child1 = Yoga.createNode();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("createNode(子节点):", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const child2 = Yoga.createNode();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("createNode(子节点2):", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.insertChild(child1, 0);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("insertChild:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.insertChild(child2, 1);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("insertChild(第二个):", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.calculateLayout(500, 300);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("calculateLayout:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const layoutX = node.getLayoutX();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getLayoutX:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const layoutY = node.getLayoutY();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getLayoutY:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const layoutWidth = node.getLayoutWidth();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getLayoutWidth:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const layoutHeight = node.getLayoutHeight();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getLayoutHeight:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const clonedNode = node.clone();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("clone:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMargin(YogaEdge.ALL, 10);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMargin:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setPadding(YogaEdge.VERTICAL, 5);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setPadding:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setBorder(YogaEdge.LEFT, 2);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setBorder:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setPosition(YogaEdge.TOP, 5);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setPosition:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const margin = node.getMargin(YogaEdge.LEFT);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMargin:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const padding = node.getPadding(YogaEdge.TOP);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getPadding:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const border = node.getBorder(YogaEdge.LEFT);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getBorder:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const position = node.getPosition(YogaEdge.TOP);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getPosition:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setBaselineFunction((node: YogaNode, width: number, height: number) => {
      return height / 2;
    });
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setBaselineFunction:", (endTime - startTime), "μs");

    const nodeMeasure = Yoga.createNode();
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    nodeMeasure.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode, height: number, heightMode: YogaMeasureMode) => {
      return YogaMeasureOutput.make(100, 100);
    });
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMeasureFunction:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setFlex(1);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setFlex:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const flex = node.getFlex();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getFlex:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setFlexGrow(1);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setFlexGrow:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const flexGrow = node.getFlexGrow();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getFlexGrow:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setFlexShrink(1);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setFlexShrink:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const flexShrink = node.getFlexShrink();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getFlexShrink:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMinWidth(50);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMinWidth:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const minWidth = node.getMinWidth();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMinWidth:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMaxHeight(200);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMaxHeight:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const maxHeight = node.getMaxHeight();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMaxHeight:", (endTime - startTime), "μs");
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setDirection(YogaDirection.LTR);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setDirection:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const styleDirection = node.getStyleDirection();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getStyleDirection:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const layoutDirection = node.getLayoutDirection();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getLayoutDirection:", (endTime - startTime), "μs");
    
    // 对齐相关
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setAlignContent(YogaAlign.CENTER);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setAlignContent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const alignContent = node.getAlignContent();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getAlignContent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    child1.setAlignSelf(YogaAlign.FLEX_START);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setAlignSelf:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const alignSelf = child1.getAlignSelf();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getAlignSelf:", (endTime - startTime), "μs");
    
    // 定位相关
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    child1.setPositionType(YogaPositionType.ABSOLUTE);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setPositionType:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const positionType = child1.getPositionType();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getPositionType:", (endTime - startTime), "μs");
    
    // 换行和溢出相关
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setFlexWrap(YogaWrap.WRAP);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setFlexWrap:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const flexWrap = node.getFlexWrap();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getFlexWrap:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setOverflow(YogaOverflow.HIDDEN);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setOverflow:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const overflow = node.getOverflow();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getOverflow:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    child1.setDisplay(YogaDisplay.NONE);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setDisplay:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const display = child1.getDisplay();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getDisplay:", (endTime - startTime), "μs");
    
    // 弹性基础尺寸相关
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setFlexBasis(100);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setFlexBasis:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setFlexBasisPercent(50);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setFlexBasisPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setFlexBasisAuto();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setFlexBasisAuto:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const flexBasis = node.getFlexBasis();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getFlexBasis:", (endTime - startTime), "μs");
    
    // 尺寸相关（百分比和自动）
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setWidthPercent(80);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setWidthPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setWidthAuto();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setWidthAuto:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setHeightPercent(60);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setHeightPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setHeightAuto();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setHeightAuto:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMinWidthPercent(20);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMinWidthPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const minWidthPercent = node.getMinWidth();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMinWidth(Percent):", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMinHeight(50);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMinHeight:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const minHeight = node.getMinHeight();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMinHeight:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMinHeightPercent(30);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMinHeightPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const minHeightPercent = node.getMinHeight();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMinHeight(Percent):", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMaxWidth(300);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMaxWidth:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const maxWidth = node.getMaxWidth();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMaxWidth:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMaxWidthPercent(90);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMaxWidthPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const maxWidthPercent = node.getMaxWidth();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMaxWidth(Percent):", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMaxHeightPercent(70);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMaxHeightPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const maxHeightPercent = node.getMaxHeight();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getMaxHeight(Percent):", (endTime - startTime), "μs");
    
    // 间距相关
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setGap(YogaGutter.COLUMN, 10);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setGap:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setGapPercent(YogaGutter.COLUMN, 5);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setGapPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const gap = node.getGap(YogaGutter.COLUMN);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getGap:", (endTime - startTime), "μs");
    
    // 盒模型相关
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setBoxSizing(YogaBoxSizing.BORDER_BOX);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setBoxSizing:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const boxSizing = node.getBoxSizing();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getBoxSizing:", (endTime - startTime), "μs");
    
    // 宽高比相关
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setAspectRatio(1.5);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setAspectRatio:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const aspectRatio = node.getAspectRatio();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getAspectRatio:", (endTime - startTime), "μs");
    
    // 边距百分比
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMarginPercent(YogaEdge.LEFT, 5);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMarginPercent:", (endTime - startTime), "μs");
    
    // 内边距百分比
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setPaddingPercent(YogaEdge.TOP, 3);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setPaddingPercent:", (endTime - startTime), "μs");
    
    // 位置百分比和自动
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setPositionPercent(YogaEdge.RIGHT, 10);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setPositionPercent:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setPositionAuto(YogaEdge.BOTTOM);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setPositionAuto:", (endTime - startTime), "μs");
    
    // 基线相关扩展接口
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    child1.setIsReferenceBaseline(true);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setIsReferenceBaseline:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const isReferenceBaseline = child1.isReferenceBaseline();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("isReferenceBaseline:", (endTime - startTime), "μs");
    
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    child1.setAlwaysFormsContainingBlock(true);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setAlwaysFormsContainingBlock:", (endTime - startTime), "μs");
    
    // 克隆相关接口
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const clonedWithChildren = node.cloneWithChildren();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("cloneWithChildren:", (endTime - startTime), "μs");

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const clonedWithoutChildren = node.cloneWithoutChildren();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("cloneWithoutChildren:", (endTime - startTime), "μs");

    // 子节点管理接口
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const childCount = node.getChildCount();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getChildCount:", (endTime - startTime), "μs");

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const owner = child1.getOwner();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getOwner:", (endTime - startTime), "μs");

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const childIndex = node.indexOf(child1);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("indexOf:", (endTime - startTime), "μs");

    // 布局状态相关接口
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const hasNewLayout = node.hasNewLayout();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("hasNewLayout:", (endTime - startTime), "μs");

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.markLayoutSeen();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("markLayoutSeen:", (endTime - startTime), "μs");

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const isDirty = node.isDirty();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("isDirty:", (endTime - startTime), "μs");

    const leafNode = Yoga.createNode();
    leafNode.setMeasureFunction((node: YogaNode, width: number, widthMode: YogaMeasureMode, height: number, heightMode: YogaMeasureMode) => {
      return YogaMeasureOutput.make(100, 100);
    });
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    leafNode.markDirty();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("markDirty:", (endTime - startTime), "μs");

    // 样式复制接口
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const styleCopyNode = Yoga.createNode();
    styleCopyNode.copyStyle(node);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("copyStyle:", (endTime - startTime), "μs");

    // 边距自动设置
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.setMarginAuto(YogaEdge.RIGHT);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setMarginAuto:", (endTime - startTime), "μs");

    // 布局边缘值获取
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const layoutMargin = node.getLayoutMargin(YogaEdge.LEFT);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getLayoutMargin:", (endTime - startTime), "μs");

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const layoutBorder = node.getLayoutBorder(YogaEdge.TOP);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getLayoutBorder:", (endTime - startTime), "μs");

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const layoutPadding = node.getLayoutPadding(YogaEdge.BOTTOM);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getLayoutPadding:", (endTime - startTime), "μs");

    // 重置接口
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const resetNode = Yoga.createNode();
    resetNode.setFlex(1);
    resetNode.setWidth(100);
    resetNode.reset();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("reset:", (endTime - startTime), "μs");

    // swapChild 和 removeChild 测试需要先添加一个子节点用于替换
    const tempChild = Yoga.createNode();
    tempChild.setWidth(50);
    tempChild.setHeight(50);
    node.insertChild(tempChild, 2);

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const newChild = Yoga.createNode();
    newChild.setWidth(30);
    newChild.setHeight(30);
    node.swapChild(newChild, 2);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("swapChild:", (endTime - startTime), "μs");

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    node.removeChild(2);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("removeChild:", (endTime - startTime), "μs");

    // clearChildren 测试
    const clearNode = Yoga.createNode();
    const clearChild1 = Yoga.createNode();
    const clearChild2 = Yoga.createNode();
    clearNode.insertChild(clearChild1, 0);
    clearNode.insertChild(clearChild2, 1);

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    clearNode.clearChildren();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("clearChildren:", (endTime - startTime), "μs");

    // getChild 测试
    const getChildNode = Yoga.createNode();
    const testChild = Yoga.createNode();
    getChildNode.insertChild(testChild, 0);

    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const retrievedChild = getChildNode.getChild(0);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getChild:", (endTime - startTime), "μs");
  }

  /**
   * 测试YogaConfig主要接口
   */
  private testYogaConfigInterfacePerformance(): void {
    let startTime: number = Number(systemDateTime.getTime(true)) / 1000;
    const config = Yoga.createConfig();
    let endTime: number = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("createNode: ", (endTime - startTime), "μs");
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    config.setUseWebDefaults(true);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setUseWebDefaults: ", (endTime - startTime), "μs");
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    config.setPointScaleFactor(2.0);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setPointScaleFactor: ", (endTime - startTime), "μs");
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    config.setErrata(YogaErrata.STRETCH_FLEX_BASIS);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setErrata: ", (endTime - startTime), "μs");
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const errata = config.getErrata();
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("getErrata: ", (endTime - startTime), "μs");
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    config.setExperimentalFeatureEnabled(YogaExperimentalFeature.WEB_FLEX_BASIS, true);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("setExperimentalFeatureEnabled: ", (endTime - startTime), "μs");
    startTime = Number(systemDateTime.getTime(true)) / 1000;
    const nodeWithConfig = Yoga.createNode(config);
    endTime = Number(systemDateTime.getTime(true)) / 1000;
    this.logAndDisplay("createNode(config): ", (endTime - startTime), "μs");
  }

  build() {
    Row() {
      Column() {
        Text("Yoga功能测试已完成，请查看下方日志输出")
          .fontSize(16)
          .margin({ top: 20 })
        
        if (this.showLogs) {
            Scroll() {
              Column() {
                Text(this.logOutput)
                  .fontSize(14)
                  .textAlign(TextAlign.Start)
                  .padding(10)
                  .backgroundColor('#f5f5f5')
                  .border({ width: 1, color: '#ddd' })
                  .borderRadius(4)
                  .width('100%')
              }
              .width('100%')
              .padding({ left: 10, right: 10, bottom: 10 })
            }
            .layoutWeight(1)
            .margin({ top: 10 })
        }
        
        Button("重新运行测试")
          .onClick(() => {
            this.showLogs = false;
            this.logOutput = '';
            setTimeout(() => {
              this.runAllTests();
              this.showLogs = true;
            }, 100);
          })
          .margin({ top: 10, bottom: 20 })
          .width('80%')
      }
      .width('100%')
      .padding(10)
    }
    .height('100%')
  }
}
