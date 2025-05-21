/**
 * https://github.com/JuneAndGreen/expr-parser
 */


const ESCAPE: { [key: string]: string } = {
  'n': '\n',
  'f': '\f',
  'r': '\r',
  't': '\t',
  'v': '\v',
};

const CONSTANTS: { [key: string]: (data: any) => any } = {
  'null': (_: any) => null,
  'true': (_: any) => true,
  'false': (_: any) => false,
  'undefined': (_: any) => undefined,
}

function CONTAINS(a: any, b: any) {
  if (typeof a == 'string' && typeof b == 'string') {
    return a.indexOf(b) != -1
  } else if (Array.isArray(a)) {
    return a.indexOf(b) != -1
  } else if (typeof a == 'object') {
    return Object.keys(a).indexOf(b) != -1
  }
  return false
}

const OPERATORS: { [key: string]: (data: any, a: Function, b?: Function) => any } = {
  '+': (data, a, b) => a(data) + (b ? b(data) : 0),
  '-': (data, a, b) => a(data) - (b ? b(data) : 0),
  '*': (data, a, b) => a(data) * (b ? b(data) : 1),
  '/': (data, a, b) => a(data) / (b ? b(data) : 1),
  '%': (data, a, b) => a(data) % (b ? b(data) : 1),
  '===': (data, a, b) => a(data) === b(data),
  '!==': (data, a, b) => a(data) !== b(data),
  '==': (data, a, b) => a(data) == b(data),
  '!=': (data, a, b) => a(data) != b(data),
  '<': (data, a, b) => a(data) < b(data),
  '>': (data, a, b) => a(data) > b(data),
  '<=': (data, a, b) => a(data) <= b(data),
  '>=': (data, a, b) => a(data) >= b(data),
  '&&': (data, a, b) => a(data) && b(data),
  'AND': (data, a, b) => a(data) && b(data),
  '||': (data, a, b) => a(data) || b(data),
  'OR': (data, a, b) => a(data) || b(data),
  'CNS': (data, a, b) => CONTAINS(a(data), b(data)), // 对应 CONTAINS
  '!': (data, a) =>!a(data),
};

function isNumber(char: string): boolean {
  return char >= '0' && char <= '9' && typeof char === 'string';
}

function isExpOperator(char: string): boolean {
  return (char === '-' || char === '+' || isNumber(char));
}

function isIdent(char: string): boolean {
  return char >= 'a' && char <= 'z' ||
    char >= 'A' && char <= 'Z' ||
    char.charCodeAt(0) >= 0x4E00 && char.charCodeAt(0) <= 0x9FA5 ||
    char === '_' ||
    char === '$';
}

type Token = TokenInterface | undefined

interface TokenInterface {
  index?: number
  constant?: boolean
  text?: string
  value?: string | number
  identifier?: boolean
  operator?: boolean
}

class Expression {
  content: string;
  tokens: Array<TokenInterface> = [];

  constructor(content: string) {
    if (!content) {
      throw new Error('invalid expression');
    }
    this.content = content;
  }

