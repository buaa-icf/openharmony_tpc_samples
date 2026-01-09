import { XMPDateTime, XMPMeta, XMPProperty, XMPPropertyInfo  } from '@ohos/xmp_toolkit';
import { XMPMetaFactory } from '@ohos/xmp_toolkit';
import { XMPDateTimeFactory } from '@ohos/xmp_toolkit';
import { PropertyOptions } from '@ohos/xmp_toolkit';
import { IteratorOptions } from '@ohos/xmp_toolkit';
import { ParseOptions } from '@ohos/xmp_toolkit';
import { XMPIterator } from '@ohos/xmp_toolkit';

/**
 * 测试结果项
 */
class TestResult {
  public name: string = '';
  public passed: boolean = false;
  public message: string = '';

  constructor(name: string, passed: boolean, message: string) {
    this.name = name;
    this.passed = passed;
    this.message = message;
  }
}

@Entry
@Component
struct Index {
  @State message: string = '点击运行测试';
  @State isRunning: boolean = false;
  @State testResults: TestResult[] = [];
  @State totalTests: number = 0;
  @State passedTests: number = 0;
  @State failedTests: number = 0;
  @State currentTest: string = '';

  private readonly NS1 = 'ns:test1/';
  private readonly NS2 = 'ns:test2/';

  // 测试用 RDF 数据
  private readonly SIMPLE_RDF: string = `<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <rdf:Description rdf:about="Test:SimpleRDF" xmlns:ns1="ns:test1/" xmlns:ns2="ns:test2/">
      <ns1:SimpleProp>Simple value</ns1:SimpleProp>
      <ns1:ArrayProp>
        <rdf:Bag>
          <rdf:li>Item1 value</rdf:li>
          <rdf:li>Item2 value</rdf:li>
        </rdf:Bag>
      </ns1:ArrayProp>
      <ns1:StructProp rdf:parseType="Resource">
        <ns2:Field1>Field1 value</ns2:Field1>
        <ns2:Field2>Field2 value</ns2:Field2>
      </ns1:StructProp>
    </rdf:Description>
  </rdf:RDF>`;

  private readonly DATETIME_RDF: string = `<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <rdf:Description rdf:about="Test:DateTimeRDF" xmlns:ns1="ns:test1/">
      <ns1:Date1>2003</ns1:Date1>
      <ns1:Date2>2003-12</ns1:Date2>
      <ns1:Date3>2003-12-31</ns1:Date3>
    </rdf:Description>
  </rdf:RDF>`;

  addResult(name: string, passed: boolean, message: string) {
    this.testResults.push(new TestResult(name, passed, message));
    this.totalTests++;
    if (passed) {
      this.passedTests++;
    } else {
      this.failedTests++;
    }
  }

  async runAllTests() {
    this.testResults = [];
    this.totalTests = 0;
    this.passedTests = 0;
    this.failedTests = 0;

    // 注册测试命名空间
    const registry = XMPMetaFactory.getSchemaRegistry();
    registry.registerNamespace(this.NS1, 'ns1');
    registry.registerNamespace(this.NS2, 'ns2');

    // 15 个测试项目
    await this.test01_SetPropertyMethods();
    await this.test02_GetPropertyMethods();
    await this.test03_ExistingProperties();
    await this.test04_DeleteProperties();
    await this.test05_LocalisedProperties();
    await this.test06_LiteralProperties();
    await this.test07_ArrayItems();
    await this.test08_ComplexProperties();
    await this.test09_IteratorMethods();
    await this.test10_ObjectAndOthers();
  }

