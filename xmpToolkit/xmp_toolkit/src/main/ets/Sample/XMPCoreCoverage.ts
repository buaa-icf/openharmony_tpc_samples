/*
Copyright (c) 2026 Huawei Device Co., Ltd.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import XMPConst from '../XMPConst';
import XMPDateTime from '../XMPDateTime';
import XMPDateTimeFactory from '../XMPDateTimeFactory';
import XMPException from '../XMPException';
import XMPIterator from '../XMPIterator';
import XMPMeta from '../XMPMeta';
import XMPMetaFactory from '../XMPMetaFactory';
import XMPPathFactory from '../XMPPathFactory';
import XMPSchemaRegistry from '../XMPSchemaRegistry';
import PropertyOptions from '../options/PropertyOptions';
import IteratorOptions from '../options/IteratorOptions';
import ParseOptions from '../options/ParseOptions';
import SerializeOptions from '../options/SerializeOptions';
import XMPAliasInfo from '../properties/XMPAliasInfo';
import XMPProperty from '../properties/XMPProperty';
import XMPPropertyInfo from '../properties/XMPPropertyInfo';
import { NS1, NS2, RDF_COVERAGE, SIMPLE_RDF, NAMESPACE_RDF, XMPMETA_RDF, NEWLINE_RDF, INCONSISTENT_RDF, DATETIME_RDF } from './XMPCoreCoverageConst';
import { util } from '@kit.ArkTS';

/**
 * XMPCore示例应用
 * 涵盖XMPCore的大部分功能，但不提供任何有意义的工作流
 */
export default class XMPCoreCoverage {
  /** 快捷键到模式注册表 */
  private static registry: XMPSchemaRegistry = XMPMetaFactory.getSchemaRegistry();
  
  /**
   * 运行示例
   */
  public static async main(): Promise<void> {
    try {
      console.log('XMPCoreCoverage starting   ' + new Date());
      
      try {
        const versionInfo = XMPMetaFactory.getVersionInfo();
        console.log('XMPCore Version: ' + JSON.stringify(versionInfo));
      } catch (e) {
        console.log('Error getting version info: ' + (e as Error).message);
        throw new Error(e);
      }
      
      console.log('\n');
      console.log('Starting doCoreCoverage...');

      await XMPCoreCoverage.doCoreCoverage();

      console.log('\n');
      console.log('\n');
      console.log('XMPCoreCoverage ending   ' + new Date());
    } catch (e) {
      console.log('=== ERROR CAUGHT ===');
      if (e instanceof XMPException) {
        console.log('Caught XMPException ' + e.getErrorCode() + ' :   ' + e.message);
        console.log('Stack: ' + (e.stack || 'No stack trace'));
      } else {
        const error = e as Error;
        console.log('Caught Throwable: ' + error.message);
        console.log('Stack: ' + (error.stack || 'No stack trace'));
        console.log('Error type: ' + (error.constructor?.name || 'Unknown'));
      }
      throw new Error(e); // 重新抛出以便 UI 能捕获
    }
  }
  
  /**
   * 运行解释XMPCore某些功能的示例函数
   * @throws Exception 转发异常
   */
  private static async doCoreCoverage(): Promise<void> {
    try {
      console.log('[1/15] Testing namespace registry...');
      XMPCoreCoverage.coverNamespaceRegistry();
      
      console.log('[2/15] Testing alias registry...');
      XMPCoreCoverage.coverAliasRegistry();
      
      console.log('[3/15] Testing XMP creation...');
      XMPCoreCoverage.coverCreatingXMP();
      
      console.log('[4/15] Testing set property methods...');
      const meta: XMPMeta = XMPCoreCoverage.coverSetPropertyMethods();
      
      console.log('[5/15] Testing get property methods...');
      XMPCoreCoverage.coverGetPropertyMethods(meta);
      
      console.log('[6/15] Testing existing properties...');
      XMPCoreCoverage.coverExistingProperties(meta);
      
      console.log('[7/15] Testing delete properties...');
      XMPCoreCoverage.coverDeleteProperties(meta);
      
      console.log('[8/15] Testing localised properties...');
      XMPCoreCoverage.coverLocalisedProperties();
      
      console.log('[9/15] Testing literal properties...');
      XMPCoreCoverage.coverLiteralProperties();
      
      console.log('[10/15] Testing parsing...');
      XMPCoreCoverage.coverParsing();
      
      console.log('[11/15] Testing linefeed values...');
      await XMPCoreCoverage.coverLinefeedValues();
      
      console.log('[12/15] Testing serialization...');
      await XMPCoreCoverage.coverSerialization();
      
      console.log('[13/15] Testing iterator...');
      XMPCoreCoverage.coverIterator();
      
      console.log('[14/15] Testing path creation...');
      XMPCoreCoverage.coverPathCreation();
      
      console.log('[15/15] Testing date time...');
      XMPCoreCoverage.coverDateTime();
      
      console.log('All tests completed successfully!');
    } catch (e) {
      console.log('Error in doCoreCoverage: ' + (e as Error).message);
      console.log('Stack: ' + ((e as Error).stack || 'No stack trace'));
      throw new Error(e);
    }
  }
  