  lex(): Array<TokenInterface> {
    let content = this.content;
    let length = content.length;
    let index = 0;
    let tokens: Array<TokenInterface> = [];

    while (index < length) {
      let char = content.charAt(index);

      if (char === '"' || char === '\'') {
        // 字符串
        let start = ++index;
        let escape = false;
        let value = '';
        let token: Token;

        while (index < length) {
          let c = content.charAt(index);

          if (escape) {
            if (c === 'u') {
              let hex = content.substring(index + 1, index + 5);
              if (!hex.match(/[\da-f]{4}/i)) {
                throw new Error(`invalid expression: ${content}, invalid unicode escape [\\u${hex}]`);
              }
              index += 4;
              value += String.fromCharCode(parseInt(hex, 16));
            } else {
              let rep = ESCAPE[c];
              value = value + (rep || c);
            }
            escape = false;
          } else if (c === '\\') {
            escape = true;
          } else if (c === char) {
            index++;
            token = {
              index: start,
              constant: true,
              text: char + value + char,
              value,
            };
            break;
          } else {
            value += c;
          }

          index++;
        }

        if (!token) {
          throw new Error(`invalid expression: ${content}`);
        } else {
          tokens.push(token);
        }
      } else if (isNumber(char) || (char === '.' && isNumber(content.charAt(index + 1)))) {
        // 数字
        let start = index;
        let value = '';

        while (index < length) {
          let c = content.charAt(index).toLowerCase();
          if (c === '.' || isNumber(c)) {
            value += c;
          } else {
            let c2 = content.charAt(index + 1);
            if (c === 'e' && isExpOperator(c2)) {
              value += c;
            } else if (isExpOperator(c) && c2 && isNumber(c2) && value.charAt(value.length - 1) === 'e') {
              value += c;
            } else if (isExpOperator(c) && (!c2 || !isNumber(c2)) && value.charAt(value.length - 1) == 'e') {
              throw new Error(`invalid expression: ${content}`);
            } else {
              break;
            }
          }
          index++;
        }

        tokens.push({
          index: start,
          constant: true,
          text: value,
          value: Number(value),
        })
      } else if (isIdent(char)) {
        // 标识符
        let start = index;
        while (index < length) {
          let c = content.charAt(index);
          if (!(isIdent(c) || isNumber(c))) {
            break;
          }
          index++;
        }

        tokens.push({
          index: start,
          text: content.slice(start, index),
          identifier: true
        });
      } else if ('(){}[].,;:?'.indexOf(char) >= 0) {
        // 边界
        tokens.push({
          index,
          text: char
        });

        index++;
      } else if (char === ' ' || char === '\r' || char === '\t' || char === '\n' || char === '\v' ||
        char === '\u00A0') {
        // 空格
        index++;
      } else {
        // 操作符
        let char2 = char + content.charAt(index + 1);
        let char3 = char2 + content.charAt(index + 2);
        let op1 = OPERATORS[char];
        let op2 = OPERATORS[char2];
        let op3 = OPERATORS[char3];
        if (op1 || op2 || op3) {
          let text = op3 ? char3 : op2 ? char2 : char;

          tokens.push({
            index: index,
            text,
            operator: true
          });

          index += text.length;
        } else {
          throw new Error(`invalid expression: ${content}`);
        }
      }
    }

    this.tokens = tokens;
    return tokens;
  }

  parse(): (data: any) => any {
    let tokens = this.lex();

    let func: Function | undefined;
    let token = tokens[0];
    let text = token.text;

    if (tokens.length > 0 && text !== '}' && text !== ')' && text !== ']') {
      func = this.expression();
    }

    return (data: any) => func && func(data);
  }

  expect(text?: string): any {
    let tokens = this.tokens;
    let token = tokens[0];

    if (!text || text === (token && token.text)) {
      return tokens.shift();
    }
  }

  consume(text?: string): any {
    if (!this.tokens.length) {
      throw new Error(`parse expression error: ${this.content}`);
    }

    let token = this.expect(text);
    if (!token) {
      throw new Error(`parse expression error: ${this.content}`);
    }

    return token;
  }

  expression(): Function {
    return this.ternary();
  }

  ternary(): Function {
    let left = this.logicalCONTAINS();
    let token: Token = this.expect('?');
    if (token) {
      let middle = this.expression();
      this.consume(':')
      let right = this.expression();
      return (data: any) => left(data) ? middle(data) : right(data);
    }
    return left;
  }

  binary(left: Function, op: string, right: Function): Function {
    let fn = OPERATORS[op];
    return (data: any) => fn(data, left, right);
  }

  unary(): Function {
    let token: Token;

    if (this.expect('+')) {
      return this.primary();
    } else if (token = this.expect('-')) {
      return this.binary((_: any) => 0, token.text, this.unary());
    } else if (token = this.expect('!')) {
      let fn = OPERATORS[token.text];
      let right = this.unary();
      return (data: any) => fn(data, right);
    } else {
      return this.primary();
    }
  }

  logicalCONTAINS(): Function {
    let left = this.logicalOR();
    let token: Token;
    while (token = this.expect('CNS')) {
      left = this.binary(left, token.text, this.logicalOR());
    }
    return left;
  }

  logicalOR(): Function {
    let left = this.logicalAND();
    let token: Token;
    while (token = this.expect('||') || this.expect('OR')) {
      left = this.binary(left, token.text, this.logicalAND());
    }
    return left;
  }

  logicalAND(): Function {
    let left = this.equality();
    let token: Token;
    while (token = this.expect('&&') || this.expect('AND')) {
      left = this.binary(left, token.text, this.equality());
    }
    return left;
  }

  equality(): Function {
    let left = this.relational();
    let token: Token;
    while (token = this.expect('===') || this.expect('!==') || this.expect('==') || this.expect('!=')) {
      left = this.binary(left, token.text, this.relational());
    }
    return left;
  }

  relational(): Function {
    let left = this.additive();
    let token: Token;
    while (token = this.expect('<') || this.expect('>') || this.expect('<=') || this.expect('>=')) {
      left = this.binary(left, token.text, this.additive());
    }
    return left;
  }

