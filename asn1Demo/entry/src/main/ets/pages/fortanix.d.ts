declare module '@fortanix/asn1js' {
  class Base {
    static blockName: string;

    toDER(sizeOnly?: boolean): ArrayBuffer;

    toJSON(): Error;

    toBER(): ArrayBuffer;

    fromBER(inputBuffer?: ArrayBuffer, inputOffset?: number, inputLength?: number): any;

    fromDER(inputBuffer?: ArrayBuffer, inputOffset?: number, inputLength?: number, expectedLength?: number): any;
  }

  interface Params {
    name?: string | number,
    value?: string | number | boolean | Array<ESObject>,
    valueHex?: Uint8Array,
    optional?: boolean,
  }

  export class Boolean extends Base {
    constructor(params: Params);
  }

  export class BmpString extends Base {
    constructor(params: Params);

    fromBuffer(inputBuffer: ArrayBuffer);

    fromString(inputString: string);
  }

  export class BitString extends Base {
    constructor(params: Params);

    isEqual(bitString: BitString): boolean;
  }

  export class Integer extends Base {
    constructor(params: Params);

    isEqual(integer: Integer): boolean;

    covertToDer(): number;

    covertFromDER(): number;
  }

  export class CharacterString extends Base {
    constructor(params: Params);
  }

  export class UniversalString extends Base {
    constructor(params: Params);

    fromBuffer(inputBuffer: ArrayBuffer);

    fromString(inputString: string);
  }

  export class Utf8String extends Base {
    constructor(params: Params);

    fromBuffer(inputBuffer: ArrayBuffer);

    fromString(inputString: string);
  }

  export class DATE extends Base {
    constructor(params: Params);
  }

  export class DateTime extends Base {
    constructor(params: Params);
  }

  export class Duration extends Base {
    constructor(params: Params);
  }

  export class GeneralString extends Base {
    constructor(params: Params);
  }

  export class GraphicString extends Base {
    constructor(params: Params);
  }

  export class NumericString extends Base {
    constructor(params: Params);
  }

  export class ObjectIdentifier extends Base {
    constructor(params: Params);
  }

  export class OctetString extends Base {
    constructor(params: Params);

    isEqual(octetString: OctetString): boolean;
  }

  export class Null extends Base {
    constructor(params?: Params);
  }

  export class Sequence extends Base {
    constructor(params: Params);
  }

  export function fromBER(inputBuffer?: ArrayBuffer, inputOffset?: number, inputLength?: number): any;

  export function fromDER(inputBuffer?: ArrayBuffer, inputOffset?: number, inputLength?: number,
    expectedLength?: number): any;
}