  async test01_SetPropertyMethods() {
    this.currentTest = '[1/10] 设置XMP属性';
    try {
      const meta = XMPMetaFactory.create();

      meta.setProperty(this.NS1, 'Prop', 'Prop value');
      meta.setProperty(this.NS1, 'PropOption', 'Default value', new PropertyOptions().setHasLanguage(true));
      const prop = meta.getProperty(this.NS1, 'Prop');
      const hasLanguage = meta.getProperty(this.NS1, 'PropOption')?.getOptions()?.getHasLanguage();

      meta.setStructField(this.NS1, 'Struct', this.NS2, 'Field1', 'Field1 value');
      meta.setStructField(this.NS1, 'Person', this.NS2, 'Email', 'zhangsan@example.com', new PropertyOptions().setHasType(true));
      const field = meta.getStructField(this.NS1, 'Struct', this.NS2, 'Field1');
      const emailField = meta.getStructField(this.NS1, 'Person', this.NS2, 'Email');
      const emailHasType = emailField?.getOptions()?.getHasType();

      meta.deleteStructField(this.NS1, 'Struct', this.NS2, 'Field1');
      const afterDelete = meta.getStructField(this.NS1, 'Struct', this.NS1, 'Field1');
      const fieldDeleted = afterDelete === null;

      meta.setQualifier(this.NS1, 'Prop', this.NS2, 'Qual1', 'Qual1 value', new PropertyOptions().setHasLanguage(true));
      meta.setQualifier(this.NS1, 'Prop', this.NS2, 'Qual2', 'Qual2 value');
      meta.deleteQualifier(this.NS1, 'Prop', this.NS2, 'Qual2');
      const testQual1 = meta.getQualifier(this.NS1, 'Prop', this.NS2, 'Qual1');
      const testQual2 = meta.getQualifier(this.NS1, 'Prop', this.NS2, 'Qual2');
      const qualHasLanguage = testQual1?.getOptions()?.getHasLanguage();
      const qualiDeleted = testQual2 === null;

      const passed = prop?.getValue() === 'Prop value' &&
        field?.getValue() === 'Field1 value' && hasLanguage === true &&
        emailField?.getValue() === 'zhangsan@example.com' && emailHasType === true &&
        qualiDeleted === true && testQual1?.getValue() === 'Qual1 value' &&
        qualHasLanguage === true && fieldDeleted === true;

      let message = '属性=' + prop?.getValue() + ', 属性语言选项=' + hasLanguage;
      message += ', 结构字段=' + (emailField?.getValue() || 'null') + ', 结构字段Type选项=';
      message += emailHasType + ', 限定符=' + testQual1?.getValue();
      message += ', 限定符语言选项=' + qualHasLanguage;
      this.addResult('1. 设置XMP属性', passed, message);
    } catch (e) {
      this.addResult('1. 设置XMP属性', false, (e as Error).message);
    }
  }

  async test02_GetPropertyMethods() {
    this.currentTest = '[2/10] 获取XMP属性';
    try {
      const meta = XMPMetaFactory.parseFromString(this.SIMPLE_RDF);

      const simpleProp = meta.getProperty(this.NS1, 'SimpleProp');

      const arrayOptions = new PropertyOptions().setArray(true);
      meta.appendArrayItem(this.NS1, 'TestArray', arrayOptions, 'Item1 value', null);
      meta.appendArrayItem(this.NS1, 'TestArray', arrayOptions, 'Item2', null);
      meta.appendArrayItem(this.NS1, 'TestArray', arrayOptions, 'Item3', null);
      const initialItem1 = meta.getArrayItem(this.NS1, 'TestArray', 1);
      const initialCount = meta.countArrayItems(this.NS1, 'TestArray');
      meta.setArrayItem(this.NS1, 'TestArray', 1, 'UpdatedItem1', null);
      meta.setArrayItem(this.NS1, 'TestArray', 2, 'UpdatedItem2', new PropertyOptions().setQualifier(true));
      const updatedItem2 = meta.getArrayItem(this.NS1, 'TestArray', 2);
      const isQualifier = updatedItem2?.getOptions()?.isQualifier();

      const structField = meta.getStructField(this.NS1, 'StructProp', this.NS2, 'Field1');

      // 测试 insertArrayItem 在开头插入（位置1）
      meta.insertArrayItem(this.NS1, 'TestArray', 1, 'InsertedAtStart', null);
      meta.insertArrayItem(this.NS1, 'TestArray', 3, 'InsertedInMiddle', new PropertyOptions().setHasLanguage(true));
      const middleItem = meta.getArrayItem(this.NS1, 'TestArray', 3);
      const hasLanguage = middleItem?.getOptions()?.getHasLanguage();
      const afterMiddleInsertCount = meta.countArrayItems(this.NS1, 'TestArray');
      meta.deleteArrayItem(this.NS1, 'TestArray', 1);
      const deleteCount = meta.countArrayItems(this.NS1, 'TestArray');

      const passed = simpleProp?.getValue() === 'Simple value' &&
        initialItem1?.getValue() === 'Item1 value' && structField?.getValue() === 'Field1 value' &&
        updatedItem2?.getValue() === 'UpdatedItem2' && isQualifier === true &&
        middleItem?.getValue() === 'InsertedInMiddle' && hasLanguage === true &&
        afterMiddleInsertCount === 5 && deleteCount === 4;

      let message = '简单属性=';
      message += simpleProp?.getValue() + ', 结构=' + structField?.getValue();
      message += ', 初始数组项=' + initialItem1?.getValue() + ', 修改后数组项=' + updatedItem2?.getValue();
      message += ', 数组项限定符选项=' + isQualifier + ', 初始数组项数=' + initialCount;
      message += ', 插入数组项=' + middleItem?.getValue() + ', 插入后数组项数=' + afterMiddleInsertCount;

      this.addResult('2. 获取XMP属性', passed, message);
    } catch (e) {
      this.addResult('2. 获取XMP属性', false, (e as Error).message);
    }
  }

