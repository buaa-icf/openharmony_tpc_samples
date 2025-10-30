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

import yoga from 'libyoga_native.so';
import {
  YogaDirection,
  YogaEdge,
  YogaFlexDirection,
  YogaJustify,
  YogaAlign,
  YogaPositionType,
  YogaWrap,
  YogaOverflow,
  YogaDisplay,
  YogaBoxSizing,
  YogaGutter,
  YogaUnit
} from './yogaEnum';
import { YogaValue, LayoutData, EdgeValues, YogaMeasureFunction, YogaBaselineFunction } from './yogaValues';
import { YogaConfig } from './yogaConfig';

interface YGValueObj {
  value: number;
  unit: YogaUnit;
}

interface NativeYogaNode {
  _layout?: LayoutData;
}

export class YogaNode {
  private nativeNode: Object | null;
  private childNode: YogaNode[] = [];
  private owner: YogaNode | null = null;
  private layoutData: LayoutData = LayoutData.defaultInit();

  constructor(config?: YogaConfig) {
    if (config) {
      this.nativeNode = yoga.nodeNewWithConfig(config.getNativeConfig());
    } else {
      this.nativeNode = yoga.nodeNew();
    }
  }

  /**
   * 克隆节点（默认实现为克隆不带子节点）
   * @returns 克隆的Yoga节点
   */
  clone(): YogaNode {
    return this.cloneWithoutChildren();
  }

  /**
   * 克隆节点及其所有子节点
   * @returns 克隆的Yoga节点
   */
  cloneWithChildren(): YogaNode {
    if (!this.nativeNode) {
      throw new Error('Node has been freed');
    }

    const clonedNode = new YogaNode();
    clonedNode.nativeNode = yoga.nodeClone(this.nativeNode);
    for (let i = 0; i < this.childNode.length; i++) {
      const clonedChild = this.childNode[i].cloneWithChildren();
      clonedNode.childNode.push(clonedChild);
      clonedChild.owner = clonedNode;
    }

    for (let i = 0; i < clonedNode.childNode.length; i++) {
      if (clonedNode.nativeNode && clonedNode.childNode[i].nativeNode) {
        yoga.nodeInsertChild(clonedNode.nativeNode, clonedNode.childNode[i].nativeNode, i);
      }
    }
    return clonedNode;
  }

  /**
   * 克隆节点但不包含子节点
   * @returns 克隆的Yoga节点
   */
  cloneWithoutChildren(): YogaNode {
    if (!this.nativeNode) {
      throw new Error('Node has been freed');
    }

    const clonedNode = new YogaNode();
    clonedNode.nativeNode = yoga.nodeClone(this.nativeNode);
    return clonedNode;
  }

  /**
   * 重置节点到初始状态
   */
  reset(): void {
    if (this.nativeNode) {
      this.layoutData = LayoutData.defaultInit();
      yoga.nodeReset(this.nativeNode);
    }
  }

  private updateLayoutData(): void {
    if (!this.nativeNode) {
      return;
    }

    const nativeNode = this.nativeNode as NativeYogaNode;
    if (nativeNode._layout) {
      this.layoutData = LayoutData.updateFromNative(nativeNode._layout);
    }
  }

  private updateLayoutDataRecursive(): void {
    this.updateLayoutData();
    for (const node of this.childNode) {
      node.updateLayoutDataRecursive();
    }
  }

  /**
   * 计算节点布局
   * @param availableWidth 可用宽度
   * @param availableHeight 可用高度
   */
  calculateLayout(availableWidth: number, availableHeight: number): void {
    if (this.nativeNode) {
      yoga.nodeCalculateLayout(this.nativeNode, availableWidth, availableHeight);
      this.updateLayoutDataRecursive();
    }
  }

  /**
   * 检查节点是否有新的布局数据
   * @returns 是否有新的布局数据
   */
  hasNewLayout(): boolean {
    return this.layoutData.hasNewLayout;
  }

