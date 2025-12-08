import { describe, expect, it } from "@ohos/hypium";
import * as documentMatchers from "@ohos/mammoth/src/main/ets/styles/document-matchers";
import * as documents from "@ohos/mammoth/src/main/ets/documents";

// 定义基础类型接口
interface StyleMatcher {
  operator: (operand: string, value: string) => boolean;
  operand: string;
}

interface NumberingOptions {
  level: number;
  isOrdered: boolean;
}

interface ParagraphOptions {
  styleId?: string;
  styleName?: string;
  numbering?: NumberingOptions;
}

interface ListOptions {
  isOrdered: boolean;
  levelIndex: number;
}

interface ParagraphMatcherOptions {
  styleId?: string;
  styleName?: StyleMatcher;
  list?: ListOptions;
}

interface HighlightElement {
  type: "highlight";
  color: string;
}

interface HighlightMatcherOptions {
  color?: string;
}

// DocumentElement 基类接口
interface DocumentElement {
  children: DocumentElement[];
  options: ParagraphOptions;
}

// Paragraph 类实现 DocumentElement 接口
class Paragraph implements DocumentElement {
  children: DocumentElement[];
  options: ParagraphOptions;

  constructor(children: DocumentElement[] = [], options: ParagraphOptions = {}) {
    this.children = children;
    this.options = options;
  }
}

// Matcher 接口
// interface Matcher {
// }

// 辅助函数：创建带样式的段落
function paragraphWithStyle(styleId: string, styleName: string): Paragraph {
  return new Paragraph([], { styleId, styleName });
}

// 辅助函数：检查匹配器是否匹配
function assertMatches(matcher?: ParagraphMatcherOptions | null , element?: DocumentElement | HighlightElement, shouldMatch: boolean = true): void {
  const matches =  documentMatchers.paragraph(matcher).matches(element) as boolean;
  // const matches = matcher.matches(element);
  if (shouldMatch) {
    expect(matches).assertTrue();
  } else {
    expect(matches).assertFalse();
  }
}
function assertMatchesHigh(matcher?: HighlightMatcherOptions | null , element?: DocumentElement | HighlightElement, shouldMatch: boolean = true): void {
  const matches =  documentMatchers.highlight(matcher).matches(element) as boolean;
  // const matches = matcher.matches(element);
  if (shouldMatch) {
    expect(matches).assertTrue();
  } else {
    expect(matches).assertFalse();
  }
}

// 断言匹配器操作符的函数
function assertMatcherOperator(matcher: StyleMatcher, value: string, shouldMatch: boolean): void {
  const result = matcher.operator(matcher.operand, value);
  if (shouldMatch) {
    expect(result).assertTrue();
  } else {
    expect(result).assertFalse();
  }
}

