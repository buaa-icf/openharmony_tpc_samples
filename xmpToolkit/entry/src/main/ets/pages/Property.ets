import { XMPMetaFactory, XMPProperty, PropertyOptions, XMPException, IteratorOptions } from '@ohos/xmp_toolkit';

/**
 * 测试结果项
 */
class TestResult {
  public name: string = '';
  public passed: boolean = false;
  public message: string = '';
  public timestamp: string = '';

  constructor(name: string, passed: boolean, message: string) {
    this.name = name;
    this.passed = passed;
    this.message = message;
    this.timestamp = new Date().toLocaleTimeString();
  }
}

/**
 * 测试输入参数
 */
class TestInputs {
  // 通用参数
  public schemaNS: string = 'ns:test/';
  public propName: string = 'TestProperty';
  public propValue: string = 'TestValue';

  // 数组相关
  public arrayName: string = 'TestArray';
  public itemIndex: number = 1;
  public itemValue: string = 'ArrayItem';

  // 结构体相关
  public structName: string = 'TestStruct';
  public fieldNS: string = 'ns:field/';
  public fieldName: string = 'Field1';
  public fieldValue: string = 'FieldValue';

  // 限定符相关
  public qualNS: string = 'ns:qual/';
  public qualName: string = 'Qualifier';
  public qualValue: string = 'QualValue';

  // 选项相关
  public options: string[] = [];

  // Iterator 相关
  public iteratorSchemaNS: string = 'ns:test/';
  public iteratorPropName: string = '';
  public iteratorOpts: string[] = [];
}

@Entry
@Component
struct Index {
  @State message: string = 'XMP 接口测试';
  @State inputs: TestInputs = new TestInputs();
  @State currentOperation: string = '';
  @State iteratorResults: string[] = [];

  // 输入框状态 - 每组操作独立
  @State schemaNSInput: string = 'ns:test/';
  @State propNameInput: string = 'TestProperty';
  @State propValueInput: string = 'TestValue';
  @State propOptions: string[] = [];
  @State propOperationResult: TestResult[] = [];

  @State arraySchemaNSInput: string = 'ns:test/';
  @State arrayNameInput: string = 'TestArray';
  @State itemIndexInput: string = '1';
  @State itemValueInput: string = 'ArrayItem';
  @State arrayOpts: string[] = [];
  @State arrayOperationResult: TestResult[] = [];

  @State structSchemaNSInput: string = 'ns:test/';
  @State structNameInput: string = 'TestStruct';
  @State fieldNameInput: string = 'Field1';
  @State fieldValueInput: string = 'FieldValue';
  @State structOpts: string[] = [];
  @State structOperationResult: TestResult[] = [];

  @State qualSchemaNSInput: string = 'ns:test/';
  @State qualPropNameInput: string = 'TestProperty';
  @State qualNameInput: string = 'Qualifier';
  @State qualValueInput: string = 'QualValue';
  @State qualOptions: string[] = [];
  @State qualOperationResult: TestResult[] = [];

  // Iterator 输入状态
  @State iteratorSchemaNSInput: string = 'ns:test/';
  @State iteratorPropNameInput: string = '';
  @State iteratorOpts: string[] = [];
  @State iteratorOperationResult: TestResult[] = [];

  // Select组件选项 - 每个选项都是单选
  @State propertyOptionsList: SelectOption[] = [
    { value: '无选项' },
    { value: 'language' },
    { value: 'type' },
    { value: 'qualifier' }
  ];
  @State selectedPropOption: string = '无选项';

  @State arrayOptionsList: SelectOption[] = [
    { value: '无选项' },
    { value: 'language' },
    { value: 'type' },
    { value: 'qualifier' }
  ];
  @State selectedArrayOption: string = '无选项';

  @State structOptionsList: SelectOption[] = [
    { value: '无选项' },
    { value: 'language' },
    { value: 'qualifier' }
  ];
  @State selectedStructOption: string = '无选项';

  @State qualifierOptionsList: SelectOption[] = [
    { value: '无选项' },
    { value: 'language' }
  ];
  @State selectedQualOption: string = '无选项';

  @State iteratorOptionsList: SelectOption[] = [
    { value: '无选项' },
    { value: 'JUST_CHILDREN' },
    { value: 'JUST_LEAFNODES' },
    { value: 'JUST_LEAFNAME' },
    { value: 'OMIT_QUALIFIERS' },
    { value: 'INCLUDE_ALIASES' }
  ];
  @State selectedIteratorOption: string = '无选项';

  // XMP 实例
  private xmpMeta = XMPMetaFactory.create();

  // 初始化命名空间
  aboutToAppear(): void {
    const registry = XMPMetaFactory.getSchemaRegistry();
    registry.registerNamespace(this.inputs.schemaNS, 'test');
    registry.registerNamespace(this.inputs.fieldNS, 'field');
    registry.registerNamespace(this.inputs.qualNS, 'qual');
  }

