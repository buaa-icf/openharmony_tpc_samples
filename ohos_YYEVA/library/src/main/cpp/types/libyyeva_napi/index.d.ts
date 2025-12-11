import { image } from "@kit.ImageKit";

export class ThreadTask {
  constructor(name: string);
  stop(): Promise<void>;
}

export const getRenderThread: (controllerId: number) => ThreadTask;

/**
 * 处理图像像素（替代 Android Bitmap）
 * @param pixelMap - 鸿蒙图像对象
 */
export const nativeProcessPixelMap: (pixelMap: image.PixelMap) => void;

/**
 * 获取外部纹理 ID
 * @param controllerId - 渲染控制器 ID
 * @returns
 */
export const getExternalTexture: (controllerId: number) => number;

/**
 * 更新渲染视图尺寸
 * @param controllerId - 控制器 ID
 * @param width - 新宽度
 * @param height - 新高度
 */
export const updateViewPoint: (controllerId: number, width: number, height: number) => void;

/**
 * 处理视频尺寸变化
 * @param controllerId - 控制器 ID
 * @param newWidth - 新宽度
 * @param newHeight - 新高度
 */
export const videoSizeChange: (controllerId: number, newWidth: number, newHeight: number) => void;

/**
 * 初始化 MP4 渲染器
 * @param controllerId - 控制器 ID
 * @param surface - 鸿蒙 Surface 对象（替代 Android Surface）
 * @param isNeedYuv - 是否需要 YUV 格式输出
 * @param isNormalMp4 - 是否为标准 MP4 格式
 * @returns 管理器 ID（失败返回 -1）
 */
export const initRender: (
  controllerId: number,
  surfaceId: string,
  isNeedYuv: boolean,
  isNormalMp4: boolean,
  isVideoRecord?: boolean
) => number;

/**
 * 设置动效 JSON 配置
 * @param controllerId - 控制器 ID
 * @param json - 动效配置数据
 */
export const setRenderConfig: (controllerId: number, json: string) => void;

/**
 * 设置默认渲染配置
 * @param controllerId - 控制器 ID
 * @param width - 视图宽度
 * @param height - 视图高度
 * @param defaultVideoMode - 视频模式（见下方枚举）
 */
export const defaultConfig: (
  controllerId: number,
  width: number,
  height: number,
  defaultVideoMode?: VideoMode
) => void;

/**
 * 设置背景图像
 * @param controllerId - 控制器 ID
 * @param pixelMap - 图像对象（null 表示清空背景）
 */
export const setBgBitmap: (controllerId: number, pixelMap: image.PixelMap | null) => void;

/**
 * 设置动效元素图像
 * @param controllerId - 控制器 ID
 * @param srcId - 动效元素 ID
 * @param pixelMap - 图像对象
 * @param scaleMode - 缩放模式（"fitXY" | "centerCrop" | "centerInside"）
 */
export const setSrcBitmap: (
  controllerId: number,
  srcId: string,
  pixelMap: image.PixelMap | null,
  scaleMode: string
) => void;

/**
 * 设置动效元素文本
 * @param controllerId - 控制器 ID
 * @param srcId - 动效元素 ID
 * @param txt - 文本内容
 */
export const setSrcTxt: (controllerId: number, srcId: string, txt: string) => void;

/**
 * 渲染单帧画面
 * @param controllerId - 控制器 ID
 */
export const renderFrame: (controllerId: number) => void;

/**
 * 清空当前帧画面
 * @param controllerId - 控制器 ID
 */
export const renderClearFrame: (controllerId: number) => void;

/**
 * 释放纹理资源
 * @param controllerId - 控制器 ID
 */
export const releaseTexture: (controllerId: number) => void;

/**
 * 交换渲染缓冲区（双缓冲机制）
 * @param controllerId - 控制器 ID
 */
export const renderSwapBuffers: (controllerId: number) => void;

/**
 * 销毁渲染器
 * @param controllerId - 控制器 ID
 */
export const destroyRender: (controllerId: number) => void;

/**
 * 创建动效混合渲染器
 * @param controllerId - 控制器 ID
 * @param json - 动效配置 JSON
 * @returns 渲染器 ID（失败返回 -1）
 */
export const mixConfigCreate: (controllerId: number, json: string) => number;

/**
 * 初始化动效混合渲染
 * @param controllerId - 控制器 ID
 */
export const mixRenderCreate: (controllerId: number) => void;

/**
 * 执行动效混合渲染
 * @param controllerId - 控制器 ID
 * @param frameIndex - 目标帧索引
 */
export const mixRendering: (controllerId: number, frameIndex: number) => void;

/**
 * 销毁动效混合渲染器
 * @param controllerId - 控制器 ID
 */
export const mixRenderDestroy: (controllerId: number) => void;

/** 视频渲染模式枚举 */
enum VideoMode {
  SPLIT_HORIZONTAL_REVERSE = 0,
  // 其他模式需补充...
}

/**
     * 初始化录制视频
     */
export const initVideoRecord: (controllerId: number, surface: string) => number;

/**
 * 设置动效json数据
 */
export const setRecordRenderConfig: (controllerId: number, json: string) => void;


/**
 * 触发录制绘制
 */
export const recordRender: (controllerId: number, time: number) => void;

/**
 * 停止录制
 */
export const stopRecord: (controllerId: number) => void;

/**
 * 是否开启视频录制
 * 需要在主渲染线程开启，不是录制线程开启
 */
export const setVideoRecord: (controllerId: number, isVideoRecord: boolean) => void;

type Log = (level: string, tag: string, message: string) => void;
export const setLog: (log: Log) => void;

export const setBlendMode: (controllerId: number, blendMode: number) => void;