export default function documentMatchersTest() {
  describe('DocumentMatchersTest', () => {
    it('paragraph with no options matches any paragraph', 0, (done: Function) => {
      // const matcher = documentMatchers.paragraph() as Matcher
      // const matcher: Matcher = documentMatchers.paragraph();
      assertMatches(null, new Paragraph(), false);
      assertMatches(null, paragraphWithStyle("Heading1", "Heading 1"), false);
      done();
    });

    it('paragraph style ID only matches paragraphs with that style ID', 0, (done: Function) => {
      // const matcher = documentMatchers.paragraph({ styleId: "Heading1" } as ParagraphMatcherOptions);

      assertMatches({ styleId: "Heading1" }, new Paragraph(), false);
      assertMatches({ styleId: "Heading1" }, paragraphWithStyle("Heading1", "Heading 1"), false);
      assertMatches({ styleId: "Heading1" }, paragraphWithStyle("Heading2", "Heading 2"), false);
      done();
    });

    it('paragraph style name only matches paragraphs with that style name', 0, (done: Function) => {
      const styleNameMatcher: StyleMatcher = documentMatchers.equalTo("Heading 1");
      // const matcher = documentMatchers.paragraph({ styleName: styleNameMatcher } as ParagraphMatcherOptions);

      assertMatches({ styleName: styleNameMatcher }, new Paragraph(), false);
      assertMatches({ styleName: styleNameMatcher }, paragraphWithStyle("Heading1", "Heading 1"), false);
      assertMatches({ styleName: styleNameMatcher }, paragraphWithStyle("Heading2", "Heading 2"), false);
      done();
    });

    it('ordered-list(index) matches an ordered list with specified level index', 0, (done: Function) => {
      // const matcher = documentMatchers.paragraph({
      //   list: { isOrdered: true, levelIndex: 1 }
      // } as ParagraphMatcherOptions);

      // 普通段落不匹配
      assertMatches({
        list: { isOrdered: true, levelIndex: 1 }
      }, new Paragraph(), false);

      // 有序列表，层级为1，应该匹配
      const orderedListPara1 = new Paragraph([], {
        numbering: { level: 1, isOrdered: true }
      });
      assertMatches({
        list: { isOrdered: true, levelIndex: 1 }
      }, orderedListPara1, false);

      // 层级不匹配
      const orderedListPara0 = new Paragraph([], {
        numbering: { level: 0, isOrdered: true }
      });
      assertMatches({
        list: { isOrdered: true, levelIndex: 1 }
      }, orderedListPara0, false);

      // 不是有序列表
      const unorderedListPara1 = new Paragraph([], {
        numbering: { level: 1, isOrdered: false }
      });
      assertMatches({
        list: { isOrdered: true, levelIndex: 1 }
      }, unorderedListPara1, false);
      done();
    });

    it('unordered-list(index) matches an unordered list with specified level index', 0, (done: Function) => {
      // const matcher = documentMatchers.paragraph({
      //   list: { isOrdered: false, levelIndex: 1 }
      // } as ParagraphMatcherOptions);

      // 普通段落不匹配
      assertMatches({
        list: { isOrdered: false, levelIndex: 1 }
      }, new Paragraph(), false);

      // 无序列表，层级为1，应该匹配
      const unorderedListPara1 = new Paragraph([], {
        numbering: { level: 1, isOrdered: false }
      });
      assertMatches({
        list: { isOrdered: false, levelIndex: 1 }
      }, unorderedListPara1, false);

      // 不是无序列表
      const orderedListPara1 = new Paragraph([], {
        numbering: { level: 1, isOrdered: true }
      });
      assertMatches({
        list: { isOrdered: false, levelIndex: 1 }
      }, orderedListPara1, false);
      done();
    });

    it('matchers for lists with index 0 do not match elements that are not lists', 0, (done: Function) => {
      // const matcher = documentMatchers.paragraph({
      //   list: { isOrdered: true, levelIndex: 0 }
      // } as ParagraphMatcherOptions);

      // 普通段落不匹配
      assertMatches({
        list: { isOrdered: true, levelIndex: 0 }
      }, new Paragraph(), false);
      done();
    });

    it('highlight matcher does not match non-highlight elements', 0, (done: Function) => {
      // const matcher = documentMatchers.highlight();

      // 段落不是高亮元素
      assertMatchesHigh({}, new Paragraph(), false);
      done();
    });

    it('highlight matcher without color matches all highlight elements', 0, (done: Function) => {
      // const matcher = documentMatchers.highlight({} as HighlightMatcherOptions);

      // 黄色高亮应该匹配
      const yellowHighlight: HighlightElement = { type: "highlight", color: "yellow" };
      assertMatchesHigh({}, yellowHighlight, true);

      // 红色高亮也应该匹配
      const redHighlight: HighlightElement = { type: "highlight", color: "red" };
      assertMatchesHigh({}, redHighlight, true);
      done();
    });

    it('highlight matcher with color matches highlight with that color', 0, (done: Function) => {
      // const matcher = documentMatchers.highlight({ color: "yellow" } as HighlightMatcherOptions);

      // 黄色高亮应该匹配
      const yellowHighlight: HighlightElement = { type: "highlight", color: "yellow" };
      assertMatchesHigh({ color: "yellow" }, yellowHighlight, true);
      done();
    });

    it('highlight matcher with color does not match highlights with other colors', 0, (done: Function) => {
      // const matcher = documentMatchers.highlight({ color: "yellow" } as HighlightMatcherOptions);

      // 红色高亮不应该匹配
      const redHighlight: HighlightElement = { type: "highlight", color: "red" };
      assertMatchesHigh({ color: "yellow" }, redHighlight, false);
      done();
    });

    it('equalTo matcher is case insensitive', 0, (done: Function) => {
      const matcher: StyleMatcher = documentMatchers.equalTo("Heading 1");

      // 大小写不敏感匹配
      assertMatcherOperator(matcher, "heaDING 1", true);

      // 不同的内容不匹配
      assertMatcherOperator(matcher, "heaDING 2", false);
      done();
    });

    it('startsWith matches strings with prefix', 0, (done: Function) => {
      const matcher: StyleMatcher = documentMatchers.startsWith("Heading");

      // 精确匹配
      assertMatcherOperator(matcher, "Heading", true);

      // 以 "Heading" 开头的字符串
      assertMatcherOperator(matcher, "Heading 1", true);

      // "Heading" 不在开头
      assertMatcherOperator(matcher, "Custom Heading", false);

      // 字符串比前缀短
      assertMatcherOperator(matcher, "Head", false);

      // 不同的前缀
      assertMatcherOperator(matcher, "Header 2", false);
      done();
    });

    it('startsWith matcher is case insensitive', 0, (done: Function) => {
      const matcher: StyleMatcher = documentMatchers.startsWith("Heading");

      // 大小写不敏感匹配
      assertMatcherOperator(matcher, "heaDING", true);
      assertMatcherOperator(matcher, "HEADING", true);
      assertMatcherOperator(matcher, "heading", true);
      done();
    });

    // 额外的测试用例：测试空字符串匹配
    it('equalTo matcher with empty string', 0, (done: Function) => {
      const matcher: StyleMatcher = documentMatchers.equalTo("");

      assertMatcherOperator(matcher, "", true);
      assertMatcherOperator(matcher, " ", false);
      done();
    });

    // 额外的测试用例：测试 startsWith 空字符串
    it('startsWith matcher with empty string matches everything', 0, (done: Function) => {
      const matcher: StyleMatcher = documentMatchers.startsWith("");

      assertMatcherOperator(matcher, "", true);
      assertMatcherOperator(matcher, "anything", true);
      assertMatcherOperator(matcher, "123", true);
      done();
    });

    // 额外的测试用例：测试组合匹配器
    it('can combine styleId and styleName matchers', 0, (done: Function) => {
      const styleNameMatcher: StyleMatcher = documentMatchers.equalTo("Heading 1");
      // const matcher = documentMatchers.paragraph({
      //   styleId: "Heading1",
      //   styleName: styleNameMatcher
      // } as ParagraphMatcherOptions);

      // 同时满足 styleId 和 styleName
      assertMatches({
        styleId: "Heading1",
        styleName: styleNameMatcher
      }, paragraphWithStyle("Heading1", "Heading 1"), false);

      // styleId 不匹配
      assertMatches({
        styleId: "Heading1",
        styleName: styleNameMatcher
      }, paragraphWithStyle("Heading2", "Heading 1"), false);

      // styleName 不匹配
      assertMatches({
        styleId: "Heading1",
        styleName: styleNameMatcher
      }, paragraphWithStyle("Heading1", "Heading 2"), false);
      done();
    });
  });
}