  // 同步输入到 inputs 对象
  syncInputs(): void {
    this.inputs.schemaNS = this.schemaNSInput;
    this.inputs.propName = this.propNameInput;
    this.inputs.propValue = this.propValueInput;
    this.propOptions = this.selectedPropOption === '无选项' ? [] : [this.selectedPropOption];
    this.inputs.options = this.propOptions;

    this.inputs.arrayName = this.arrayNameInput;
    this.inputs.itemIndex = parseInt(this.itemIndexInput) || 1;
    this.inputs.itemValue = this.itemValueInput;
    this.arrayOpts = this.selectedArrayOption === '无选项' ? [] : [this.selectedArrayOption];
    this.inputs.options = this.arrayOpts;

    this.inputs.structName = this.structNameInput;
    this.inputs.fieldName = this.fieldNameInput;
    this.inputs.fieldValue = this.fieldValueInput;
    this.structOpts = this.selectedStructOption === '无选项' ? [] : [this.selectedStructOption];
    this.inputs.options = this.structOpts;

    this.inputs.qualName = this.qualNameInput;
    this.inputs.qualValue = this.qualValueInput;
    this.qualOptions = this.selectedQualOption === '无选项' ? [] : [this.selectedQualOption];
    this.inputs.options = this.qualOptions;

    this.inputs.iteratorSchemaNS = this.iteratorSchemaNSInput;
    this.inputs.iteratorPropName = this.iteratorPropNameInput;
    this.iteratorOpts = this.selectedIteratorOption === '无选项' ? [] : [this.selectedIteratorOption];
    this.inputs.iteratorOpts = this.iteratorOpts;
  }

  // 添加属性操作结果（到局部）
  addPropResult(name: string, passed: boolean, message: string): void {
    this.propOperationResult = [new TestResult(name, passed, message)];
  }

  // 添加数组操作结果（到局部）
  addArrayResult(name: string, passed: boolean, message: string): void {
    this.arrayOperationResult = [new TestResult(name, passed, message)];
  }

  // 添加结构体操作结果（到局部）
  addStructResult(name: string, passed: boolean, message: string): void {
    this.structOperationResult = [new TestResult(name, passed, message)];
  }

  // 添加限定符操作结果（到局部）
  addQualResult(name: string, passed: boolean, message: string): void {
    this.qualOperationResult = [new TestResult(name, passed, message)];
  }

  // 添加迭代器操作结果（到局部）
  addIteratorResult(name: string, passed: boolean, message: string): void {
    this.iteratorOperationResult = [new TestResult(name, passed, message)];
  }

  // 解析属性选项
  parseOptions(optionsArray: string[]): PropertyOptions {
    const options = new PropertyOptions();

    optionsArray.forEach((option: string) => {
      const trimmed = option.trim();
      switch(trimmed) {
        case 'language':
          options.setHasLanguage(true);
          break;
        case 'type':
          options.setHasType(true);
          break;
        case 'qualifier':
          options.setQualifier(true);
          break;
      }
    });

    return options;
  }

  // 解析 Iterator 选项
  parseIteratorOptions(optionsArray: string[]): IteratorOptions {
    const options = new IteratorOptions();

    optionsArray.forEach((option: string) => {
      const trimmed = option.trim();
      switch(trimmed) {
        case 'JUST_CHILDREN':
          options.setJustChildren(true);
          break;
        case 'JUST_LEAFNODES':
          if (options.setJustLeafnodes) {
            options.setJustLeafnodes(true);
          }
          break;
        case 'JUST_LEAFNAME':
          if (options.setJustLeafname) {
            options.setJustLeafname(true);
          }
          break;
        case 'OMIT_QUALIFIERS':
          options.setOmitQualifiers(true);
          break;
        case 'INCLUDE_ALIASES':
          options.setIncludeAliases(true);
          break;
      }
    });

    return options;
  }

  // 测试 设置属性
  testSetProperty(): void {
    this.currentOperation = '设置属性';
    this.syncInputs();
    try {
      const options = this.parseOptions(this.propOptions);
      this.xmpMeta.setProperty(
        this.schemaNSInput,
        this.propNameInput,
        this.propValueInput,
        options
      );

      const message = `设置属性成功:\n` +
        `命名空间: ${this.schemaNSInput}\n` +
        `属性名: ${this.propNameInput}\n` +
        `属性值: ${this.propValueInput}\n` +
        `选项: ${this.propOptions.length > 0 ? this.propOptions.join(', ') : '无选项'}`;
      this.addPropResult('设置属性', true, message);
    } catch (e) {
      const error = e as Error;
      const message = `设置属性失败: ${error.message}`;
      this.addPropResult('设置属性', false, message);
    }
  }

