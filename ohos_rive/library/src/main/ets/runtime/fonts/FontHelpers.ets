/*
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

import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import xml from '@ohos.xml';
import rive from 'libohos_rive.so';
import fileIo from '@ohos.file.fs';
import { Context } from '@kit.AbilityKit';

const TAG: string = 'FontHelper';

/**
 * 字体样式常量
 */
export const FONT_STYLE_NORMAL: string = 'normal';

export const FONT_STYLE_ITALIC: string = 'italic';

/**
 * 字体类
 */
export class Font {
  public weight: Weight;
  public style: string;
  public name: string; // TTF 文件名
  public axis: Axis[] | null = null; // 可变字体的可选轴
  public ttcIndex: number = 0;
  public postScriptName: string | null = null;
  public fallbackFor: string | null = null;

  constructor(
    weight: Weight,
    style: string,
    name: string,
    axis: Axis[] | null = null,
    ttcIndex: number = 0,
    postScriptName: string | null = null,
    fallbackFor: string | null = null
  ) {
    this.weight = weight;
    this.style = style;
    this.name = name;
    this.axis = axis;
    this.ttcIndex = ttcIndex;
    this.postScriptName = postScriptName;
    this.fallbackFor = fallbackFor;
  }
}

/**
 * 字体轴类（用于可变字体）
 */
export class Axis {
  public tag: string;
  public styleValue: string;

  constructor(tag: string, styleValue: string) {
    this.tag = tag;
    this.styleValue = styleValue;
  }
}

/**
 * 字体族类
 */
export class Family {
  public name: string | null = null; // 可选的未命名族组
  public variant: string | null = null;
  public lang: string | null = null; // 可选的语言规范
  public fonts: Map<Weight, Font[]>;

  constructor(
    fonts: Map<Weight, Font[]>,
    name: string | null = null,
    variant: string | null = null,
    lang: string | null = null
  ) {
    this.name = name;
    this.variant = variant;
    this.lang = lang;
    this.fonts = fonts;
  }
}

/**
 * 字体别名类
 */
export class Alias {
  public name: string;
  public original: string;
  public weight: Weight | null = Weight.NORMAL;

  constructor(name: string, original: string, weight: Weight | null = Weight.NORMAL) {
    this.name = name;
    this.original = original;
    this.weight = weight;
  }
}

/**
 * 字重类
 */
export class Weight {
  public weight: number = 400;
  public static readonly NORMAL: Weight = new Weight(400);
  public static readonly BOLD: Weight = new Weight(700);

  constructor(weight: number = 400) {
    this.weight = Math.max(0, Math.min(1000, weight));
  }

  static fromString(stringValue: string | null | undefined): Weight {
    const intValue = stringValue ? parseInt(stringValue, 10) : null;
    return new Weight(intValue ? Math.max(0, Math.min(1000, intValue)) : 400);
  }

  static fromInt(intValue: number = 400): Weight {
    return new Weight(Math.max(0, Math.min(1000, intValue)));
  }

  compareTo(other: Weight): number {
    return this.weight - other.weight;
  }
}

/**
 * 字体选项类
 */
export class FontOpts {
  public familyName: string | null = null;
  public lang: string | null = null;
  public weight: Weight | null = Weight.NORMAL;
  public style: string | null = FONT_STYLE_NORMAL;
  /**
   * 默认配置，用于一般用途
   */
  public static readonly DEFAULT: FontOpts = new FontOpts('sans-serif');

  constructor(
    familyName: string | null = null,
    lang: string | null = null,
    weight: Weight | null = Weight.NORMAL,
    style: string | null = FONT_STYLE_NORMAL
  ) {
    this.familyName = familyName;
    this.lang = lang;
    this.weight = weight;
    this.style = style;
  }
}

/**
 * 文件字体类
 */
export class FileFont {
  public name: string;
  public variant: string | null = null;
  public lang: string | null = null;

  constructor(name: string, variant: string | null = null, lang: string | null = null) {
    this.name = name;
    this.variant = variant;
    this.lang = lang;
  }
}

