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

import BuildProfile from "../../../../BuildProfile";


/**
 * 日志级别枚举
 */
export enum LogLevel {
  DEBUG = 0,
  INFO = 1,
  WARN = 2,
  ERROR = 3,
  NONE = 4
}

/**
 * 统一日志管理类
 * 根据构建配置控制日志输出
 */
export class Logger {
  private static instance: Logger;
  private logLevel: LogLevel = LogLevel.NONE;
  private tag: string = 'SwipeMenuListView';

  private constructor() {
    if (BuildProfile.DEBUG) {
      this.logLevel = LogLevel.DEBUG;
    } else {
      this.logLevel = LogLevel.NONE;
    }
  }

  /**
   * 获取Logger单例
   */
  public static getInstance(): Logger {
    if (!Logger.instance) {
      Logger.instance = new Logger();
    }
    return Logger.instance;
  }

  /**
   * 设置日志级别
   */
  public setLogLevel(level: LogLevel): void {
    this.logLevel = level;
  }

  /**
   * 设置日志标签
   */
  public setTag(tag: string): void {
    this.tag = tag;
  }

  /**
   * 调试日志
   */
  public debug(message: string, ...args: (string | number | boolean | object)[]): void {
    if (this.logLevel <= LogLevel.DEBUG) {
      console.log(`[${this.tag}][DEBUG] ${message}`, ...args);
    }
  }

  /**
   * 信息日志
   */
  public info(message: string, ...args: (string | number | boolean | object)[]): void {
    if (this.logLevel <= LogLevel.INFO) {
      console.log(`[${this.tag}][INFO] ${message}`, ...args);
    }
  }

  /**
   * 警告日志
   */
  public warn(message: string, ...args: (string | number | boolean | object)[]): void {
    if (this.logLevel <= LogLevel.WARN) {
      console.warn(`[${this.tag}][WARN] ${message}`, ...args);
    }
  }

  /**
   * 错误日志
   */
  public error(message: string, ...args: (string | number | boolean | object)[]): void {
    if (this.logLevel <= LogLevel.ERROR) {
      console.error(`[${this.tag}][ERROR] ${message}`, ...args);
    }
  }

  /**
   * 创建带特定标签的日志器
   */
  public createTaggedLogger(tag: string): TaggedLogger {
    return new TaggedLogger(this, tag);
  }
}

/**
 * 带标签的日志器
 */
export class TaggedLogger {
  private logger: Logger;
  private tag: string;

  constructor(logger: Logger, tag: string) {
    this.logger = logger;
    this.tag = tag;
  }

  public debug(message: string, ...args: (string | number | boolean | object)[]): void {
    this.logger.debug(`[${this.tag}] ${message}`, ...args);
  }

  public info(message: string, ...args: (string | number | boolean | object)[]): void {
    this.logger.info(`[${this.tag}] ${message}`, ...args);
  }

  public warn(message: string, ...args: (string | number | boolean | object)[]): void {
    this.logger.warn(`[${this.tag}] ${message}`, ...args);
  }

  public error(message: string, ...args: (string | number | boolean | object)[]): void {
    this.logger.error(`[${this.tag}] ${message}`, ...args);
  }
}

export const logger = Logger.getInstance();