  async test03_ExistingProperties() {
    this.currentTest = '[3/10] 属性存在检查';
    try {
      const meta = XMPMetaFactory.parseFromString(this.SIMPLE_RDF);

      const exists1 = meta.doesPropertyExist(this.NS1, 'SimpleProp');

      const arrayOptions = new PropertyOptions().setArray(true);
      meta.appendArrayItem(this.NS1, 'TestArray', arrayOptions, 'Item1', null);
      meta.appendArrayItem(this.NS1, 'TestArray', arrayOptions, 'Item2', null);
      const item1Exists = meta.doesArrayItemExist(this.NS1, 'TestArray', 1);
      const item0Exists = meta.doesArrayItemExist(this.NS1, 'TestArray', 0);

      meta.setStructField(this.NS1, 'Person', this.NS2, 'Name', '张三', null);
      meta.setStructField(this.NS1, 'Person', this.NS2, 'Age', '30', null);
      const nameExists = meta.doesStructFieldExist(this.NS1, 'Person', this.NS2, 'Name');
      const addressExists = meta.doesStructFieldExist(this.NS1, 'Person', this.NS2, 'Address');

      meta.setProperty(this.NS1, 'Document', '文档内容', null);
      meta.setQualifier(this.NS1, 'Document', this.NS2, 'Author', '张三', null);
      meta.setQualifier(this.NS1, 'Document', this.NS2, 'Date', '2025-12-26', null);
      const authorExists = meta.doesQualifierExist(this.NS1, 'Document', this.NS2, 'Author');
      const versionExists = meta.doesQualifierExist(this.NS1, 'Document', this.NS2, 'Version');

      const passed = exists1 && item1Exists && !item0Exists &&
        nameExists && !addressExists && authorExists && !versionExists;

      let message = 'SimpleProp=';
      message += exists1 + ', ArrayItem[1]==' + item1Exists;
      message += ', ArrayItem[0]=' + item1Exists + ', StructField-Name=' + nameExists;
      message += ', StructField-Address=' + addressExists + ', Qualifier-Author=' + authorExists;
      message += ', Qualifier-Version=' + versionExists;
      this.addResult('3. 属性存在检查', passed, message);
    } catch (e) {
      this.addResult('3. 属性存在检查', false, (e as Error).message);
    }
  }

  async test04_DeleteProperties() {
    this.currentTest = '[4/10] 删除XMP属性';
    try {
      const meta = XMPMetaFactory.create();
      meta.setProperty(this.NS1, 'ToDelete', 'value');

      const existsBefore = meta.doesPropertyExist(this.NS1, 'ToDelete');
      meta.deleteProperty(this.NS1, 'ToDelete');
      const existsAfter = meta.doesPropertyExist(this.NS1, 'ToDelete');

      const passed = existsBefore && !existsAfter;
      this.addResult('4. 删除XMP属性', passed,
        `删除前=${existsBefore}, 删除后=${existsAfter}`);
    } catch (e) {
      this.addResult('4. 删除XMP属性', false, (e as Error).message);
    }
  }

  async test05_LocalisedProperties() {
    this.currentTest = '[5/10] 本地化属性';
    try {
      const meta = XMPMetaFactory.create();

      meta.setLocalizedText(this.NS1, 'AltText', 'en', 'en-us', 'en-us value', null);
      meta.setLocalizedText(this.NS1, 'AltText', 'zh', 'zh-CN', '中文简体值', new PropertyOptions().setArrayAltText(true));

      const prop = meta.getLocalizedText(this.NS1, 'AltText', 'en', 'en-us');
      const zhCNProp = meta.getLocalizedText(this.NS1, 'AltText', 'zh', 'zh-CN');
      const isAltText  = meta.getProperty(this.NS1, 'AltText')?.getOptions()?.isArrayAltText();

      const passed = prop !== null && prop.getValue() === 'en-us value' &&
        zhCNProp?.getValue() === '中文简体值' && isAltText  === true;
      this.addResult('5. 本地化属性', passed, `语言文本=${prop?.getValue()}`);
    } catch (e) {
      this.addResult('5. 本地化属性', false, (e as Error).message);
    }
  }