  additive(): Function {
    let left = this.multiplicative();
    let token: Token;
    while (token = this.expect('+') || this.expect('-')) {
      left = this.binary(left, token.text, this.multiplicative());
    }
    return left;
  }

  multiplicative(): Function {
    let left = this.unary();
    let token: Token;
    while (token = this.expect('*') || this.expect('/') || this.expect('%')) {
      left = this.binary(left, token.text, this.unary());
    }
    return left;
  }

  primary(): Function {
    let token = this.tokens[0];
    let primary: Function;

    if (this.expect('(')) {
      primary = this.expression();
      this.consume(')');
    } else if (this.expect('[')) {
      primary = this.array();
    } else if (this.expect('{')) {
      primary = this.object();
    } else if (token.identifier && token.text in CONSTANTS) {
      primary = CONSTANTS[this.consume().text];
    } else if (token.identifier) {
      primary = this.identifier();
    } else if (token.constant) {
      primary = this.constant();
    } else {
      throw new Error(`parse expression error: ${this.content}`);
    }

    let next: any | undefined;
    let context: Function | undefined;
    while (next = this.expect('(') || this.expect('[') || this.expect('.')) {
      if (next.text === '(') {
        primary = this.functionCall(primary, context);
        context = undefined;
      } else if (next.text === '[') {
        context = primary;
        primary = this.objectIndex(primary);
      } else {
        context = primary;
        primary = this.fieldAccess(primary);
      }
    }
    return primary;
  }

  fieldAccess(object: Function): Function {
    let getter = this.identifier();
    return (data: any) => {
      let o = object(data);
      return o && getter(o);
    };
  }

  objectIndex(object: Function): Function {
    let indexFn = this.expression();
    this.consume(']');
    return (data: any) => {
      let o = object(data);
      let key = indexFn(data) + '';
      return o && o[key];
    };
  }

  functionCall(func: Function, context: Function | undefined): Function {
    let args: Function[] = [];
    if (this.tokens[0].text !== ')') {
      do {
        args.push(this.expression());
      } while (this.expect(','));
    }
    this.consume(')');

    return (data: any) => {
      let callContext = context && context(data);
      let fn = func(data, callContext);

      return fn && fn.apply(callContext, args.length ? args.map(arg => arg(data)) : null);
    };
  }

  array(): Function {
    let elements: Function[] = [];
    let token = this.tokens[0];
    if (token.text !== ']') {
      do {
        if (this.tokens[0].text === ']') {
          break;
        }
        elements.push(this.expression());
      } while (this.expect(','));
    }
    this.consume(']');
    return (data: any) => elements.map(element => element(data));
  }

  object(): Function {
    let keys: (string | number)[] = [];
    let values: Function[] = [];
    let token = this.tokens[0];
    if (token.text !== '}') {
      do {
        token = this.tokens[0];
        if (token.text === '}') {
          break;
        }
        token = this.consume();
        if (token.constant) {
          keys.push(token.value);
        } else if (token.identifier) {
          keys.push(token.text);
        } else {
          throw new Error(`parse expression error: ${this.content}`);
        }
        this.consume(':');
        values.push(this.expression());
      } while (this.expect(','));
    }

    this.consume('}');

    return (data: any) => {
      let object: { [key: string]: any } = {};
      for (let i = 0, length = values.length; i < length; i++) {
        object[keys[i]] = values[i](data);
      }
      return object;
    };
  }

  identifier(): Function {
    let id = this.consume().text;

    let token = this.tokens[0];
    let token2 = this.tokens[1];
    let token3 = this.tokens[2];

    // 连续读取 . 操作符后的非函数调用标识符
    while (token && token.text === '.' && token2 && token2.identifier && token3 && token3.text !== '(') {
      id += this.consume().text + this.consume().text;
      token = this.tokens[0];
      token2 = this.tokens[1];
      token3 = this.tokens[2];
    }

    return (data: any) => {
      let elements = id.split('.');
      let length: number = elements.length
      let key: string | undefined;

      for (let i = 0; elements.length > 1; i++) {
        key = elements.shift();
        data = data[key];

        if (!data) {
          break;
        }
      }

      key = elements.shift();
      if (key && length == 1 && key.startsWith('$')) {
        key = key.replace('$', '')
        if (data && data['args']) {
          return data['args'][key]
        }
      } else if (length == 1) {
        if (data && Object.keys(data).indexOf(key) != -1) {
          return data[key]
        }
        return key
      }
      return data && data[key];
    };
  }

  constant(): Function {
    let value = this.consume().value;
    return (_: any) => value;
  }
}

export { Expression }