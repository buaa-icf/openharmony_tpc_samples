/**
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * This software is distributed under a license. The full license
 * agreement can be found in the file LICENSE in this distribution.
 * This software may not be copied, modified, sold or distributed
 * other than expressed in the named license agreement.
 *
 * This software is distributed without any warranty.
 */

type ColorType = string | number | Resource;

type ImageResourceType = ResourceStr | PixelMap;


export interface SwipeMenuItemOptions {
  id: string | number;
  title?: string;
  icon?: ImageResourceType;
  background: ColorType;
  width?: number;

  titleColor?: ColorType;
  titleSize?: number;
}

@Observed
export class SwipeMenuItem {
  id: string | number;
  title?: string;
  icon?: ImageResourceType;
  background: ColorType;
  width: number;
  titleColor: ColorType;
  titleSize: number;

  constructor(options: SwipeMenuItemOptions) {
    this.id = options.id;
    this.title = options.title;
    this.icon = options.icon;
    this.background = options.background;
    this.width = options.width ?? 80;
    this.titleColor = options.titleColor ?? '#FFFFFF'; // 默认白色字符串
    this.titleSize = options.titleSize ?? 16;
  }
  
  /**
   * 获取菜单项ID
   * @returns 菜单项的唯一标识
   */
  public getId(): string | number {
    return this.id;
  }

  /**
   * 设置菜单项ID
   * @param id 菜单项的唯一标识
   */
  public setId(id: string | number): void {
    this.id = id;
  }

  /**
   * 获取菜单项图标
   * @returns 图标资源
   */
  public getIcon(): ImageResourceType | undefined {
    return this.icon;
  }

  /**
   * 设置菜单项图标
   * @param icon 图标资源
   */
  public setIcon(icon: ImageResourceType): void {
    this.icon = icon;
  }

  /**
   * 设置菜单项标题 (支持资源ID)
   * @param title 标题文本或资源ID
   */
  public setTitle(title: string | ResourceStr): void {
    this.title = title as string;
  }

  /**
   * 获取菜单项标题
   * @returns 标题文本
   */
  public getTitle(): string | undefined {
    return this.title;
  }

  /**
   * 设置菜单项背景 (支持资源ID)
   * @param background 背景颜色或资源ID
   */
  public setBackground(background: ColorType): void {
    this.background = background;
  }

  /**
   * 获取菜单项背景
   * @returns 背景颜色
   */
  public getBackground(): ColorType {
    return this.background;
  }

  /**
   * 设置菜单项宽度
   * @param width 宽度值
   */
  public setWidth(width: number): void {
    this.width = width;
  }

  /**
   * 获取菜单项宽度
   * @returns 宽度值
   */
  public getWidth(): number {
    return this.width;
  }

  /**
   * 设置标题颜色
   * @param color 文字颜色
   */
  public setTitleColor(color: ColorType): void {
    this.titleColor = color;
  }

  /**
   * 获取标题颜色
   * @returns 文字颜色
   */
  public getTitleColor(): ColorType {
    return this.titleColor;
  }

  /**
   * 设置标题字体大小
   * @param size 字体大小
   */
  public setTitleSize(size: number): void {
    this.titleSize = size;
  }

  /**
   * 获取标题字体大小
   * @returns 字体大小
   */
  public getTitleSize(): number {
    return this.titleSize;
  }
}