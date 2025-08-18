export class Deserializer {
  constructor() {
    return this.deserialize.bind(this);
  }

  deserialize(object) {
    return this.deserializationImpl(object);
  }
}
