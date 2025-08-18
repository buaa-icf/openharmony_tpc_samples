import { LogUtil } from './logUtil';
import { BigInteger } from './BigInteger';
import { Constructed, Primitive } from './encodings';

const TAG = 'asn1Demo-types';

export class Type { }

const TypeClassFactory = (tagClass, type, validEncodings, defaultValue, defaultContent, contentProcessor) => class extends Type {
  constructor(content, { encoding = validEncodings[0], value = null } = {}) {
    super();
    this.encoding = encoding;
    if (value != null) this._value = value;
    if (content != null || defaultContent != null) this.content = content != null ? content : defaultContent;
    if (contentProcessor && this.content != null) this.content = contentProcessor(this.content);
  }
  get tagClass() {
    return tagClass;
  }
  get type() {
    return type || this._value;
  }
  get value() {
    return this._value || defaultValue;
  }
};

const TagClassFactory = (type, defaultValue) => class {
  //
  constructor(value, content, encoding, { validEncodings = [Constructed] } = {}) {
    const NewType = class extends TypeClassFactory(this.constructor, null, validEncodings) { };
    return new NewType(content, { encoding, value });
  }
  static get type() {
    return type;
  }
  static get value() {
    return defaultValue;
  }
};

class Universal extends TagClassFactory('universal', 0x00) {}
class Application extends TagClassFactory('application', 0x40) {}
class ContextSpecific extends TagClassFactory('contextSpecific', 0x80) {}
class Private extends TagClassFactory('private', 0xC0) {}

function importInteger(content) {
  const contentType = typeof content;
  if (contentType === 'number') {
    LogUtil.info(`Importing integer from number: ${content}`);
    return content;
  }
  if (contentType === 'string') {
    // big integer import
    const radix = content.startsWith('0x') ? 16 : 10;
    const intStr = radix === 16 ? content.slice(2) : content;
    LogUtil.debug(`Importing big integer from string: ${content} with radix:${radix}`);
    return BigInteger.fromString(intStr, radix);
      // return '';

  }
  if (contentType === 'object') {
    if (content.constructor.name === 'BigInteger') {
        LogUtil.info(`Importing integer from BigInteger object`);
        return content;
    }
    LogUtil.error('integer objects must be instance of BigInteger');
    throw new Error('integer objects must be instance of BigInteger');
  }
  LogUtil.error(`cannot import an integer from "${contentType}"`);
  throw new Error(`cannot import an integer from "${contentType}"`);
}


Universal.EOC = class EOC extends TypeClassFactory(Universal, 'endOfContent', [Primitive], 0) { };
Universal.Bool = class Bool extends TypeClassFactory(Universal, 'boolean', [Primitive], 1) { };
Universal.Integer = class Integer extends TypeClassFactory(Universal, 'integer', [Primitive], 2, null, importInteger) { };
Universal.BitString = class BitString extends TypeClassFactory(Universal, 'bitString', [Primitive, Constructed], 3) { };
Universal.OctetString = class OctetString extends TypeClassFactory(Universal, 'octetString', [Primitive, Constructed], 4) { };
Universal.Null = class Null extends TypeClassFactory(Universal, 'null', [Primitive], 5) { };
Universal.OID = class OID extends TypeClassFactory(Universal, 'oid', [Primitive], 6) { };
Universal.ODesc = class ODesc extends TypeClassFactory(Universal, 'odesc', [Primitive, Constructed], 7) { };
Universal.External = class External extends TypeClassFactory(Universal, 'external', [Constructed], 8) { };
Universal.Real = class Real extends TypeClassFactory(Universal, 'float', [Primitive], 9) { };
Universal.Enumerated = class Enumerated extends TypeClassFactory(Universal, 'enumerated', [Primitive], 10) { };
Universal.EnumeratedPDV = class EnumeratedPDV extends TypeClassFactory(Universal, 'embeddedPDV', [Constructed], 11) { };
Universal.UTF8String = class UTF8String extends TypeClassFactory(Universal, 'utf8String', [Primitive, Constructed], 12) { };
Universal.ROID = class ROID extends TypeClassFactory(Universal, 'roid', [Primitive], 13) { };
Universal.Sequence = class Sequence extends TypeClassFactory(Universal, 'sequence', [Constructed], 16, []) { };
Universal.Set = class Set extends TypeClassFactory(Universal, 'set', [Constructed], 17, []) { };
Universal.NumericString = class NumericString extends TypeClassFactory(Universal, 'numericString', [Primitive, Constructed], 18) { };
Universal.PrintableString = class PrintableString extends TypeClassFactory(Universal, 'printableString', [Primitive, Constructed], 19) { };
Universal.T61String = class T61String extends TypeClassFactory(Universal, 't61String', [Primitive, Constructed], 20) { };
Universal.VideoetxString = class VideoetxString extends TypeClassFactory(Universal, 'videotexString', [Primitive, Constructed], 21) { };
Universal.IA5String = class IA5String extends TypeClassFactory(Universal, 'ia5String', [Primitive, Constructed], 22) { };
Universal.UTCTime = class UTCTime extends TypeClassFactory(Universal, 'utcTime', [Primitive, Constructed], 23) { };
Universal.GeneralizedTime = class GeneralizedTime extends TypeClassFactory(Universal, 'generalizedTime', [Primitive, Constructed], 24) { };
Universal.GraphicString = class GraphicString extends TypeClassFactory(Universal, 'graphicString', [Primitive, Constructed], 25) { };
Universal.VisibleString = class VisibleString extends TypeClassFactory(Universal, 'visibleString', [Primitive, Constructed], 26) { };
Universal.GeneralString = class GeneralString extends TypeClassFactory(Universal, 'generalString', [Primitive, Constructed], 27) { };
Universal.UniversalString = class UniversalString extends TypeClassFactory(Universal, 'universalString', [Primitive, Constructed], 28) { };
Universal.CharString = class CharString extends TypeClassFactory(Universal, 'characterString', [Primitive, Constructed], 29) { };
Universal.BMPString = class BMPString extends TypeClassFactory(Universal, 'bmpString', [Primitive, Constructed], 30) { };

const Types = Object.keys(Universal).map(key => Universal[key].constructor ? Universal[key] : null).filter(Boolean);

export { Universal, Application, ContextSpecific, Private };

const TagClasses = [Universal, Application, ContextSpecific, Private];

export function findTagClass(value) {
  const valueType = typeof value;
  switch (valueType) {
    case 'string':
        LogUtil.debug(`Looking up tag class by string: ${value}`);
        return TagClasses.find(tagClass => tagClass.type === value);
    case 'number':
        LogUtil.debug(`Looking up tag class by number: ${value}`);
        return TagClasses.find(tagClass => tagClass.value === value);
    default:
      LogUtil.error(`Must use string or number to lookup tag class, not "${valueType}"`);
      throw new Error(`Must use string or number to lookup tag class, not "${valueType}"`);
  }
}

export function findType(value) {
  const valueType = typeof value;
  switch (valueType) {
    case 'string':
        LogUtil.debug(`Looking up type by string: ${value}`);
        return Types.find(AType => new AType().type === value);
    case 'number':
        LogUtil.debug(`Looking up type by number: ${value}`);
        return Types.find(AType => new AType().value === value);
    default:
      LogUtil.error(`Must use string or number to lookup type, not "${valueType}"`);
      throw new Error(`Must use string or number to lookup type, not "${valueType}"`);
  }
}