  // 测试 获取属性
  testGetProperty(): void {
    this.currentOperation = '获取属性';
    this.syncInputs();
    try {
      const property = this.xmpMeta.getProperty(
        this.schemaNSInput,
        this.propNameInput
      );

      if (property) {
        const message = `获取属性成功:\n` +
          `属性值: ${property.getValue()}\n` +
          `命名空间: ${this.schemaNSInput}\n` +
          `属性名: ${this.propNameInput}`;
        this.addPropResult('获取属性', true, message);
      } else {
        const message = '属性不存在';
        this.addPropResult('获取属性', false, message);
      }
    } catch (e) {
      const error = e as Error;
      const message = `获取属性失败: ${error.message}`;
      this.addPropResult('获取属性', false, message);
    }
  }

  // 测试 追加数组项
  testAppendArrayItem(): void {
    this.currentOperation = '追加数组项';
    this.syncInputs();
    try {
      // 如果数组不存在，先创建数组
      if (!this.xmpMeta.doesPropertyExist(this.arraySchemaNSInput, this.arrayNameInput)) {
        const arrayOptions = new PropertyOptions();
        arrayOptions.setArray(true);
        this.xmpMeta.setProperty(this.arraySchemaNSInput, this.arrayNameInput, '', arrayOptions);
      }

      // 追加数组项
      const itemOptions = this.parseOptions(this.arrayOpts);
      this.xmpMeta.appendArrayItem(
        this.arraySchemaNSInput,
        this.arrayNameInput,
        itemOptions,
        this.itemValueInput,
        itemOptions
      );

      // 获取追加后的数组数量
      const itemCount = this.xmpMeta.countArrayItems(this.arraySchemaNSInput, this.arrayNameInput);

      const message = `追加数组项成功:\n` +
        `数组名: ${this.arrayNameInput}\n` +
        `追加的值: ${this.itemValueInput}\n` +
        `选项: ${this.arrayOpts.length > 0 ? this.arrayOpts.join(', ') : '无选项'}\n` +
        `数组当前项数: ${itemCount}`;
      this.addArrayResult('追加数组项', true, message);
    } catch (e) {
      const error = e as Error;
      const message = `追加数组项失败: ${error.message}`;
      this.addArrayResult('追加数组项', false, message);
    }
  }

  // 测试 设置数组项
  testSetArrayItem(): void {
    this.currentOperation = '设置数组项';
    this.syncInputs();
    try {
      const options = this.parseOptions(this.arrayOpts);

      if (!this.xmpMeta.doesPropertyExist(this.arraySchemaNSInput, this.arrayNameInput)) {
        const arrayOptions = new PropertyOptions();
        arrayOptions.setArray(true);
        this.xmpMeta.setProperty(this.arraySchemaNSInput, this.arrayNameInput, '', arrayOptions);
      }

      this.xmpMeta.setArrayItem(
        this.arraySchemaNSInput,
        this.arrayNameInput,
        parseInt(this.itemIndexInput) || 1,
        this.itemValueInput,
        options
      );

      const message = `设置数组项成功:\n` +
        `数组名: ${this.arrayNameInput}\n` +
        `索引: ${this.itemIndexInput}\n` +
        `值: ${this.itemValueInput}\n` +
        `选项: ${this.arrayOpts.length > 0 ? this.arrayOpts.join(', ') : '无选项'}`;
      this.addArrayResult('设置数组项', true, message);
    } catch (e) {
      const error = e as Error;
      const message = `设置数组项失败: ${error.message}`;
      this.addArrayResult('设置数组项', false, message);
    }
  }

  // 测试 获取数组项
  testGetArrayItem(): void {
    this.currentOperation = '获取数组项';
    this.syncInputs();
    try {
      const item = this.xmpMeta.getArrayItem(
        this.arraySchemaNSInput,
        this.arrayNameInput,
        parseInt(this.itemIndexInput) || 1
      );

      if (item) {
        const message = `获取数组项成功:\n` +
          `数组: ${this.arrayNameInput}\n` +
          `索引: ${this.itemIndexInput}\n` +
          `值: ${item.getValue()}`;
        this.addArrayResult('获取数组项', true, message);
      } else {
        const message = '数组项不存在';
        this.addArrayResult('获取数组项', false, message);
      }
    } catch (e) {
      const error = e as Error;
      const message = `获取数组项失败: ${error.message}`;
      this.addArrayResult('获取数组项', false, message);
    }
  }