  async test06_LiteralProperties() {
    this.currentTest = '[6/10] 简单数据类型属性';
    try {
      const meta = XMPMetaFactory.create();

      meta.setPropertyBoolean(this.NS1, 'Bool', true);
      meta.setPropertyBoolean(this.NS1, 'BoolArray', false, new PropertyOptions().setQualifier(true));
      meta.setPropertyInteger(this.NS1, 'Int', 42);
      meta.setPropertyInteger(this.NS1, 'IntStruct', 206, new PropertyOptions().setHasLanguage(true));
      meta.setPropertyDouble(this.NS1, 'Double', 3.14);
      meta.setPropertyDouble(this.NS1, 'DoubleArray', 6.534, new PropertyOptions().setQualifier(true));
      meta.setPropertyLong(this.NS1, 'Long', 20456789);
      meta.setPropertyLong(this.NS1, 'LongText', 2265871, new PropertyOptions().setHasLanguage(true));

      const boolVal = meta.getPropertyBoolean(this.NS1, 'Bool');
      const isQualifier = meta.getProperty(this.NS1, 'BoolArray')?.getOptions()?.isQualifier();
      const intVal = meta.getPropertyInteger(this.NS1, 'Int');
      const hasLanguage = meta.getProperty(this.NS1, 'IntStruct')?.getOptions()?.getHasLanguage();
      const doubleVal = meta.getPropertyDouble(this.NS1, 'Double');
      const doubleIsQualifier = meta.getProperty(this.NS1, 'DoubleArray')?.getOptions()?.isQualifier();
      const longVal = meta.getPropertyLong(this.NS1, 'Long');
      const lonLanguage = meta.getProperty(this.NS1, 'LongText')?.getOptions()?.getHasLanguage();

      const passed = boolVal === true && intVal === 42 &&
        Math.abs(doubleVal - 3.14) < 0.01 && isQualifier === true &&
        hasLanguage === true && doubleIsQualifier === true &&
        longVal === 20456789 && lonLanguage === true;

      this.addResult('6. 简单数据类型属性', passed,
        `布尔=${boolVal}, 整数=${intVal}, 浮点=${doubleVal.toFixed(2)}, 长整数=${longVal}`);
    } catch (e) {
      this.addResult('6. 简单数据类型属性', false, (e as Error).message);
    }
  }

  async test07_ArrayItems() {
    this.currentTest = '[7/10] 数组项';
    try {
      const meta = XMPMetaFactory.create();

      meta.appendArrayItem(this.NS1, 'Bag', new PropertyOptions().setArray(true), 'BagItem', null);

      meta.appendArrayItem(this.NS1, 'TestArray', new PropertyOptions().setArray(true), 'Item1', null);
      meta.appendArrayItem(this.NS1, 'TestArray', new PropertyOptions().setArray(true), 'Item2', null);
      meta.appendArrayItem(this.NS1, 'TestArray', new PropertyOptions().setArray(true), 'Item3', null);
      // 获取现有数组的项数
      const count1 = meta.countArrayItems(this.NS1, 'TestArray');
      const bagItem = meta.getArrayItem(this.NS1, 'Bag', 1);

      const passed = bagItem?.getValue() === 'BagItem' &&
        count1 === 3;

      this.addResult('7. 数组项', passed, `数组=${bagItem?.getValue()}, 数组项数=${count1}`);
    } catch (e) {
      this.addResult('7. 数组项', false, (e as Error).message);
    }
  }

