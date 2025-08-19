declare module "@ohos/asn1" {
  interface Serialized {
    tagClass: string
    type: string
    encoding: string
    content: string
  }

  interface JSONSerializer {
    <T>(data: T): any;
  }

  class Serializer {
    serialize(aom: any, params: any): any
  }

  class JSONSerializer extends Serializer {
    serializationImpl(aom: any): Serialized
  }


  interface JSONDeserializer {
    <T>(data: T): any;
  }

  class Deserializer {
    deserialize(aom: any, params: any): any
  }

  class JSONDeserializer extends Deserializer {
    deserializationImpl(json: any, root: boolean): any
  }

  // namespace Universal
  export namespace Universal {
    const TagClass: {
      new(value: any, content: any, encoding: any, { validEncodings }?: {
        validEncodings?: (typeof TagClass)[];
      }): {};
      readonly type: any;
      readonly value: any;
    };

    export class Universal extends TagClass {
    }

    export class Application extends TagClass {
    }

    export class ContextSpecific extends TagClass {
    }

    export class Private extends TagClass {
    }

    const Base: {
      new(content: any, { encoding, value }?: {
        encoding?: any;
        value?: any;
      }): {
        encoding: any;
        _value: any;
        content: any;
        readonly tagClass: any;
        readonly type: any;
        readonly value: any;
      };
    };

    abstract class UniversalType {
      // abstract value: unknown;
    }

    export class EOC extends UniversalType {
    }

    export class Bool extends UniversalType {
      constructor(value: boolean);
    }

    class Integer extends UniversalType {
      value: number | bigint;

      constructor(value: number | bigint | string);
    }

    export class BitString extends UniversalType {
    }

    export class OctetString extends UniversalType {
    }

    export class Null extends UniversalType {
      value: number | bigint;

      constructor();
    }

    export class OID extends UniversalType {
    }

    export class ODesc extends UniversalType {
    }

    export class External extends UniversalType {
    }

    export class Real extends UniversalType {
    }

    export class Enumerated extends UniversalType {
    }

    export class EnumeratedPDV extends UniversalType {
    }

    export class UTF8String extends UniversalType {
    }

    export class ROID extends UniversalType {
    }

    export class Sequence extends UniversalType {
      value: any[];

      toString(): string

      constructor(value: any)
    }

    export class Set extends UniversalType {
    }

    export class NumericString extends UniversalType {
    }

    export class PrintableString extends UniversalType {
      constructor(value: string)
    }

    export class T61String extends UniversalType {
    }

    export class VideoetxString extends UniversalType {
    }

    export class IA5String extends UniversalType {
    }

    export class UTCTime extends UniversalType {
    }

    export class GeneralizedTime extends UniversalType {
    }

    export class GraphicString extends UniversalType {
    }

    export class VisibleString extends UniversalType {
    }

    export class GeneralString extends UniversalType {
    }

    export class UniversalString extends UniversalType {
    }

    export class CharString extends UniversalType {
    }

    export class BMPString extends UniversalType {
    }
  }

}








