import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import * as xml from "@ohos/mammoth/src/main/ets/xml";
import { DocumentsImage, ResultType } from '../Type';
import { createBodyReader, _readNumberingProperties } from '@ohos/mammoth/src/main/ets/docx/body-reader';
import { Styles } from '@ohos/mammoth/src/main/ets/docx/styles-reader';
import { defaultNumbering } from '@ohos/mammoth/src/main/ets/docx/numbering-xml';
import { Relationships } from '@ohos/mammoth/src/main/ets/docx/relationships-reader';
import { buffer, buffer as Buffer } from '@kit.ArkTS';

// 元素接口定义
interface IElement {
  type: string;
  name: string;
  attributes: Record<string, string>;
  children: IElement[] | TextNode[];

  first(name: string): IElement | null;

  firstOrEmpty(name: string): IElement;

  getElementsByTagName(name: string): IElementList;

  text(): string;
}

// 元素列表接口
interface IElementList extends Array<IElement> {
  getElementsByTagName(name: string): IElementList;
}

// 文本节点类型
export interface TextNode {
  type: "text";
  value: string;
}

// 工厂函数：创建元素
function createElement(name: string, attributes?: Record<string, string>,
  children?: IElement[] | TextNode[]): IElement {
  return xml.element(name, attributes, children);
}

// 工厂函数：创建文本节点
function createText(value: string): TextNode {
  return xml.text(value) as TextNode;
}

// 定义接口类型
interface Options {
  relationships?: Object;
  contentTypes?: Object;
  docxFile?: DocxFile;
  files?: File;
  numbering?: Object;
  styles?: OptionsStyles;
}

interface DocxFile {
  read: (path: string, encoding?: string) => Promise<ESObject>
  exists: (path: string) => ESObject

}

interface File {
  read: (path: string, encoding?: string) => Promise<ESObject>
}

const createFakeDocxFile = (files: ESObject) => {
  const exists = (path: string) => {
    return !!files[path];
  }

  let res: DocxFile = {
    read: createRead(files),
    exists: exists
  };
  return res
}

const createFakeFiles = (files: ESObject) => {
  let res: File = {
    read: createRead(files)
  };
  return res
}

const createRead = (files: ESObject): ESObject => {
  const read = (path: string, encoding: string): ESObject => {
    const fileContent: ESObject = files[path];

    return Promise.resolve(fileContent).then((buffer: Buffer.Buffer): ESObject => {
      if (typeof buffer === 'string') {
        buffer = Buffer.from(buffer);
      }

      if (!Buffer.isBuffer(buffer)) {
        return Promise.reject(new Error("file was not a buffer"));
      } else if (encoding) {
        return Promise.resolve(buffer.toString(encoding));
      } else {
        // 注意：buffer.buffer 返回的是底层的 ArrayBuffer
        // 如果没有这个属性，直接返回 buffer
        return Promise.resolve(buffer.buffer || buffer);
      }
    });
  }
  return read;
}

interface OptionsStyles {
  findParagraphStyleById: (styleId: string) => Style | undefined,
  findCharacterStyleById: (styleId: string) => Style | undefined,
  findTableStyleById: (styleId: string) => Style | undefined,
  findNumberingStyleById: (styleId: string) => Style | undefined
}

interface Style {
  name: string;
};

interface FakeContentTypes {
  findContentType: (filePath: string) => string;
};

interface Numbering {
  level: string;
  isOrdered: boolean;
}

interface Indent {
  start: string | null;
  end: string | null;
  firstLine: string | null;
  hanging: string | null;
}

interface Paragraph {
  type: string;
  styleId: string | null;
  styleName: string | null;
  alignment: string | null;
  indent: Indent;
  numbering: Numbering | null;
  children: Run[];
}

interface Run {
  type: string;
  styleId: string | null;
  styleName: string | null;
  isBold: boolean;
  isItalic: boolean;
  isUnderline: boolean;
  isStrikethrough: boolean;
  isSmallCaps: boolean;
  isAllCaps: boolean;
  verticalAlignment: string;
  font: string | null;
  fontSize: number | null;
  highlight: string | null;
  children: Hyperlink[] | DocumentsImage[] | Checkbox[] | Text[] | Break[] | NoteReference[] | CommentReference[] | BookmarkStart[];
}

interface Table {
  type: string;
  styleId: string | null;
  styleName: string | null;
  children: TableRow[];
}

interface TableRow {
  type: string;
  isHeader: boolean;
  children: TableCell[];
}

interface TableCell {
  type: string;
  colSpan?: number;
  rowSpan?: number;
  children: Paragraph[];
}

export interface Hyperlink {
  type: string;
  href?: string;
  anchor?: string;
  targetFrame?: string | null;
  children: Text[] | DocumentsImage[];
}


interface Checkbox {
  type: string;
  checked: boolean;
}

interface Text {
  type: string;
  value: string;
}

interface Break {
  type: string;
  breakType: string;
}

interface Tab {
  type: string;
}

interface NoteReference {
  type: string;
  noteType: string;
  noteId: string;
}

interface CommentReference {
  type: string;
  commentId: string;
}

interface BookmarkStart {
  type: string;
  name: string;
}

interface BodyReaderFor {
  readXmlElement: (options: Options) => ResultType;
  readXmlElements: (options: Options) => ResultType;
}

interface InlineImageOption {
  blip: IElement;
  description?: string;
  title?: string;
  docPrChildren?: IElement[];
}

interface RelationshipOption {
  relationshipId: string,
  target: string,
  type: string
}

interface NumberingMapOption {
  findLevel?: Record<string, Record<string, Numbering>>;
  findLevelByParagraphStyleId?: Record<string, Numbering>;
}

interface NumberingMapInterface {
  findLevel: (numId: string, level: string) => Numbering;
  findLevelByParagraphStyleId: (styleId: string) => Numbering;
}

// 测试辅助函数
const TAG = 'BodyReaderTest';
const DOMAIN = 0x0000;

//testing
function createBodyReaderForTests(options?: Options): BodyReaderFor {
  let opt: Options = options || {};
  opt.styles = opt.styles || Styles({}, {});
  opt.numbering = opt.numbering || defaultNumbering;
  return createBodyReader(opt);
}

function readIElement(element: object, options?: Options): ResultType {
  return createBodyReaderForTests(options).readXmlElement(element);
}

function readIElements(element: object, options?: Options): ResultType {
  return createBodyReaderForTests(options).readXmlElements(element);
}

function readIElementValue(element: object,
  options?: Options): string | DocumentsImage | DocumentsImage[] | Hyperlink | Hyperlink[] {
  let result: ResultType = readIElement(element, options);
  expect(result.messages).assertDeepEquals([]);
  return result.value;
}

function readIElementsValue(elements: object[],
  options?: Options): string | DocumentsImage | DocumentsImage[] | Hyperlink | Hyperlink[] {
  let result: ResultType = readIElements(elements, options);
  expect(result.messages).assertDeepEquals([]);
  return result.value;
}

// 辅助函数：创建带缩进属性的段落
function paragraphWithIndent(indentAttributes: Record<string, string>): IElement {
  const indentXml: IElement = createElement('w:ind', indentAttributes, []);
  const propertiesXml: IElement = createElement('w:pPr', {}, [indentXml]);
  return createElement('w:p', {}, [propertiesXml]);
}

function paragraphWithStyleId(styleId: string): IElement {
  return createElement("w:p", {}, [
    createElement("w:pPr", {}, [
      createElement("w:pStyle", { "w:val": styleId }, [])
    ])
  ]);
}

function runWithProperties(children: IElement[]): IElement {
  return createElement("w:r", {}, [createRunPropertiesXml(children)]);
}

function createRunPropertiesXml(children: IElement[]) {
  return createElement("w:rPr", {}, children);
}

function single(array: object[]): object {
  if (array.length === 1) {
    return array[0];
  } else {
    throw new Error("Array has " + array.length + " elements");
  }
}

function createInlineImage(options: InlineImageOption) {
  return createElement("w:drawing", {}, [
    createElement("wp:inline", {}, [
      createElement(
        "wp:docPr",
        { "descr": options.description ?? "", "title": options.title ?? "" },
        options.docPrChildren ?? []
      ),
      createElement("a:graphic", {}, [
        createElement("a:graphicData", {}, [
          createElement("pic:pic", {}, [
            createElement("pic:blipFill", {}, [
              options.blip
            ])
          ])
        ])
      ])
    ])
  ]);
}

function createEmbeddedBlip(relationshipId: string): IElement {
  return createElement("a:blip", { "r:embed": relationshipId });
}

function createLinkedBlip(relationshipId: string): IElement {
  return createElement("a:blip", { "r:link": relationshipId });
}

function runOfText(text: string): IElement {
  let textIElement: TextNode = createText(text);
  let textXml = createElement("w:t", {}, [textIElement]);
  return createElement("w:r", {}, [textXml]);
}

function hyperlinkRelationship(relationshipId: string, target: string): RelationshipOption {
  return {
    relationshipId: relationshipId,
    target: target,
    type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink"
  };
}

function imageRelationship(relationshipId: string, target: string): RelationshipOption {
  return {
    relationshipId: relationshipId,
    target: target,
    type: "http://schemas.openxmlformats.org/officeDocument/2006/relationships/image"
  };
}

function NumberingMap(options: NumberingMapOption): NumberingMapInterface {
  let findLevel: Record<string, Record<string, Numbering>> = options.findLevel || {};
  let findLevelByParagraphStyleId: Record<string, Numbering> = options.findLevelByParagraphStyleId || {};

  return {
    findLevel: (numId: string, level: string) => {
      return findLevel[numId][level];
    },
    findLevelByParagraphStyleId: (styleId) => {
      return findLevelByParagraphStyleId[styleId];
    }
  };
}

// 辅助函数：创建空单元格
function emptyCell(...props: IElement[]): IElement {
  const tcPrChildren: IElement[] = [...props];
  return createElement("w:tc", {}, [
    createElement("w:tcPr", {}, tcPrChildren)
  ]);
}

// 辅助函数：创建vMerge元素
function vMerge(val?: string): IElement {
  const attrs: Record<string, string> = val ? { "w:val": val } : {};
  return createElement("w:vMerge", attrs, []);
}

// 辅助函数：创建行
function row(...cells: IElement[]): IElement {
  return createElement("w:tr", {}, cells);
}

// 辅助函数：创建gridSpan元素
function gridSpan(val: string): IElement {
  return createElement("w:gridSpan", { "w:val": val }, []);
}


const fakeContentTypes: FakeContentTypes = {
  findContentType: (filePath: string): string => {
    const extensionTypes: Record<string, string> = {
      ".png": "image/png",
      ".emf": "image/x-emf"
    };
    const ext: string = filePath.substring(filePath.lastIndexOf('.'));
    return extensionTypes[ext];
  }
};

