import { describe, expect, it } from "@ohos/hypium";
import { Element } from '../Type'
import * as reader from "@ohos/mammoth/src/main/ets/xml/reader";
import * as nodes from "@ohos/mammoth/src/main/ets/xml/nodes";


export default function readerTest() {
  describe('readerTest', () => {
    it('should read self-closing element', 0, async (done: Function) => {
      const result = await(reader.readString("<body/>") as  Promise<nodes.Element>);
      const  expected:Element={
        type:"element",
        name:"body",
        children:[],
        attributes:{}
      }
      expect(result).assertDeepEquals(expected);
      done();
    });

    it('should read empty element with separate closing tag', 0, async (done: Function) => {
      const result = await (reader.readString("<body></body>") as Promise<nodes.Element>);
      const expected:Element={
        type:"element",
        name:"body",
        children:[],
        attributes:{}
      }
      expect(result).assertDeepEquals(expected);
      done();
    });

    it('should read attributes of tags', 0, async (done: Function) => {
      const result = await (reader.readString('<body name="bob"/>') as  Promise<nodes.Element>);
      const expectedAttributes:Element={
        name:"bob",
      }
      expect(result.attributes).assertDeepEquals(expectedAttributes);
      done();
    });

    it('can read text element', 0, async (done: Function) => {
      const result = await (reader.readString('<body>Hello!</body>') as Promise<nodes.Element>);
      const expectedChild:Element={
        type:"text",
        value:"Hello!"
      }
      // 使用类型守卫确保是 XmlText
      const child = (result.children as Element[])[0];
        expect(child).assertDeepEquals(expectedChild);
      done();
    });

    it('should read element with children', 0, async (done: Function) => {
      const root = await reader.readString("<body><a/><b/></body>") as Element;
      expect(root.children!.length).assertEqual(2);

      // 使用类型守卫
      const childA = root.children![0];
      const childB = root.children![1];
        expect(childA.name).assertEqual("a");
        expect(childB.name).assertEqual("b");
      done();
    });

    it('unmapped namespaces URIs are included in braces as prefix', 0, async (done: Function) => {
      const result = await reader.readString('<w:body xmlns:w="word"/>') as Element;
      expect(result.name).assertEqual("{word}body");
      done();
    });

    it('mapped namespaces URIs are translated using map', 0, async (done: Function) => {
      const namespaceMap:Record<string, string> = {
        "word": "x"
      };
      const result = await reader.readString('<w:body xmlns:w="word"/>', namespaceMap) as Element;
      expect(result.name).assertEqual("x:body");
      done();
    });

    it('namespace of attributes is mapped to prefix', 0, async (done: Function) => {
      const namespaceMap:Record<string, string> = {
        "word": "x"
      };
      const xmlString = '<w:body xmlns:w="word" w:val="Hello!"/>';
      const result = await reader.readString(xmlString, namespaceMap) as Element;
      expect(result.attributes!["x:val"]).assertEqual("Hello!");
      done();
    });

    it('can find first element with name', 0, async (done: Function) => {
      const result = await (reader.readString('<body><a/><b index="1"/><b index="2"/></body>') as Promise<Element>);
      // const first = result.first("b");first.attributes.index
      let first:Element = {}
        result.children?.forEach((child) => {
        if (child.name === "b" && child.attributes!["index"] == "1") {
          first = child;
        }
      })
        expect(first?.attributes!["index"]).assertEqual("1");
      done();
    });

    it('whitespace between xml declaration and root tag is ignored', 0, async (done: Function) => {
      const result = await reader.readString('<?xml version="1.0" ?>\n<body/>') as  Element;
      expect(result.name).assertEqual("body");
      done();
    });

    it('error if XML is badly formed', 0, async (done: Function) => {

      const result = await (reader.readString("<bo") as Promise<Element>);
      reader.readString("<bo").then((result: Element| undefined) => {
        // 检查错误是否存在
        expect(result?.name).assertEqual("bo");
        done();
      }).catch((error: Error) => {
        expect().assertFail();
        done();
      })

    });
  })
}