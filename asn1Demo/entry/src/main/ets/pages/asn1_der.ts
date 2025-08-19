declare module "@ohos/asn1-der" {
  interface DERSerializer {
    <T>(data: T): any;
  }

  class DERSerializer {
  }

  interface DERDeserializer {
    <T>(data: T): any;
  }

  class DERDeserializer {
  }
}