  // 测试 设置结构体
  testSetStructField(): void {
    this.currentOperation = '设置结构体';
    this.syncInputs();
    try {
      const options = this.parseOptions(this.structOpts);

      if (!this.xmpMeta.doesPropertyExist(this.structSchemaNSInput, this.structNameInput)) {
        const structOptions = new PropertyOptions();
        structOptions.setStruct(true);
        this.xmpMeta.setProperty(this.structSchemaNSInput, this.structNameInput, '', structOptions);
      }

      this.xmpMeta.setStructField(
        this.structSchemaNSInput,
        this.structNameInput,
        'ns:field/',
        this.fieldNameInput,
        this.fieldValueInput,
        options
      );

      const message = `设置结构体字段成功:\n` +
        `结构体: ${this.structNameInput}\n` +
        `字段: ${this.fieldNameInput}\n` +
        `值: ${this.fieldValueInput}\n` +
        `选项: ${this.structOpts.length > 0 ? this.structOpts.join(', ') : '无选项'}`;
      this.addStructResult('设置结构体', true, message);
    } catch (e) {
      const error = e as Error;
      const message = `设置结构体字段失败: ${error.message}`;
      this.addStructResult('设置结构体', false, message);
    }
  }

  // 测试 获取结构体
  testGetStructField(): void {
    this.currentOperation = '获取结构体';
    this.syncInputs();
    try {
      const field = this.xmpMeta.getStructField(
        this.structSchemaNSInput,
        this.structNameInput,
        'ns:field/',
        this.fieldNameInput
      );

      if (field) {
        const message = `获取结构体字段成功:\n` +
          `结构体: ${this.structNameInput}\n` +
          `字段: ${this.fieldNameInput}\n` +
          `值: ${field.getValue()}`;
        this.addStructResult('获取结构体', true, message);
      } else {
        const message = '结构体字段不存在';
        this.addStructResult('获取结构体', false, message);
      }
    } catch (e) {
      const error = e as Error;
      const message = `获取结构体字段失败: ${error.message}`;
      this.addStructResult('获取结构体', false, message);
    }
  }

  // 测试 设置限定符
  testSetQualifier(): void {
    this.currentOperation = '设置限定符';
    this.syncInputs();
    try {
      const options = this.parseOptions(this.qualOptions);

      if (!this.xmpMeta.doesPropertyExist(this.qualSchemaNSInput, this.qualPropNameInput)) {
        this.xmpMeta.setProperty(this.qualSchemaNSInput, this.qualPropNameInput, 'InitialValue');
      }

      this.xmpMeta.setQualifier(
        this.qualSchemaNSInput,
        this.qualPropNameInput,
        'ns:qual/',
        this.qualNameInput,
        this.qualValueInput,
        options
      );

      const message = `设置限定符成功:\n` +
        `属性: ${this.qualPropNameInput}\n` +
        `限定符: ${this.qualNameInput}\n` +
        `值: ${this.qualValueInput}\n` +
        `选项: ${this.qualOptions.length > 0 ? this.qualOptions.join(', ') : '无选项'}`;
      this.addQualResult('设置限定符', true, message);
    } catch (e) {
      const error = e as Error;
      const message = `设置限定符失败: ${error.message}`;
      this.addQualResult('设置限定符', false, message);
    }
  }

  // 测试 获取限定符
  testGetQualifier(): void {
    this.currentOperation = '获取限定符';
    this.syncInputs();
    try {
      const qualifier = this.xmpMeta.getQualifier(
        this.qualSchemaNSInput,
        this.qualPropNameInput,
        'ns:qual/',
        this.qualNameInput
      );

      if (qualifier) {
        const message = `获取限定符成功:\n` +
          `属性: ${this.qualPropNameInput}\n` +
          `限定符: ${this.qualNameInput}\n` +
          `值: ${qualifier.getValue()}`;
        this.addQualResult('获取限定符', true, message);
      } else {
        const message = '限定符不存在';
        this.addQualResult('获取限定符', false, message);
      }
    } catch (e) {
      const error = e as Error;
      const message = `获取限定符失败: ${error.message}`;
      this.addQualResult('获取限定符', false, message);
    }
  }

  // 测试 删除属性
  testDeleteProperty(): void {
    this.currentOperation = '删除属性';
    this.syncInputs();
    try {
      if (!this.xmpMeta.doesPropertyExist(this.schemaNSInput, this.propNameInput)) {
        this.xmpMeta.setProperty(this.schemaNSInput, this.propNameInput, 'TempValue');
      }

      this.xmpMeta.deleteProperty(this.schemaNSInput, this.propNameInput);

      const exists = this.xmpMeta.doesPropertyExist(this.schemaNSInput, this.propNameInput);

      if (!exists) {
        const message = `删除属性成功:\n` +
          `命名空间: ${this.schemaNSInput}\n` +
          `属性名: ${this.propNameInput}`;
        this.addPropResult('删除属性', true, message);
      } else {
        const message = '删除属性失败，属性仍然存在';
        this.addPropResult('删除属性', false, message);
      }
    } catch (e) {
      const error = e as Error;
      const message = `删除属性失败: ${error.message}`;
      this.addPropResult('删除属性', false, message);
    }
  }