  async test08_ComplexProperties() {
    this.currentTest = '[8/10] 复合数据类型属性';
    try {
      const meta = XMPMetaFactory.create();

      const date1: XMPDateTime = XMPDateTimeFactory.createFromISO8601('2025-12-26T14:30:45');
      meta.setPropertyDate(this.NS1, 'DateStruct', date1, new PropertyOptions().setQualifier(true));
      const date2: XMPDateTime = XMPDateTimeFactory.createFromISO8601('2025-12-26');
      meta.setPropertyDate(this.NS1, 'SimpleDate', date2, null);
      const retrievedDate1: XMPDateTime | null = meta.getPropertyDate(this.NS1, 'DateStruct');
      const retrievedDate2: XMPDateTime | null = meta.getPropertyDate(this.NS1, 'SimpleDate');
      const isQualif = meta.getProperty(this.NS1, 'DateStruct')?.getOptions()?.isQualifier();

      // 将日期转换为ISO字符串进行比较
      const date1ISO: string = date1.getISO8601String();
      const date2ISO: string = date2.getISO8601String();
      const retrievedDate1ISO: string | null = retrievedDate1 ? retrievedDate1.getISO8601String() : null;
      const retrievedDate2ISO: string | null = retrievedDate2 ? retrievedDate2.getISO8601String() : null;

      const calendar1Str = '2025-12-26T14:30:45';
      const calendar2Str = '2025-11-10T14:30:45';
      meta.setPropertyCalendar(this.NS1, 'GregorianCalendar', calendar1Str, null);
      meta.setPropertyCalendar(this.NS1, 'ChineseCalendar', calendar2Str, new PropertyOptions().setHasLanguage(true));

      const calendarDate1: XMPDateTime | null = meta.getPropertyDate(this.NS1, 'GregorianCalendar');
      const calendarDate2: XMPDateTime | null = meta.getPropertyDate(this.NS1, 'ChineseCalendar');

      let calendar1Valid = false;
      let calendar2Valid = false;
      if (calendarDate1) {
        const propertyCalendar1 = calendarDate1.getISO8601String();
        calendar1Valid = propertyCalendar1 === calendar1Str;
      }
      if (calendarDate2) {
        const propertyCalendar2 = calendarDate2.getISO8601String();
        calendar2Valid = propertyCalendar2 === calendar2Str;
      }

      const binaryData1 = new Uint8Array([72, 101, 108, 108, 111]); // 'Hello' 的 ASCII 码
      const binaryData2 = new Uint8Array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]); // 数字序列
      meta.setPropertyBase64(this.NS1, 'BinaryData1', binaryData1);
      meta.setPropertyBase64(this.NS1, 'BinaryData2', binaryData2, new PropertyOptions().setHasType(true));
      const retrievedData1: Uint8Array | null = meta.getPropertyBase64(this.NS1, 'BinaryData1');
      const retrievedData2: Uint8Array | null = meta.getPropertyBase64(this.NS1, 'BinaryData2');
      const hasType = meta.getProperty(this.NS1, 'BinaryData2')?.getOptions()?.getHasType();

      let data1Valid = false;
      let data2Valid = false;
      let data1Values: number[] = [];
      let data2Values: number[] = [];
      if (retrievedData1 !== null && retrievedData1.length === binaryData1.length) {
        data1Valid = true;
        data1Values = Array.from(retrievedData1);
        for (let i = 0; i < binaryData1.length; i++) {
          if (retrievedData1[i] !== binaryData1[i]) {
            data1Valid = false;
            break;
          }
        }
      }

      if (retrievedData2 !== null && retrievedData2.length === binaryData2.length) {
        data2Valid = true;
        data2Values = Array.from(retrievedData2);
        for (let i = 0; i < binaryData2.length; i++) {
          if (retrievedData2[i] !== binaryData2[i]) {
            data2Valid = false;
            break;
          }
        }
      }

      let data1Display = '';
      if (data1Values.length > 0) {
        data1Display = '字节值: [' + data1Values.join(', ') + ']';
        // 尝试转换为ASCII字符串
        const asciiStr = String.fromCharCode(...data1Values);
        if (asciiStr.match(/^[\x20-\x7E]+$/)) { // 只显示可打印ASCII字符
          data1Display += ' (ASCII: "' + asciiStr + '")';
        }
      } else {
        data1Display = '无数据';
      }

      let data2Display = '';
      if (data2Values.length > 0) {
        data2Display = '字节值: [' + data2Values.join(', ') + ']';
        // 显示为十六进制
        const hexValues = data2Values.map(b => b.toString(16).padStart(2, '0'));
        data2Display += ' (十六进制: [' + hexValues.join(', ') + '])';
      } else {
        data2Display = '无数据';
      }

      const passed =  retrievedDate1ISO !== null && retrievedDate1ISO === date1ISO &&
        retrievedDate2ISO !== null && retrievedDate2ISO === date2ISO &&
        isQualif === true && calendar1Valid && calendar2Valid &&
        data1Valid && data2Valid && hasType === true &&
        calendar1Valid && calendar2Valid;

      let message = '简单日期=';
      message += retrievedDate1ISO ? retrievedDate1ISO.substring(0, 10) : 'null';
      message += ', 限定符选项=' + isQualif;
      message += ', 公历=' + calendarDate1?.getYear() + '年' + calendarDate1?.getMonth() + '月' + calendarDate1?.getDay() + '日';
      message += ', 农历=' + calendarDate2?.getYear() + '年' + calendarDate2?.getMonth() + '月' + calendarDate2?.getDay() + '日';
      message += ', Base64数据1=' + data1Display;
      message += 'Base64数据2=' + data2Display;