  /**
   * 标记布局已处理
   */
  markLayoutSeen(): void {
    if (this.layoutData) {
      this.layoutData.hasNewLayout = false;
    }
  }

  /**
   * 检查节点是否为脏状态（需要重新计算布局）
   * @returns 节点是否为脏状态
   */
  isDirty(): boolean {
    if (!this.nativeNode) {
      return false;
    }
    return yoga.nodeIsDirty(this.nativeNode);
  }

  /**
   * 标记节点为脏状态
   */
  markDirty(): void {
    if (this.nativeNode) {
      yoga.nodeMarkDirty(this.nativeNode);
    }
  }

  /**
   * 在指定位置插入子节点
   * @param child 要插入的子节点
   * @param index 插入位置
   */
  insertChild(child: YogaNode, index: number): void {
    if (this.nativeNode && child.nativeNode) {
      if (child.getOwner() !== null) {
        throw new Error('Child already has a parent, it must be removed first.');
      }

      this.childNode.splice(index, 0, child);
      child.owner = this;
      yoga.nodeInsertChild(this.nativeNode, child.nativeNode, index);
    }
  }

  /**
   * 在指定位置替换子节点
   * @param newChild 新的子节点
   * @param position 替换位置
   */
  swapChild(newChild: YogaNode, position: number): void {
    if (this.nativeNode && newChild.nativeNode) {
      if (newChild.getOwner() !== null) {
        throw new Error('New child already has a parent, it must be removed first.');
      }

      yoga.nodeSwapChild(this.nativeNode, newChild.nativeNode, position);

      const oldChild = this.childNode[position];
      this.childNode[position] = newChild;
      oldChild.owner = null;
      newChild.owner = this;
    }
  }

  /**
   * 移除指定索引的子节点
   * @param index 要移除的子节点索引
   */
  removeChild(index: number): void {
    if (index < 0 || index >= this.childNode.length) {
      throw new Error('Index out of bounds');
    }
    if (this.nativeNode) {
      const child = this.childNode[index];
      if (child.nativeNode) {
        this.childNode.splice(index, 1);
        child.owner = null;
        yoga.nodeRemoveChild(this.nativeNode, child.nativeNode);
      }
    }
  }

  /**
   * 清除所有子节点
   */
  clearChildren(): void {
    if (this.nativeNode) {
      for (const child of this.childNode) {
        child.owner = null;
      }
      this.childNode = [];
      yoga.nodeRemoveAllChildren(this.nativeNode);
    }
  }

  /**
   * 获取指定索引的子节点
   * @param index 子节点索引
   * @returns 指定索引的子节点
   */
  getChild(index: number): YogaNode {
    if (index < 0 || index >= this.childNode.length) {
      throw new Error('Index out of bounds');
    }
    return this.childNode[index];
  }

  /**
   * 获取子节点数量
   * @returns 子节点数量
   */
  getChildCount(): number {
    return this.childNode.length;
  }

  /**
   * 查找子节点的索引位置
   * @param child 要查找的子节点
   * @returns 子节点的索引位置，未找到返回-1
   */
  indexOf(child: YogaNode): number {
    return this.childNode.indexOf(child);
  }

  /**
   * 获取父节点
   * @returns 父节点或null
   */
  getOwner(): YogaNode | null {
    return this.owner;
  }

  /**
   * 设置测量函数
   * @param measureFunc 测量函数，传null表示取消设置
   */
  setMeasureFunction(measureFunc: YogaMeasureFunction | null): void {
    if (!this.nativeNode) {
      throw new Error('Node has been freed');
    }
    yoga.nodeSetMeasureFunc(this.nativeNode, measureFunc);
  }

  /**
   * 设置基线函数
   * @param baselineFunc 基线函数，传null表示取消设置
   */
  setBaselineFunction(baselineFunc: YogaBaselineFunction | null): void {
    if (!this.nativeNode) {
      throw new Error('Node has been freed');
    }
    yoga.nodeSetBaselineFunc(this.nativeNode, baselineFunc);
  }