  // 测试 删除数组项
  testDeleteArrayItem(): void {
    this.currentOperation = '删除数组项';
    this.syncInputs();
    try {
      if (!this.xmpMeta.doesArrayItemExist(this.arraySchemaNSInput, this.arrayNameInput,
                                           parseInt(this.itemIndexInput) || 1)) {
        this.testSetArrayItem();
      }

      const countBefore = this.xmpMeta.countArrayItems(this.arraySchemaNSInput,
                                                       this.arrayNameInput);
      this.xmpMeta.deleteArrayItem(this.arraySchemaNSInput, this.arrayNameInput,
                                   parseInt(this.itemIndexInput) || 1);
      const countAfter = this.xmpMeta.countArrayItems(this.arraySchemaNSInput, this.arrayNameInput);

      const message = `删除数组项成功:\n` +
        `数组: ${this.arrayNameInput}\n` +
        `索引: ${this.itemIndexInput}\n` +
        `删除前数量: ${countBefore}\n` +
        `删除后数量: ${countAfter}`;
      this.addArrayResult('删除数组项', true, message);
    } catch (e) {
      const error = e as Error;
      const message = `删除数组项失败: ${error.message}`;
      this.addArrayResult('删除数组项', false, message);
    }
  }

  // 测试 删除结构体字段
  testDeleteStructField(): void {
    this.currentOperation = '删除结构体字段';
    this.syncInputs();
    try {
      if (!this.xmpMeta.doesStructFieldExist(
        this.structSchemaNSInput,
        this.structNameInput,
        'ns:field/',
        this.fieldNameInput
      )) {
        this.testSetStructField();
      }

      const existsBefore = this.xmpMeta.doesStructFieldExist(
        this.structSchemaNSInput,
        this.structNameInput,
        'ns:field/',
        this.fieldNameInput
      );

      this.xmpMeta.deleteStructField(
        this.structSchemaNSInput,
        this.structNameInput,
        'ns:field/',
        this.fieldNameInput
      );

      const existsAfter = this.xmpMeta.doesStructFieldExist(
        this.structSchemaNSInput,
        this.structNameInput,
        'ns:field/',
        this.fieldNameInput
      );

      if (existsBefore && !existsAfter) {
        const message = `删除结构体字段成功:\n` +
          `结构体: ${this.structNameInput}\n` +
          `字段: ${this.fieldNameInput}`;
        this.addStructResult('删除结构体字段', true, message);
      } else {
        const message = '删除结构体字段失败';
        this.addStructResult('删除结构体字段', false, message);
      }
    } catch (e) {
      const error = e as Error;
      const message = `删除结构体字段失败: ${error.message}`;
      this.addStructResult('删除结构体字段', false, message);
    }
  }

  // 测试 删除限定符
  testDeleteQualifier(): void {
    this.currentOperation = '删除限定符';
    this.syncInputs();
    try {
      if (!this.xmpMeta.doesQualifierExist(
        this.qualSchemaNSInput,
        this.qualPropNameInput,
        'ns:qual/',
        this.qualNameInput
      )) {
        this.testSetQualifier();
      }

      const existsBefore = this.xmpMeta.doesQualifierExist(
        this.qualSchemaNSInput,
        this.qualPropNameInput,
        'ns:qual/',
        this.qualNameInput
      );

      this.xmpMeta.deleteQualifier(
        this.qualSchemaNSInput,
        this.qualPropNameInput,
        'ns:qual/',
        this.qualNameInput
      );

      const existsAfter = this.xmpMeta.doesQualifierExist(
        this.qualSchemaNSInput,
        this.qualPropNameInput,
        'ns:qual/',
        this.qualNameInput
      );

      if (existsBefore && !existsAfter) {
        const message = `删除限定符成功:\n` +
          `属性: ${this.qualPropNameInput}\n` +
          `限定符: ${this.qualNameInput}`;
        this.addQualResult('删除限定符', true, message);
      } else {
        const message = '删除限定符失败';
        this.addQualResult('删除限定符', false, message);
      }
    } catch (e) {
      const error = e as Error;
      const message = `删除限定符失败: ${error.message}`;
      this.addQualResult('删除限定符', false, message);
    }
  }