      this.addResult('8. 复合数据类型属性', passed, message);
    } catch (e) {
      this.addResult('8. 复合数据类型属性', false, (e as Error).message);
    }
  }

  async test09_IteratorMethods() {
    this.currentTest = '[9/10] 迭代器综合测试';
    try {
      const meta = XMPMetaFactory.create();

      // 创建测试数据
      meta.setProperty(this.NS1, 'Prop1', 'Value1');
      meta.setProperty(this.NS1, 'Prop2', 'Value2');
      meta.setProperty(this.NS2, 'Prop3', 'Value3');
      meta.setProperty(this.NS1, 'RootProp', 'RootValue');

      // 创建结构
      meta.setStructField(this.NS1, 'Struct', this.NS2, 'Field1', 'Field1Value', null);
      meta.setStructField(this.NS1, 'Struct', this.NS2, 'Field2', 'Field2Value', null);
      meta.setStructField(this.NS1, 'Person', this.NS2, 'Name', '张三', null);
      meta.setStructField(this.NS1, 'Person', this.NS2, 'Age', '30', null);

      // 创建数组
      const arrayOptions: PropertyOptions = new PropertyOptions().setArray(true);
      meta.appendArrayItem(this.NS1, 'TestArray', arrayOptions, 'ArrayItem1', null);
      meta.appendArrayItem(this.NS1, 'TestArray', arrayOptions, 'ArrayItem2', null);
      meta.appendArrayItem(this.NS1, 'Array', arrayOptions, 'Item1', null);
      meta.appendArrayItem(this.NS1, 'Array', arrayOptions, 'Item2', null);

      // 无参数iterator() - 测试基本迭代
      const iterator1: XMPIterator = meta.iterator();
      let basicIterCount: number = 0;
      let foundProp1: boolean = false;
      let foundProp2: boolean = false;
      let foundProp3: boolean = false;
      let hasPathInfo: boolean = false;
      let hasSchemaNS: boolean = false;
      let hasRootProp: boolean = false;

      iterator1.skipSubtree();
      iterator1.skipSiblings();

      while (iterator1.hasNext()) {
        const item: XMPPropertyInfo | null = iterator1.next();
        if (item !== null) {
          const path: string | null = item.getPath();
          if (path !== null && path.length > 0) {
            basicIterCount++;
            hasPathInfo = true;
            // 检查路径是否包含我们设置的数据
            if (path.includes('Prop1') || path.includes('Value1')){
              foundProp1 = true;
            }
            if (path.includes('Prop2') || path.includes('Value2')){
              foundProp2 = true;
            }
            if (path.includes('Prop3') || path.includes('Value3')){
              foundProp3 = true;
            }
            if (path.includes('RootProp')){
              hasRootProp = true;
            }
          }
        }
      }

      // 带IteratorOptions的iterator() - 测试跳过子树
      const skipOptions: IteratorOptions = new IteratorOptions().setOmitQualifiers(true);
      const skipIterator: XMPIterator = meta.iterator(skipOptions);
      let skipCount: number = 0;

      while (skipIterator.hasNext()) {
        const item: XMPPropertyInfo | null = skipIterator.next();
        if (item !== null) {
          skipCount++;
        }
      }

      // 带schemaNS和propName的iterator() - 测试只返回叶子节点
      const leafOptions: IteratorOptions = new IteratorOptions().setJustLeafnodes(true);
      const leafIterator: XMPIterator = meta.iterator(this.NS1, '', leafOptions);
      let leafCount: number = 0;
      let hasLeafValues: boolean = false;

      while (leafIterator.hasNext()) {
        const item: XMPPropertyInfo | null = leafIterator.next();
        if (item !== null) {
          leafCount++;
          const path: string | null = item.getPath();
          if (path !== null && path.length > 0) {
            hasLeafValues = true;
          }
        }
      }

      // 带IteratorOptions的iterator() - 测试只返回子节点
      const childrenOptions: IteratorOptions = new IteratorOptions().setJustChildren(true);
      const childrenIterator: XMPIterator = meta.iterator(childrenOptions);
      let childrenCount: number = 0;

      while (childrenIterator.hasNext()) {
        const item: XMPPropertyInfo | null = childrenIterator.next();
        if (item !== null) {
          childrenCount++;
        }
      }

      // 测试5: 迭代带结构的数据
      const structIterator: XMPIterator = meta.iterator(this.NS1, 'Person',
        new IteratorOptions().setJustLeafnodes(true));
      let structFieldCount: number = 0;
      let foundName: boolean = false;
      let foundAge: boolean = false;

      while (structIterator.hasNext()) {
        const item: XMPPropertyInfo | null = structIterator.next();
        if (item !== null) {
          const path: string | null = item.getPath();
          if (path !== null) {
            structFieldCount++;
            if (path.includes('Name') || path.includes('张三')){
              foundName = true;
            }
            if (path.includes('Age') || path.includes('30')){
              foundAge = true;
            }
          }
        }
      }

      const passed: boolean = basicIterCount > 0 && foundProp1 && foundProp2 &&
        foundProp3 && hasPathInfo && hasRootProp && skipCount > 0 && leafCount > 0 &&
        hasLeafValues && childrenCount > 0 && structFieldCount === 2 &&
        foundName && foundAge;

      let message = '迭代次数=';
      message += basicIterCount + ', 跳过子树次数=' + skipCount + ', 叶子节点数=';
      message += leafCount + ', 子节点数=' + childrenCount;
      message += ', 结构字段数=' + structFieldCount;

      this.addResult('9. 迭代器', passed, message);
    } catch (e) {
      this.addResult('9. 迭代器', false, (e as Error).message);
    }
  }

  async test10_ObjectAndOthers() {
    this.currentTest = '[10/10] 对象及其他';
    try {
      const meta = XMPMetaFactory.create();

      // 默认对象名称应该为空
      const defaultName: string = meta.getObjectName();
      const isDefaultEmpty: boolean = defaultName === '';

      // 设置对象名称
      const testName1: string = 'TestObject1';
      meta.setObjectName(testName1);
      const retrievedName1: string = meta.getObjectName();
      const setName1Passed: boolean = retrievedName1 === testName1;

      // 从RDF解析的对象名称
      const protocol = 'http:';
      const xmpSpace: string = protocol + '//www.w3.org/1999/02/22-rdf-syntax-ns#';
      const rdfWithName: string =
        `<rdf:RDF xmlns:rdf="${xmpSpace}">
          <rdf:Description rdf:about="NamedObject" xmlns:ns1="ns:test1/">
            <ns1:SimpleProp>Simple value</ns1:SimpleProp>
          </rdf:Description>
        </rdf:RDF>`;

      const metaFromRDF = XMPMetaFactory.parseFromString(rdfWithName);
      const nameFromRDF: string = metaFromRDF.getObjectName();
      const hasNameFromRDF: boolean = nameFromRDF === 'NamedObject';

      // 默认数据包头部为null
      const defaultHeader: string | null = meta.getPacketHeader();
      const isDefaultNull: boolean = defaultHeader === null;
      // 从包含头部的RDF/XMP数据解析
      const rdfWithHeader: string =
        "<?xpacket begin='ï»¿' id='W5M0MpCehiHzreSzNTczkc9d'?>" +
          '<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="XMP Core 5.6.0">' +
          '  <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">' +
          '    <rdf:Description rdf:about="" xmlns:ns1="ns:test1/">' +
          '      <ns1:SimpleProp>Simple value</ns1:SimpleProp>' +
          '    </rdf:Description>' +
          '  </rdf:RDF>' +
          '</x:xmpmeta>' +
          "<?xpacket end='r'?>";

      const metaRDF = XMPMetaFactory.parseFromString(rdfWithHeader);
      const headerFromRDF: string | null = metaRDF.getPacketHeader();
      const hasHeaderFromRDF: boolean = headerFromRDF !== null && headerFromRDF.length > 0;

      meta.setProperty(this.NS1, 'Prop1', 'Value1');
      meta.setProperty(this.NS1, 'Prop2', 'Value2');
      const options1 = new ParseOptions();
      meta.normalize(options1);

      // 序列化后获取属性
      const prop1After = meta.getProperty(this.NS1, 'Prop1');
      const prop2After = meta.getProperty(this.NS1, 'Prop2');
      const basicNormalizePassed = prop1After !== null && prop1After.getValue() === 'Value1' &&
        prop2After !== null && prop2After.getValue() === 'Value2';

      // 以无序方式添加属性
      meta.setProperty(this.NS1, 'Zebra', 'Zebra Value');
      meta.setProperty(this.NS1, 'Apple', 'Apple Value');
      meta.setProperty(this.NS1, 'Monkey', 'Monkey Value');

      meta.sort();
      const appleAfter = meta.getProperty(this.NS1, 'Apple');
      const zebraAfter = meta.getProperty(this.NS1, 'Zebra');
      const monkeyAfter = meta.getProperty(this.NS1, 'Monkey');

      const propertiesExistAfterSort =
        appleAfter !== null && appleAfter.getValue() === 'Apple Value' &&
          zebraAfter !== null && zebraAfter.getValue() === 'Zebra Value' &&
          monkeyAfter !== null && monkeyAfter.getValue() === 'Monkey Value';

      const meta2 = XMPMetaFactory.create();
      meta2.setProperty(this.NS1, 'Prop1', 'Value1');
      meta2.setProperty(this.NS1, 'Prop2', 'Value2');
      const dump2: string = meta2.dumpObject();
      const simpleDumpValid: boolean = dump2 !== null && dump2 !== undefined &&
        dump2.length > 0;

      const meta3 = XMPMetaFactory.create();
      meta3.setProperty(this.NS1, 'SimpleProp', 'Simple Value');

      const cloneMeta: XMPMeta = meta3.clone() as XMPMeta;
      const originalProp = meta3.getProperty(this.NS1, 'SimpleProp');
      const clonedProp: XMPProperty | null = cloneMeta.getProperty(this.NS1, 'SimpleProp');
      const simpleCloneValid: boolean = originalProp !== null && clonedProp !== null &&
        originalProp.getValue() === clonedProp.getValue() &&
        originalProp !== clonedProp;

      // 验证所有测试结果
      const passed: boolean = isDefaultEmpty && setName1Passed && hasNameFromRDF &&
        isDefaultNull && !hasHeaderFromRDF && basicNormalizePassed &&
        propertiesExistAfterSort && simpleDumpValid && simpleCloneValid;

      let message = '默认对象=';
      message += defaultName + ', 设置对象=' + retrievedName1;
      message += ', RDF对象=' + nameFromRDF + ', 默认包头=' + defaultHeader;
      message += ', RDF包头=' + headerFromRDF + ', 序列化后属性=' + prop1After?.getValue();
      message += ', 对象输出=' + dump2 + ', clone属性=' + clonedProp?.getValue();

      this.addResult('10. 对象及其他', passed, message);
    } catch (e) {
      this.addResult('10. 对象及其他', false, (e as Error).message);
    }
  }

  build() {
    Column() {
      // 标题
      Text('xmp_toolkit 自动化接口测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12, bottom: 12 })

      // 运行按钮
      Button(this.isRunning ? `${this.currentTest}` : this.message)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .width('85%')
        .height(44)
        .enabled(!this.isRunning)
        .onClick(async () => {
          this.isRunning = true;
          this.message = '测试中...';
          try {
            await this.runAllTests();
            this.message = '重新运行测试';
          } catch (e) {
            this.message = '测试出错，点击重试';
          } finally {
            this.isRunning = false;
            this.currentTest = '';
          }
        })
        .margin({ bottom: 12 })

      // 统计信息
      if (this.totalTests > 0) {
        Row() {
          Text(`总计: ${this.totalTests}`)
            .fontSize(13)
            .margin({ right: 12 })
          Text(`✅ ${this.passedTests}`)
            .fontSize(13)
            .fontColor('#00AA00')
            .margin({ right: 12 })
          Text(`❌ ${this.failedTests}`)
            .fontSize(13)
            .fontColor('#FF0000')
        }
        .margin({ bottom: 8 })

        // 总体结果
        Text(this.failedTests === 0 ? '🎉 全部通过!' : `⚠️ ${this.failedTests}项失败`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.failedTests === 0 ? '#00AA00' : '#FF6600')
          .margin({ bottom: 10 })
      }

      // 测试结果列表
      if (this.testResults.length > 0) {
        List() {
          ForEach(this.testResults, (item: TestResult) => {
            ListItem() {
              Row() {
                Text(item.passed ? '✅' : '❌')
                  .fontSize(14)
                  .margin({ right: 6 })
                Column() {
                  Text(item.name)
                    .fontSize(13)
                    .fontWeight(FontWeight.Medium)
                  Text(item.message)
                    .fontSize(10)
                    .fontColor(item.passed ? '#666666' : '#FF0000')
                    .maxLines(12)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding({ top: 6, bottom: 6, left: 10, right: 10 })
              .backgroundColor(item.passed ? '#F0FFF0' : '#FFF0F0')
              .borderRadius(4)
            }
            .margin({ bottom: 4 })
          })
        }
        .width('94%')
        .layoutWeight(1)
        .divider({ strokeWidth: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
  }
}
