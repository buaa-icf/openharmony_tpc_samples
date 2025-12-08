// html-test.ets
import { describe, it, expect } from '@ohos/hypium';
import * as html from "@ohos/mammoth/src/main/ets/html";
import * as writers  from "@ohos/mammoth/src/main/ets/writers";

interface NodeInterface {
  type: string;
  value?: string;
  tag?: string;
  children?: NodeInterface[];
}

interface writerFace{
  asString: () => string;
  open: (tagName: string, attributes: Record<string,object>) => void;
  close: (tagName: string) => void;
  text: (value: string) => void;
  selfClosing: (tagName: string, attributes: Record<string,object>) => void;
}

function generateString(node: NodeInterface): string {
  let  writer: writerFace = writers.writer();
  html.write(writer, [node]);
  return writer.asString();
}


export default function writesTest() {

  describe('writesTest', () => {



    // 测试1: 文本HTML转义
    it('text_is_HTML_escaped', 0, (done: Function) => {
      expect(generateString(html.text('<>&')))
        .assertEqual('&lt;&gt;&amp;');
      done();
    });

    // 测试2: 属性外的双引号不转义
    it('double_quotes_outside_of_attributes_are_not_escaped', 0, (done: Function) => {
      expect(generateString(html.text('"')))
        .assertEqual('"');
      done();
    });

    // 测试3: 元素属性HTML转义
    it('element_attributes_are_HTML_escaped', 0, (done: Function) => {
      expect(generateString(html.freshElement('p', { 'x': '<' })))
        .assertEqual('<p x="&lt;"></p>');
      done();
    });

    // 测试4: 属性内双引号转义
    it('double_quotes_inside_attributes_are_escaped', 0, (done: Function) => {
      expect(generateString(html.freshElement('p', { 'x': '"' })))
        .assertEqual('<p x="&quot;"></p>');
      done();
    });

    // 测试5: 元素子节点写入
    it('element_children_are_written', 0, (done: Function) => {
      expect(generateString(html.freshElement('p', {}, [html.text('Hello')])))
        .assertEqual('<p>Hello</p>');
      done();
    });
  });
}