export default function bodyReaderAbilityTest() {
  describe('ActsBodyReaderAbilityTest', () => {

    beforeAll(() => {
      hilog.info(DOMAIN, TAG, '%{public}s', '开始执行文档解析器测试套件');
    });

    beforeEach(() => {
      hilog.info(DOMAIN, TAG, '%{public}s', '准备执行测试用例');
    });

    afterEach(() => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试用例执行完成');
    });

    afterAll(() => {
      hilog.info(DOMAIN, TAG, '%{public}s', '文档解析器测试套件执行完成');
    });

    // ========== 段落样式测试 ==========

    it('testParagraphHasNoStyleIfItHasNoProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无属性的段落没有样式');
      // 创建无属性的段落XML
      const paragraphXml: IElement = createElement('w:p', {}, []);
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.styleId).assertDeepEquals(null);
      done();
    });

    it('testParagraphHasStyleIdAndNameReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取段落样式ID和名称');

      // 创建带样式属性的段落XML
      const styleXml: IElement = createElement('w:pStyle', { 'w:val': 'Heading1' }, []);
      const propertiesXml: IElement = createElement('w:pPr', {}, [styleXml]);
      const paragraphXml: IElement = createElement('w:p', {}, [propertiesXml]);

      // 创建样式对象
      const styles: OptionsStyles = Styles({ 'Heading1': { name: 'Heading 1' } }, {});
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml, { styles: styles })));
      expect(paragraph.styleId).assertEqual('Heading1');
      expect(paragraph.styleName).assertEqual('Heading 1');
      done();
    });

    it('testWarningIsEmittedWhenParagraphStyleCannotBeFound', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试段落样式未找到时发出警告');

      // 创建带样式属性的段落XML
      const styleXml: IElement = createElement('w:pStyle', { 'w:val': 'Heading1' }, []);
      const propertiesXml: IElement = createElement('w:pPr', {}, [styleXml]);
      const paragraphXml: IElement = createElement('w:p', {}, [propertiesXml]);

      // 创建空样式对象
      const styles: OptionsStyles = Styles({}, {});

      const result: ResultType = readIElement(paragraphXml, { styles: styles });
      const paragraph: Paragraph = JSON.parse(JSON.stringify(result.value));
      expect(paragraph.styleId).assertEqual('Heading1');
      expect(paragraph.styleName).assertNull();
      // 验证是否有警告消息
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message)
        .assertEqual("Paragraph style with ID Heading1 was referenced but not defined in the document");
      done();

    });

    it('testParagraphHasJustificationReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取段落对齐方式');

      // 创建带对齐属性的段落XML
      const justificationXml: IElement = createElement('w:jc', { 'w:val': 'center' }, []);
      const propertiesXml: IElement = createElement('w:pPr', {}, [justificationXml]);
      const paragraphXml: IElement = createElement('w:p', {}, [propertiesXml]);
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.alignment).assertEqual('center');
      done();
    });


    it('testStartIndentReadFromWStart', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从w:start读取起始缩进');

      const paragraphXml: IElement = paragraphWithIndent({ 'w:start': '720', 'w:left': '40' });
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.indent.start).assertEqual('720');
      done();
    });

    it('testStartIndentReadFromWLeft', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从w:left读取起始缩进');

      const paragraphXml: IElement = paragraphWithIndent({ 'w:left': '720' });
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.indent.start).assertEqual('720');
      done();
    });

    it('testEndIndentReadFromWEnd', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从w:end读取结束缩进');

      const paragraphXml: IElement = paragraphWithIndent({ 'w:end': '720', 'w:right': '40' });
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.indent.end).assertEqual('720');
      done();
    });

    it('testEndIndentReadFromWRight', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从w:right读取结束缩进');

      const paragraphXml: IElement = paragraphWithIndent({ 'w:right': '720' });
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.indent.end).assertEqual('720');
      done();
    });

    it('testFirstLineIndentReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取首行缩进');

      const paragraphXml: IElement = paragraphWithIndent({ 'w:firstLine': '720' });
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.indent.firstLine).assertEqual('720');
      done();
    });

    it('testHangingIndentReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取悬挂缩进');

      const paragraphXml: IElement = paragraphWithIndent({ 'w:hanging': '720' });
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.indent.hanging).assertEqual('720');
      done();
    });

    it('testIndentsAreNullWhenAttributesNotSet', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试未设置属性时缩进为空');

      const paragraphXml: IElement = paragraphWithIndent({});
      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));
      expect(paragraph.indent.start).assertNull();
      expect(paragraph.indent.end).assertNull();
      expect(paragraph.indent.firstLine).assertNull();
      expect(paragraph.indent.hanging).assertNull();
      done();
    });

    // ========== 段落编号测试 ==========

    it('testParagraphHasNumberingPropertiesFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取段落编号属性');

      // 创建带编号属性的段落XML
      const ilvlXml: IElement = createElement('w:ilvl', { 'w:val': '1' }, []);
      const numIdXml: IElement = createElement('w:numId', { 'w:val': '42' }, []);
      const numberingPropertiesXml: IElement = createElement('w:numPr', {}, [ilvlXml, numIdXml]);
      const propertiesXml: IElement = createElement('w:pPr', {}, [numberingPropertiesXml]);
      const paragraphXml: IElement = createElement('w:p', {}, [propertiesXml]);

      const numberingOption: NumberingMapOption = {
        findLevel: { '42': { '1': { isOrdered: true, level: '1' } } }
      };
      const numbering: NumberingMapInterface = NumberingMap(numberingOption);

      const paragraph: Paragraph =
        JSON.parse(JSON.stringify(readIElementValue(paragraphXml, { numbering: numbering })));
      expect(paragraph.numbering?.level).assertEqual('1');
      expect(paragraph.numbering?.isOrdered).assertTrue();
      done();
    });

    it('testParagraphHasNumberingFromParagraphStyle', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从段落样式读取编号');

      // 创建带样式属性的段落XML
      const styleXml: IElement = createElement('w:pStyle', { 'w:val': 'List' }, []);
      const propertiesXml: IElement = createElement('w:pPr', {}, [styleXml]);
      const paragraphXml: IElement = createElement('w:p', {}, [propertiesXml]);

      // 模拟编号映射和样式对象
      const numberingOption: NumberingMapOption = {
        findLevelByParagraphStyleId: { 'List': { isOrdered: true, level: '1' } }
      };
      const numbering: NumberingMapInterface = NumberingMap(numberingOption);
      const styles: OptionsStyles = Styles({ 'List': { name: 'List' } }, {});

      const paragraph: Paragraph =
        JSON.parse(JSON.stringify(readIElementValue(paragraphXml, { numbering: numbering, styles: styles })));
      expect(paragraph.numbering?.level).assertEqual('1');
      expect(paragraph.numbering?.isOrdered).assertTrue();
      done();
    });

    it('testNumberingPropertiesTakePrecedenceOverStyle', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试编号属性优先级高于样式');

      // 创建带编号和样式属性的段落XML
      const ilvlXml: IElement = createElement('w:ilvl', { 'w:val': '1' }, []);
      const numIdXml: IElement = createElement('w:numId', { 'w:val': '42' }, []);
      const numberingPropertiesXml: IElement = createElement('w:numPr', {}, [ilvlXml, numIdXml]);
      const styleXml: IElement = createElement('w:pStyle', { 'w:val': 'List' }, []);
      const propertiesXml: IElement = createElement('w:pPr', {}, [styleXml, numberingPropertiesXml]);
      const paragraphXml: IElement = createElement('w:p', {}, [propertiesXml]);

      // 模拟编号映射和样式对象
      const numberingOption: NumberingMapOption = {
        findLevel: { '42': { '1': { isOrdered: true, level: '1' } } },
        findLevelByParagraphStyleId: { 'List': { isOrdered: true, level: '2' } }
      };
      const numbering: NumberingMapInterface = NumberingMap(numberingOption);
      const styles: OptionsStyles = Styles({ 'List': { name: 'List' } }, {});

      const paragraph: Paragraph =
        JSON.parse(JSON.stringify(readIElementValue(paragraphXml, { numbering: numbering, styles: styles })));
      expect(paragraph.numbering?.level).assertEqual('1');
      expect(paragraph.numbering?.isOrdered).assertTrue();
      done();
    });

    it('testNumberingPropertiesConvertedToNumberingAtSpecifiedLevel', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试编号属性转换为指定级别的编号');

      // 创建编号属性XML
      const ilvlXml: IElement = createElement('w:ilvl', { 'w:val': '1' }, []);
      const numIdXml: IElement = createElement('w:numId', { 'w:val': '42' }, []);
      const numberingPropertiesXml: IElement = createElement('w:numPr', {}, [ilvlXml, numIdXml]);

      // 模拟编号映射对象
      const numberingOption: NumberingMapOption = {
        findLevel: { '42': { '1': { isOrdered: true, level: '1' } } }
      };
      const numbering: NumberingMapInterface = NumberingMap(numberingOption);

      let numberingLevel: Numbering = _readNumberingProperties(null, numberingPropertiesXml, numbering);
      expect(numberingLevel).assertDeepEquals({ level: "1", isOrdered: true });
      done();
    });

    it('testWhenNumberingPropertiesMissingWIlvlThenLevel0Assumed', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试缺失w:ilvl时假定级别为0');

      // 创建缺少ilvl的编号属性XML
      const numIdXml: IElement = createElement('w:numId', { 'w:val': '42' }, []);
      const numberingPropertiesXml: IElement = createElement('w:numPr', {}, [numIdXml]);

      // 模拟编号映射对象
      const numberingOption: NumberingMapOption = {
        findLevel: { '42': { '0': { isOrdered: true, level: '0' } } }
      };
      const numbering: NumberingMapInterface = NumberingMap(numberingOption);

      let numberingLevel: Numbering = _readNumberingProperties(null, numberingPropertiesXml, numbering);
      expect(numberingLevel).assertDeepEquals({ level: "0", isOrdered: true });
      done();
    });

    it('testNumberingPropertiesIgnoredIfWNumIdMissing', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试缺失w:numId时忽略编号属性');

      // 创建缺少numId的编号属性XML
      const ilvlXml: IElement = createElement('w:ilvl', { 'w:val': '1' }, []);
      const numberingPropertiesXml: IElement = createElement('w:numPr', {}, [ilvlXml]);

      // 模拟编号映射对象
      const numberingOption: NumberingMapOption = {
        findLevel: { '42': { '1': { isOrdered: true, level: '1' } } }
      };
      const numbering: NumberingMapInterface = NumberingMap(numberingOption);

      let numberingLevel: Numbering = _readNumberingProperties(null, numberingPropertiesXml, numbering);
      expect(numberingLevel).assertNull();
      done();
    });

    // ========== 删除段落内容测试 ==========

    it('testContentOfDeletedParagraphIsPrependedToNextParagraph', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试删除段落内容附加到下一段落');

      // 创建样式对象
      const styles: OptionsStyles = Styles(
        {
          "Heading1": { name: "Heading 1" },
          "Heading2": { name: "Heading 2" }
        },
        {}
      );

      // 创建包含删除段落的XML结构
      const deletedParaRun = runOfText("One");
      const normalParaRun = runOfText("Two");
      const thirdParaRun = runOfText("Three");

      const bodyXml = [
        createElement("w:p", {}, [
          createElement("w:pPr", {}, [
            createElement("w:pStyle", { "w:val": "Heading1" }, []),
            createElement("w:rPr", {}, [
              createElement("w:del", {}, [])
            ])
          ]),
          deletedParaRun
        ]),
        createElement("w:p", {}, [
          createElement("w:pPr", {}, [
            createElement("w:pStyle", { "w:val": "Heading2" }, [])
          ]),
          normalParaRun
        ]),
        // 包含第二个未删除的段落，确保删除的内容只添加一次
        createElement("w:p", {}, [
          thirdParaRun
        ])
      ];

      // 读取XML元素值
      const result: Paragraph[] = JSON.parse(JSON.stringify(readIElementsValue(bodyXml, { styles: styles })));

      // 验证结果
      // 第一个段落应该是Heading2样式，包含两个文本运行："One"和"Two"
      expect(result[0].type).assertEqual('paragraph');
      expect(result[0].styleId).assertEqual('Heading2');
      expect(result[0].children.length).assertEqual(2);
      expect(result[0].children[0].type).assertEqual('run');
      expect(result[0].children[0].children[0].type).assertEqual('text');
      expect((result[0].children[0].children[0] as Text).value).assertEqual('One');
      expect(result[0].children[1].type).assertEqual('run');
      expect(result[0].children[1].children[0].type).assertEqual('text');
      expect((result[0].children[1].children[0] as Text).value).assertEqual('Two');

      // 第二个段落应该包含文本"Three"
      expect(result[1].type).assertEqual('paragraph');
      expect(result[1].children.length).assertEqual(1);
      expect(result[1].children[0].type).assertEqual('run');
      expect(result[1].children[0].children[0].type).assertEqual('text');
      expect((result[1].children[0].children[0] as Text).value).assertEqual('Three');
      done();
    });


    // ========== 复杂字段测试 ==========

    it('testComplexFieldsForHyperlinks', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试超链接的复杂字段');

      const uri: string = "http://example.com";
      const beginXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
      ]);
      const endXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "end" }, [])
      ]);
      const separateXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
      ]);
      const hyperlinkInstrText: IElement = createElement("w:instrText", {}, [
        createText(' HYPERLINK "' + uri + '"')
      ]);

      // 测试存储instrText返回空结果
      const instrText = readIElementValue(hyperlinkInstrText);
      expect(instrText).assertDeepEquals([]);
      done();
    });

    it('testRunsInComplexFieldForHyperlinkWithoutSwitchAreReadAsExternalHyperlinks', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无开关的超链接复杂字段中的运行读取为外部超链接');

      const uri: string = "http://example.com";
      const beginXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
      ]);
      const endXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "end" }, [])
      ]);
      const separateXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
      ]);
      const hyperlinkInstrText: IElement = createElement("w:instrText", {}, [
        createText(' HYPERLINK "' + uri + '"')
      ]);
      const hyperlinkRunXml: IElement = runOfText("this is a hyperlink");

      const paragraphXml: IElement = createElement("w:p", {}, [
        beginXml,
        hyperlinkInstrText,
        separateXml,
        hyperlinkRunXml,
        endXml
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(4);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（超链接指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(1);
      expect(secondRun.children[0].type).assertEqual('hyperlink');
      expect((secondRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第三个运行（超链接运行）
      const hyperlinkRun: Run = paragraph.children[2];
      expect(hyperlinkRun.type).assertEqual('run');
      expect(hyperlinkRun.children.length).assertEqual(1);
      expect(hyperlinkRun.children[0].type).assertEqual('hyperlink');
      expect((hyperlinkRun.children[0] as Hyperlink).href).assertEqual(uri);
      expect((hyperlinkRun.children[0] as Hyperlink).children.length).assertEqual(1);
      expect((hyperlinkRun.children[0] as Hyperlink).children[0].type).assertEqual('text');
      expect(((hyperlinkRun.children[0] as Hyperlink).children[0] as Text).value).assertEqual('this is a hyperlink');

      // 验证第四个运行（结束标记）
      const fourthRun = paragraph.children[3];
      expect(fourthRun.type).assertEqual('run');
      expect(fourthRun.children.length).assertEqual(0); // 空运行
      done();
    });

    it('testRunsInComplexFieldForHyperlinkWithLSwitchAreReadAsInternalHyperlinks', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试带l开关的超链接复杂字段中的运行读取为内部超链接');

      const beginXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
      ]);
      const endXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "end" }, [])
      ]);
      const separateXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
      ]);
      const hyperlinkInstrText: IElement = createElement("w:instrText", {}, [
        createText(' HYPERLINK \\l "InternalLink"')
      ]);
      const hyperlinkRunXml: IElement = runOfText("this is a hyperlink");

      const paragraphXml: IElement = createElement("w:p", {}, [
        beginXml,
        hyperlinkInstrText,
        separateXml,
        hyperlinkRunXml,
        endXml
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(4);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（超链接指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(1);
      expect(secondRun.children[0].type).assertEqual('hyperlink');
      expect((secondRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第三个运行（超链接运行）
      const hyperlinkRun: Run = paragraph.children[2];
      expect(hyperlinkRun.type).assertEqual('run');
      expect(hyperlinkRun.children.length).assertEqual(1);
      expect(hyperlinkRun.children[0].type).assertEqual('hyperlink');
      expect((hyperlinkRun.children[0] as Hyperlink).anchor).assertEqual('InternalLink');
      expect((hyperlinkRun.children[0] as Hyperlink).children.length).assertEqual(1);
      expect((hyperlinkRun.children[0] as Hyperlink).children[0].type).assertEqual('text');
      expect(((hyperlinkRun.children[0] as Hyperlink).children[0] as Text).value).assertEqual('this is a hyperlink');

      // 验证第四个运行（结束标记）
      const fourthRun = paragraph.children[3];
      expect(fourthRun.type).assertEqual('run');
      expect(fourthRun.children.length).assertEqual(0); // 空运行
      done();
    });

    it('testRunsAfterComplexFieldForHyperlinksAreNotReadAsHyperlinks', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试超链接复杂字段后的运行不读取为超链接');

      const uri: string = "http://example.com";
      const beginXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
      ]);
      const endXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "end" }, [])
      ]);
      const separateXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
      ]);
      const hyperlinkInstrText: IElement = createElement("w:instrText", {}, [
        createText(' HYPERLINK "' + uri + '"')
      ]);
      const afterEndXml: IElement = runOfText("this will not be a hyperlink");

      const paragraphXml: IElement = createElement("w:p", {}, [
        beginXml,
        hyperlinkInstrText,
        separateXml,
        endXml,
        afterEndXml
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(4);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（超链接指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(1);
      expect(secondRun.children[0].type).assertEqual('hyperlink');
      expect((secondRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第三个运行（超链接结束标记）
      const thirdRun = paragraph.children[2];
      expect(thirdRun.type).assertEqual('run');
      expect(thirdRun.children.length).assertEqual(0); // 空运行

      // 验证最后一个运行为普通文本，不是超链接
      const lastRun = paragraph.children[3];
      expect(lastRun.type).assertEqual('run');
      expect(lastRun.children.length).assertEqual(1);
      expect(lastRun.children[0].type).assertEqual('text');
      expect((lastRun.children[0] as Text).value).assertEqual('this will not be a hyperlink');
      done();

    });

    it('testCanHandleSplitInstrTextElements', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试处理拆分的instrText元素');

      const uri: string = "http://example.com";
      const beginXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
      ]);
      const endXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "end" }, [])
      ]);
      const separateXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
      ]);
      const hyperlinkInstrTextPart1: IElement = createElement("w:instrText", {}, [
        createText(" HYPE")
      ]);
      const hyperlinkInstrTextPart2: IElement = createElement("w:instrText", {}, [
        createText('RLINK "' + uri + '"')
      ]);
      const hyperlinkRunXml: IElement = runOfText("this is a hyperlink");

      const paragraphXml: IElement = createElement("w:p", {}, [
        beginXml,
        hyperlinkInstrTextPart1,
        hyperlinkInstrTextPart2,
        separateXml,
        hyperlinkRunXml,
        endXml
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(4);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（超链接指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(1);
      expect(secondRun.children[0].type).assertEqual('hyperlink');
      expect((secondRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第三个运行（超链接运行）
      const thirdRun = paragraph.children[2];
      expect(thirdRun.type).assertEqual('run');
      expect(thirdRun.children.length).assertEqual(1);
      expect(thirdRun.children[0].type).assertEqual('hyperlink');
      expect((thirdRun.children[0] as Hyperlink).href).assertEqual(uri);
      expect((thirdRun.children[0] as Hyperlink).children.length).assertEqual(1);
      expect((thirdRun.children[0] as Hyperlink).children[0].type).assertEqual('text');
      expect(((thirdRun.children[0] as Hyperlink).children[0] as Text).value).assertEqual('this is a hyperlink');

      // 验证第四个运行（结束标记）
      const fourthRun = paragraph.children[3];
      expect(fourthRun.type).assertEqual('run');
      expect(fourthRun.children.length).assertEqual(0); // 空运行
      done();

    });

    it('testHyperlinkIsNotEndedByEndOfNestedComplexField', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试超链接不被嵌套复杂字段的结束终止');

      const uri: string = "http://example.com";
      const beginXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
      ]);
      const endXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "end" }, [])
      ]);
      const separateXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
      ]);
      const hyperlinkInstrText: IElement = createElement("w:instrText", {}, [
        createText(' HYPERLINK "' + uri + '"')
      ]);
      const authorInstrText: IElement = createElement("w:instrText", {}, [
        createText(' AUTHOR "John Doe"')
      ]);
      const hyperlinkRunXml: IElement = runOfText("this is a hyperlink");

      const paragraphXml: IElement = createElement("w:p", {}, [
        beginXml,
        hyperlinkInstrText,
        separateXml,
        beginXml,
        authorInstrText,
        separateXml,
        endXml,
        hyperlinkRunXml,
        endXml
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(7);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（超链接指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(1);
      expect(secondRun.children[0].type).assertEqual('hyperlink');
      expect((secondRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第三个运行（嵌套字段开始标记）
      const thirdRun = paragraph.children[2];
      expect(thirdRun.type).assertEqual('run');
      expect(thirdRun.children.length).assertEqual(1);
      expect(thirdRun.children[0].type).assertEqual('hyperlink');
      expect((thirdRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第四个运行（嵌套字段指令文本运行）
      const fourthRun = paragraph.children[3];
      expect(fourthRun.type).assertEqual('run');
      expect(fourthRun.children.length).assertEqual(1);
      expect(fourthRun.children[0].type).assertEqual('hyperlink');
      expect((fourthRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第五个运行（嵌套字段结束标记）
      const fifthRun = paragraph.children[4];
      expect(fifthRun.type).assertEqual('run');
      expect(fifthRun.children.length).assertEqual(1);
      expect(fifthRun.children[0].type).assertEqual('hyperlink');
      expect((fifthRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第六个运行（超链接运行）
      const hyperlinkRun = paragraph.children[5];
      expect(hyperlinkRun.type).assertEqual('run');
      expect(hyperlinkRun.children.length).assertEqual(1);
      expect((hyperlinkRun.children[0] as Hyperlink).href).assertEqual(uri);
      expect((hyperlinkRun.children[0] as Hyperlink).type).assertEqual('hyperlink');
      expect((hyperlinkRun.children[0] as Hyperlink).children.length).assertEqual(1);
      expect((hyperlinkRun.children[0] as Hyperlink).children[0].type).assertEqual('text');
      expect(((hyperlinkRun.children[0] as Hyperlink).children[0] as Text).value).assertEqual('this is a hyperlink');

      // 验证第七个运行（结束标记）
      const seventhRun = paragraph.children[6];
      expect(seventhRun.type).assertEqual('run');
      expect(seventhRun.children.length).assertEqual(0); // 空运行
      done();

    });

    it('testComplexFieldNestedWithinHyperlinkComplexFieldIsWrappedWithTheHyperlink', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试嵌套在超链接复杂字段内的复杂字段被包装在超链接中');

      const uri: string = "http://example.com";
      const beginXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
      ]);
      const endXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "end" }, [])
      ]);
      const separateXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
      ]);
      const hyperlinkInstrText: IElement = createElement("w:instrText", {}, [
        createText(' HYPERLINK "' + uri + '"')
      ]);
      const authorInstrText: IElement = createElement("w:instrText", {}, [
        createText(' AUTHOR "John Doe"')
      ]);

      const paragraphXml: IElement = createElement("w:p", {}, [
        beginXml,
        hyperlinkInstrText,
        separateXml,
        beginXml,
        authorInstrText,
        separateXml,
        runOfText("John Doe"),
        endXml,
        endXml
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(7);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（超链接指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(1);
      expect(secondRun.children[0].type).assertEqual('hyperlink');
      expect((secondRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第三个运行（嵌套字段开始标记）
      const thirdRun = paragraph.children[2];
      expect(thirdRun.type).assertEqual('run');
      expect(thirdRun.children.length).assertEqual(1);
      expect(thirdRun.children[0].type).assertEqual('hyperlink');
      expect((thirdRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第四个运行（嵌套字段指令文本运行）
      const fourthRun = paragraph.children[3];
      expect(fourthRun.type).assertEqual('run');
      expect(fourthRun.children.length).assertEqual(1);
      expect(fourthRun.children[0].type).assertEqual('hyperlink');
      expect((fourthRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第五个运行（嵌套的超链接运行）
      const hyperlinkRun = paragraph.children[4];
      expect(hyperlinkRun.type).assertEqual('run');
      expect(hyperlinkRun.children.length).assertEqual(1);
      expect((hyperlinkRun.children[0] as Hyperlink).type).assertEqual('hyperlink');
      expect((hyperlinkRun.children[0] as Hyperlink).href).assertEqual(uri);
      expect((hyperlinkRun.children[0] as Hyperlink).children.length).assertEqual(1);
      expect((hyperlinkRun.children[0] as Hyperlink).children[0].type).assertEqual('text');
      expect(((hyperlinkRun.children[0] as Hyperlink).children[0] as Text).value).assertEqual('John Doe');

      // 验证第六个运行（嵌套字段结束标记）
      const sixthRun = paragraph.children[5];
      expect(sixthRun.type).assertEqual('run');
      expect(sixthRun.children.length).assertEqual(1);
      expect(sixthRun.children[0].type).assertEqual('hyperlink');
      expect((sixthRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第七个运行（结束标记）
      const seventhRun = paragraph.children[6];
      expect(seventhRun.type).assertEqual('run');
      expect(seventhRun.children.length).assertEqual(0); // 空运行
      done();

    });

    it('testFieldWithoutSeparateWFldCharIsIgnored', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试没有separate的fldChar字段被忽略');

      const uri: string = "http://example.com";
      const beginXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
      ]);
      const endXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "end" }, [])
      ]);
      const separateXml: IElement = createElement("w:r", {}, [
        createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
      ]);
      const hyperlinkInstrText: IElement = createElement("w:instrText", {}, [
        createText(' HYPERLINK "' + uri + '"')
      ]);
      const hyperlinkRunXml: IElement = runOfText("this is a hyperlink");

      const paragraphXml: IElement = createElement("w:p", {}, [
        beginXml,
        hyperlinkInstrText,
        separateXml,
        beginXml,
        endXml,
        hyperlinkRunXml,
        endXml
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(6);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（超链接指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(1);
      expect(secondRun.children[0].type).assertEqual('hyperlink');
      expect((secondRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第三个运行（嵌套字段开始标记）
      const thirdRun = paragraph.children[2];
      expect(thirdRun.type).assertEqual('run');
      expect(thirdRun.children.length).assertEqual(1);
      expect(thirdRun.children[0].type).assertEqual('hyperlink');
      expect((thirdRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第四个运行（嵌套字段结束标记）
      const fourthRun = paragraph.children[3];
      expect(fourthRun.type).assertEqual('run');
      expect(fourthRun.children.length).assertEqual(1);
      expect(fourthRun.children[0].type).assertEqual('hyperlink');
      expect((fourthRun.children[0] as Hyperlink).children.length).assertEqual(0);

      // 验证第五个运行（超链接运行）
      const hyperlinkRun = paragraph.children[4];
      expect(hyperlinkRun.type).assertEqual('run');
      expect(hyperlinkRun.children.length).assertEqual(1);
      expect((hyperlinkRun.children[0] as Hyperlink).type).assertEqual('hyperlink');
      expect((hyperlinkRun.children[0] as Hyperlink).href).assertEqual(uri);
      expect((hyperlinkRun.children[0] as Hyperlink).children.length).assertEqual(1);
      expect((hyperlinkRun.children[0] as Hyperlink).children[0].type).assertEqual('text');
      expect(((hyperlinkRun.children[0] as Hyperlink).children[0] as Text).value).assertEqual('this is a hyperlink');

      // 验证第六个运行（结束标记）
      const sixthRun = paragraph.children[5];
      expect(sixthRun.type).assertEqual('run');
      expect(sixthRun.children.length).assertEqual(0); // 空运行
      done();
    });

    // ========== 复选框测试 ==========

    it('testComplexFieldCheckboxWithoutSeparateIsRead', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无分隔符的复杂字段复选框');

      const paragraphXml: IElement = createElement("w:p", {}, [
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
        ]),
        createElement("w:instrText", {}, [
          createText(' FORMCHECKBOX ')
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "end" }, [])
        ])
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(2);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（复选框运行）
      const checkboxRun = paragraph.children[1];
      expect(checkboxRun.type).assertEqual('run');
      expect(checkboxRun.children.length).assertEqual(1);
      expect(checkboxRun.children[0].type).assertEqual('checkbox');
      done();

    });

    it('testComplexFieldCheckboxWithSeparateIsRead', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试带分隔符的复杂字段复选框');

      const paragraphXml: IElement = createElement("w:p", {}, [
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "begin" }, [])
        ]),
        createElement("w:instrText", {}, [
          createText(' FORMCHECKBOX ')
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "end" }, [])
        ])
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(3);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（分隔符标记）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(0); // 空运行

      // 验证第三个运行（复选框运行）
      const checkboxRun = paragraph.children[2];
      expect(checkboxRun.type).assertEqual('run');
      expect(checkboxRun.children.length).assertEqual(1);
      expect(checkboxRun.children[0].type).assertEqual('checkbox');
      done();

    });

    it('testComplexFieldCheckboxWithoutWDefaultNorWCheckedIsUnchecked', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无w:default和w:checked的复杂字段复选框未选中');

      const paragraphXml: IElement = createElement("w:p", {}, [
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "begin" }, [
            createElement("w:ffData", {}, [
              createElement("w:checkbox", {}, [])
            ])
          ])
        ]),
        createElement("w:instrText", {}, [
          createText(' FORMCHECKBOX ')
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
        ]),

        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "end" }, [])
        ])
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(3);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（分隔符标记））
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(0); // 空运行

      // 验证第三个运行（复选框运行）
      const checkboxRun = paragraph.children[2];
      expect(checkboxRun.type).assertEqual('run');
      expect(checkboxRun.children.length).assertEqual(1);
      expect(checkboxRun.children[0].type).assertEqual('checkbox');
      expect((checkboxRun.children[0] as Checkbox).checked).assertFalse();
      done();

    });

    it('testComplexFieldCheckboxWithWDefault0AndWithoutWCheckedIsUnchecked', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试默认0但无选中的复选框未选中');

      const paragraphXml: IElement = createElement("w:p", {}, [
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "begin" }, [
            createElement("w:ffData", {}, [
              createElement("w:checkBox", {}, [
                createElement("w:default", { "w:val": "0" }, [])
              ])
            ])
          ])
        ]),
        createElement("w:instrText", {}, [
          createText(' FORMCHECKBOX ')
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "end" }, [])
        ])
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(3);

      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（分隔符标记）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(0); // 空运行

      // 验证第三个运行（复选框运行）
      const checkboxRun = paragraph.children[2];
      expect(checkboxRun.type).assertEqual('run');
      expect(checkboxRun.children.length).assertEqual(1);
      expect(checkboxRun.children[0].type).assertEqual('checkbox');
      expect((checkboxRun.children[0] as Checkbox).checked).assertFalse();
      done();

    });

    it('testComplexFieldCheckboxWithWDefault1AndWithoutWCheckedIsChecked', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试默认1但无选中的复选框已选中');

      const paragraphXml: IElement = createElement("w:p", {}, [
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "begin" }, [
            createElement("w:ffData", {}, [
              createElement("w:checkBox", {}, [
                createElement("w:default", { "w:val": "1" }, [])
              ])
            ])
          ])
        ]),
        createElement("w:instrText", {}, [
          createText(' FORMCHECKBOX ')
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "end" }, [])
        ])
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(3);

      // 验第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(0); // 空运行

      // 验证第三个运行（复选框运行）
      const checkboxRun = paragraph.children[2];
      expect(checkboxRun.type).assertEqual('run');
      expect(checkboxRun.children.length).assertEqual(1);
      expect(checkboxRun.children[0].type).assertEqual('checkbox');
      expect((checkboxRun.children[0] as Checkbox).checked).assertTrue();
      done();
    });

    it('testComplexFieldCheckboxWithWDefault1AndWChecked0IsUnchecked', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试默认1但选中0的复选框未选中');

      const paragraphXml: IElement = createElement("w:p", {}, [
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "begin" }, [
            createElement("w:ffData", {}, [
              createElement("w:checkBox", {}, [
                createElement("w:default", { "w:val": "1" }, []),
                createElement("w:checked", { "w:val": "0" }, [])
              ])
            ])
          ])
        ]),
        createElement("w:instrText", {}, [
          createText(' FORMCHECKBOX ')
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "end" }, [])
        ])
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(3);
      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(0); // 空运行

      // 验证第三个运行（复选框运行）
      const checkboxRun = paragraph.children[2];
      expect(checkboxRun.type).assertEqual('run');
      expect(checkboxRun.children.length).assertEqual(1);
      expect(checkboxRun.children[0].type).assertEqual('checkbox');
      expect((checkboxRun.children[0] as Checkbox).checked).assertFalse();
      done();
    });

    it('testComplexFieldCheckboxWithWDefault0AndWChecked1IsChecked', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试默认0但选中1的复选框已选中');

      const paragraphXml: IElement = createElement("w:p", {}, [
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "begin" }, [
            createElement("w:ffData", {}, [
              createElement("w:checkBox", {}, [
                createElement("w:default", { "w:val": "0" }, []),
                createElement("w:checked", { "w:val": "1" }, [])
              ])
            ])
          ])
        ]),
        createElement("w:instrText", {}, [
          createText(' FORMCHECKBOX ')
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "separate" }, [])
        ]),
        createElement("w:r", {}, [
          createElement("w:fldChar", { "w:fldCharType": "end" }, [])
        ])
      ]);

      const paragraph: Paragraph = JSON.parse(JSON.stringify(readIElementValue(paragraphXml)));

      // 验证段落结构
      expect(paragraph.children.length).assertEqual(3);
      // 验证第一个运行（开始标记）
      const firstRun = paragraph.children[0];
      expect(firstRun.type).assertEqual('run');
      expect(firstRun.children.length).assertEqual(0); // 空运行

      // 验证第二个运行（指令文本运行）
      const secondRun = paragraph.children[1];
      expect(secondRun.type).assertEqual('run');
      expect(secondRun.children.length).assertEqual(0); // 空运行

      // 验证第三个运行（复选框运行）
      const checkboxRun = paragraph.children[2];
      expect(checkboxRun.type).assertEqual('run');
      expect(checkboxRun.children.length).assertEqual(1);
      expect(checkboxRun.children[0].type).assertEqual('checkbox');
      expect((checkboxRun.children[0] as Checkbox).checked).assertTrue();
      done();
    });

    it('testStructuredDocumentTagCheckboxWithoutCheckedIsNotChecked', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无选中状态的结构化文档标签复选框未选中');

      const sdtXml: IElement = createElement("w:sdt", {}, [
        createElement("w:sdtPr", {}, [
          createElement("wordml:checkbox", {}, [])
        ])
      ]);

      const result: Checkbox = JSON.parse(JSON.stringify(readIElementValue(sdtXml)));

      // 验证未选中的复选框
      expect(result.type).assertEqual('checkbox');
      expect(result.checked).assertFalse();
      done();
    });

    it('testStructuredDocumentTagCheckboxWithChecked0IsNotChecked', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试选中状态为0的结构化文档标签复选框未选中');

      const sdtXml: IElement = createElement("w:sdt", {}, [
        createElement("w:sdtPr", {}, [
          createElement("wordml:checkbox", {}, [
            createElement("wordml:checked", { "wordml:val": "0" }, [])
          ])
        ])
      ]);

      const result: Checkbox = JSON.parse(JSON.stringify(readIElementValue(sdtXml)));

      // 验证未选中的复选框
      expect(result.type).assertEqual('checkbox');
      expect(result.checked).assertFalse();
      done();
    });

    it('testStructuredDocumentTagCheckboxWithChecked1IsChecked', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试选中状态为1的结构化文档标签复选框已选中');

      const sdtXml: IElement = createElement("w:sdt", {}, [
        createElement("w:sdtPr", {}, [
          createElement("wordml:checkbox", {}, [
            createElement("wordml:checked", { "wordml:val": "1" }, [])
          ])
        ])
      ]);

      const result: Checkbox = JSON.parse(JSON.stringify(readIElementValue(sdtXml)));

      // 验证选中的复选框
      expect(result.type).assertEqual('checkbox');
      expect(result.checked).assertTrue();
      done();
    });

    it('testWhenStructuredDocumentTagCheckboxHasSdtContentThenCheckboxReplacesSingleCharacter', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试结构化文档标签复选框有sdtContent时替换单个字符');

      const tableXml: IElement = createElement("w:tbl", {}, [
        createElement("w:tr", {}, [
          createElement("w:sdt", {}, [
            createElement("w:sdtPr", {}, [
              createElement("wordml:checkbox", {}, [
                createElement("wordml:checked", { "wordml:val": "1" }, [])
              ])
            ]),
            createElement("w:sdtContent", {}, [
              createElement("w:tc", {}, [
                createElement("w:p", {}, [
                  createElement("w:r", {}, [
                    createElement("w:t", {}, [
                      createText("☐")
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ]);

      const result: Table = JSON.parse(JSON.stringify(readIElementValue(tableXml)));

      // 验证表格结构
      expect(result.type).assertEqual('table');
      expect(result.children.length).assertEqual(1);
      expect(result.children[0].type).assertEqual('tableRow');
      expect(result.children[0].children.length).assertEqual(1);
      expect(result.children[0].children[0].type).assertEqual('tableCell');
      expect(result.children[0].children[0].children.length).assertEqual(1);
      expect(result.children[0].children[0].children[0].type).assertEqual('paragraph');
      expect(result.children[0].children[0].children[0].children.length).assertEqual(1);
      expect(result.children[0].children[0].children[0].children[0].type).assertEqual('run');
      expect(result.children[0].children[0].children[0].children[0].children.length).assertEqual(1);
      expect(result.children[0].children[0].children[0].children[0].children[0].type).assertEqual('checkbox');
      expect((result.children[0].children[0].children[0].children[0].children[0] as Checkbox).checked).assertTrue();
      done();
    });

    it('testWhenStructuredDocumentTagCheckboxHasSdtContentThenDeletedContentIsIgnored', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试结构化文档标签复选框有sdtContent时忽略删除内容');

      const tableXml: IElement = createElement("w:tbl", {}, [
        createElement("w:tr", {}, [
          createElement("w:sdt", {}, [
            createElement("w:sdtPr", {}, [
              createElement("wordml:checkbox", {}, [
                createElement("wordml:checked", { "wordml:val": "1" }, [])
              ])
            ]),
            createElement("w:sdtContent", {}, [
              createElement("w:tc", {}, [
                createElement("w:p", {}, [
                  createElement("w:r", {}, [
                    createElement("w:t", {}, [
                      createText("☐")
                    ])
                  ]),
                  createElement("w:del", {}, [
                    createElement("w:r", {}, [
                      createElement("w:t", {}, [
                        createText("☐")
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ])
        ])
      ]);

      const result: Table = JSON.parse(JSON.stringify(readIElementValue(tableXml)));

      // 验证表格结构，确保删除内容被忽略
      expect(result.type).assertEqual('table');
      expect(result.children.length).assertEqual(1);
      expect(result.children[0].type).assertEqual('tableRow');
      expect(result.children[0].children.length).assertEqual(1);
      expect(result.children[0].children[0].type).assertEqual('tableCell');
      expect(result.children[0].children[0].children.length).assertEqual(1);
      expect(result.children[0].children[0].children[0].type).assertEqual('paragraph');
      expect(result.children[0].children[0].children[0].children.length).assertEqual(1);
      expect(result.children[0].children[0].children[0].children[0].type).assertEqual('run');
      expect(result.children[0].children[0].children[0].children[0].children.length).assertEqual(1);
      expect(result.children[0].children[0].children[0].children[0].children[0].type).assertEqual('checkbox');
      expect((result.children[0].children[0].children[0].children[0].children[0] as Checkbox).checked).assertTrue();
      done();
    });

    // ========== 运行样式测试 ==========

    it('testRunHasNoStyleIfItHasNoProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无属性的运行没有样式');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.styleId).assertNull();
      done();
    });

    it('testRunHasStyleIdAndNameReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取运行样式ID和名称');

      const runStyleXml: IElement = createElement("w:rStyle", { "w:val": "Heading1Char" }, []);
      const runXml: IElement = runWithProperties([runStyleXml]);

      const styles: OptionsStyles = Styles({}, { "Heading1Char": { name: "Heading 1 Char" } });

      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml, { styles: styles })));
      expect(run.styleId).assertEqual("Heading1Char");
      expect(run.styleName).assertEqual("Heading 1 Char");
      done();
    });

    it('testWarningIsEmittedWhenRunStyleCannotBeFound', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试运行样式未找到时发出警告');

      const runStyleXml: IElement = createElement("w:rStyle", { "w:val": "Heading1Char" }, []);
      const runXml: IElement = runWithProperties([runStyleXml]);

      const styles: OptionsStyles = Styles({}, {});

      const result: ResultType = readIElement(runXml, { styles: styles });
      const run: Run = JSON.parse(JSON.stringify(result.value));
      expect(run.styleId).assertEqual("Heading1Char");
      expect(run.styleName).assertNull();

      // 验证是否有警告消息
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message)
        .assertEqual("Run style with ID Heading1Char was referenced but not defined in the document");
      done();
    });

    // ========== 运行属性测试 ==========

    it('testIsBoldIsFalseIfBoldElementIsNotPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试加粗元素不存在时为false');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isBold).assertFalse();
      done();
    });

    it('testIsBoldIsTrueIfBoldElementIsPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试加粗元素存在时为true');

      const boldXml: IElement = createElement("w:b", {}, []);
      const runXml: IElement = runWithProperties([boldXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isBold).assertTrue();
      done();
    });

    it('testIsBoldIsFalseIfBoldElementIsPresentAndWValIsFalse', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试加粗元素存在但w:val为false时为false');

      const boldXml: IElement = createElement("w:b", { "w:val": "false" }, []);
      const runXml: IElement = runWithProperties([boldXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isBold).assertFalse();
      done();
    });

    it('testIsUnderlineIsFalseIfUnderlineElementIsNotPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试下划线元素不存在时为false');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertFalse();
      done();
    });

    it('testIsUnderlineIsFalseIfUnderlineElementIsPresentWithoutWValAttribute', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试下划线元素存在但无w:val属性时为false');

      const underlineXml: IElement = createElement("w:u", {}, []);
      const runXml: IElement = runWithProperties([underlineXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertFalse();
      done();
    });

    it('testIsUnderlineIsFalseIfUnderlineElementIsPresentAndWValIsFalse', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试下划线元素存在但w:val为false时为false');

      const underlineXml: IElement = createElement("w:u", { "w:val": "false" }, []);
      const runXml: IElement = runWithProperties([underlineXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertFalse();
      done();
    });

    it('testIsUnderlineIsFalseIfUnderlineElementIsPresentAndWValIs0', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试下划线元素存在但w:val为0时为false');

      const underlineXml: IElement = createElement("w:u", { "w:val": "0" }, []);
      const runXml: IElement = runWithProperties([underlineXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertFalse();
      done();
    });

    it('testIsUnderlineIsFalseIfUnderlineElementIsPresentAndWValIsNone', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试下划线元素存在但w:val为none时为false');

      const underlineXml: IElement = createElement("w:u", { "w:val": "none" }, []);
      const runXml: IElement = runWithProperties([underlineXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertFalse();
      done();
    });

    it('testIsUnderlineIsTrueIfUnderlineElementIsPresentAndWValIsNotNoneOrFalsy', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试下划线元素存在且w:val不为none或falsy时为true');

      const underlineXml: IElement = createElement("w:u", { "w:val": "single" }, []);
      const runXml: IElement = runWithProperties([underlineXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertTrue();
      done();
    });

    it('testIsStrikethroughIsFalseIfStrikethroughElementIsNotPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试删除线元素不存在时为false');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isStrikethrough).assertFalse();
      done();
    });

    it('testIsStrikethroughIsTrueIfStrikethroughElementIsPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试删除线元素存在时为true');

      const strikethroughXml: IElement = createElement("w:strike", {}, []);
      const runXml: IElement = runWithProperties([strikethroughXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isStrikethrough).assertTrue();
      done();
    });

    it('testIsItalicIsFalseIfBoldElementIsNotPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试斜体元素不存在时为false');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isItalic).assertFalse();
      done();
    });

    it('testIsItalicIsTrueIfBoldElementIsPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试斜体元素存在时为true');

      const italicXml: IElement = createElement("w:i", {}, []);
      const runXml: IElement = runWithProperties([italicXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isItalic).assertTrue();
      done();
    });

    it('testIsSmallCapsIsFalseIfSmallcapsElementIsNotPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试小型大写字母元素不存在时为false');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isSmallCaps).assertFalse();
      done();
    });

    it('testIsSmallCapsIsTrueIfSmallcapsElementIsPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试小型大写字母元素存在时为true');

      const smallCapsXml: IElement = createElement("w:smallCaps", {}, []);
      const runXml: IElement = runWithProperties([smallCapsXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isSmallCaps).assertTrue();
      done();
    });

    // 扩展运行属性测试
    it('testIsBoldIsFalseIfWbIsPresentAndWValIsFalse', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:b元素存在但w:val为false时isBold为false');

      const propertyXml: IElement = createElement("w:b", { "w:val": "false" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isBold).assertFalse();
      done();
    });

    it('testIsBoldIsFalseIfWbIsPresentAndWValIs0', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:b元素存在但w:val为0时isBold为false');

      const propertyXml: IElement = createElement("w:b", { "w:val": "0" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isBold).assertFalse();
      done();
    });

    it('testIsBoldIsTrueIfWbIsPresentAndWValIsTrue', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:b元素存在且w:val为true时isBold为true');

      const propertyXml: IElement = createElement("w:b", { "w:val": "true" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isBold).assertTrue();
      done();
    });

    it('testIsBoldIsTrueIfWbIsPresentAndWValIs1', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:b元素存在且w:val为1时isBold为true');

      const propertyXml: IElement = createElement("w:b", { "w:val": "1" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isBold).assertTrue();
      done();
    });

    it('testIsUnderlineIsFalseIfWuIsPresentAndWValIsFalse', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:u元素存在但w:val为false时isUnderline为false');

      const propertyXml: IElement = createElement("w:u", { "w:val": "false" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertFalse();
      done();
    });

    it('testIsUnderlineIsFalseIfWuIsPresentAndWValIs0', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:u元素存在但w:val为0时isUnderline为false');

      const propertyXml: IElement = createElement("w:u", { "w:val": "0" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertFalse();
      done();
    });

    it('testIsUnderlineIsTrueIfWuIsPresentAndWValIsTrue', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:u元素存在且w:val为true时isUnderline为true');

      const propertyXml: IElement = createElement("w:u", { "w:val": "true" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertTrue();
      done();
    });

    it('testIsUnderlineIsTrueIfWuIsPresentAndWValIs1', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:u元素存在且w:val为1时isUnderline为true');

      const propertyXml: IElement = createElement("w:u", { "w:val": "1" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isUnderline).assertTrue();
      done();
    });

    it('testIsItalicIsFalseIfWiIsPresentAndWValIsFalse', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:i元素存在但w:val为false时isItalic为false');

      const propertyXml: IElement = createElement("w:i", { "w:val": "false" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isItalic).assertFalse();
      done();
    });

    it('testIsItalicIsFalseIfWiIsPresentAndWValIs0', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:i元素存在但w:val为0时isItalic为false');

      const propertyXml: IElement = createElement("w:i", { "w:val": "0" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isItalic).assertFalse();
      done();
    });

    it('testIsItalicIsTrueIfWiIsPresentAndWValIsTrue', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:i元素存在且w:val为true时isItalic为true');

      const propertyXml: IElement = createElement("w:i", { "w:val": "true" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isItalic).assertTrue();
      done();
    });

    it('testIsItalicIsTrueIfWiIsPresentAndWValIs1', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:i元素存在且w:val为1时isItalic为true');

      const propertyXml: IElement = createElement("w:i", { "w:val": "1" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isItalic).assertTrue();
      done();
    });

    it('testIsStrikethroughIsFalseIfWstrikeIsPresentAndWValIsFalse', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:strike元素存在但w:val为false时isStrikethrough为false');

      const propertyXml: IElement = createElement("w:strike", { "w:val": "false" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isStrikethrough).assertFalse();
      done();
    });

    it('testIsStrikethroughIsFalseIfWstrikeIsPresentAndWValIs0', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:strike元素存在但w:val为0时isStrikethrough为false');

      const propertyXml: IElement = createElement("w:strike", { "w:val": "0" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isStrikethrough).assertFalse();
      done();
    });

    it('testIsStrikethroughIsTrueIfWstrikeIsPresentAndWValIsTrue', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:strike元素存在且w:val为true时isStrikethrough为true');

      const propertyXml: IElement = createElement("w:strike", { "w:val": "true" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isStrikethrough).assertTrue();
      done();
    });

    it('testIsStrikethroughIsTrueIfWstrikeIsPresentAndWValIs1', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:strike元素存在且w:val为1时isStrikethrough为true');

      const propertyXml: IElement = createElement("w:strike", { "w:val": "1" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isStrikethrough).assertTrue();
      done();
    });

    it('testIsAllCapsIsFalseIfWcapsIsPresentAndWValIsFalse', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:caps元素存在但w:val为false时isAllCaps为false');

      const propertyXml: IElement = createElement("w:caps", { "w:val": "false" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isAllCaps).assertFalse();
      done();
    });

    it('testIsAllCapsIsFalseIfWcapsIsPresentAndWValIs0', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:caps元素存在但w:val为0时isAllCaps为false');

      const propertyXml: IElement = createElement("w:caps", { "w:val": "0" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isAllCaps).assertFalse();
      done();
    });

    it('testIsAllCapsIsTrueIfWcapsIsPresentAndWValIsTrue', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:caps元素存在且w:val为true时isAllCaps为true');

      const propertyXml: IElement = createElement("w:caps", { "w:val": "true" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isAllCaps).assertTrue();
      done();
    });

    it('testIsAllCapsIsTrueIfWcapsIsPresentAndWValIs1', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:caps元素存在且w:val为1时isAllCaps为true');

      const propertyXml: IElement = createElement("w:caps", { "w:val": "1" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isAllCaps).assertTrue();
      done();
    });

    it('testIsSmallCapsIsFalseIfWsmallCapsIsPresentAndWValIsFalse', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:smallCaps元素存在但w:val为false时isSmallCaps为false');

      const propertyXml: IElement = createElement("w:smallCaps", { "w:val": "false" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isSmallCaps).assertFalse();
      done();
    });

    it('testIsSmallCapsIsFalseIfWsmallCapsIsPresentAndWValIs0', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:smallCaps元素存在但w:val为0时isSmallCaps为false');

      const propertyXml: IElement = createElement("w:smallCaps", { "w:val": "0" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isSmallCaps).assertFalse();
      done();
    });

    it('testIsSmallCapsIsTrueIfWsmallCapsIsPresentAndWValIsTrue', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:smallCaps元素存在且w:val为true时isSmallCaps为true');

      const propertyXml: IElement = createElement("w:smallCaps", { "w:val": "true" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isSmallCaps).assertTrue();
      done();
    });

    it('testIsSmallCapsIsTrueIfWsmallCapsIsPresentAndWValIs1', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:smallCaps元素存在且w:val为1时isSmallCaps为true');

      const propertyXml: IElement = createElement("w:smallCaps", { "w:val": "1" }, []);
      const runXml: IElement = runWithProperties([propertyXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.isSmallCaps).assertTrue();
      done();
    });

    // ========== 运行垂直对齐测试 ==========

    it('testRunHasBaselineVerticalAlignmentByDefault', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试运行默认具有基线垂直对齐');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.verticalAlignment).assertEqual('baseline');
      done();
    });

    it('testRunHasVerticalAlignmentReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取运行垂直对齐');

      const verticalAlignmentXml: IElement = createElement("w:vertAlign", { "w:val": "superscript" }, []);
      const runXml: IElement = runWithProperties([verticalAlignmentXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.verticalAlignment).assertEqual('superscript');
      done();
    });

    // ========== 运行字体测试 ==========

    it('testRunHasNullFontByDefault', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试运行默认字体为空');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.font).assertNull();
      done();
    });

    it('testRunHasFontReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取运行字体');

      const fontXml: IElement = createElement("w:rFonts", { "w:ascii": "Arial" }, []);
      const runXml: IElement = runWithProperties([fontXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.font).assertEqual("Arial");
      done();
    });

    // ========== 运行字体大小测试 ==========

    it('testRunHasNullFontSizeByDefault', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试运行默认字体大小为空');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.fontSize).assertNull();
      done();
    });

    it('testRunHasFontSizeReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取运行字体大小');

      const fontSizeXml: IElement = createElement("w:sz", { "w:val": "28" }, []);
      const runXml: IElement = runWithProperties([fontSizeXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.fontSize).assertEqual(14);
      done();
    });

    it('testRunWithInvalidWSzHasNullFontSize', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无效的w:sz属性使字体大小为空');

      const fontSizeXml: IElement = createElement("w:sz", { "w:val": "28a" }, []);
      const runXml: IElement = runWithProperties([fontSizeXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.fontSize).assertNull();
      done();
    });

    // ========== 运行高亮测试 ==========

    it('testRunHasNoHighlightByDefault', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试运行默认无高亮');

      const runXml: IElement = runWithProperties([]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.highlight).assertNull();
      done();
    });

    it('testRunHasHighlightReadFromProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从属性读取运行高亮');

      const highlightXml: IElement = createElement("w:highlight", { "w:val": "yellow" }, []);
      const runXml: IElement = runWithProperties([highlightXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.highlight).assertEqual("yellow");
      done();
    });

    it('testWhenHighlightIsNoneThenRunHasNoHighlight', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试高亮为none时运行无高亮');

      const highlightXml: IElement = createElement("w:highlight", { "w:val": "none" }, []);
      const runXml: IElement = runWithProperties([highlightXml]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));
      expect(run.highlight).assertNull();
      done();
    });

    // ========== 运行属性测试 ==========

    it('testRunPropertiesNotIncludedAsChildOfRun', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试运行属性不作为运行的子元素');

      const runStyleXml: IElement = createElement("w:rStyle", {}, []);
      const runPropertiesXml: IElement = createElement("w:rPr", {}, [runStyleXml]);
      const runXml: IElement = createElement("w:r", {}, [runPropertiesXml]);
      const result: ResultType = readIElement(runXml);
      const run: Run = JSON.parse(JSON.stringify(result.value));
      expect(run.children).assertDeepEquals([]);
      done();
    });

    // ========== 特殊文本元素测试 ==========

    it('testWTabIsReadAsDocumentTabElement', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:tab读取为文档制表符元素');

      const tabXml: IElement = createElement("w:tab", {}, []);
      const result: ResultType = readIElement(tabXml);
      const tab: Tab = JSON.parse(JSON.stringify(result.value));
      expect(tab.type).assertEqual('tab');
      done();
    });

    it('testWNoBreakHyphenIsReadAsNonBreakingHyphenCharacter', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:noBreakHyphen读取为不间断连字符字符');

      const noBreakHyphenXml: IElement = createElement("w:noBreakHyphen", {}, []);
      const result: ResultType = readIElement(noBreakHyphenXml);
      const text: Text = JSON.parse(JSON.stringify(result.value));
      expect(text.type).assertEqual('text');
      expect(text.value).assertEqual('\u2011');
      done();
    });

    it('testSoftHyphensAreReadAsText', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试软连字符读取为文本');

      const element: IElement = createElement("w:softHyphen", {}, []);
      const text: Text = JSON.parse(JSON.stringify(readIElementValue(element)));
      expect(text.type).assertEqual('text');
      expect(text.value).assertEqual('\u00AD');
      done();
    });

    // ========== 符号测试 ==========

    it('testWSymWithSupportedFontAndSupportedCodePointInASCIIRangeIsConvertedToText', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试支持字体和支持ASCII范围内码点的w:sym转换为文本');

      const element: IElement = createElement("w:sym", { "w:font": "Wingdings", "w:char": "28" }, []);
      const text: Text = JSON.parse(JSON.stringify(readIElementValue(element)));
      expect(text.type).assertEqual('text');
      expect(text.value).assertEqual("🕿");
      done();
    });

    it('testWSymWithSupportedFontAndSupportedCodePointInPrivateUseAreaIsConvertedToText', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试支持字体和支持私用区码点的w:sym转换为文本');

      const element: IElement = createElement("w:sym", { "w:font": "Wingdings", "w:char": "F028" }, []);
      const text: Text = JSON.parse(JSON.stringify(readIElementValue(element)));
      expect(text.type).assertEqual('text');
      expect(text.value).assertEqual("🕿");
      done();
    });

    it('testWSymWithUnsupportedFontAndCodePointProducesEmptyResultWithWarning', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试不支持字体和码点的w:sym产生带警告的空结果');

      const element: IElement = createElement("w:sym", { "w:font": "Dingwings", "w:char": "28" }, []);
      const result: ResultType = readIElement(element);

      expect(result.value).assertDeepEquals([]);
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message)
        .assertEqual("A w:sym element with an unsupported character was ignored: char 28 in font Dingwings");
      done();
    });

    // ========== 表格测试 ==========

    it('testWTblIsReadAsDocumentTableElement', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:tbl读取为文档表格元素');

      const tableXml: IElement = createElement("w:tbl", {}, [
        createElement("w:tr", {}, [
          createElement("w:tc", {}, [
            createElement("w:p", {}, [])
          ])
        ])
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      expect(table.type).assertEqual('table');
      expect(table.children.length).assertEqual(1);
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].children[0].type).assertEqual('paragraph');
      done();
    });

    it('testTableHasNoStyleIfItHasNoProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无属性的表格无样式');

      const tableXml: IElement = createElement("w:tbl", {}, []);
      const table: Table = JSON.parse(JSON.stringify(readIElementValue(tableXml)));
      expect(table.styleId).assertNull();
      done();
    });

    it('testTableHasStyleIdAndNameReadFromTablePropertiesIfPresent', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试从表格属性读取样式ID和名称');

      const styleXml: IElement = createElement("w:tblStyle", { "w:val": "TableNormal" }, []);
      const propertiesXml: IElement = createElement("w:tblPr", {}, [styleXml]);
      const tableXml: IElement = createElement("w:tbl", {}, [propertiesXml]);

      const styles: OptionsStyles = Styles({}, {}, { "TableNormal": { name: "Normal Table" } });

      const table: Table = JSON.parse(JSON.stringify(readIElementValue(tableXml, { styles: styles })));
      expect(table.styleId).assertEqual("TableNormal");
      expect(table.styleName).assertEqual("Normal Table");
      done();
    });

    it('testWarningIsEmittedWhenTableStyleCannotBeFound', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试找不到表格样式时发出警告');

      const styleXml: IElement = createElement("w:tblStyle", { "w:val": "TableNormal" }, []);
      const propertiesXml: IElement = createElement("w:tblPr", {}, [styleXml]);
      const tableXml: IElement = createElement("w:tbl", {}, [propertiesXml]);

      const result: ResultType = readIElement(tableXml, { styles: Styles({}, {}, {}, {}) });
      const table: Table = JSON.parse(JSON.stringify(result.value));

      expect(table.styleId).assertEqual("TableNormal");
      expect(table.styleName).assertNull();
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message)
        .assertEqual("Table style with ID TableNormal was referenced but not defined in the document");
      done();
    });

    it('testWTblHeaderMarksTableRowAsHeader', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:tblHeader标记表格行作为表头');

      const tableXml: IElement = createElement("w:tbl", {}, [
        createElement("w:tr", {}, [
          createElement("w:trPr", {}, [
            createElement("w:tblHeader", {}, [])
          ])
        ]),
        createElement("w:tr", {}, [])
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      expect(table.type).assertEqual("table");
      expect(table.children.length).assertEqual(2);
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[1].type).assertEqual('tableRow');
      expect(table.children[0].isHeader).assertTrue();
      expect(table.children[1].isHeader).assertFalse();
      done();
    });

    it('testWGridSpanIsReadAsColSpanForTableCell', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:gridSpan读取为表格单元格的列跨度');

      const tableXml: IElement = createElement("w:tbl", {}, [
        createElement("w:tr", {}, [
          createElement("w:tc", {}, [
            createElement("w:tcPr", {}, [
              createElement("w:gridSpan", { "w:val": "2" }, [])
            ]),
            createElement("w:p", {}, [])
          ])
        ])
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      expect(table.type).assertEqual("table");
      expect(table.children.length).assertEqual(1);
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[0].colSpan).assertEqual(2);
      expect(table.children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].children[0].type).assertEqual('paragraph');
      done();
    });
    // ========== 表格行合并测试 ==========

    it('testWVMergeIsReadAsRowSpanForTableCell', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:vMerge读取为表格单元格的行跨度');


      const tableXml: IElement = createElement("w:tbl", {}, [
        row(emptyCell()),
        row(emptyCell(vMerge("restart"))),
        row(emptyCell(vMerge("continue"))),
        row(emptyCell(vMerge("continue"))),
        row(emptyCell())
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      // 验证表格结构
      expect(table.type).assertEqual('table');
      expect(table.children.length).assertEqual(5);

      // 验证第一行
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[0].rowSpan).assertEqual(1);
      expect(table.children[0].children[0].colSpan).assertEqual(1);
      expect(table.children[0].children[0].children.length).assertEqual(0);

      // 验证第二行（包含rowSpan的单元格）
      expect(table.children[1].type).assertEqual('tableRow');
      expect(table.children[1].children.length).assertEqual(1);
      expect(table.children[1].children[0].type).assertEqual('tableCell');
      expect(table.children[1].children[0].rowSpan).assertEqual(3);
      expect(table.children[0].children[0].colSpan).assertEqual(1);
      expect(table.children[1].children[0].children.length).assertEqual(0);

      // 验证第三行（应为空）
      expect(table.children[2].type).assertEqual('tableRow');
      expect(table.children[2].children.length).assertEqual(0);

      // 验证第四行（应为空）
      expect(table.children[3].type).assertEqual('tableRow');
      expect(table.children[3].children.length).assertEqual(0);

      // 验证第五行
      expect(table.children[4].type).assertEqual('tableRow');
      expect(table.children[4].children.length).assertEqual(1);
      expect(table.children[4].children[0].type).assertEqual('tableCell');
      expect(table.children[4].children[0].rowSpan).assertEqual(1);
      expect(table.children[0].children[0].colSpan).assertEqual(1);
      expect(table.children[4].children[0].children.length).assertEqual(0);
      done();

    });

    it('testWVMergeWithoutValIsTreatedAsContinue', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无val的w:vMerge被视为continue');

      const tableXml: IElement = createElement("w:tbl", {}, [
        row(emptyCell(vMerge("restart"))),
        row(emptyCell(vMerge()))
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      // 验证表格结构
      expect(table.type).assertEqual('table');
      expect(table.children.length).assertEqual(2);

      // 验证第一行
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[0].rowSpan).assertEqual(2);
      expect(table.children[0].children[0].colSpan).assertEqual(1);
      expect(table.children[0].children[0].children.length).assertEqual(0);

      // 验证第二行
      expect(table.children[1].type).assertEqual('tableRow');
      expect(table.children[1].children.length).assertEqual(0);
      done();

    });

    it('testWVMergeAccountsForCellsSpanningColumns', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:vMerge考虑跨列单元格');

      const tableXml: IElement = createElement("w:tbl", {}, [
        row(emptyCell(), emptyCell(), emptyCell(vMerge("restart"))),
        row(emptyCell(gridSpan("2")), emptyCell(vMerge("continue"))),
        row(emptyCell(), emptyCell(), emptyCell(vMerge("continue"))),
        row(emptyCell(), emptyCell(), emptyCell())
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      // 验证表格结构
      expect(table.type).assertEqual('table');
      expect(table.children.length).assertEqual(4);

      // 验证第一行
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[0].children.length).assertEqual(3);
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[0].rowSpan).assertEqual(1);
      expect(table.children[0].children[0].colSpan).assertEqual(1);
      expect(table.children[0].children[0].children.length).assertEqual(0);
      expect(table.children[0].children[1].type).assertEqual('tableCell');
      expect(table.children[0].children[1].rowSpan).assertEqual(1);
      expect(table.children[0].children[1].colSpan).assertEqual(1);
      expect(table.children[0].children[1].children.length).assertEqual(0);
      expect(table.children[0].children[2].type).assertEqual('tableCell');
      expect(table.children[0].children[2].rowSpan).assertEqual(3);
      expect(table.children[0].children[2].colSpan).assertEqual(1);
      expect(table.children[0].children[2].children.length).assertEqual(0);

      // 验证第二行
      expect(table.children[1].type).assertEqual('tableRow');
      expect(table.children[1].children.length).assertEqual(1);
      expect(table.children[1].children[0].type).assertEqual('tableCell');
      expect(table.children[1].children[0].rowSpan).assertEqual(1);
      expect(table.children[1].children[0].colSpan).assertEqual(2);
      expect(table.children[1].children[0].children.length).assertEqual(0);

      // 验证第三行
      expect(table.children[2].type).assertEqual('tableRow');
      expect(table.children[2].children.length).assertEqual(2);
      expect(table.children[2].children[0].type).assertEqual('tableCell');
      expect(table.children[2].children[0].rowSpan).assertEqual(1);
      expect(table.children[2].children[0].colSpan).assertEqual(1);
      expect(table.children[2].children[0].children.length).assertEqual(0);
      expect(table.children[2].children[1].type).assertEqual('tableCell');
      expect(table.children[2].children[1].rowSpan).assertEqual(1);
      expect(table.children[2].children[1].colSpan).assertEqual(1);
      expect(table.children[2].children[1].children.length).assertEqual(0);

      // 验证第四行
      expect(table.children[3].type).assertEqual('tableRow');
      expect(table.children[3].children.length).assertEqual(3);
      expect(table.children[3].children[0].type).assertEqual('tableCell');
      expect(table.children[3].children[0].rowSpan).assertEqual(1);
      expect(table.children[3].children[0].colSpan).assertEqual(1);
      expect(table.children[3].children[0].children.length).assertEqual(0);
      expect(table.children[3].children[1].type).assertEqual('tableCell');
      expect(table.children[3].children[1].rowSpan).assertEqual(1);
      expect(table.children[3].children[1].colSpan).assertEqual(1);
      expect(table.children[3].children[1].children.length).assertEqual(0);
      expect(table.children[3].children[2].type).assertEqual('tableCell');
      expect(table.children[3].children[2].rowSpan).assertEqual(1);
      expect(table.children[3].children[2].colSpan).assertEqual(1);
      expect(table.children[3].children[2].children.length).assertEqual(0);
      done();
    });

    it('testNoVerticalCellMergingIfMergedCellsDoNotLineUp', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试合并单元格不对齐时不进行垂直合并');


      const tableXml: IElement = createElement("w:tbl", {}, [
        row(emptyCell(gridSpan("2"), vMerge("restart"))),
        row(emptyCell(), emptyCell(vMerge("continue")))
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      // 验证表格结构
      expect(table.type).assertEqual('table');
      expect(table.children.length).assertEqual(2);

      // 验证第一行
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[0].colSpan).assertEqual(2);
      expect(table.children[0].children[0].rowSpan).assertEqual(1);
      expect(table.children[0].children[0].children.length).assertEqual(0);

      // 验证第二行
      expect(table.children[1].type).assertEqual('tableRow');
      expect(table.children[1].children.length).assertEqual(2);
      expect(table.children[1].children[0].type).assertEqual('tableCell');
      expect(table.children[1].children[0].colSpan).assertEqual(1);
      expect(table.children[1].children[0].rowSpan).assertEqual(1);
      expect(table.children[1].children[0].children.length).assertEqual(0);
      expect(table.children[1].children[1].type).assertEqual('tableCell');
      expect(table.children[1].children[1].colSpan).assertEqual(1);
      expect(table.children[1].children[1].rowSpan).assertEqual(1);
      expect(table.children[1].children[1].children.length).assertEqual(0);
      done();

    });

    it('testWhenRowIsMarkedAsDeletedInRowPropertiesThenRowIsIgnored', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试行属性中标记为删除的行被忽略');

      const tableXml: IElement = createElement("w:tbl", {}, [
        createElement("w:tr", {}, [
          createElement("w:tc", {}, [
            createElement("w:p", {}, [
              runOfText("Row 1")
            ])
          ])
        ]),
        createElement("w:tr", {}, [
          createElement("w:trPr", {}, [
            createElement("w:del", {}, [])
          ]),
          createElement("w:tc", {}, [
            createElement("w:p", {}, [
              runOfText("Row 2")
            ])
          ])
        ])
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      // 验证表格结构
      expect(table.type).assertEqual('table');
      expect(table.children.length).assertEqual(1);

      // 验证第一行
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[0].children.length).assertEqual(1);

      // 验证第一个单元格
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[0].children.length).assertEqual(1);

      // 验证段落
      expect(table.children[0].children[0].children[0].type).assertEqual('paragraph');
      expect(table.children[0].children[0].children[0].children.length).assertEqual(1);

      // 验证运行
      expect(table.children[0].children[0].children[0].children[0].type).assertEqual('run');
      expect(table.children[0].children[0].children[0].children[0].children.length).assertEqual(1);

      // 验证文本内容
      expect(table.children[0].children[0].children[0].children[0].children[0].type).assertEqual('text');
      expect((table.children[0].children[0].children[0].children[0].children[0] as Text).value).assertEqual("Row 1");
      done();

    });
    // ========== 警告处理测试 ==========
    it('testWarningIfNonRowInTable', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试表格中的非行元素发出警告');

      // 包含正常行以确保它们仍被正确读取
      const tableXml: IElement = createElement("w:tbl", {}, [
        createElement("w:tr", {}, [
          createElement("w:tc", {}, [
            createElement("w:p", {}, [
              runOfText("Row 1")
            ])
          ])
        ]),
        createElement("w:p", {}, []),
        createElement("w:tr", {}, [
          createElement("w:tc", {}, [
            createElement("w:p", {}, [
              runOfText("Row 2")
            ])
          ])
        ])
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      // 验证表格结构
      expect(table.type).assertEqual('table');
      expect(table.children.length).assertEqual(3);
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[1].type).assertEqual('paragraph');
      expect(table.children[2].type).assertEqual('tableRow');

      // 验证第一个表格行
      expect(table.children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].children[0].type).assertEqual('paragraph');
      expect(table.children[0].children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].children[0].children[0].type).assertEqual('run');
      expect(table.children[0].children[0].children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].children[0].children[0].children[0].type).assertEqual('text');
      expect((table.children[0].children[0].children[0].children[0].children[0] as Text).value).assertEqual('Row 1');

      // 验证中间段落
      expect(table.children[1].children.length).assertEqual(0);

      // 验证第二个表格行
      expect(table.children[2].children.length).assertEqual(1);
      expect(table.children[2].children[0].type).assertEqual('tableCell');
      expect(table.children[2].children[0].children.length).assertEqual(1);
      expect(table.children[2].children[0].children[0].type).assertEqual('paragraph');
      expect(table.children[2].children[0].children[0].children.length).assertEqual(1);
      expect(table.children[2].children[0].children[0].children[0].type).assertEqual('run');
      expect(table.children[2].children[0].children[0].children[0].children.length).assertEqual(1);
      expect(table.children[2].children[0].children[0].children[0].children[0].type).assertEqual('text');
      expect((table.children[2].children[0].children[0].children[0].children[0] as Text).value).assertEqual('Row 2');

      // 验证警告消息
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message)
        .assertEqual("unexpected non-row element in table, cell merging may be incorrect");
      done();

    });

    it('testWarningIfNonCellInTableRow', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试表格行中的非单元格元素发出警告');

      // 包含正常单元格以确保它们仍被正确读取
      const tableXml: IElement = createElement("w:tbl", {}, [
        createElement("w:tr", {}, [
          createElement("w:tc", {}, [
            createElement("w:p", {}, [
              runOfText("Cell 1")
            ])
          ]),
          createElement("w:p", {}, []),
          createElement("w:tc", {}, [
            createElement("w:p", {}, [
              runOfText("Cell 2")
            ])
          ])
        ])
      ]);

      const result: ResultType = readIElement(tableXml);
      const table: Table = JSON.parse(JSON.stringify(result.value));

      // 验证表格结构
      expect(table.type).assertEqual('table');
      expect(table.children.length).assertEqual(1);
      expect(table.children[0].type).assertEqual('tableRow');
      expect(table.children[0].children.length).assertEqual(3);
      expect(table.children[0].children[0].type).assertEqual('tableCell');
      expect(table.children[0].children[1].type).assertEqual('paragraph');
      expect(table.children[0].children[2].type).assertEqual('tableCell');

      // 验证第一个单元格
      expect(table.children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].children[0].type).assertEqual('paragraph');
      expect(table.children[0].children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].children[0].children[0].type).assertEqual('run');
      expect(table.children[0].children[0].children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[0].children[0].children[0].children[0].type).assertEqual('text');
      expect((table.children[0].children[0].children[0].children[0].children[0] as Text).value).assertEqual('Cell 1');

      // 验证中间段落
      expect(table.children[0].children[1].children.length).assertEqual(0);

      // 验证第二个单元格
      expect(table.children[0].children[2].children.length).assertEqual(1);
      expect(table.children[0].children[2].children[0].type).assertEqual('paragraph');
      expect(table.children[0].children[2].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[2].children[0].children[0].type).assertEqual('run');
      expect(table.children[0].children[2].children[0].children[0].children.length).assertEqual(1);
      expect(table.children[0].children[2].children[0].children[0].children[0].type).assertEqual('text');
      expect((table.children[0].children[2].children[0].children[0].children[0] as Text).value).assertEqual('Cell 2');

      // 验证警告消息
      expect(result.messages.length).assertLarger(0);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message)
        .assertEqual("unexpected non-cell element in table row, cell merging may be incorrect");
      done();
    });

    // ========== 书签测试 ==========

    it('testWBookmarkStartIsReadAsABookmarkStart', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:bookmarkStart读取为书签开始');

      const bookmarkStart: IElement = createElement("w:bookmarkStart", { "w:name": "_Peter", "w:id": "42" }, []);
      const result: ResultType = readIElement(bookmarkStart);
      const bookmark: BookmarkStart = JSON.parse(JSON.stringify(result.value));

      expect(bookmark.name).assertEqual("_Peter");
      expect(bookmark.type).assertEqual("bookmarkStart");
      done();
    });

    it('testGoBackBookmarkIsIgnored', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试_GoBack书签被忽略');

      const bookmarkStart: IElement = createElement("w:bookmarkStart", { "w:name": "_GoBack" }, []);
      const result: ResultType = readIElement(bookmarkStart);
      expect(result.value).assertDeepEquals([]);
      done();
    });

    // 图片相关测试用例
    it('testCanReadImagedataElementsWithRIdAttribute', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取带r:id属性的imagedata元素');

      // 创建模拟的图片数据
      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const imagedataElement: IElement = createElement("v:imagedata", {
        "r:id": "rId5",
        "o:title": "It's a hat"
      }, []);

      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "media/hat.png")
      ];
      const result: ResultType = readIElement(imagedataElement, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        docxFile: createFakeDocxFile({
          "word/media/hat.png": imageBuffer
        })
      });

      expect(result.messages).assertDeepEquals([]);
      const image: DocumentsImage = result.value as DocumentsImage;
      expect(image.type).assertEqual('image');
      expect(image.altText).assertEqual("It's a hat");
      expect(image.contentType).assertEqual("image/png");

      image.read().then(data => {
        expect(data).assertDeepEquals(imageBuffer);
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    });

    it('testImagedataElementWithoutRelationshipIDIsIgnoredWithWarning', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试没有关系ID的imagedata元素被忽略并发出警告');

      const imagedataElement: IElement = createElement("v:imagedata", {}, []);

      const result: ResultType = readIElement(imagedataElement);

      expect(result.value).assertDeepEquals([]);
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message).assertEqual("A v:imagedata element without a relationship ID was ignored");
      done();
    });

    it('testCanReadInlinePictures', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取内联图片');

      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const drawing: IElement = createInlineImage({
        blip: createEmbeddedBlip("rId5"),
        description: "It's a hat"
      });

      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "media/hat.png")
      ];
      const result: ResultType = readIElement(drawing, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        docxFile: createFakeDocxFile({
          "word/media/hat.png": imageBuffer
        })
      });

      expect(result.messages).assertDeepEquals([]);
      const images: DocumentsImage[] = result.value as DocumentsImage[];
      expect(images.length).assertEqual(1);
      const image: DocumentsImage = images[0];
      expect(image.type).assertEqual('image');
      expect(image.altText).assertEqual("It's a hat");
      expect(image.contentType).assertEqual("image/png");

      image.read().then(data => {
        expect(data).assertDeepEquals(imageBuffer);
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    });

    it('testAltTextTitleIsUsedIfDescriptionIsMissing', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试缺失描述时使用标题作为替代文本');

      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const drawing: IElement = createInlineImage({
        blip: createEmbeddedBlip("rId5"),
        title: "It's a hat"
      });

      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "media/hat.png")
      ];
      const result: ResultType = readIElement(drawing, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        docxFile: createFakeDocxFile({
          "word/media/hat.png": imageBuffer
        })
      });

      expect(result.messages).assertDeepEquals([]);
      const images: DocumentsImage[] = result.value as DocumentsImage[];
      expect(images.length).assertEqual(1);
      const image: DocumentsImage = images[0];
      expect(image.type).assertEqual('image');
      expect(image.altText).assertEqual("It's a hat");
      expect(image.contentType).assertEqual("image/png");

      image.read().then(data => {
        expect(data).assertDeepEquals(imageBuffer);
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    });

    it('testAltTextTitleIsUsedIfDescriptionIsBlank', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试描述为空白时使用标题作为替代文本');

      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const drawing: IElement = createInlineImage({
        blip: createEmbeddedBlip("rId5"),
        description: " ",
        title: "It's a hat"
      });

      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "media/hat.png")
      ];
      const result: ResultType = readIElement(drawing, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        docxFile: createFakeDocxFile({
          "word/media/hat.png": imageBuffer
        })
      });

      expect(result.messages).assertDeepEquals([]);
      const images: DocumentsImage[] = result.value as DocumentsImage[];
      expect(images.length).assertEqual(1);
      const image: DocumentsImage = images[0];
      expect(image.type).assertEqual('image');
      expect(image.altText).assertEqual("It's a hat");
      expect(image.contentType).assertEqual("image/png");

      image.read().then(data => {
        expect(data).assertDeepEquals(imageBuffer);
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    });

    it('testAltTextDescriptionIsPreferredToAltTextTitle', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试描述优先于标题作为替代文本');
      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const drawing: IElement = createInlineImage({
        blip: createEmbeddedBlip("rId5"),
        description: "It's a hat",
        title: "hat"
      });

      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "media/hat.png")
      ];
      const result: ResultType = readIElement(drawing, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        docxFile: createFakeDocxFile({
          "word/media/hat.png": imageBuffer
        })
      });

      expect(result.messages).assertDeepEquals([]);
      const images: DocumentsImage[] = result.value as DocumentsImage[];
      expect(images.length).assertEqual(1);
      const image: DocumentsImage = images[0];
      expect(image.type).assertEqual('image');
      expect(image.altText).assertEqual("It's a hat");
      expect(image.contentType).assertEqual("image/png");

      image.read().then(data => {
        expect(data).assertDeepEquals(imageBuffer);
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    });

    it('testCanReadAnchoredPictures', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取锚定图片');

      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const drawing: IElement = createElement("w:drawing", {}, [
        createElement("wp:anchor", {}, [
          createElement("wp:docPr", { "descr": "It's a hat" }, []),
          createElement("a:graphic", {}, [
            createElement("a:graphicData", {}, [
              createElement("pic:pic", {}, [
                createElement("pic:blipFill", {}, [
                  createElement("a:blip", { "r:embed": "rId5" }, [])
                ])
              ])
            ])
          ])
        ])
      ]);

      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "media/hat.png")
      ];
      const result: ResultType = readIElement(drawing, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        docxFile: createFakeDocxFile({
          "word/media/hat.png": imageBuffer
        })
      });

      expect(result.messages).assertDeepEquals([]);
      const images: DocumentsImage[] = result.value as DocumentsImage[];
      expect(images.length).assertEqual(1);
      const image: DocumentsImage = images[0];
      expect(image.type).assertEqual('image');
      expect(image.altText).assertEqual("It's a hat");
      expect(image.contentType).assertEqual("image/png");

      image.read().then(data => {
        expect(data).assertDeepEquals(imageBuffer);
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    });

    it('testCanReadLinkedPictures', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取链接图片');

      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const drawing: IElement = createInlineImage({
        blip: createLinkedBlip("rId5"),
        description: "It's a hat"
      });
      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "file:///media/hat.png")
      ];
      const image: DocumentsImage = single(readIElementValue(drawing, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        files: createFakeFiles({
          "file:///media/hat.png": imageBuffer
        })
      }) as DocumentsImage[]) as DocumentsImage;

      expect(image).not().assertNull();
      expect(image.type).assertEqual('image');
      expect(image.altText).assertEqual("It's a hat");
      expect(image.contentType).assertEqual("image/png");

      image.read().then(data => {
        expect(data).assertDeepEquals(imageBuffer);
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    });

    it('testWarningIfBlipHasNoImageFile', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试blip无图像文件时发出警告');

      const drawing: IElement = createInlineImage({
        blip: createElement("a:blip", {}, []),
        description: "It's a hat"
      });

      const result: ResultType = readIElement(drawing);

      expect(result.value).assertDeepEquals([]);
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message).assertEqual("Could not find image file for a:blip element");
      done();
    });

    it('testWarningIfUnsupportedImageType', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试不支持的图像类型时发出警告');

      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const drawing: IElement = createInlineImage({
        blip: createEmbeddedBlip("rId5"),
        description: "It's a hat"
      });

      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "media/hat.emf")
      ];

      const result: ResultType = readIElement(drawing, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        docxFile: createFakeDocxFile({
          "word/media/hat.efm": imageBuffer
        })
      });

      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message)
        .assertEqual("Image of type image/x-emf is unlikely to display in web browsers");

      const elements: DocumentsImage = single(result.value as DocumentsImage[]) as DocumentsImage;
      expect(elements.contentType).assertEqual("image/x-emf");
      done();
    });

    it('testNoElementsCreatedIfImageCannotBeFoundInWDrawing', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试在w:drawing中找不到图像时不创建元素');

      const drawing: IElement = createElement("w:drawing", {}, []);

      const result: ResultType = readIElement(drawing);

      expect(result.messages).assertDeepEquals([]);
      expect(result.value).assertDeepEquals([]);
      done();
    });


    it('testNoElementsCreatedIfImageCannotBeFoundInWpInline', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试在wp:inline中找不到图像时不创建元素');

      const drawing: IElement = createElement("wp:inline", {}, []);

      const result: ResultType = readIElement(drawing);

      expect(result.messages).assertDeepEquals([]);
      expect(result.value).assertDeepEquals([]);
      done();
    });

    it('testCanReadPicturesWithHyperlinkSpecifiedInDocumentProperties', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取文档属性中指定超链接的图片');

      const imageData: string = "Not an image at all!";
      const imageBuffer = buffer.alloc(20, imageData);

      const drawing: IElement = createInlineImage({
        blip: createEmbeddedBlip("rId5"),
        docPrChildren: [
          createElement("a:hlinkClick", { "r:id": "rId42" }, [])
        ]
      });

      const relationshipsOption: RelationshipOption[] = [
        imageRelationship("rId5", "media/hat.png"),
        hyperlinkRelationship("rId42", "http://example.com")
      ];

      const result: ResultType = readIElement(drawing, {
        relationships: Relationships(relationshipsOption),
        contentTypes: fakeContentTypes,
        docxFile: createFakeDocxFile({
          "word/media/hat.png": imageBuffer
        })
      });

      expect(result.messages).assertDeepEquals([]);

      const elements: Hyperlink[] = result.value as Hyperlink[];
      expect(elements.length).assertEqual(1);

      const hyperlink: Hyperlink = elements[0]
      expect(hyperlink.type).assertEqual("hyperlink");
      expect(hyperlink.href).assertEqual("http://example.com");
      expect(hyperlink.children.length).assertEqual(1);

      const image: DocumentsImage = hyperlink.children[0] as DocumentsImage;
      expect(image.type).assertEqual('image');
      expect(image.contentType).assertEqual("image/png");

      image.read().then(data => {
        expect(data).assertDeepEquals(imageBuffer);
        done();
      }).catch(() => {
        expect().assertFail();
        done();
      })
    });

    it('testChildrenOfWInsAreConvertedNormally', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:ins的子元素正常转换');

      const runXml: IElement = createElement("w:r", {}, []);
      const insElement: IElement = createElement("w:ins", {}, [runXml]);
      const result: ResultType = readIElement(insElement);

      const elements: Run[] = JSON.parse(JSON.stringify(result.value));
      expect(elements.length).assertEqual(1);
      expect(elements[0].type).assertEqual("run");
      done();
    });

    it('testChildrenOfWObjectAreConvertedNormally', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:object的子元素正常转换');

      const runXml: IElement = createElement("w:r", {}, []);
      const objectElement: IElement = createElement("w:object", {}, [runXml]);
      const result: ResultType = readIElement(objectElement);

      const elements: Run[] = JSON.parse(JSON.stringify(result.value));
      expect(elements.length).assertEqual(1);
      expect(elements[0].type).assertEqual("run");
      done();
    });

    it('testChildrenOfWSmartTagAreConvertedNormally', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:smartTag的子元素正常转换');

      const runXml: IElement = createElement("w:r", {}, []);
      const smartTagElement: IElement = createElement("w:smartTag", {}, [runXml]);
      const result: ResultType = readIElement(smartTagElement);

      const elements: Run[] = JSON.parse(JSON.stringify(result.value));
      expect(elements.length).assertEqual(1);
      expect(elements[0].type).assertEqual("run");
      done();
    });

    it('testChildrenOfVGroupAreConvertedNormally', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试v:group的子元素正常转换');

      const runXml: IElement = createElement("w:r", {}, []);
      const groupElement: IElement = createElement("v:group", {}, [runXml]);
      const result: ResultType = readIElement(groupElement);

      const elements: Run[] = JSON.parse(JSON.stringify(result.value));
      expect(elements.length).assertEqual(1);
      expect(elements[0].type).assertEqual("run");
      done();
    });

    it('testChildrenOfVRectAreConvertedNormally', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试v:rect的子元素正常转换');

      const runXml: IElement = createElement("w:r", {}, []);
      const rectElement: IElement = createElement("v:rect", {}, [runXml]);
      const result: ResultType = readIElement(rectElement);

      const elements: Run[] = JSON.parse(JSON.stringify(result.value));
      expect(elements.length).assertEqual(1);
      expect(elements[0].type).assertEqual("run");
      done();
    });

    // ========== 超链接测试 ==========

    it('testWHyperlinkIsReadAsExternalHyperlinkIfItHasRelationshipId', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试有关系ID的w:hyperlink读取为外部超链接');

      const runXml: IElement = createElement("w:r", {}, []);
      const hyperlinkXml: IElement = createElement("w:hyperlink", { "r:id": "r42" }, [runXml]);
      const relationshipsOption: RelationshipOption[] = [
        hyperlinkRelationship("r42", "http://example.com")
      ];

      const result: ResultType = readIElement(hyperlinkXml, { relationships: Relationships(relationshipsOption) });
      const hyperlink: Hyperlink = JSON.parse(JSON.stringify(result.value));

      expect(hyperlink.href).assertEqual("http://example.com");
      expect(hyperlink.children[0].type).assertEqual("run");
      done();
    });

    it('testWHyperlinkIsReadAsExternalHyperlinkIfItHasRelationshipIdAndAnchor', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试有关系ID和锚点的w:hyperlink读取为外部超链接');

      const runXml: IElement = createElement("w:r", {}, []);
      const hyperlinkXml: IElement =
        createElement("w:hyperlink", { "r:id": "r42", "w:anchor": "fragment" }, [runXml]);
      const relationshipsOption: RelationshipOption[] = [
        hyperlinkRelationship("r42", "http://example.com/")
      ];

      const result: ResultType = readIElement(hyperlinkXml, { relationships: Relationships(relationshipsOption) });
      const hyperlink: Hyperlink = JSON.parse(JSON.stringify(result.value));

      expect(hyperlink.href).assertEqual("http://example.com/#fragment");
      expect(hyperlink.children[0].type).assertEqual("run");
      done();
    });

    it('testExistingFragmentIsReplacedWhenAnchorIsSetOnExternalLink', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试设置锚点时替换现有片段');

      const runXml: IElement = createElement("w:r", {}, []);
      const hyperlinkXml: IElement =
        createElement("w:hyperlink", { "r:id": "r42", "w:anchor": "fragment" }, [runXml]);
      const relationshipsOption: RelationshipOption[] = [
        hyperlinkRelationship("r42", "http://example.com/#previous")
      ];

      const result: ResultType = readIElement(hyperlinkXml, { relationships: Relationships(relationshipsOption) });
      const hyperlink: Hyperlink = JSON.parse(JSON.stringify(result.value));

      expect(hyperlink.href).assertEqual("http://example.com/#fragment");
      expect(hyperlink.children[0].type).assertEqual("run");
      done();
    });

    it('testWHyperlinkIsReadAsInternalHyperlinkIfItHasAnchor', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试有锚点的w:hyperlink读取为内部超链接');

      const runXml: IElement = createElement("w:r", {}, []);
      const hyperlinkXml: IElement = createElement("w:hyperlink", { "w:anchor": "_Peter" }, [runXml]);

      const result: ResultType = readIElement(hyperlinkXml);
      const hyperlink: Hyperlink = JSON.parse(JSON.stringify(result.value));

      expect(hyperlink.anchor).assertEqual("_Peter");
      expect(hyperlink.children[0].type).assertEqual("run");
      done();
    });

    it('testWHyperlinkIsIgnoredIfItDoesNotHaveRelationshipIdNorAnchor', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试既没有关系ID也没有锚点的w:hyperlink被忽略');

      const runXml: IElement = createElement("w:r", {}, []);
      const hyperlinkXml: IElement = createElement("w:hyperlink", {}, [runXml]);

      const result: ResultType = readIElement(hyperlinkXml);
      const elements: Run[] = JSON.parse(JSON.stringify(result.value));

      expect(elements[0].type).assertEqual("run");
      done();
    });

    it('testTargetFrameIsRead', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取目标框架');

      const hyperlinkXml: IElement = createElement("w:hyperlink", {
        "w:anchor": "Introduction",
        "w:tgtFrame": "_blank"
      });

      const result: ResultType = readIElement(hyperlinkXml);
      const hyperlink: Hyperlink = JSON.parse(JSON.stringify(result.value));

      expect(hyperlink.targetFrame).assertEqual("_blank");
      done();
    });

    it('testEmptyTargetFrameIsIgnored', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试忽略空目标框架');

      const hyperlinkXml: IElement = createElement("w:hyperlink", {
        "w:anchor": "Introduction",
        "w:tgtFrame": ""
      });

      const result: ResultType = readIElement(hyperlinkXml);
      const hyperlink: Hyperlink = JSON.parse(JSON.stringify(result.value));

      expect(hyperlink.targetFrame).assertNull();
      done();
    });

    // ========== 换行符测试 ==========

    it('testWBrWithoutExplicitTypeIsReadAsLineBreak', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试无显式类型的w:br读取为换行符');

      const breakXml: IElement = createElement("w:br", {}, []);
      const result: ResultType = readIElement(breakXml);
      const breakElement: Break = JSON.parse(JSON.stringify(result.value));

      expect(breakElement.type).assertEqual('break');
      expect(breakElement.breakType).assertEqual('line');
      done();
    });

    it('testWBrWithTextWrappingTypeIsReadAsLineBreak', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试textWrapping类型的w:br读取为换行符');

      const breakXml: IElement = createElement("w:br", { "w:type": "textWrapping" }, []);
      const result: ResultType = readIElement(breakXml);
      const breakElement: Break = JSON.parse(JSON.stringify(result.value));

      expect(breakElement.type).assertEqual('break');
      expect(breakElement.breakType).assertEqual('line');
      done();
    });

    it('testWBrWithPageTypeIsReadAsPageBreak', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试page类型的w:br读取为分页符');

      const breakXml: IElement = createElement("w:br", { "w:type": "page" }, []);
      const result: ResultType = readIElement(breakXml);
      const breakElement: Break = JSON.parse(JSON.stringify(result.value));

      expect(breakElement.type).assertEqual('break');
      expect(breakElement.breakType).assertEqual('page');
      done();
    });

    it('testWBrWithColumnTypeIsReadAsColumnBreak', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试column类型的w:br读取为分栏符');

      const breakXml: IElement = createElement("w:br", { "w:type": "column" }, []);
      const result: ResultType = readIElement(breakXml);
      const breakElement: Break = JSON.parse(JSON.stringify(result.value));

      expect(breakElement.type).assertEqual('break');
      expect(breakElement.breakType).assertEqual('column');
      done();
    });

    it('testWarningOnBreaksThatArentRecognised', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试对无法识别的换行类型发出警告');

      const breakXml: IElement = createElement("w:br", { "w:type": "unknownBreakType" }, []);
      const result: ResultType = readIElement(breakXml);

      expect(result.value).assertDeepEquals([]);
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message).assertEqual("Unsupported break type: unknownBreakType");
      done();
    });

    // ========== 引用测试 ==========

    it('testWFootnoteReferenceHasIdRead', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取w:footnoteReference的ID');

      const referenceXml: IElement = createElement("w:footnoteReference", { "w:id": "4" });
      const result: ResultType = readIElement(referenceXml);
      const noteReference: NoteReference = JSON.parse(JSON.stringify(result.value));

      expect(noteReference.type).assertEqual('noteReference');
      expect(noteReference.noteType).assertEqual('footnote');
      expect(noteReference.noteId).assertEqual('4');
      expect(result.messages).assertDeepEquals([]);
      done();
    });

    it('testWCommentReferenceHasIdRead', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取w:commentReference的ID');

      const referenceXml: IElement = createElement("w:commentReference", { "w:id": "4" });
      const result: ResultType = readIElement(referenceXml);
      const commentReference: CommentReference = JSON.parse(JSON.stringify(result.value));

      expect(commentReference.type).assertEqual('commentReference');
      expect(commentReference.commentId).assertEqual('4');
      expect(result.messages).assertDeepEquals([]);
      done();
    });

    // ========== 警告处理测试 ==========

    it('testEmitsWarningOnUnrecognisedElement', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试对无法识别的元素发出警告');

      const unrecognisedElement: IElement = createElement("w:not-an-element");
      const result: ResultType = readIElement(unrecognisedElement);

      expect(result.value).assertDeepEquals([]);
      expect(result.messages.length).assertEqual(1);
      expect(result.messages[0].type).assertEqual("warning");
      expect(result.messages[0].message).assertEqual("An unrecognised element was ignored: w:not-an-element");
      done();
    });

    it('testWBookmarkEndIsIgnoredWithoutWarning', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试w:bookmarkEnd被忽略且无警告');

      const ignoredElement: IElement = createElement("w:bookmarkEnd");
      const result: ResultType = readIElement(ignoredElement);

      expect(result.messages).assertDeepEquals([]);
      expect(result.value).assertDeepEquals([]);
      done();
    });

    it('testTextBoxesHaveContentAppendedAfterContainingParagraph', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试文本框内容附加到包含段落之后');

      const textbox: IElement = createElement("w:pict", {}, [
        createElement("v:shape", {}, [
          createElement("v:textbox", {}, [
            createElement("w:txbxContent", {}, [
              paragraphWithStyleId("textbox-content")
            ])
          ])
        ])
      ]);

      const paragraph: IElement = createElement("w:p", {}, [
        createElement("w:r", {}, [textbox])
      ]);

      const result: ResultType = readIElement(paragraph);
      const elements: Paragraph[] = JSON.parse(JSON.stringify(result.value));

      expect(elements[1].styleId).assertEqual("textbox-content");
      done();
    });

    it('testMcAlternateContentWhenMcFallbackIsPresentThenMcFallbackIsRead', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试当mc:Fallback存在时则读取mc:Fallback');

      const styles: OptionsStyles = Styles({ "first": { name: "First" }, "second": { name: "Second" } }, {});
      const textbox: IElement = createElement("mc:AlternateContent", {}, [
        createElement("mc:Choice", { "Requires": "wps" }, [
          paragraphWithStyleId("first")
        ]),
        createElement("mc:Fallback", {}, [
          paragraphWithStyleId("second")
        ])
      ]);

      const result: ResultType = readIElement(textbox, { styles: styles });
      const elements: Paragraph[] = JSON.parse(JSON.stringify(result.value));

      expect(elements[0].styleId).assertEqual("second");
      done();
    });

    it('testMcAlternateContentWhenMcFallbackIsNotPresentThenElementIsIgnored', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试当mc:Fallback不存在时则忽略元素');

      const textbox: IElement = createElement("mc:AlternateContent", {}, [
        createElement("mc:Choice", { "Requires": "wps" }, [
          paragraphWithStyleId("first")
        ])
      ]);

      const result: ResultType = readIElement(textbox);

      expect(result.value).assertDeepEquals([]);
      done();
    });

    it('testWSdtContentIsUsedWhenWSdtIsRead', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取w:sdt时使用w:sdtContent');

      const element: IElement = createElement("w:sdt", {}, [
        createElement("w:sdtContent", {}, [
          createElement("w:t", {}, [createText("Blackdown")])
        ])
      ]);

      const result: ResultType = readIElement(element);
      const elements: Text[] = JSON.parse(JSON.stringify(result.value));

      expect(elements.length).assertEqual(1);
      expect(elements[0].type).assertEqual("text");
      expect(elements[0].value).assertEqual("Blackdown");
      done();
    });

    it('testTextNodesAreIgnoredWhenReadingChildren', 0, (done: Function) => {
      hilog.info(DOMAIN, TAG, '%{public}s', '测试读取子元素时忽略文本节点');

      const runXml: IElement = createElement("w:r", {}, [createText("[text]")]);
      const run: Run = JSON.parse(JSON.stringify(readIElementValue(runXml)));

      expect(run.type).assertEqual("run");
      expect(run.children).assertDeepEquals([]);
      done();
    });
  });
}