  // 测试 iterator
  testIteratorWithParams(): void {
    this.currentOperation = 'iterator(schemaNS, propName, options)';
    this.syncInputs();
    try {
      this.xmpMeta.setProperty('ns:test/', 'Root/Sub1', 'Value1');
      this.xmpMeta.setProperty('ns:test/', 'Root/Sub2', 'Value2');
      this.xmpMeta.setProperty('ns:test/', 'OtherProp', 'Value3');

      const options = this.parseIteratorOptions(this.iteratorOpts);
      const iterator = this.xmpMeta.iterator(
        this.iteratorSchemaNSInput,
        this.iteratorPropNameInput,
        options
      );

      let count = 0;
      let resultText = '属性遍历结果:\n';
      resultText += `命名空间: ${this.iteratorSchemaNSInput}\n`;
      resultText += `路径: ${this.iteratorPropNameInput || '空(遍历所有)'}\n`;
      resultText += `选项: ${this.iteratorOpts.length > 0 ? this.iteratorOpts.join(', ') : '无选项'}\n\n`;

      while (iterator.hasNext()) {
        const property = iterator.next();
        if (property) {
          count++;
          resultText += `${count}. ${property.getValue()}\n`;
        }
      }

      resultText += `\n总共找到 ${count} 个属性`;
      this.iteratorResults = [resultText];

      const message = `属性遍历测试成功:\n` +
        `命名空间: ${this.iteratorSchemaNSInput}\n` +
        `路径: ${this.iteratorPropNameInput || '空'}\n` +
        `选项: ${this.iteratorOpts.length > 0 ? this.iteratorOpts.join(', ') : '无选项'}\n` +
        `找到 ${count} 个属性`;
      this.addIteratorResult('属性遍历', true, message);
    } catch (e) {
      const error = e as Error;
      const message = `属性遍历测试失败: ${error.message}`;
      this.addIteratorResult('属性遍历', false, message);
    }
  }

  // 清空所有数据
  clearAllData(): void {
    this.xmpMeta = XMPMetaFactory.create();
    this.iteratorResults = [];
    this.propOperationResult = [];
    this.arrayOperationResult = [];
    this.structOperationResult = [];
    this.qualOperationResult = [];
    this.iteratorOperationResult = [];
    this.selectedPropOption = '无选项';
    this.selectedArrayOption = '无选项';
    this.selectedStructOption = '无选项';
    this.selectedQualOption = '无选项';
    this.selectedIteratorOption = '无选项';
  }

  // 清除测试结果
  clearResults(): void {
    this.iteratorResults = [];
    this.currentOperation = '';
    this.propOperationResult = [];
    this.arrayOperationResult = [];
    this.structOperationResult = [];
    this.qualOperationResult = [];
    this.iteratorOperationResult = [];
  }