/**
 * 字体辅助类
 */
export class FontHelper {
  private static readonly TAG: string = TAG;
  // 字体缓存（注意：在 ArkTS 中，静态变量在多线程环境下需要额外同步机制）
  private static familiesMapCache: Map<string, Family> | null = null;
  private static familiesListCache: Family[] | null = null;

  /**
   * 获取所有可用系统字体的映射。
   *
   * **已弃用**：使用 [getSystemFontList] 代替，以便更可靠地处理未命名字体族。
   * 当多个未命名族具有相同文件名的第一个字体时，此方法可能会丢失数据。
   *
   * @return 表示所有可用字体族的 [Map]<String, Family>，如果未找到有效 XML 则返回空映射。
   * @deprecated Use getSystemFontList() instead. Map approach can lose unnamed
   *   families with colliding first font names.
   */
  public static getSystemFonts(context: Context): Map<string, Family> {
    // 如果缓存可用则返回缓存的字体
    if (FontHelper.familiesMapCache) {
      return FontHelper.familiesMapCache;
    }

    // 双重检查锁定模式
    if (!FontHelper.familiesMapCache) {
      FontHelper.familiesMapCache = FontHelper.loadFonts(context);
    }
    return FontHelper.familiesMapCache;
  }

  /**
   * 获取所有可用系统字体的列表。
   *
   * 这是访问系统字体的首选方法，因为它保留了所有字体族，包括可能具有相同第一个字体文件名的多个未命名族。
   * 基于 Map 的方法（[getSystemFonts]）可能由于键冲突而丢失数据。
   *
   * @return 表示所有可用字体族的 [List]<Family>，如果未找到有效 XML 则返回空列表。
   */
  public static getSystemFontList(context: Context): Family[] {
    if (FontHelper.familiesListCache) {
      return FontHelper.familiesListCache;
    }
    // 双重检查锁定模式
    if (!FontHelper.familiesListCache) {
      FontHelper.familiesListCache = FontHelper.loadFontList(context);
    }
    return FontHelper.familiesListCache;
  }

  /**
   * 从第一个可用的 XML 文件加载并解析系统字体配置，根据字体文件存在性过滤结果，并更新内部字体缓存。
   *
   * @return 字体族名称到 [Family] 对象的 [Map]，仅包含在文件系统上找到字体的字体。
   * 如果未找到配置文件、解析失败或没有字体通过文件系统存在性检查，则返回空映射。
   */
  private static loadFonts(context: Context): Map<string, Family> {

    let loadedFonts: Map<string, Family> = new Map();
    if (context) {
      try {
        let dataStream: Uint8Array = context.resourceManager.getRawFileContentSync(SystemFontsParser.FONTS_XML_PATH,);
        console.warn(`snake : loadedFonts.` + dataStream.length);
        loadedFonts = SystemFontsParser.parseFontsXMLMap(dataStream);
      } catch (e) {
        console.error(`${TAG}: Error parsing fonts XML: ${e}`);
        loadedFonts = new Map();
      }
    } else {
      console.warn(`${TAG}: No valid system font XML file found at expected paths.`);
      loadedFonts = new Map();
    }

    // 过滤掉文件系统上不存在的字体
    const existingFonts = FontHelper.filterNonExistingFontsMap(loadedFonts);

    // 原子更新缓存
    FontHelper.familiesMapCache = existingFonts;

    return existingFonts;
  }

  private static loadFontList(context: Context): Family[] {
    let loadedFonts: Family[] = [];
    if (context) {
      try {
        let dataStream: Uint8Array = context.resourceManager.getRawFileContentSync(SystemFontsParser.FONTS_XML_PATH,);
        console.warn(`snake : loadedFonts.` + dataStream.length);
        loadedFonts = SystemFontsParser.parseFontsXML(dataStream);
      } catch (e) {
        console.error(`snake: Error parsing fonts XML: ${e}`);
        loadedFonts = [];
      }
    } else {
      console.warn(`snake : No valid system font XML file found at expected paths.`);
      loadedFonts = [];
    }
    console.warn(`snake : loadedFonts.` + loadedFonts.length);
    // 过滤掉文件系统上不存在的字体
    const existingFontsList = FontHelper.filterNonExistingFonts(loadedFonts);
    console.warn(`snake : existingFontsList.` + existingFontsList.length);

    // 原子更新缓存
    FontHelper.familiesListCache = existingFontsList;

    return existingFontsList;
  }