  /**
   * 列出预定义命名空间和别名；
   * 注册新的命名空间和别名
   * @throws XMPException 转发异常
   */
  private static coverNamespaceRegistry(): void {
    XMPCoreCoverage.writeMajorLabel("Test of namespace registry");
    
    // 列出预定义命名空间
    XMPCoreCoverage.writeMinorLabel("List predefined namespaces");
    const namespaces: Map<string, string> = XMPCoreCoverage.registry.getNamespaces();
    namespaces.forEach((namespace, prefix) => {
      console.log(prefix + "   --->   " + namespace);
    });
    
    // 注册命名空间函数
    XMPCoreCoverage.writeMinorLabel("Test namespace registry functions");
    
    let prefix: string = XMPCoreCoverage.registry.registerNamespace(NS1, "ns1");
    console.log("registerNamespace ns1:   " + prefix + "   --->   " + 
      XMPCoreCoverage.registry.getNamespaceURI(prefix));
    
    prefix = XMPCoreCoverage.registry.registerNamespace(NS2, "ns2");
    console.log("registerNamespace ns2:   " + prefix + "   --->   " + 
      XMPCoreCoverage.registry.getNamespaceURI(prefix));
    
    const prefixResult: string | null = XMPCoreCoverage.registry.getNamespacePrefix(NS1);
    console.log("getNamespacePrefix ns1:   " + (prefixResult || "null"));
    
    const ns: string | null = XMPCoreCoverage.registry.getNamespaceURI("ns1");
    console.log("getNamespaceURI ns1:   " + ns);
    
    prefix = XMPCoreCoverage.registry.getNamespacePrefix("bogus") || "null";
    console.log("getNamespacePrefix bogus:   " + prefix);
    
    const bogusNs: string | null = XMPCoreCoverage.registry.getNamespaceURI("bogus");
    console.log("getNamespaceURI bogus:   " + (bogusNs || "null"));
  }
  
