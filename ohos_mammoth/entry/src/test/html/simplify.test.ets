// simplify.tests.ets
import { describe, it, expect } from '@ohos/hypium';
import * as html from "@ohos/mammoth/src/main/ets/html";
import * as htmlPaths from "@ohos/mammoth/src/main/ets/styles/html-paths";


// 定义具体的HTML节点类型
interface ElementInterface {
  tagName: string;
  tagNames: Record<string, boolean>;
  attributes: Record<string, string>;
  fresh?: boolean;
  separator?: string;
  matchesElement?: (element: ElementInterface) => boolean;
  wrap?: (generateNodes: () => NodeInterface[]) => NodeInterface[];
  wrapNodes?: (nodes: NodeInterface[]) => NodeInterface[];
}

interface NodeInterface {
  type: string;
  value?: string;
  tag?: ElementInterface;
  children?: NodeInterface[];
}

type HtmlNode = NodeInterface;

// 辅助函数
const simplifyNode = ( node: HtmlNode): HtmlNode[] => {
  return html.simplify([node]);
}

const concat = (...arrays: HtmlNode[][]): HtmlNode[] => {
  return arrays.flat();
}

export default function simplifyTest() {
  describe('simplifyTest', () => {
    // 测试1: 空文本节点被移除
    it('empty_text_nodes_are_removed', 0, (done: Function) => {
      expect(simplifyNode(html.text('')))
        .assertDeepEquals([]);
      done();
    });

    // 测试2: 没有子元素的元素被移除
    it('elements_with_no_children_are_removed', 0, (done: Function) => {
      expect(simplifyNode(html.nonFreshElement('p', {}, [])))
        .assertDeepEquals([]);
      done();
    });

    // 测试3: 只包含空节点的元素被移除
    it('elements_only_containing_empty_nodes_are_removed', 0, (done: Function) => {
      expect(simplifyNode(html.nonFreshElement('p', {}, [html.text('')])))
        .assertDeepEquals([]);
      done();
    });

    // 测试4: 移除元素中的空子节点
    it('empty_children_of_element_are_removed', 0, (done: Function) => {
      const result = simplifyNode(html.nonFreshElement('p', {}, [html.text('Hello'), html.text('')]));
      expect(result).assertDeepEquals([html.nonFreshElement('p', {}, [html.text('Hello')])]);
      done();
    });

    // 测试5: 空的void元素不被移除
    it('empty_void_elements_are_not_removed', 0, (done: Function) => {
      expect(simplifyNode(html.nonFreshElement('br', {}, [])))
        .assertDeepEquals([html.nonFreshElement('br', {}, [])]);
      done();
    });

    // 测试6: 连续的新鲜元素不合并
    it('successive_fresh_elements_are_not_collapsed', 0, (done: Function) => {
      const original = concat(
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: true })]).wrap(() => [html.text('Hello')]),
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: true })]).wrap(() => [html.text(' there')])
      );

      expect(html.simplify(original))
        .assertDeepEquals(original);
      done();
    });

    // 测试7: 连续的非新鲜元素合并（相同标签名）
    it('successive_plain_non_fresh_elements_are_collapsed_if_they_have_the_same_tag_name', 0, (done: Function) => {
      const input = concat(
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: false })]).wrap(() => [html.text('Hello')]),
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: false })]).wrap(() => [html.text(' there')])
      );

      expect(html.simplify(input))
        .assertDeepEquals(htmlPaths.elements([htmlPaths.element('p', {}, { fresh: false })]).wrap(() => [html.text('Hello'), html.text(' there')]));
      done();
    });

    // 测试8: 非新鲜元素可合并到前一个新鲜元素
    it('non_fresh_can_collapse_into_preceding_fresh_element', 0, (done: Function) => {
      const input = concat(
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: true })]).wrap(() => [html.text('Hello')]),
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: false })]).wrap(() => [html.text(' there')])
      );

      expect(html.simplify(input))
        .assertDeepEquals(htmlPaths.elements([htmlPaths.element('p', {}, { fresh: true })]).wrap(() => [html.text('Hello'), html.text(' there')]));
      done();
    });

    // 测试9: 合并元素的子元素也可以合并
    it('children_of_collapsed_element_can_collapse_with_children_of_another_collapsed_element', 0, (done: Function) => {

      expect(html.simplify([
        html.nonFreshElement('blockquote', {}, [html.nonFreshElement('p', {}, [html.text('Hello')])]),
        html.nonFreshElement('blockquote', {}, [html.nonFreshElement('p', {}, [html.text('there')])])
      ]))
        .assertDeepEquals([
          html.nonFreshElement('blockquote', {}, [html.nonFreshElement('p', {}, [html.text('Hello'), html.text('there')])])
        ]);
      done();
    });

    // 测试10: 先移除空元素再合并
    it('empty_elements_are_removed_before_collapsing', 0, (done: Function) => {
      const input = concat(
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: false })]).wrap(() => [html.text('Hello')]),
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: true })]).wrap(() => []),
        htmlPaths.elements([htmlPaths.element('p', {}, { fresh: false })]).wrap(() => [html.text(' there')])
      );

      expect(html.simplify(input))
        .assertDeepEquals(htmlPaths.elements([htmlPaths.element('p', {}, { fresh: false })]).wrap(() => [html.text('Hello'), html.text(' there')]));
      done();
    });

    // 测试11: 有分隔符时合并元素前置分隔符
    it('when_separator_is_present_then_separator_is_prepended_to_collapsed_element', 0, (done: Function) => {
      const input = concat(
        htmlPaths.elements([htmlPaths.element('pre', {}, { fresh: false })]).wrap(() => [html.text('Hello')]),
        htmlPaths.elements([htmlPaths.element('pre', {}, { fresh: false, separator: '\n' })]).wrap(() => [html.text(' the'), html.text('re')])
      );

      expect(html.simplify(input))
        .assertDeepEquals(htmlPaths.elements([htmlPaths.element('pre', {}, { fresh: false })]).wrap(() => [html.text('Hello'), html.text('\n'), html.text(' the'), html.text('re')]));
      done();
    });
  });
}