  /**
   * 设置节点是否作为基准线参考节点
   * @param isReferenceBaseline 是否作为基准线参考节点
   */
  setIsReferenceBaseline(isReferenceBaseline: boolean): void {
    if (!this.nativeNode) {
      throw new Error('Node has been freed');
    }
    yoga.nodeSetIsReferenceBaseline(this.nativeNode, isReferenceBaseline);
  }

  /**
   * 检查节点是否作为基准线参考节点
   * @returns 是否作为基准线参考节点
   */
  isReferenceBaseline(): boolean {
    if (!this.nativeNode) {
      throw new Error('Node has been freed');
    }
    return yoga.nodeIsReferenceBaseline(this.nativeNode);
  }

  /**
   * 设置节点是否始终形成包含块
   * @param alwaysFormsContainingBlock 是否始终形成包含块
   */
  setAlwaysFormsContainingBlock(alwaysFormsContainingBlock: boolean): void {
    if (!this.nativeNode) {
      throw new Error('Node has been freed');
    }
    yoga.nodeSetAlwaysFormsContainingBlock(this.nativeNode, alwaysFormsContainingBlock);
  }

  /**
   * 获取布局计算后节点X坐标
   * @returns 节点X坐标
   */
  getLayoutX(): number {
    return this.layoutData.left;
  }

  /**
   * 获取布局计算后节点Y坐标
   * @returns 节点Y坐标
   */
  getLayoutY(): number {
    return this.layoutData.top;
  }

  /**
   * 获取布局计算后节点宽度
   * @returns 节点宽度
   */
  getLayoutWidth(): number {
    return this.layoutData.width;
  }

  /**
   * 获取布局计算后节点高度
   * @returns 节点高度
   */
  getLayoutHeight(): number {
    return this.layoutData.height;
  }

  /**
   * 获取布局计算后节点布局方向
   * @returns 布局方向
   */
  getLayoutDirection(): YogaDirection {
    return this.layoutData.direction;
  }

  private getEdgeValue(edgeValues: EdgeValues | undefined, edge: YogaEdge): number {
    if (!edgeValues) {
      return 0;
    }

    switch (edge) {
      case YogaEdge.LEFT:
        return edgeValues.left ?? 0;
      case YogaEdge.TOP:
        return edgeValues.top ?? 0;
      case YogaEdge.RIGHT:
        return edgeValues.right ?? 0;
      case YogaEdge.BOTTOM:
        return edgeValues.bottom ?? 0;
      case YogaEdge.START:
        return this.getLayoutDirection() === YogaDirection.RTL
          ? (edgeValues.right ?? 0)
          : (edgeValues.left ?? 0);
      case YogaEdge.END:
        return this.getLayoutDirection() === YogaDirection.RTL
          ? (edgeValues.left ?? 0)
          : (edgeValues.right ?? 0);
      default:
        return 0;
    }
  }

  /**
   * 获取布局计算后节点指定边缘的边距
   * @param edge 边缘类型
   * @returns 边距值
   */
  getLayoutMargin(edge: YogaEdge): number {
    return this.getEdgeValue(this.layoutData.margin, edge);
  }

  /**
   * 获取布局计算后节点指定边缘的边框
   * @param edge 边缘类型
   * @returns 边框值
   */
  getLayoutBorder(edge: YogaEdge): number {
    return this.getEdgeValue(this.layoutData.border, edge);
  }

  /**
   * 获取布局计算后节点指定边缘的内边距
   * @param edge 边缘类型
   * @returns 内边距值
   */
  getLayoutPadding(edge: YogaEdge): number {
    return this.getEdgeValue(this.layoutData.padding, edge);
  }