  /**
   * 列出预定义别名，注册新别名和解析别名
   * @throws XMPException 转发异常
   */
  private static coverAliasRegistry(): void {
    XMPCoreCoverage.writeMajorLabel("Test alias registry and functions");
    XMPCoreCoverage.dumpAliases();
    
    // 注册新别名
    XMPCoreCoverage.writeMinorLabel("Add ns2: to ns1: aliases");
    
    XMPCoreCoverage.dumpAliases();

    // 解析别名
    XMPCoreCoverage.writeMinorLabel("Resolve ns2: to ns1: aliases");
    
    let aliasInfo: XMPAliasInfo | null = XMPCoreCoverage.registry.resolveAlias(NS1, "SimpleActual");
    console.log("resolveAlias ns1:SimpleActual:   " + aliasInfo + "   (wrong way!)");
    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "SimpleAlias");
    console.log("resolveAlias ns2:SimpleAlias:   " + aliasInfo);

    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "BagAlias");
    console.log("resolveAlias ns2:BagAlias:   " + aliasInfo);
    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "SeqAlias");
    console.log("resolveAlias ns2:SeqAlias:   " + aliasInfo);
    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "AltAlias");
    console.log("resolveAlias ns2:AltAlias:   " + aliasInfo);
    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "AltTextAlias");
    console.log("resolveAlias ns2:AltTextAlias:   " + aliasInfo);

    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "BagItemAlias");
    console.log("resolveAlias ns2:BagItemAlias:   " + aliasInfo);
    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "SeqItemAlias");
    console.log("resolveAlias ns2:SeqItemAlias:   " + aliasInfo);
    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "AltItemAlias");
    console.log("resolveAlias ns2:AltItemAlias:   " + aliasInfo);
    
    aliasInfo = XMPCoreCoverage.registry.resolveAlias(NS2, "AltTextItemAlias");
    console.log("resolveAlias ns2:AltTextItemAlias:   " + aliasInfo);

    
    // set alias properties
    XMPCoreCoverage.writeMinorLabel("Test setProperty through ns2: simple aliases");
    
    const meta: XMPMeta = XMPMetaFactory.create();
    meta.setProperty(NS2, "SimpleAlias", "Simple value");
    meta.setProperty(NS2, "ns2:BagItemAlias", "BagItem value");
    meta.setProperty(NS2, "SeqItemAlias", "SeqItem value");
    meta.setProperty(NS2, "AltItemAlias", "AltItem value");
    meta.setProperty(NS2, "AltTextItemAlias", "AltTextItem value");
    XMPCoreCoverage.printXMPMeta(meta, "Check for aliases and bases");
    
    // delete aliases
    XMPCoreCoverage.writeMinorLabel("Delete some ns2: to ns1: aliases");
    
    XMPCoreCoverage.dumpAliases();
  }
  
  /**
   * 转储所有别名
   */
  private static dumpAliases(): void {
    console.log("Dumping all aliases (implementation dependent)");
    const aliases: Map<string, XMPAliasInfo> = XMPCoreCoverage.registry.getAliases();
    aliases.forEach((aliasInfo, qname) => {
      console.log("" + qname + "   --->   " + aliasInfo);
    });

  }
  
  /**
   * 测试简单构造函数和解析，设置实例ID
   * @throws XMPException 转发异常
   */
  private static coverCreatingXMP(): void {
    XMPCoreCoverage.writeMajorLabel("Test simple constructors and parsing, setting the instance ID");
    
    const meta1: XMPMeta = XMPMetaFactory.create();
    XMPCoreCoverage.printXMPMeta(meta1, "Empty XMP object");
    
    const meta2: XMPMeta = XMPMetaFactory.create();
    meta2.setObjectName("New object name");
    XMPCoreCoverage.printXMPMeta(meta2, "XMP object with name");
    
    const meta3: XMPMeta = XMPMetaFactory.parseFromString(RDF_COVERAGE);
    XMPCoreCoverage.printXMPMeta(meta3, "Construct and parse from buffer");
    
    meta3.setProperty(XMPConst.NS_XMP_MM, "InstanceID", "meta2:Original");
    XMPCoreCoverage.printXMPMeta(meta3, "Add instance ID");
    
    const meta4: XMPMeta = meta3.clone() as XMPMeta;
    meta4.setProperty(XMPConst.NS_XMP_MM, "InstanceID", "meta2:Clone");
    XMPCoreCoverage.printXMPMeta(meta3, "Clone and add instance ID");
  }
  
  /**
   * 覆盖一些基本的set调用（包括数组和结构体）
   * @return 返回一个<code>XMPMeta</code>对象，在接下来的示例中重用
   * @throws XMPException 转发异常
   */
  private static coverSetPropertyMethods(): XMPMeta {
    // 基本的set/get方法
    XMPCoreCoverage.writeMajorLabel("Test setProperty and related methods");
    
    const meta: XMPMeta = XMPMetaFactory.create();
    meta.setProperty(NS1, "Prop", "Prop value");
    meta.setProperty(NS1, "ns1:XMLProp", "<PropValue/>");
    meta.setProperty(NS1, "ns1:URIProp", "URI:value/", new PropertyOptions().setURI(true));
    
    meta.appendArrayItem(NS1, "Bag", new PropertyOptions().setArray(true), "BagItem value", null);
    meta.appendArrayItem(NS1, "ns1:Seq", new PropertyOptions().setArrayOrdered(true), "SeqItem value", null);
    meta.appendArrayItem(NS1, "ns1:Alt", new PropertyOptions().setArrayAlternate(true), "AltItem value", null);
    
    meta.setArrayItem(NS1, "Bag", 1, "BagItem 3");
    meta.insertArrayItem(NS1, "ns1:Bag", 1, "BagItem 1");
    meta.insertArrayItem(NS1, "ns1:Bag", 2, "BagItem 2");
    meta.appendArrayItem(NS1, "Bag", "BagItem 4");
    
    meta.setStructField(NS1, "Struct", NS2, "Field1", "Field1 value");
    meta.setStructField(NS1, "ns1:Struct", NS2, "Field2", "Field2 value");
    meta.setStructField(NS1, "ns1:Struct", NS2, "Field3", "Field3 value");
    
    XMPCoreCoverage.printXMPMeta(meta, "A few basic set property calls");
    
    // -----------------------------------------------------------------------------------------
    
    // 添加一些带有限定符的属性
    XMPCoreCoverage.writeMinorLabel("Add some properties with qualifier");
    console.log("CountArrayItems Bag = " + meta.countArrayItems(NS1, "Bag"));
    
    meta.setProperty(NS1, "QualProp1", "Prop value");
    meta.setQualifier(NS1, "QualProp1", NS2, "Qual1", "Qual1 value");
    meta.setProperty(NS1, "QualProp1/?ns2:Qual3", "Qual3 value");
    meta.setProperty(NS1, "QualProp1/?xml:lang", "x-qual");
    
    meta.setProperty(NS1, "QualProp2", "Prop value");
    meta.setQualifier(NS1, "QualProp2", XMPConst.NS_XML, "lang", "en-us");
    meta.setProperty(NS1, "QualProp2/@xml:lang", "x-attr");
    
    meta.setProperty(NS1, "QualProp3", "Prop value");
    meta.setQualifier(NS1, "ns1:QualProp3", XMPConst.NS_XML, "xml:lang", "en-us");
    meta.setQualifier(NS1, "ns1:QualProp3", NS2, "ns2:Qual", "Qual value");
    
    meta.setProperty(NS1, "QualProp4", "Prop value");
    meta.setQualifier(NS1, "QualProp4", NS2, "Qual", "Qual value");
    meta.setQualifier(NS1, "QualProp4", XMPConst.NS_XML, "lang", "en-us");
    XMPCoreCoverage.printXMPMeta(meta, "Add some qualifiers");
    
    meta.setProperty(NS1, "QualProp1", "new value");
    meta.setProperty(NS1, "QualProp2", "new value");
    meta.setProperty(NS1, "QualProp3", "new value");
    meta.setProperty(NS1, "QualProp4", "new value");
    XMPCoreCoverage.printXMPMeta(meta, "Change values and keep qualifiers");
    
    return meta;
  }
  
  /**
   * 测试getProperty, deleteProperty和相关方法
   * @param meta 预定义的<code>XMPMeta</code>对象
   * @throws XMPException 转发异常
   */
  private static coverGetPropertyMethods(meta: XMPMeta): void {
    XMPCoreCoverage.writeMajorLabel("Test getProperty, deleteProperty and related methods");
    
    meta.deleteProperty(NS1, "QualProp1"); // ! Start with fresh qualifiers.
    meta.deleteProperty(NS1, "ns1:QualProp2");
    meta.deleteProperty(NS1, "ns1:QualProp3");
    meta.deleteProperty(NS1, "QualProp4");
    
    XMPCoreCoverage.writeMinorLabel("Set properties with qualifier");
    
    meta.setProperty(NS1, "QualProp1", "Prop value");
    meta.setQualifier(NS1, "QualProp1", NS2, "Qual1", "Qual1 value");
    
    meta.setProperty(NS1, "QualProp2", "Prop value");
    meta.setQualifier(NS1, "QualProp2", XMPConst.NS_XML, "lang", "en-us");
    
    meta.setProperty(NS1, "QualProp3", "Prop value");
    meta.setQualifier(NS1, "QualProp3", XMPConst.NS_XML, "lang", "en-us");
    meta.setQualifier(NS1, "QualProp3", NS2, "Qual", "Qual value");
    
    meta.setProperty(NS1, "QualProp4", "Prop value");
    meta.setQualifier(NS1, "QualProp4", NS2, "Qual", "Qual value");
    meta.setQualifier(NS1, "QualProp4", XMPConst.NS_XML, "lang", "en-us");
    
    XMPCoreCoverage.printXMPMeta(meta, "XMP object");
    
    XMPCoreCoverage.writeMinorLabel("Get simple properties");
    
    let property: XMPProperty | null = meta.getProperty(NS1, "Prop");
    if (property) {
      console.log("getProperty ns1:Prop =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getProperty(NS1, "ns1:XMLProp");
    if (property) {
      console.log("getProperty ns1:XMLProp =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getProperty(NS1, "ns1:URIProp");
    if (property) {
      console.log("getProperty ns1:URIProp =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getArrayItem(NS1, "Bag", 2);
    if (property) {
      console.log("getArrayItem ns1:Bag[2] =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    try {
      meta.getArrayItem(null as ESObject, "ns1:Bag", 1);
    } catch (e) {
      if (e instanceof XMPException) {
        console.log("getArrayItem with no schema URI - threw XMPException #" + e.getErrorCode() + " :   " + e.message + ")");
      }
    }
    
    XMPCoreCoverage.writeMinorLabel("Get array items and struct fields");
    
    property = meta.getArrayItem(NS1, "ns1:Seq", 1);
    if (property) {
      console.log("getArrayItem ns1:Seq[1] =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getArrayItem(NS1, "ns1:Alt", 1);
    if (property) {
      console.log("getArrayItem ns1:Alt[1] =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }

    
    property = meta.getStructField(NS1, "Struct", NS2, "Field1");
    if (property) {
      console.log("getStructField ns1:Struct/ns2:Field1 =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getStructField(NS1, "ns1:Struct", NS2, "Field2");
    if (property) {
      console.log("getStructField ns1:Struct/ns2:Field2 =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getStructField(NS1, "ns1:Struct", NS2, "ns2:Field3");
    if (property) {
      console.log("getStructField ns1:Struct/ns2:Field3 =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getStructField(NS1, "ns1:Struct", NS2, "ns2:Field3");
    if (property) {
      console.log("getStructField ns1:Struct/ns2:Field3 =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getStructField(NS1, "ns1:Struct", NS2, "ns2:Field3");
    if (property) {
      console.log("getStructField ns1:Struct/ns2:Field3 =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }

    
    XMPCoreCoverage.writeMinorLabel("Get qualifier");
    
    property = meta.getQualifier(NS1, "QualProp1", NS2, "Qual1");
    if (property) {
      console.log("getQualifier  ns1:QualProp1/?ns2:Qual1 =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    try {
      meta.getQualifier(null as ESObject, "ns1:QualProp1", NS2, "Qual1");
    } catch (e) {
      if (e instanceof XMPException) {
        console.log("getQualifier with no schema URI - threw XMPException #" + e.getErrorCode() + " :   " + e.message);
      }
    }
    
    property = meta.getQualifier(NS1, "QualProp3", XMPConst.NS_XML, "xml:lang");
    if (property) {
      console.log("getQualifier ns1:QualProp3/@xml-lang =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getQualifier(NS1, "QualProp3", NS2, "ns2:Qual");
    if (property) {
      console.log("getQualifier ns1:QualProp3/?ns2:Qual =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }

    
    XMPCoreCoverage.writeMinorLabel("Get non-simple properties");
    
    property = meta.getProperty(NS1, "Bag");
    if (property) {
      console.log("getProperty ns1:Bag =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getProperty(NS1, "Seq");
    if (property) {
      console.log("getProperty ns1:Seq =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getProperty(NS1, "Alt");
    if (property) {
      console.log("getProperty ns1:Alt =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }
    
    property = meta.getProperty(NS1, "Struct");
    if (property) {
      console.log("getProperty ns1:Struct =   " + property.getValue() + " (" + property.getOptions().toString() + ")");
    }

    
    XMPCoreCoverage.writeMinorLabel("Get not existing properties");
    
    try {
      meta.getProperty("ns:bogus/", "Bogus");
    } catch (e) {
      if (e instanceof XMPException) {
        console.log("getProperty with bogus schema URI - threw XMPException #" + e.getErrorCode() + " :   " + e.message);
      }
    }
    
    property = meta.getProperty(NS1, "Bogus");
    console.log("getProperty ns1:Bogus (not existing) =   " + property);
    
    property = meta.getArrayItem(NS1, "Bag", 99);
    console.log("ArrayItem ns1:Bag[99] (not existing) =   " + property);
    
    property = meta.getStructField(NS1, "Struct", NS2, "Bogus");
    console.log("getStructField ns1:Struct/ns2:Bogus (not existing) =   " + property);
    
    property = meta.getQualifier(NS1, "Prop", NS2, "Bogus");
    console.log("getQualifier ns1:Prop/?ns2:Bogus (not existing) =   " + property);
  }
  
  /**
   * 测试现有属性
   * @param meta XMPMeta对象
   */
  private static coverExistingProperties(meta: XMPMeta): void {
    XMPCoreCoverage.writeMajorLabel("Test doesPropertyExist, deleteProperty, and related methods");
    
    XMPCoreCoverage.printXMPMeta(meta, "XMP object");
    
    console.log("doesPropertyExist ns1:Prop =    " + meta.doesPropertyExist(NS1, "Prop"));
    console.log("doesPropertyExist ns1:Struct =    " + meta.doesPropertyExist(NS1, "ns1:Struct"));
    console.log("doesArrayItemExist ns1:Bag[2] =    " + meta.doesArrayItemExist(NS1, "Bag", 2));
    console.log("doesArrayItemExist ns1:Seq[last()] =    " + meta.doesArrayItemExist(NS1, "ns1:Seq", XMPConst.ARRAY_LAST_ITEM));
    console.log("doesStructFieldExist ns1:Struct/ns2:Field1 =    " + meta.doesStructFieldExist(NS1, "Struct", NS2, "Field1"));
    console.log("doesQualifierExist ns1:QualProp1/?ns2:Qual1 =    " + meta.doesQualifierExist(NS1, "QualProp1", NS2, "Qual1"));
    console.log("doesQualifierExist ns1:QualProp2/?xml:lang =    " + meta.doesQualifierExist(NS1, "QualProp2", XMPConst.NS_XML, "lang"));

    console.log("doesPropertyExist (namespace is null) =    " + meta.doesPropertyExist(null, "ns1:Bag"));
    console.log("doesArrayItemExist (namespace is null) =    " + meta.doesArrayItemExist(null, "ns1:Bag", XMPConst.ARRAY_LAST_ITEM));
    console.log("doesQualifierExist ns:Bogus (namespace not existing) =    " + meta.doesPropertyExist("ns:bogus/", "Bogus"));
    console.log("doesPropertyExist ns1:Bogus =    " + meta.doesPropertyExist(NS1, "Bogus"));
    console.log("doesArrayItemExist ns1:Bag[99] =    " + meta.doesArrayItemExist(NS1, "Bag", 99));
    console.log("doesStructFieldExist ns1:Struct/ns2:Bogus =    " + meta.doesStructFieldExist(NS1, "Struct", NS2, "Bogus"));
    console.log("doesQualifierExist ns1:Prop/?ns2:Bogus =    " + meta.doesQualifierExist(NS1, "Prop", NS2, "Bogus"));
  }
  
  /**
   * 测试删除属性
   * @param meta XMPMeta对象
   * @throws XMPException 转发异常
   */
  private static coverDeleteProperties(meta: XMPMeta): void {
    XMPCoreCoverage.writeMajorLabel("Test deleteProperty");
    
    meta.deleteProperty(NS1, "Prop");
    meta.deleteArrayItem(NS1, "Bag", 2);
    meta.deleteStructField(NS1, "Struct", NS2, "Field1");
    
    XMPCoreCoverage.printXMPMeta(meta, "Delete Prop, Bag[2], and Struct1/Field1");
    
    meta.deleteQualifier(NS1, "QualProp1", NS2, "Qual1");
    meta.deleteQualifier(NS1, "QualProp2", XMPConst.NS_XML, "lang");
    meta.deleteQualifier(NS1, "QualProp3", NS2, "Qual");
    meta.deleteQualifier(NS1, "QualProp4", XMPConst.NS_XML, "lang");
    
    XMPCoreCoverage.printXMPMeta(meta,
      "Delete QualProp1/?ns2:Qual1, QualProp2/?xml:lang, " +
      "QualProp3:/ns2:Qual, and QualProp4/?xml:lang");
    
    meta.deleteProperty(NS1, "Bag");
    meta.deleteProperty(NS1, "Struct");
    
    XMPCoreCoverage.printXMPMeta(meta, "Delete all of Bag and Struct");
  }
  
  /**
   * 测试本地化属性
   * @throws XMPException 转发异常
   */
  private static coverLocalisedProperties(): void {
    XMPCoreCoverage.writeMajorLabel("Test setLocalizedText and getLocalizedText");
    
    const meta: XMPMeta = XMPMetaFactory.create();
    meta.setLocalizedText(NS1, "AltText", "", "x-default", "default value", null);
    XMPCoreCoverage.printXMPMeta(meta, "Set x-default value");
    
    meta.setLocalizedText(NS1, "AltText", "en", "en-us", "en-us value", null);
    XMPCoreCoverage.printXMPMeta(meta, "Set en/en-us value");
    
    meta.setLocalizedText(NS1, "AltText", "en", "en-uk", "en-uk value", null);
    XMPCoreCoverage.printXMPMeta(meta, "Set en/en-uk value");

    
    const property: XMPProperty | null = meta.getLocalizedText(NS1, "AltText", "en", "en-ca");
    if (property) {
      console.log("getLocalizedText en/en-ca =   " + property.getValue() + " (lang: " + property.getLanguage() + ", opt: " + property.getOptions().toString() + ")");
    }
    
    const prop: XMPProperty | null = meta.getProperty(NS1, "AltText");
    if (prop) {
      console.log("getProperty ns1:AltText =   " + prop.getValue() + " (lang: " + prop.getLanguage() + ", opt: " + prop.getOptions().toString() + ")");
    }
  }
  
  /**
   * 测试文本属性
   * @throws XMPException 转发异常
   */
  private static coverLiteralProperties(): void {
    XMPCoreCoverage.writeMajorLabel("Test setProperty... and getProperty... methods " +
      "(set/get with literal values)");
    
    const meta: XMPMeta = XMPMetaFactory.parseFromString(DATETIME_RDF);
    const dateValue: XMPDateTime = XMPDateTimeFactory.create(2000, 1, 2, 3, 4, 5, 0);
    
    meta.setPropertyBoolean(NS1, "Bool0", false);
    meta.setPropertyBoolean(NS1, "Bool1", true);
    meta.setPropertyInteger(NS1, "Int", 42);
    meta.setPropertyDouble(NS1, "Double", 4.2);
    
    meta.setPropertyDate(NS1, "Date10", dateValue);
    let offset: number = (6 * 3600 * 1000 + 7 * 60 * 1000) * 1;
    dateValue.setTimeZoneOffset(offset);
    meta.setPropertyDate(NS1, "Date11", dateValue);
    offset *= -1;
    dateValue.setTimeZoneOffset(offset);
    meta.setPropertyDate(NS1, "Date12", dateValue);
    dateValue.setNanoSecond(9);
    meta.setPropertyDate(NS1, "Date13", dateValue);
    
    XMPCoreCoverage.printXMPMeta(meta, "A few basic binary Set... calls");

    
    const bool0: boolean = meta.getPropertyBoolean(NS1, "Bool0");
    console.log("getPropertyBoolean ns1:Bool0 =   " + bool0);
    
    const bool1: boolean = meta.getPropertyBoolean(NS1, "Bool1");
    console.log("getPropertyBoolean ns1:Bool1 =   " + bool1);
    
    const integer: number = meta.getPropertyInteger(NS1, "Int");
    console.log("getPropertyBoolean ns1:Int =   " + integer);
    
    const d: number = meta.getPropertyDouble(NS1, "Double");
    console.log("getPropertyBoolean ns1:Int =   " + d);

    
    for (let i = 1; i <= 13; i++) {
      const dateName: string = "Date" + i;
      const dt: XMPDateTime | null = meta.getPropertyDate(NS1, dateName);
      if (dt) {
        console.log("getPropertyDate (" + i + ") =   " + dt.toString());
        meta.setPropertyDate(NS2, dateName, dateValue);
      }
    }
    
    XMPCoreCoverage.printXMPMeta(meta, "Get and re-set the dates in NS2");
  }
  
  /**
   * 测试解析
   * @throws XMPException 转发异常
   */
  private static coverParsing(): void {
    XMPCoreCoverage.writeMajorLabel("Test parsing with multiple buffers and various options");
    
    let meta: XMPMeta = XMPMetaFactory.parseFromString(SIMPLE_RDF);
    XMPCoreCoverage.printXMPMeta(meta, "Parse from String");
    
    meta = XMPMetaFactory.parseFromString(SIMPLE_RDF, new ParseOptions().setRequireXMPMeta(true));
    XMPCoreCoverage.printXMPMeta(meta, "Parse and require xmpmeta element, which is missing");
    
    meta = XMPMetaFactory.parseFromString(NAMESPACE_RDF);
    XMPCoreCoverage.printXMPMeta(meta, "Parse RDF with multiple nested namespaces");
    
    meta = XMPMetaFactory.parseFromString(XMPMETA_RDF, new ParseOptions().setRequireXMPMeta(true));
    XMPCoreCoverage.printXMPMeta(meta, "Parse and require xmpmeta element, which is present");
    
    meta = XMPMetaFactory.parseFromString(INCONSISTENT_RDF);
    XMPCoreCoverage.printXMPMeta(meta, "Parse and reconcile inconsistent aliases");
    
    try {
      XMPMetaFactory.parseFromString(INCONSISTENT_RDF, new ParseOptions().setStrictAliasing(true));
    } catch (e) {
      if (e instanceof XMPException) {
        console.log("Parse and do not reconcile inconsistent aliases - threw XMPException #" + e.getErrorCode() + " :   " + e.message);
      }
    }
  }
  
  /**
   * 测试换行值
   */
  private static async coverLinefeedValues(): Promise<void> {
    XMPCoreCoverage.writeMajorLabel("Test CR and LF in values");
    
    const valueWithCR: string = "ASCII \r CR";
    const valueWithLF: string = "ASCII \n LF";
    const valueWithCRLF: string = "ASCII \r\n CRLF";
    
    const meta: XMPMeta = XMPMetaFactory.parseFromString(NEWLINE_RDF);
    
    meta.setProperty(NS2, "HasCR", valueWithCR);
    meta.setProperty(NS2, "HasLF", valueWithLF);
    meta.setProperty(NS2, "HasCRLF", valueWithCRLF);
    
    const result: string = await XMPMetaFactory.serializeToString(meta,
                                                new SerializeOptions().setOmitPacketWrapper(true));
    console.log(result);
    
    const hasCR: string = meta.getPropertyString(NS1, "HasCR");
    const hasCR2: string = meta.getPropertyString(NS2, "HasCR");
    const hasLF: string = meta.getPropertyString(NS1, "HasLF");
    const hasLF2: string = meta.getPropertyString(NS2, "HasLF");
    const hasCRLF: string = meta.getPropertyString(NS1, "HasCRLF");
    const hasCRLF2: string = meta.getPropertyString(NS2, "HasCRLF");
    if (hasCR === valueWithCR && hasCR2 === valueWithCR &&
      hasLF === valueWithLF && hasLF2 === valueWithLF &&
      hasCRLF === valueWithCRLF && hasCRLF2 === valueWithCRLF) {

      console.log("\n## HasCR and HasLF and HasCRLF correctly retrieved\n");
    }
  }
  
  /**
   * 测试序列化
   * @throws XMPException 转发异常
   */
  private static async coverSerialization(): Promise<void> {
    XMPCoreCoverage.writeMajorLabel("Test serialization with various options");
    
    const meta: XMPMeta = XMPMetaFactory.parseFromString(SIMPLE_RDF);
    meta.setProperty(NS2, "Another", "Something in another schema");
    meta.setProperty(NS2, "Yet/pdf:More", "Yet more in another schema");
    
    XMPCoreCoverage.printXMPMeta(meta, "Parse simple RDF, serialize with various options");
    
    XMPCoreCoverage.writeMinorLabel("Default serialize");
    console.log(await XMPMetaFactory.serializeToString(meta, undefined));
    
    XMPCoreCoverage.writeMinorLabel("Compact RDF, no packet serialize");
    console.log(await XMPMetaFactory.serializeToString(meta,
                                     new SerializeOptions().setUseCompactFormat(true).setOmitPacketWrapper(true)));
    
    XMPCoreCoverage.writeMinorLabel("Read-only serialize");
    console.log(await XMPMetaFactory.serializeToString(meta, new SerializeOptions().setReadOnlyPacket(true)));
    
    XMPCoreCoverage.writeMinorLabel("Alternate newline serialize");
    console.log(await XMPMetaFactory.serializeToString(meta,
                         new SerializeOptions().setNewline("<--newline-->\n").setOmitPacketWrapper(true)));
    
    XMPCoreCoverage.writeMinorLabel("Alternate indent serialize");
    console.log(await XMPMetaFactory.serializeToString(meta,
                                new SerializeOptions().setIndent("-->").setBaseIndent(5).setOmitPacketWrapper(true)));
    
    XMPCoreCoverage.writeMinorLabel("Small padding serialize");
    console.log(await XMPMetaFactory.serializeToString(meta, new SerializeOptions().setPadding(10)));
    
    XMPCoreCoverage.writeMinorLabel("Serialize with exact packet size");
    const buffer: Uint8Array = await XMPMetaFactory.serializeToBuffer(meta, new SerializeOptions().setReadOnlyPacket(true));
    const s: number = buffer.length;
    console.log("Minimum packet size is " + s + " bytes\n");
    
    // with the flag "exact packet size" the padding becomes the overall length of the packet
    const exactBuffer: Uint8Array = await XMPMetaFactory.serializeToBuffer(meta,
                                            new SerializeOptions().setExactPacketLength(true).setPadding(s));
    // Convert Uint8Array to string (UTF-8)

    let textDecoder = new util.TextDecoder()
    let result: string = textDecoder.decodeToString(exactBuffer);
    console.log(result);
    
    try {
      XMPMetaFactory.parseFromString(await XMPMetaFactory.serializeToString(meta,
        new SerializeOptions().setExactPacketLength(true).setPadding(s - 1)));
    } catch (e) {
      if (e instanceof XMPException) {
        console.log("\nExact packet size smaller than minimal packet length - " +
          "threw XMPException #" + e.getErrorCode() + " :   " + e.message);
      }
    }
  }
  
  /**
   * 测试迭代器
   * @throws XMPException 转发异常
   */
  private static coverIterator(): void {
    XMPCoreCoverage.writeMajorLabel("Test iteration methods");
    
    const meta: XMPMeta = XMPMetaFactory.parseFromString(RDF_COVERAGE);
    meta.setProperty(NS2, "Prop", "Prop value");
    meta.appendArrayItem(NS2, "Bag", new PropertyOptions().setArray(true), "BagItem 2", null);
    meta.appendArrayItem(NS2, "Bag", "BagItem 1");
    meta.appendArrayItem(NS2, "Bag", "BagItem 3");
    
    XMPCoreCoverage.printXMPMeta(meta, "Parse \"coverage\" RDF, add Bag items out of order");
    
    XMPCoreCoverage.writeMinorLabel("Default iteration");
    const it1: XMPIterator = meta.iterator();
    while (it1.hasNext()) {
      const prop: XMPPropertyInfo = it1.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Iterate omitting qualifiers");
    const it2: XMPIterator = meta.iterator(new IteratorOptions().setOmitQualifiers(true));
    while (it2.hasNext()) {
      const prop: XMPPropertyInfo = it2.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Iterate with just leaf names");
    const it3: XMPIterator = meta.iterator(new IteratorOptions().setJustLeafname(true));
    while (it3.hasNext()) {
      const prop: XMPPropertyInfo = it3.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Iterate with just leaf nodes");
    const it4: XMPIterator = meta.iterator(new IteratorOptions().setJustLeafnodes(true));
    while (it4.hasNext()) {
      const prop: XMPPropertyInfo = it4.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Iterate just the schema nodes");
    const it5: XMPIterator = meta.iterator(new IteratorOptions().setJustChildren(true));
    while (it5.hasNext()) {
      const prop: XMPPropertyInfo = it5.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Iterate the ns2: namespace");
    const it6: XMPIterator = meta.iterator(NS2, "", new IteratorOptions());
    while (it6.hasNext()) {
      const prop: XMPPropertyInfo = it6.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Start at ns2:Bag");
    const it7: XMPIterator = meta.iterator(NS2, "Bag", new IteratorOptions());
    while (it7.hasNext()) {
      const prop: XMPPropertyInfo = it7.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Start at ns2:NestedStructProp/ns1:Outer");
    const it8: XMPIterator = meta.iterator(NS2, "NestedStructProp/ns1:Outer", new IteratorOptions());
    while (it8.hasNext()) {
      const prop: XMPPropertyInfo = it8.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Iterate an empty namespace");
    const it9: XMPIterator = meta.iterator("ns:Empty", "", new IteratorOptions());
    while (it9.hasNext()) {
      const prop: XMPPropertyInfo = it9.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Iterate the top of the ns2: namespace with just leaf names");
    const it10: XMPIterator = meta.iterator(NS2, "", new IteratorOptions().setJustChildren(true).setJustLeafname(true));
    while (it10.hasNext()) {
      const prop: XMPPropertyInfo = it10.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
    
    XMPCoreCoverage.writeMinorLabel("Iterate the top of the ns2: namespace with just leaf nodes");
    const it11: XMPIterator = meta.iterator(NS2, "", new IteratorOptions().setJustChildren(true).setJustLeafnodes(true));
    while (it11.hasNext()) {
      const prop: XMPPropertyInfo = it11.next() as XMPPropertyInfo;
      XMPCoreCoverage.printPropertyInfo(prop);
    }
  }
  
  /**
   * 测试路径创建
   * @throws XMPException 转发异常
   */
  private static coverPathCreation(): void {
    XMPCoreCoverage.writeMajorLabel("XPath composition utilities");
    
    const meta: XMPMeta = XMPMetaFactory.create();
    
    meta.appendArrayItem(NS1, "ArrayProp", new PropertyOptions().setArray(true), "Item 1", null);
    
    let path: string = XMPPathFactory.composeArrayItemPath("ArrayProp", 2);
    console.log("composeArrayItemPath ArrayProp[2] =   " + path);
    meta.setProperty(NS1, path, "new ns1:ArrayProp[2] value");
    
    path = "StructProperty";
    path += XMPPathFactory.composeStructFieldPath(NS2, "Field3");
    console.log("composeStructFieldPath StructProperty/ns2:Field3 =   " + path);
    meta.setProperty(NS1, path, "new ns1:StructProp/ns2:Field3 value");
    
    path = "QualProp";
    path += XMPPathFactory.composeQualifierPath(NS2, "Qual");
    console.log("composeStructFieldPath QualProp/?ns2:Qual =   " + path);
    meta.setProperty(NS1, path, "new ns1:QualProp/?ns2:Qual value");
    
    meta.setLocalizedText(NS1, "AltTextProp", "", "en-US", "initival value", null);
    path = "AltTextProp";
    path += XMPPathFactory.composeQualifierPath(XMPConst.NS_XML, "lang");
    console.log("composeQualifierPath ns1:AltTextProp/?xml:lang =   " + path);
    meta.setProperty(NS1, path, "new ns1:AltTextProp/?xml:lang value");
    
    XMPCoreCoverage.printXMPMeta(meta, "Modified simple RDF");
  }
  
  /**
   * 测试日期时间功能
   * @throws XMPException 转发异常
   */
  private static coverDateTime(): void {
    XMPCoreCoverage.writeMajorLabel("Test date/time utilities and special values");
    
    const date1: XMPDateTime = XMPDateTimeFactory.create(2000, 1, 31, 12, 34, 56, -1);
    // Note: ArkTS doesn't have TimeZone.getTimeZone, use offset directly
    const pstOffset: number = -8 * 3600 * 1000; // PST is UTC-8
    date1.setTimeZoneOffset(pstOffset);
    const date2: XMPDateTime = XMPDateTimeFactory.create(0, 0, 0, 0, 0, 0, 0);
    const cal: Date = new Date(2007, 1, 28);
    const date3: XMPDateTime = XMPDateTimeFactory.createFromCalendar(cal);
    const currentDateTime: XMPDateTime = XMPDateTimeFactory.getCurrentDateTime();
    
    console.log("Print date 2000 Jan 31 12:34:56 PST =   " + date1.toString());
    console.log("Print zero date =   " + date2.toString());
    console.log("Print date created by a calendar =   " + date3.toString());
    console.log("Print current date =   " + currentDateTime.toString());

  }
  
  /**
   * 打印主标签
   * @param label 标签文本
   */
  private static writeMajorLabel(label: string): void {

    console.log("// =============================================================================");
    console.log("// " + label);
    console.log("// =============================================================================");

  }
  
  /**
   * 打印次标签
   * @param label 标签文本
   */
  private static writeMinorLabel(label: string): void {

    const separator = "// -----------------------------------------------------------------------------";
    console.log(separator.substring(0, label.length + 3));
    console.log("// " + label);

  }
  
  /**
   * 打印XMP元数据
   * @param meta XMP元数据对象
   * @param label 标签文本
   */
  private static printXMPMeta(meta: XMPMeta, label: string): void {
    const name: string | null = meta.getObjectName();
    if (name !== null && name.length > 0) {
      console.log(label + " (Name: '" + name + "'):");
    } else {
      console.log(label + ":");
    }
    console.log(meta.dumpObject());

  }
  
  /**
   * 打印属性信息
   * @param prop 来自XMPIterator的XMPPropertyInfo
   */
  private static printPropertyInfo(prop: XMPPropertyInfo): void {
    console.log("NS (" + prop.getNamespace() + ")   PATH (" + prop.getPath() + ")   VALUE (" +
      prop.getValue() + ")  OPTIONS (" + prop.getOptions().toString() + ")");
  }
}

// 如果直接运行此文件，则执行示例
// Note: ArkTS doesn't support require/module, so this check is removed
// XMPCoreCoverage.main();