  /**
   * 根据可选的字体首选项获取回退字体。
   *
   * @param opts 可选的 [FontOpts] 指定所需的字体特征。如果未提供，则使用默认设置。
   * @return 匹配指定选项的 [Font]，如果未找到合适的字体则返回 `null`。
   */
  public static getFallbackFont(context: Context, opts: FontOpts | null = null): Font | null {
    const fonts = FontHelper.getFallbackFonts(context, opts ?? FontOpts.DEFAULT);
    return fonts.length > 0 ? fonts[0] : null;
  }

  /**
   * 根据可选的字体首选项获取回退字体列表。
   *
   * @param opts 可选的 [FontOpts] 指定所需的字体特征。如果未提供，则使用默认设置。
   * @return 匹配指定选项的 [Font] 列表，如果未找到合适的字体则返回空列表。
   */
  public static getFallbackFonts(context: Context, opts: FontOpts = FontOpts.DEFAULT): Font[] {
    const fontFamilies = FontHelper.getSystemFontList(context);
    if (fontFamilies.length === 0) {
      console.error(`${TAG}: getFallbackFonts: no system font found`);
      return [];
    }

    return FontHelper.findMatchesList(fontFamilies, opts);
  }

  /**
   * 在提供的字体族映射中搜索匹配指定条件的字体，返回有序的唯一匹配列表。
   *
   * @param fontFamilies 要搜索的字体族名称到 [Family] 对象的映射。
   * @param opts 指定所需字体特征（族、语言、字重、样式）的 [FontOpts]。
   * @return 匹配条件的唯一 [Font] 对象列表，按优先级排序，如果未找到匹配则返回空列表。
   */
  public static findMatches(
    fontFamilies: Map<string, Family>,
    opts: FontOpts = FontOpts.DEFAULT
  ): Font[] {
    const familyName = opts.familyName;
    const lang = opts.lang;

    const matchingFamilies = Array.from(fontFamilies.values()).filter(family => {
      return (
        (familyName == null || (family.name && family.name.toLowerCase() === familyName.toLowerCase())) &&
          (lang == null || family.lang === lang)
      );
    });

    return FontHelper.processMatchingFamilies(
      matchingFamilies,
      opts.lang,
      opts.weight,
      opts.style
    );
  }

  /**
   * 在提供的字体族列表中搜索匹配指定条件的字体，返回有序的唯一匹配列表。
   *
   * @param fontFamiliesList 要搜索的 [Family] 对象列表。
   * @param opts 指定所需字体特征（族、语言、字重、样式）的 [FontOpts]。
   * @return 匹配条件的唯一 [Font] 对象列表，按优先级排序，如果未找到匹配则返回空列表。
   */
  public static findMatchesList(
    fontFamiliesList: Family[],
    opts: FontOpts = FontOpts.DEFAULT
  ): Font[] {
    const familyName = opts.familyName;
    const lang = opts.lang;

    const matchingFamilies = fontFamiliesList.filter(family => {
      return (
        (familyName == null || (family.name && family.name.toLowerCase() === familyName.toLowerCase())) &&
          (lang == null || family.lang === lang)
      );
    });

    return FontHelper.processMatchingFamilies(
      matchingFamilies,
      opts.lang,
      opts.weight,
      opts.style
    );
  }

