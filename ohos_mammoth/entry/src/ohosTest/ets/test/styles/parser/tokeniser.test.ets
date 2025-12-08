import { describe, expect, it } from "@ohos/hypium";
import { tokenise } from '@ohos/mammoth/src/main/ets/styles/parser/tokeniser'

interface Token {
  name: string;
  value: string | null;
}

// 辅助函数：创建 Token 匹配器
function isToken(tokenType: string, value?: string | null): Token {
  return {
    name: tokenType,
    value: value !== undefined ? value : null
  };
}

// 辅助函数：断言 Token 序列
function assertTokens(input: string, expectedTokens: Token[]): void {
  const tokens = tokenise(input) as Token[];
  const expectedWithEnd = [...expectedTokens, isToken("end", null)];

  expect(tokens.length).assertEqual(expectedWithEnd.length);

  for (let i = 0; i < tokens.length; i++) {
    const token = tokens[i];
    const expected = expectedWithEnd[i];

    expect(token.name).assertEqual(expected.name);

    if (expected.value) {
      expect(JSON.stringify(token.value)).assertEqual(JSON.stringify(expected.value));
    }
  }
}

export default function tokeniserTest() {
  describe('tokeniserTest', () => {

    it('unknown tokens are tokenised', 0, (done: Function) => {
      assertTokens("~", [isToken("unrecognisedCharacter", "~")]);
      done();
    });

    it('empty string is tokenised to end of file token', 0, (done: Function) => {
      assertTokens("", []);
      done();
    });

    it('whitespace is tokenised', 0, (done: Function) => {
      assertTokens(" \t\t  ", [isToken("whitespace", " \t\t  ")]);
      done();
    });

    it('identifiers are tokenised', 0, (done: Function) => {
      assertTokens("Overture", [isToken("identifier", "Overture")]);
      done();
    });

    it('integers are tokenised', 0, (done: Function) => {
      assertTokens("123", [isToken("integer", "123")]);
      done();
    });

    it('strings are tokenised', 0, (done: Function) => {
      assertTokens("'Tristan'", [isToken("string", "Tristan")]);
      done();
    });

    it('unterminated strings are tokenised', 0, (done: Function) => {
      assertTokens("'Tristan", [isToken("unterminated-string", "Tristan")]);
      done();
    });

    it('arrows are tokenised', 0, (done: Function) => {
      assertTokens("=>", [isToken("arrow", "=>")]);
      done();
    });

    it('classes are tokenised', 0, (done: Function) => {
      assertTokens("overture", [
        // isToken("dot", "."),
        isToken("identifier", "overture")
      ]);
      done();
    });

    it('colons are tokenised', 0, (done: Function) => {
      assertTokens("::", [
        isToken("colon", ":"),
        isToken("colon", ":")
      ]);
      done();
    });

    it('greater thans are tokenised', 0, (done: Function) => {
      assertTokens(">>", [
        isToken("gt", ">"),
        isToken("gt", ">")
      ]);
      done();
    });

    it('equals are tokenised', 0, (done: Function) => {
      assertTokens("==", [
        isToken("equals", "="),
        isToken("equals", "=")
      ]);
      done();
    });

    it('startsWith symbols are tokenised', 0, (done: Function) => {
      assertTokens("^=^=", [
        isToken("startsWith", "^="),
        isToken("startsWith", "^=")
      ]);
      done();
    });

    it('open parens are tokenised', 0, (done: Function) => {
      assertTokens("((", [
        isToken("open-paren", "("),
        isToken("open-paren", "(")
      ]);
      done();
    });

    it('close parens are tokenised', 0, (done: Function) => {
      assertTokens("))", [
        isToken("close-paren", ")"),
        isToken("close-paren", ")")
      ]);
      done();
    });

    it('open square brackets are tokenised', 0, (done: Function) => {
      assertTokens("[[", [
        isToken("open-square-bracket", "["),
        isToken("open-square-bracket", "[")
      ]);
      done();
    });

    it('close square brackets are tokenised', 0, (done: Function) => {
      assertTokens("]]", [
        isToken("close-square-bracket", "]"),
        isToken("close-square-bracket", "]")
      ]);
      done();
    });

    it('choices are tokenised', 0, (done: Function) => {
      assertTokens("||", [
        isToken("choice", "|"),
        isToken("choice", "|")
      ]);
      done();
    });

    it('can tokenise multiple tokens', 0, (done: Function) => {
      assertTokens("The Magic Position", [
        isToken("identifier", "The"),
        isToken("whitespace", " "),
        isToken("identifier", "Magic"),
        isToken("whitespace", " "),
        isToken("identifier", "Position")
      ]);
      done();
    });
  })
}
