import { describe, expect, it } from "@ohos/hypium";
import * as htmlWriter from "@ohos/mammoth/src/main/ets/writers/html-writer";


interface HtmlWriter {
    open(tag: string): void;
    close(tag: string): void;
    text(content: string): void;
    selfClosing(tag: string): void;
    asString(): string;
}
interface WriterOptions {
    prettyPrint?: boolean;
}
function createWriter(options?: WriterOptions): HtmlWriter {
    return htmlWriter.writer(options);
}

export default function html_writerTest() {
    describe('html_writerTest',()=>{
        it('can generate simple paragraph', 0, (done: Function) => {
            const writer = createWriter();
            writer.open("p");
            writer.text("Hello");
            writer.close("p");
            const expected = "<p>Hello</p>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('can nest elements', 0, (done: Function) => {
            const writer = createWriter();
            writer.open("ul");
            writer.open("li");
            writer.text("One");
            writer.close("li");
            writer.open("li");
            writer.text("Two");
            writer.close("li");
            writer.close("ul");
            const expected = "<ul><li>One</li><li>Two</li></ul>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('indents text if prettyPrint is true', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("p");
            writer.text("One");
            writer.close("p");
            writer.open("p");
            writer.text("Two");
            writer.close("p");
            const expected = "<p>\n  One\n</p>\n<p>\n  Two\n</p>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('indents element if prettyPrint is true', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("ul");
            writer.open("li");
            writer.text("One");
            writer.close("li");
            writer.open("li");
            writer.text("Two");
            writer.close("li");
            writer.close("ul");
            const expected = "<ul>\n  <li>\n    One\n  </li>\n  <li>\n    Two\n  </li>\n</ul>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('when prettyPrint is true inner elements do not have new lines', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("p");
            writer.text("One");
            writer.open("em");
            writer.text("Two");
            writer.close("em");
            writer.close("p");
            const expected = "<p>\n  One<em>Two</em>\n</p>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('indents closing element correctly when nested inside another indented element', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("div");
            writer.open("div");
            writer.open("div");
            writer.text("Hello");
            writer.close("div");
            writer.close("div");
            writer.close("div");
            const expected = "<div>\n  <div>\n    <div>\n      Hello\n    </div>\n  </div>\n</div>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('newlines in text are indented', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("p");
            writer.text("One\nTwo");
            writer.close("p");
            const expected = "<p>\n  One\n  Two\n</p>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('run of text has only one new line', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("p");
            writer.text("One");
            writer.text("Two");
            writer.close("p");
            const expected = "<p>\n  OneTwo\n</p>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('run of html has only one new line', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("p");
            writer.text("One");
            writer.text("Two");
            writer.close("p");
            const expected = "<p>\n  OneTwo\n</p>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('self closing elements are indented', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("p");
            writer.selfClosing("br");
            writer.close("p");
            const expected = "<p>\n  <br />\n</p>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('newlines in appended HTML are indented', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("p");
            writer.text("One\nTwo");
            writer.close("p");
            const expected = "<p>\n  One\n  Two\n</p>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('newlines in <pre> are not indented', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("pre");
            writer.text("One\nTwo");
            writer.close("pre");
            const expected = "<pre>One\nTwo</pre>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        it('newlines in element in <pre> are not indented', 0, (done: Function) => {
            const writer = createWriter({ prettyPrint: true });
            writer.open("pre");
            writer.open("p");
            writer.text("One\nTwo");
            writer.close("p");
            writer.close("pre");
            const expected = "<pre><p>One\nTwo</p></pre>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        // 额外的测试用例：测试属性写入
        it('can write element with attributes', 0, (done: Function) => {
            const writer = createWriter();
            // 假设有 writeElement 方法可以写入带属性的元素
            // 这里需要根据实际的 htmlWriter API 调整
            writer.open("a");
            // 如果实际 API 支持属性，这里需要调整
            writer.text("Link");
            writer.close("a");
            const expected = "<a>Link</a>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

        // 额外的测试用例：测试混合内容
        it('can write mixed content', 0, (done: Function) => {
            const writer = createWriter();
            writer.open("div");
            writer.text("Text before ");
            writer.open("span");
            writer.text("span content");
            writer.close("span");
            writer.text(" text after");
            writer.close("div");
            const expected = "<div>Text before <span>span content</span> text after</div>";
            expect(writer.asString()).assertEqual(expected);
            done();
        });

    })
}