  /**
   * 处理匹配的字体族，根据语言、字重和样式进行过滤和排序。
   */
  private static processMatchingFamilies(
    matchingFamilies: Family[],
    requestedLang: string | null,
    requestedWeight: Weight | null,
    requestedStyle: string | null
  ): Font[] {
    // 分离命名和未命名的族
    const namedFamilies: Family[] = [];
    const unnamedFamilies: Family[] = [];

    matchingFamilies.forEach(family => {
      if (family.name && family.name.trim().length > 0) {
        namedFamilies.push(family);
      } else {
        unnamedFamilies.push(family);
      }
    });

    // 按语言匹配优先级排序族
    const sortedNamedFamilies = namedFamilies.sort((a, b) => {
      const aMatch = a.lang === requestedLang ? 1 : 0;
      const bMatch = b.lang === requestedLang ? 1 : 0;
      return bMatch - aMatch;
    });

    const sortedUnnamedFamilies = unnamedFamilies.sort((a, b) => {
      const aMatch = a.lang === requestedLang ? 1 : 0;
      const bMatch = b.lang === requestedLang ? 1 : 0;
      return bMatch - aMatch;
    });

    const resultFonts = new Set<Font>();

    FontHelper.filterFamilies(sortedNamedFamilies, resultFonts, requestedWeight, requestedStyle);
    FontHelper.filterFamilies(sortedUnnamedFamilies, resultFonts, requestedWeight, requestedStyle);

    return Array.from(resultFonts);
  }

  /**
   * 根据字重和样式过滤字体族，并将它们添加到结果集中以确保唯一性。
   */
  private static filterFamilies(
    families: Family[],
    resultSet: Set<Font>,
    weight: Weight | null,
    style: string | null
  ): void {
    families.forEach(family => {
      const fontsForWeight = weight == null
        ? Array.from(family.fonts.values()).flat()
        : (family.fonts.get(weight) || []);

      fontsForWeight.forEach(font => {
        if (style == null || style.trim().length === 0 || font.style === style) {
          resultSet.add(font);
        }
      });
    });
  }

  /**
   * 从系统的字体路径中获取指定字体的文件。
   *
   * @param font 表示要查找字体的 [Font] 对象。
   * @return 指向字体文件的文件路径字符串，如果文件不存在则返回 `null`。
   */
  public static getFontFile(font: Font): string | null {
    for (const basePath of SystemFontsParser.SYSTEM_FONTS_PATHS) {
      const filePath = `${basePath}${font.name.trim()}`;
      try {
        const stat = fs.statSync(filePath);
        if (stat.isFile()) {
          return filePath;
        }
      } catch (e) {
        // 文件不存在，继续查找
      }
    }
    return null;
  }

  /**
   * 读取并返回指定字体文件的字节。
   *
   * @param font 表示要读取字体的 [Font] 对象。
   * @return 包含字体文件字节的 [Uint8Array]，如果无法找到或读取文件则返回 `null`。
   */
  public static getFontBytes(font: Font): Uint8Array | null {
    const filePath = FontHelper.getFontFile(font);
    if (!filePath) {
      return null;
    }

    try {
      const file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      const stat = fs.statSync(filePath);
      const buffer = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buffer);
      fs.closeSync(file);
      return new Uint8Array(buffer);
    } catch (e) {
      console.error(`${TAG}: Error reading font file: ${e}`);
      return null;
    }
  }

  /**
   * 过滤掉文件系统上不存在的字体。
   */
  private static filterNonExistingFontsMap(
    fontFamilies: Map<string, Family>
  ): Map<string, Family> {
    if (fontFamilies.size === 0) {
      return fontFamilies;
    }

    const familiesList = Array.from(fontFamilies.values());
    const filteredList = FontHelper.filterNonExistingFonts(familiesList);

    // 使用与原始相同的键逻辑重建映射
    const result = new Map<string, Family>();
    filteredList.forEach(family => {
      const mapKey = (family.name && family.name.trim().length > 0)
        ? family.name
        : (family.fonts.size > 0 ? Array.from(family.fonts.values())[0][0]?.name : '');
      if (mapKey) {
        result.set(mapKey, family);
      }
    });

    return result;
  }

  private static filterNonExistingFonts(fontFamilies: Family[]): Family[] {
    if (fontFamilies.length === 0) {
      return fontFamilies;
    }

    return fontFamilies.map(family => {
      const existingFonts = new Map<Weight, Font[]>();
      family.fonts.forEach((fontList, weight) => {
        const filtered = fontList.filter(font => FontHelper.getFontFile(font) != null);
        if (filtered.length > 0) {
          existingFonts.set(weight, filtered);
        }
      });

      if (existingFonts.size > 0) {
        return new Family(existingFonts, family.name, family.variant, family.lang);
      } else {
        return null;
      }
    }).filter(family => family != null) as Family[];
  }

  /**
   * 获取由可选字体选项指定的回退字体的字节数组。
   *
   * @param opts 可选的 [FontOpts] 指定所需的字体特征。如果未提供，则使用默认选项。
   * @return 包含字体数据的 [Uint8Array]，如果未找到合适的字体或访问字体文件时出错则返回 `null`。
   */
  public static getFallbackFontBytes(context: Context, opts: FontOpts | null = null): Uint8Array | null {
    const font = FontHelper.getFallbackFont(context, opts ?? FontOpts.DEFAULT);
    if (!font) {
      return null;
    }
    return FontHelper.getFontBytes(font);
  }

  /**
   * 重置缓存（用于测试）
   */
  public static resetForTesting(): void {
    FontHelper.familiesMapCache = null;
    FontHelper.familiesListCache = null;
  }
}

