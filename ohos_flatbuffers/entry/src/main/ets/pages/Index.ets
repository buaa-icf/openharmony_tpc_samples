import * as flatbuffers from 'flatbuffers';
import { Person } from '../common/example/person';

interface Personl {
  id: number;
  name: string;
  age: number;
}

const data: Personl = {
  id: 1,
  name: 'John',
  age: 20
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  serializedData: Uint8Array | undefined;

  build() {
    Column() {
      Text('序列化')
        .fontSize(24)
        .onClick(() => {
          const builder = new flatbuffers.Builder();
          const nameBuilder = builder.createString(data.name);

          Person.startPerson(builder);
          Person.addId(builder, data.id);
          Person.addName(builder, nameBuilder);
          Person.addAge(builder, data.age);

          const personOffset = Person.endPerson(builder);
          builder.finish(personOffset);
          this.serializedData = builder.asUint8Array();
          console.log('serializedData:' + this.serializedData);
        })

      Text('反序列化')
        .fontSize(24)
        .onClick(() => {
          if (this.serializedData) {
            const buffer = new flatbuffers.ByteBuffer(this.serializedData);
            const person: Person = Person.getRootAsPerson(buffer);

            console.log('data: id:' + person.id());
            console.log('data: name:' + person.name());
            console.log('data: age:' + person.age());
          } else {
            console.log('serializedData is undefined.');
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}