  build() {
    Scroll() {
      Column() {
        Text('属性读写操作以及遍历-测试')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 20 })

        if (this.currentOperation) {
          Text(`当前操作: ${this.currentOperation}`)
            .fontSize(14)
            .fontColor('#0066CC')
            .margin({ bottom: 20 })
        }

        // 1. Property 操作区域
        Column() {
          Text('1. 属性操作')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('命名空间:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入命名空间', text: this.schemaNSInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.schemaNSInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.propNameInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.propNameInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('属性值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性值', text: this.propValueInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.propValueInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.propertyOptionsList)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .value(this.selectedPropOption)
              .onSelect((index: number, value: string) => {
                this.selectedPropOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置属性')
              .fontSize(12)
              .backgroundColor('#007DFF')
              .width('30%')
              .onClick(() => this.testSetProperty())
              .margin({ right: '2%' })

            Button('获取属性')
              .fontSize(12)
              .backgroundColor('#007DFF')
              .width('30%')
              .onClick(() => this.testGetProperty())
              .margin({ right: '2%' })

            Button('删除属性')
              .fontSize(12)
              .backgroundColor('#FF4444')
              .width('30%')
              .onClick(() => this.testDeleteProperty())
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 8 })

          // 属性操作结果
          if (this.propOperationResult.length > 0) {
            ForEach(this.propOperationResult, (item: TestResult) => {
              Column() {
                Row() {
                  Text(item.name)
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(item.passed ? '#006600' : '#CC0000')
                    .layoutWeight(1)

                  Text(item.passed ? '✅' : '❌')
                    .fontSize(14)
                }
                .width('100%')
                .margin({ bottom: 2 })

                Text(item.message)
                  .fontSize(10)
                  .fontColor('#666666')
                  .maxLines(5)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(item.timestamp)
                  .fontSize(9)
                  .fontColor('#999999')
                  .margin({ top: 2 })
              }
              .padding(8)
              .backgroundColor(item.passed ? '#F0FFF0' : '#FFF0F0')
              .borderRadius(4)
              .width('100%')
            }, (item: TestResult) => item.timestamp + item.name)
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 2. Array 操作区域
        Column() {
          Text('2. 数组操作')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('命名空间:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入命名空间', text: this.arraySchemaNSInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.arraySchemaNSInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('数组名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入数组名', text: this.arrayNameInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.arrayNameInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('索引:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入索引', text: this.itemIndexInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.itemIndexInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('数组项值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入数组项值', text: this.itemValueInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.itemValueInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.arrayOptionsList)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .value(this.selectedArrayOption)
              .onSelect((index: number, value: string) => {
                this.selectedArrayOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Column() {
            Row() {
              Button('追加数组项')
                .fontSize(12)
                .backgroundColor('#00AA33')
                .width('48%')
                .onClick(() => this.testAppendArrayItem())
                .margin({ right: '4%' })

              Button('设置数组项')
                .fontSize(12)
                .backgroundColor('#007DFF')
                .width('48%')
                .onClick(() => this.testSetArrayItem())
            }
            .width('100%')
            .margin({ bottom: 6 })

            Row() {
              Button('获取数组项')
                .fontSize(12)
                .backgroundColor('#007DFF')
                .width('48%')
                .onClick(() => this.testGetArrayItem())
                .margin({ right: '4%' })

              Button('删除数组项')
                .fontSize(12)
                .backgroundColor('#FF4444')
                .width('48%')
                .onClick(() => this.testDeleteArrayItem())
            }
            .width('100%')
          }
          .width('100%')
          .margin({ bottom: 8 })

          // 数组操作结果
          if (this.arrayOperationResult.length > 0) {
            ForEach(this.arrayOperationResult, (item: TestResult) => {
              Column() {
                Row() {
                  Text(item.name)
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(item.passed ? '#006600' : '#CC0000')
                    .layoutWeight(1)

                  Text(item.passed ? '✅' : '❌')
                    .fontSize(14)
                }
                .width('100%')
                .margin({ bottom: 2 })

                Text(item.message)
                  .fontSize(10)
                  .fontColor('#666666')
                  .maxLines(5)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(item.timestamp)
                  .fontSize(9)
                  .fontColor('#999999')
                  .margin({ top: 2 })
              }
              .padding(8)
              .backgroundColor(item.passed ? '#F0FFF0' : '#FFF0F0')
              .borderRadius(4)
              .width('100%')
            }, (item: TestResult) => item.timestamp + item.name)
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 3. Struct 操作区域
        Column() {
          Text('3. 结构体操作')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('命名空间:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入命名空间', text: this.structSchemaNSInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.structSchemaNSInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('结构体名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入结构体名', text: this.structNameInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.structNameInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('字段名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入字段名', text: this.fieldNameInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.fieldNameInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('字段值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入字段值', text: this.fieldValueInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.fieldValueInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.structOptionsList)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .value(this.selectedStructOption)
              .onSelect((index: number, value: string) => {
                this.selectedStructOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置结构体')
              .fontSize(12)
              .backgroundColor('#007DFF')
              .width('30%')
              .onClick(() => this.testSetStructField())
              .margin({ right: '2%' })

            Button('获取结构体')
              .fontSize(12)
              .backgroundColor('#007DFF')
              .width('30%')
              .onClick(() => this.testGetStructField())
              .margin({ right: '2%' })

            Button('删除结构体字段')
              .fontSize(12)
              .backgroundColor('#FF4444')
              .width('30%')
              .onClick(() => this.testDeleteStructField())
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 8 })

          // 结构体操作结果
          if (this.structOperationResult.length > 0) {
            ForEach(this.structOperationResult, (item: TestResult) => {
              Column() {
                Row() {
                  Text(item.name)
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(item.passed ? '#006600' : '#CC0000')
                    .layoutWeight(1)

                  Text(item.passed ? '✅' : '❌')
                    .fontSize(14)
                }
                .width('100%')
                .margin({ bottom: 2 })

                Text(item.message)
                  .fontSize(10)
                  .fontColor('#666666')
                  .maxLines(5)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(item.timestamp)
                  .fontSize(9)
                  .fontColor('#999999')
                  .margin({ top: 2 })
              }
              .padding(8)
              .backgroundColor(item.passed ? '#F0FFF0' : '#FFF0F0')
              .borderRadius(4)
              .width('100%')
            }, (item: TestResult) => item.timestamp + item.name)
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 4. Qualifier 操作区域
        Column() {
          Text('4. 限定符操作')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('命名空间:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入命名空间', text: this.qualSchemaNSInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.qualSchemaNSInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('属性名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入属性名', text: this.qualPropNameInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.qualPropNameInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('限定符名:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入限定符名', text: this.qualNameInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.qualNameInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('限定符值:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入限定符值', text: this.qualValueInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.qualValueInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.qualifierOptionsList)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .value(this.selectedQualOption)
              .onSelect((index: number, value: string) => {
                this.selectedQualOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('设置限定符')
              .fontSize(12)
              .backgroundColor('#007DFF')
              .width('30%')
              .onClick(() => this.testSetQualifier())
              .margin({ right: '2%' })

            Button('获取限定符')
              .fontSize(12)
              .backgroundColor('#007DFF')
              .width('30%')
              .onClick(() => this.testGetQualifier())
              .margin({ right: '2%' })

            Button('删除限定符')
              .fontSize(12)
              .backgroundColor('#FF4444')
              .width('30%')
              .onClick(() => this.testDeleteQualifier())
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 8 })

          // 限定符操作结果
          if (this.qualOperationResult.length > 0) {
            ForEach(this.qualOperationResult, (item: TestResult) => {
              Column() {
                Row() {
                  Text(item.name)
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(item.passed ? '#006600' : '#CC0000')
                    .layoutWeight(1)

                  Text(item.passed ? '✅' : '❌')
                    .fontSize(14)
                }
                .width('100%')
                .margin({ bottom: 2 })

                Text(item.message)
                  .fontSize(10)
                  .fontColor('#666666')
                  .maxLines(5)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(item.timestamp)
                  .fontSize(9)
                  .fontColor('#999999')
                  .margin({ top: 2 })
              }
              .padding(8)
              .backgroundColor(item.passed ? '#F0FFF0' : '#FFF0F0')
              .borderRadius(4)
              .width('100%')
            }, (item: TestResult) => item.timestamp + item.name)
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        // 5. Iterator 操作区域
        Column() {
          Text('5. 属性遍历操作')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Text('命名空间:')
              .fontSize(14)
              .width('30%')
            TextInput({ placeholder: '输入命名空间', text: this.iteratorSchemaNSInput })
              .fontSize(14)
              .width('70%')
              .onChange((value: string) => {
                this.iteratorSchemaNSInput = value;
              })
          }
          .margin({ bottom: 6 })
          .width('100%')

          Row() {
            Text('选项:')
              .fontSize(14)
              .width('30%')
            Select(this.iteratorOptionsList)
              .selectedOptionFont({ size: 14 })
              .optionFont({ size: 14 })
              .width('70%')
              .value(this.selectedIteratorOption)
              .onSelect((index: number, value: string) => {
                this.selectedIteratorOption = value;
              })
          }
          .margin({ bottom: 8 })
          .width('100%')

          Row() {
            Button('属性遍历')
              .fontSize(12)
              .backgroundColor('#007DFF')
              .width('100%')
              .onClick(() => this.testIteratorWithParams())
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 8 })

          // 迭代器操作结果
          if (this.iteratorOperationResult.length > 0) {
            ForEach(this.iteratorOperationResult, (item: TestResult) => {
              Column() {
                Row() {
                  Text(item.name)
                    .fontSize(12)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(item.passed ? '#006600' : '#CC0000')
                    .layoutWeight(1)

                  Text(item.passed ? '✅' : '❌')
                    .fontSize(14)
                }
                .width('100%')
                .margin({ bottom: 2 })

                Text(item.message)
                  .fontSize(10)
                  .fontColor('#666666')
                  .maxLines(5)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(item.timestamp)
                  .fontSize(9)
                  .fontColor('#999999')
                  .margin({ top: 2 })
              }
              .padding(8)
              .backgroundColor(item.passed ? '#F0FFF0' : '#FFF0F0')
              .borderRadius(4)
              .width('100%')
            }, (item: TestResult) => item.timestamp + item.name)
          }
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })

        if (this.iteratorResults.length > 0) {
          Column() {
            Text('遍历结果')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 10 })

            ForEach(this.iteratorResults, (result: string, index: number) => {
              Text(result)
                .fontSize(12)
                .fontColor('#333333')
                .backgroundColor('#F8F8F8')
                .padding(12)
                .borderRadius(6)
                .margin({ bottom: 8 })
                .width('100%')
            }, (result: string, index: number) => index.toString())
          }
          .padding(12)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .margin({ bottom: 12 })
        }

        // 管理按钮
        Column() {
          Text('管理操作')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 8 })
            .width('100%')

          Row() {
            Button('清空数据')
              .fontSize(12)
              .width('48%')
              .height(36)
              .backgroundColor('#FF6600')
              .onClick(() => this.clearAllData())
              .margin({ right: '4%' })

            Button('清除结果')
              .fontSize(12)
              .width('48%')
              .height(36)
              .backgroundColor('#FFAA33')
              .onClick(() => this.clearResults())
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding(12)
        .backgroundColor('#F8F9FA')
        .borderRadius(8)
        .margin({ bottom: 12 })
      }
      .padding({ left: 16, right: 16, top: 8, bottom: 16 })
    }
    .width('100%')
    .height('100%')
  }
}