/**
 * 系统字体解析器
 */
export class SystemFontsParser {
  private static readonly TAG: string = 'SystemFontsParser';
  public static readonly FONTS_XML_PATH: string = 'fonts.xml';
  public static readonly SYSTEM_FONTS_PATHS: string[] = [
    'resources/rawfile/fonts/',
  ];

  /**
   * 解析字体 XML 为映射
   */
  public static parseFontsXMLMap(xmlFileStream: Uint8Array): Map<string, Family> {
    // 先解析为 Family 列表，再根据与 Kotlin 实现一致的 key 规则构建 Map
    const familiesList = SystemFontsParser.parseFontsXML(xmlFileStream);
    const result = new Map<string, Family>();

    familiesList.forEach(family => {
      const mapKey = (family.name && family.name.trim().length > 0)
        ? family.name
        : (family.fonts.size > 0 ? Array.from(family.fonts.values())[0][0]?.name : '');
      if (mapKey) {
        result.set(mapKey, family);
      }
    });

    return result;
  }

  /**
   * 解析字体 JSON 为列表
   */
  public static parseFontsJSON(jsonFileStream: Uint8Array): Family[] {
    const families: Family[] = [];

    // 定义明确的类型
    interface FontData {
      weight?: number;
      style?: string;
      name?: string;
      ttcIndex?: number;
      postScriptName?: string;
      fallbackFor?: string;
    }

    interface FamilyData {
      name?: string;
      variant?: string;
      lang?: string;
      fonts?: FontData[];
    }

    interface AliasData {
      name: string;
      original: string;
    }

    interface FontsConfig {
      families?: FamilyData[];
      aliases?: AliasData[];
    }

    try {
      // 将 Uint8Array 转换为字符串，使用循环替换Function.apply，ArkTS不支持Function.apply和Function.call
      const buffer = new Uint8Array(jsonFileStream.buffer);
      let jsonString: string = '';
      for (let i = 0; i < buffer.length; i++) {
        jsonString += String.fromCharCode(buffer[i]);
      }
      // 解析 JSON
      const jsonData: FontsConfig = JSON.parse(jsonString);

      // 处理字体族
      if (jsonData.families && Array.isArray(jsonData.families)) {
        jsonData.families.forEach((familyData: FamilyData) => {
          const currentFonts: Map<Weight, Font[]> = new Map<Weight, Font[]>();

          // 处理字体
          if (familyData.fonts && Array.isArray(familyData.fonts)) {
            familyData.fonts.forEach((fontData: FontData) => {
              // 解析字体属性
              const weight = Weight.fromInt(fontData.weight || 400);
              const style = fontData.style || FONT_STYLE_NORMAL;
              const name = fontData.name || '';
              const ttcIndex = fontData.ttcIndex || 0;
              const postScriptName = fontData.postScriptName || null;
              const fallbackFor = fontData.fallbackFor || null;

              // 创建 Font 对象
              const font = new Font(
                weight,
                style,
                name,
                null, // 暂时不处理 axis
                ttcIndex,
                postScriptName,
                fallbackFor
              );

              // 将字体添加到对应字重的列表中
              const key = weight;
              const list = currentFonts.get(key) ?? [];
              list.push(font);
              currentFonts.set(key, list);
            });
          }

          // 创建 Family 对象并添加到结果列表中
          if (currentFonts.size > 0) {
            families.push(new Family(
              currentFonts,
              familyData.name || null,
              familyData.variant || null,
              familyData.lang || null
            ));
          }
        });
      }

      // 处理别名（aliases）
      if (jsonData.aliases && Array.isArray(jsonData.aliases)) {
        const aliases: AliasData[] = jsonData.aliases;

        // 创建现有字体族名称的集合
        const familyNames = new Set<string>();
        families.forEach(family => {
          if (family.name) {
            familyNames.add(family.name);
          }
        });

        // 第一次遍历：处理直接别名
        for (const alias of aliases) {
          if (!familyNames.has(alias.name)) {
            const originalFamily = families.find(family => family.name === alias.original);
            if (originalFamily) {
              // 为别名创建新的字体族，复制原始字体族的属性
              const aliasFamily = new Family(
                originalFamily.fonts,
                alias.name,
                originalFamily.variant,
                originalFamily.lang
              );
              families.push(aliasFamily);
              familyNames.add(alias.name);
            }
          }
        }

        // 第二次遍历：处理嵌套别名（如果有的话）
        let progress = true;
        const unresolvedAliases: AliasData[] = [...aliases];

        while (progress && unresolvedAliases.length > 0) {
          progress = false;
          const iterator = unresolvedAliases.entries();
          let result = iterator.next();

          while (!result.done) {
            // 使用传统变量声明替换解构赋值
            const entry = result.value;
            const index = entry[0];
            const alias = entry[1];

            if (!familyNames.has(alias.name)) {
              const originalFamily = families.find(family => family.name === alias.original);
              if (originalFamily) {
                // 为别名创建新的字体族
                const aliasFamily = new Family(
                  originalFamily.fonts,
                  alias.name,
                  originalFamily.variant,
                  originalFamily.lang
                );
                families.push(aliasFamily);
                familyNames.add(alias.name);
                unresolvedAliases.splice(index, 1);
                progress = true;
                break;
              }
            } else {
              // 别名已解决，从待处理列表中移除
              unresolvedAliases.splice(index, 1);
              progress = true;
              break;
            }

            result = iterator.next();
          }
        }
      }
    } catch (e) {
      console.error(`${SystemFontsParser.TAG}: Error parsing fonts JSON: ${e}`);
    }

    return families;
  }