  /**
   * 复制源节点的样式到当前节点
   * @param srcNode 源节点
   */
  copyStyle(srcNode: YogaNode): void {
    if (this.nativeNode && srcNode.nativeNode) {
      yoga.nodeCopyStyle(this.nativeNode, srcNode.nativeNode);
    }
  }

  /**
   * 设置布局方向
   * @param direction 布局方向
   */
  setDirection(direction: YogaDirection): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetDirection(this.nativeNode, direction);
    }
  }

  /**
   * 设置弹性盒子方向
   * @param flexDirection 弹性盒子方向
   */
  setFlexDirection(flexDirection: YogaFlexDirection): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetFlexDirection(this.nativeNode, flexDirection);
    }
  }

  /**
   * 设置内容对齐方式
   * @param justifyContent 内容对齐方式
   */
  setJustifyContent(justifyContent: YogaJustify): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetJustifyContent(this.nativeNode, justifyContent);
    }
  }

  /**
   * 设置多行内容对齐方式
   * @param alignContent 多行内容对齐方式
   */
  setAlignContent(alignContent: YogaAlign): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetAlignContent(this.nativeNode, alignContent);
    }
  }

  /**
   * 设置子项对齐方式
   * @param alignItems 子项对齐方式
   */
  setAlignItems(alignItems: YogaAlign): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetAlignItems(this.nativeNode, alignItems);
    }
  }

  /**
   * 设置自身对齐方式
   * @param alignSelf 自身对齐方式
   */
  setAlignSelf(alignSelf: YogaAlign): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetAlignSelf(this.nativeNode, alignSelf);
    }
  }

  /**
   * 设置定位类型
   * @param positionType 定位类型
   */
  setPositionType(positionType: YogaPositionType): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetPositionType(this.nativeNode, positionType);
    }
  }

  /**
   * 设置换行方式
   * @param flexWrap 换行方式
   */
  setFlexWrap(flexWrap: YogaWrap): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetFlexWrap(this.nativeNode, flexWrap);
    }
  }

  /**
   * 设置溢出处理方式
   * @param overflow 溢出处理方式
   */
  setOverflow(overflow: YogaOverflow): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetOverflow(this.nativeNode, overflow);
    }
  }

  /**
   * 设置显示类型
   * @param display 显示类型
   */
  setDisplay(display: YogaDisplay): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetDisplay(this.nativeNode, display);
    }
  }

  /**
   * 设置弹性盒子缩放比例
   * @param flex 缩放比例
   */
  setFlex(flex: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetFlex(this.nativeNode, flex);
    }
  }

  /**
   * 设置放大比例
   * @param flexGrow 放大比例
   */
  setFlexGrow(flexGrow: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetFlexGrow(this.nativeNode, flexGrow);
    }
  }

  /**
   * 设置缩小比例
   * @param flexShrink 缩小比例
   */
  setFlexShrink(flexShrink: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetFlexShrink(this.nativeNode, flexShrink);
    }
  }

  /**
   * 设置弹性基础尺寸
   * @param flexBasis 弹性基础尺寸
   */
  setFlexBasis(flexBasis: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetFlexBasis(this.nativeNode, flexBasis);
    }
  }

  /**
   * 设置弹性基础尺寸百分比
   * @param flexBasis 弹性基础尺寸百分比
   */
  setFlexBasisPercent(flexBasis: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetFlexBasisPercent(this.nativeNode, flexBasis);
    }
  }

  /**
   * 设置弹性基础尺寸为自动
   */
  setFlexBasisAuto(): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetFlexBasisAuto(this.nativeNode);
    }
  }

  /**
   * 设置位置
   * @param edge 边缘类型
   * @param position 位置值
   */
  setPosition(edge: YogaEdge, position: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetPosition(this.nativeNode, edge, position);
    }
  }

  /**
   * 设置位置百分比
   * @param edge 边缘类型
   * @param position 位置百分比
   */
  setPositionPercent(edge: YogaEdge, position: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetPositionPercent(this.nativeNode, edge, position);
    }
  }

  /**
   * 设置位置为自动
   * @param edge 边缘类型
   */
  setPositionAuto(edge: YogaEdge): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetPositionAuto(this.nativeNode, edge);
    }
  }

  /**
   * 设置边距
   * @param edge 边缘类型
   * @param margin 边距值
   */
  setMargin(edge: YogaEdge, margin: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMargin(this.nativeNode, edge, margin);
    }
  }

  /**
   * 设置边距百分比
   * @param edge 边缘类型
   * @param margin 边距百分比
   */
  setMarginPercent(edge: YogaEdge, margin: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMarginPercent(this.nativeNode, edge, margin);
    }
  }

  /**
   * 设置边距为自动
   * @param edge 边缘类型
   */
  setMarginAuto(edge: YogaEdge): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMarginAuto(this.nativeNode, edge);
    }
  }

  /**
   * 设置内边距
   * @param edge 边缘类型
   * @param padding 内边距值
   */
  setPadding(edge: YogaEdge, padding: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetPadding(this.nativeNode, edge, padding);
    }
  }

  /**
   * 设置内边距百分比
   * @param edge 边缘类型
   * @param padding 内边距百分比
   */
  setPaddingPercent(edge: YogaEdge, padding: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetPaddingPercent(this.nativeNode, edge, padding);
    }
  }

  /**
   * 设置边框
   * @param edge 边缘类型
   * @param border 边框值
   */
  setBorder(edge: YogaEdge, border: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetBorder(this.nativeNode, edge, border);
    }
  }

  /**
   * 设置间距
   * @param gutter 间距类型
   * @param gapLength 间距长度
   */
  setGap(gutter: YogaGutter, gapLength: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetGap(this.nativeNode, gutter, gapLength);
    }
  }

  /**
   * 设置间距百分比
   * @param gutter 间距类型
   * @param gapLength 间距长度百分比
   */
  setGapPercent(gutter: YogaGutter, gapLength: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetGapPercent(this.nativeNode, gutter, gapLength);
    }
  }

  /**
   * 设置盒模型
   * @param boxSizing 盒模型类型
   */
  setBoxSizing(boxSizing: YogaBoxSizing): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetBoxSizing(this.nativeNode, boxSizing);
    }
  }

  /**
   * 设置宽度
   * @param width 宽度值
   */
  setWidth(width: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetWidth(this.nativeNode, width);
    }
  }

  /**
   * 设置宽度百分比
   * @param width 宽度百分比
   */
  setWidthPercent(width: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetWidthPercent(this.nativeNode, width);
    }
  }

  /**
   * 设置宽度为自动
   */
  setWidthAuto(): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetWidthAuto(this.nativeNode);
    }
  }

  /**
   * 设置高度
   * @param height 高度值
   */
  setHeight(height: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetHeight(this.nativeNode, height);
    }
  }

  /**
   * 设置高度百分比
   * @param height 高度百分比
   */
  setHeightPercent(height: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetHeightPercent(this.nativeNode, height);
    }
  }

  /**
   * 设置高度为自动
   */
  setHeightAuto(): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetHeightAuto(this.nativeNode);
    }
  }

  /**
   * 设置最小宽度
   * @param minWidth 最小宽度值
   */
  setMinWidth(minWidth: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMinWidth(this.nativeNode, minWidth);
    }
  }

  /**
   * 设置最小宽度百分比
   * @param minWidth 最小宽度百分比
   */
  setMinWidthPercent(minWidth: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMinWidthPercent(this.nativeNode, minWidth);
    }
  }

  /**
   * 设置最小高度
   * @param minHeight 最小高度值
   */
  setMinHeight(minHeight: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMinHeight(this.nativeNode, minHeight);
    }
  }

  /**
   * 设置最小高度百分比
   * @param minHeight 最小高度百分比
   */
  setMinHeightPercent(minHeight: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMinHeightPercent(this.nativeNode, minHeight);
    }
  }

  /**
   * 设置最大宽度
   * @param maxWidth 最大宽度值
   */
  setMaxWidth(maxWidth: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMaxWidth(this.nativeNode, maxWidth);
    }
  }

  /**
   * 设置最大宽度百分比
   * @param maxWidth 最大宽度百分比
   */
  setMaxWidthPercent(maxWidth: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMaxWidthPercent(this.nativeNode, maxWidth);
    }
  }

  /**
   * 设置最大高度
   * @param maxHeight 最大高度值
   */
  setMaxHeight(maxHeight: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMaxHeight(this.nativeNode, maxHeight);
    }
  }

  /**
   * 设置最大高度百分比
   * @param maxHeight 最大高度百分比
   */
  setMaxHeightPercent(maxHeight: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetMaxHeightPercent(this.nativeNode, maxHeight);
    }
  }

  /**
   * 设置宽高比
   * @param aspectRatio 宽高比
   */
  setAspectRatio(aspectRatio: number): void {
    if (this.nativeNode) {
      yoga.nodeStyleSetAspectRatio(this.nativeNode, aspectRatio);
    }
  }

  /**
   * 获取布局方向
   * @returns 布局方向
   */
  getStyleDirection(): YogaDirection {
    if (!this.nativeNode) {
      return YogaDirection.INHERIT;
    }
    return yoga.nodeStyleGetDirection(this.nativeNode) as YogaDirection;
  }

  /**
   * 获取弹性盒子方向
   * @returns 弹性盒子方向
   */
  getFlexDirection(): YogaFlexDirection {
    if (!this.nativeNode) {
      return YogaFlexDirection.COLUMN;
    }
    return yoga.nodeStyleGetFlexDirection(this.nativeNode) as YogaFlexDirection;
  }

  /**
   * 获取内容对齐方式
   * @returns 内容对齐方式
   */
  getJustifyContent(): YogaJustify {
    if (!this.nativeNode) {
      return YogaJustify.FLEX_START;
    }
    return yoga.nodeStyleGetJustifyContent(this.nativeNode) as YogaJustify;
  }

  /**
   * 获取多行内容对齐方式
   * @returns 多行内容对齐方式
   */
  getAlignContent(): YogaAlign {
    if (!this.nativeNode) {
      return YogaAlign.AUTO;
    }
    return yoga.nodeStyleGetAlignContent(this.nativeNode) as YogaAlign;
  }

  /**
   * 获取子项对齐方式
   * @returns 子项对齐方式
   */
  getAlignItems(): YogaAlign {
    if (!this.nativeNode) {
      return YogaAlign.STRETCH;
    }
    return yoga.nodeStyleGetAlignItems(this.nativeNode) as YogaAlign;
  }

  /**
   * 获取自身对齐方式
   * @returns 自身对齐方式
   */
  getAlignSelf(): YogaAlign {
    if (!this.nativeNode) {
      return YogaAlign.AUTO;
    }
    return yoga.nodeStyleGetAlignSelf(this.nativeNode) as YogaAlign;
  }

  /**
   * 获取定位类型
   * @returns 定位类型
   */
  getPositionType(): YogaPositionType {
    if (!this.nativeNode) {
      return YogaPositionType.RELATIVE;
    }
    return yoga.nodeStyleGetPositionType(this.nativeNode) as YogaPositionType;
  }

  /**
   * 获取换行方式
   * @returns 换行方式
   */
  getFlexWrap(): YogaWrap {
    if (!this.nativeNode) {
      return YogaWrap.NO_WRAP;
    }
    return yoga.nodeStyleGetFlexWrap(this.nativeNode) as YogaWrap;
  }

  /**
   * 获取溢出处理方式
   * @returns 溢出处理方式
   */
  getOverflow(): YogaOverflow {
    if (!this.nativeNode) {
      return YogaOverflow.VISIBLE;
    }
    return yoga.nodeStyleGetOverflow(this.nativeNode) as YogaOverflow;
  }

  /**
   * 获取显示类型
   * @returns 显示类型
   */
  getDisplay(): YogaDisplay {
    if (!this.nativeNode) {
      return YogaDisplay.FLEX;
    }
    return yoga.nodeStyleGetDisplay(this.nativeNode) as YogaDisplay;
  }

  /**
   * 获取弹性盒子缩放比例
   * @returns 缩放比例
   */
  getFlex(): number {
    if (!this.nativeNode) {
      return 0;
    }
    return yoga.nodeStyleGetFlex(this.nativeNode);
  }

  /**
   * 获取放大比例
   * @returns 放大比例
   */
  getFlexGrow(): number {
    if (!this.nativeNode) {
      return 0;
    }
    return yoga.nodeStyleGetFlexGrow(this.nativeNode);
  }

  /**
   * 获取缩小比例
   * @returns 缩小比例
   */
  getFlexShrink(): number {
    if (!this.nativeNode) {
      return 0;
    }
    return yoga.nodeStyleGetFlexShrink(this.nativeNode);
  }

  /**
   * 获取弹性基础尺寸
   * @returns 弹性基础尺寸
   */
  getFlexBasis(): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetFlexBasis(this.nativeNode) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取位置
   * @param edge 边缘类型
   * @returns 位置值
   */
  getPosition(edge: YogaEdge): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetPosition(this.nativeNode, edge) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取边距
   * @param edge 边缘类型
   * @returns 边距值
   */
  getMargin(edge: YogaEdge): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetMargin(this.nativeNode, edge) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取内边距
   * @param edge 边缘类型
   * @returns 内边距值
   */
  getPadding(edge: YogaEdge): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetPadding(this.nativeNode, edge) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取边框
   * @param edge 边缘类型
   * @returns 边框值
   */
  getBorder(edge: YogaEdge): number {
    if (!this.nativeNode) {
      return 0;
    }
    return yoga.nodeStyleGetBorder(this.nativeNode, edge);
  }

  /**
   * 获取间距
   * @param gutter 间距类型
   * @returns 间距长度
   */
  getGap(gutter: YogaGutter): number {
    if (!this.nativeNode) {
      return 0;
    }
    return yoga.nodeStyleGetGap(this.nativeNode, gutter);
  }

  /**
   * 获取盒模型
   * @returns 盒模型类型
   */
  getBoxSizing(): YogaBoxSizing {
    if (!this.nativeNode) {
      return YogaBoxSizing.CONTENT_BOX;
    }
    return yoga.nodeStyleGetBoxSizing(this.nativeNode) as YogaBoxSizing;
  }

  /**
   * 获取宽度
   * @returns 宽度值
   */
  getWidth(): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetWidth(this.nativeNode) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取高度
   * @returns 高度值
   */
  getHeight(): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetHeight(this.nativeNode) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取最小宽度
   * @returns 最小宽度值
   */
  getMinWidth(): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetMinWidth(this.nativeNode) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取最小高度
   * @returns 最小高度值
   */
  getMinHeight(): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetMinHeight(this.nativeNode) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取最大宽度
   * @returns 最大宽度值
   */
  getMaxWidth(): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetMaxWidth(this.nativeNode) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取最大高度
   * @returns 最大高度值
   */
  getMaxHeight(): YogaValue {
    if (!this.nativeNode) {
      return new YogaValue(0, YogaUnit.UNDEFINED);
    }
    const obj = yoga.nodeStyleGetMaxHeight(this.nativeNode) as YGValueObj;
    return new YogaValue(obj.value, obj.unit as YogaUnit);
  }

  /**
   * 获取宽高比
   * @returns 宽高比
   */
  getAspectRatio(): number {
    if (!this.nativeNode) {
      return 0;
    }
    return yoga.nodeStyleGetAspectRatio(this.nativeNode);
  }
}