  /**
   * 解析字体 JSON 为映射
   */
  public static parseFontsJSONMap(jsonFileStream: Uint8Array): Map<string, Family> {
    // 先解析为 Family 列表，再根据与 Kotlin 实现一致的 key 规则构建 Map
    const familiesList = SystemFontsParser.parseFontsJSON(jsonFileStream);
    const result = new Map<string, Family>();

    familiesList.forEach(family => {
      const mapKey = (family.name && family.name.trim().length > 0)
        ? family.name
        : (family.fonts.size > 0 ? Array.from(family.fonts.values())[0][0]?.name : '');
      if (mapKey) {
        result.set(mapKey, family);
      }
    });

    return result;
  }

  /**
   * 解析字体 XML 为列表
   */
  public static parseFontsXML(xmlFileStream: Uint8Array): Family[] {
    const families: Family[] = [];

    // 当前正在解析的 family 及其属性
    let currentFamilyName: string | null = null;
    let currentFamilyVariant: string | null = null;
    let currentFamilyLang: string | null = null;
    let currentFonts: Map<Weight, Font[]> = new Map<Weight, Font[]>();

    // 当前正在解析的 font 属性
    let currentWeight: Weight = Weight.NORMAL;
    let currentStyle: string = FONT_STYLE_NORMAL;
    let currentTtcIndex: number = 0;
    let currentPostScriptName: string | null = null;
    let currentFallbackFor: string | null = null;

    const flushCurrentFamily = (): void => {
      if (currentFamilyName !== null && currentFonts.size > 0) {
        families.push(new Family(
          currentFonts,
          currentFamilyName,
          currentFamilyVariant,
          currentFamilyLang
        ));
      }
      // 重置 family 状态
      currentFamilyName = null;
      currentFamilyVariant = null;
      currentFamilyLang = null;
      currentFonts = new Map<Weight, Font[]>();
    };

    const parser = new xml.XmlPullParser(xmlFileStream.buffer as ArrayBuffer, 'UTF-8');

    // 处理标签文本（主要用于 <font>filename.ttf</font>）
    const tagValueCallbackFunction = (name: string, value: string): boolean => {
      const trimmed = value ? value.trim() : '';
      if (name === 'font' && trimmed.length > 0 && currentFamilyName !== null) {
        const font = new Font(
          currentWeight,
          currentStyle,
          trimmed,
          null,
          currentTtcIndex,
          currentPostScriptName,
          currentFallbackFor
        );

        const key = currentWeight;
        const list = currentFonts.get(key) ?? [];
        list.push(font);
        currentFonts.set(key, list);

        // 重置当前 font 局部状态（文件名已消费）
        currentTtcIndex = 0;
        currentPostScriptName = null;
        currentFallbackFor = null;
      }
      return true;
    };

    // 处理属性（family 的 name/lang/variant 以及 font 的 weight/style/index/postScriptName/fallbackFor）
    const attributeValueCallbackFunction = (name: string, value: string): boolean => {
      const trimmed = value ? value.trim() : '';

      switch (name) {
        case 'name':
          // 如果已有一个 family 且已经收集到字体，则在遇到新的 name 时刷新上一个 family
          if (currentFamilyName !== null && currentFonts.size > 0) {
            flushCurrentFamily();
          }
          currentFamilyName = trimmed;
          break;
        case 'lang':
          currentFamilyLang = trimmed || null;
          break;
        case 'variant':
          currentFamilyVariant = trimmed || null;
          break;
        case 'weight':
          currentWeight = Weight.fromString(trimmed);
          break;
        case 'style':
          currentStyle = trimmed || FONT_STYLE_NORMAL;
          break;
        case 'index':
          currentTtcIndex = trimmed ? parseInt(trimmed, 10) || 0 : 0;
          break;
        case 'postScriptName':
          currentPostScriptName = trimmed || null;
          break;
        case 'fallbackFor':
          currentFallbackFor = trimmed || null;
          break;
        default:
          break;
      }
      return true;
    };

    try {
      parser.parse({
        supportDoctype: true,
        ignoreNameSpace: true,
        tagValueCallbackFunction,
        attributeValueCallbackFunction
      });
    } catch (e) {
      console.error(`${SystemFontsParser.TAG}: parseFontsXML error: ${e}`);
    }

    // 处理最后一个 family
    if (currentFamilyName !== null && currentFonts.size > 0) {
      families.push(new Family(
        currentFonts,
        currentFamilyName,
        currentFamilyVariant,
        currentFamilyLang
      ));
    }

    return families;
  }
}

/**
 * 原生字体辅助对象
 */
export class NativeFontHelper {

  public static cppRegisterFallbackFont(fontBytes: Uint8Array): boolean {
    const fontByteList: number[] = Array.from(fontBytes);
    console.warn('NativeFontHelper.cppRegisterFallbackFont not yet implemented');
    return rive.Napi_Font_cppRegisterFallbackFont(fontBytes);
    // return rive.Napi_Font_cppRegisterFallbackFont(fontByteList);
  }
}

