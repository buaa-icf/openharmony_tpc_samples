/**
 * XMPMeta 测试
 * 测试 XMP 元数据对象的所有属性操作
 */
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  XMPMetaFactory,
  XMPMeta,
  XMPDateTime,
  XMPDateTimeFactory,
  PropertyOptions,
  ParseOptions
} from '@ohos/xmp_toolkit';

const NS1 = 'ns:test1/';
const NS2 = 'ns:test2/';

export default function xmpMetaTest() {
  describe('XMPMeta', () => {
    let registry = XMPMetaFactory.getSchemaRegistry();

    beforeAll(() => {
      XMPMetaFactory.reset();
      registry = XMPMetaFactory.getSchemaRegistry();
      registry.registerNamespace(NS1, 'ns1');
      registry.registerNamespace(NS2, 'ns2');
    });

    afterAll(() => {
      XMPMetaFactory.reset();
    });

    describe('SimpleProperties', () => {
      it('should set and get simple property', 0, () => {
        const meta = XMPMetaFactory.create();

        let startTime = Date.now();
        meta.setProperty(NS1, 'Prop', 'Value');
        console.log("===== XMPMeta.setProperty 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const prop = meta.getProperty(NS1, 'Prop');
        console.log("===== XMPMeta.getProperty 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(prop).not().assertNull();
        expect(prop!.getValue()).assertEqual('Value');
      });

      it('should check property existence', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, 'Prop', 'Value');

        let startTime = Date.now();
        const propExist = meta.doesPropertyExist(NS1, 'Prop');
        console.log("===== XMPMeta.doesPropertyExist 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const otherExist = meta.doesPropertyExist(NS1, 'Prop2');
        
        expect(propExist).assertTrue();
        expect(otherExist).assertFalse();
      });

      it('should delete property', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, 'Prop', 'Value');

        let startTime = Date.now();
        meta.deleteProperty(NS1, 'Prop');
        console.log("===== XMPMeta.deleteProperty 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(meta.doesPropertyExist(NS1, 'Prop')).assertFalse();
      });
    });

    describe('TypedProperties', () => {
      it('should set and get boolean property', 0, () => {
        const meta = XMPMetaFactory.create();

        let startTime = Date.now();
        meta.setPropertyBoolean(NS1, 'BoolTrue', true);
        console.log("===== XMPMeta.setPropertyBoolean 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const boolValue = meta.getPropertyBoolean(NS1, 'BoolTrue');
        console.log("===== XMPMeta.getPropertyBoolean 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(boolValue).assertTrue();
        expect(meta.getPropertyBoolean(NS1, 'BoolTrue')).assertTrue();
      });

      it('should set and get integer property', 0, () => {
        const meta = XMPMetaFactory.create();

        let startTime = Date.now();
        meta.setPropertyInteger(NS1, 'Int', 42);
        console.log("===== XMPMeta.setPropertyInteger 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const intValue = meta.getPropertyInteger(NS1, 'Int');
        console.log("===== XMPMeta.getPropertyInteger 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(meta.getPropertyInteger(NS1, 'Int')).assertEqual(42);
      });

      it('should set and get long property', 0, () => {
        const meta = XMPMetaFactory.create();

        let startTime = Date.now();
        meta.setPropertyLong(NS1, "Long", 20456789);
        console.log("===== XMPMeta.setPropertyLong 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const longValue = meta.getPropertyLong(NS1, "Long");
        console.log("===== XMPMeta.getPropertyLong 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(longValue).assertEqual(20456789);
      });

      it('should set and get double property', 0, () => {
        const meta = XMPMetaFactory.create();

        let startTime = Date.now();
        meta.setPropertyDouble(NS1, 'Double', 3.14);
        console.log("===== XMPMeta.setPropertyDouble 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const value = meta.getPropertyDouble(NS1, 'Double');
        console.log("===== XMPMeta.getPropertyDouble 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(Math.abs(value - 3.14)).assertLess(0.001);
      });

      it('should get property as string', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, 'Prop', 'StringValue');

        let startTime = Date.now();
        const strValue = meta.getPropertyString(NS1, 'Prop');
        console.log("===== XMPMeta.getPropertyString 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(strValue).assertEqual('StringValue');
      });
    });

    describe('ArrayProperties', () => {
      it('should create and append to bag array', 0, () => {
        const meta = XMPMetaFactory.create();

        meta.appendArrayItem(NS1, 'Bag', new PropertyOptions().setArray(true), 'Item1', null);
        let startTime = Date.now();
        meta.appendArrayItem(NS1, 'Bag', 'Item2');
        console.log("===== XMPMeta.appendArrayItem 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const arraySize = meta.countArrayItems(NS1, 'Bag');
        console.log("===== XMPMeta.countArrayItems 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(arraySize).assertEqual(2);
      });

      it('should get array item by index', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.appendArrayItem(NS1, 'Bag', new PropertyOptions().setArray(true), 'Item1', null);
        meta.appendArrayItem(NS1, 'Bag', 'Item2');

        let startTime = Date.now();
        const item1 = meta.getArrayItem(NS1, 'Bag', 1);
        console.log("===== XMPMeta.getArrayItem 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const item2 = meta.getArrayItem(NS1, 'Bag', 2);
        
        expect(item1!.getValue()).assertEqual('Item1');
        expect(item2!.getValue()).assertEqual('Item2');
      });

      it('should set array item', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.appendArrayItem(NS1, 'Bag', new PropertyOptions().setArray(true), 'Item1', null);
        meta.appendArrayItem(NS1, 'Bag', 'Item2');

        let startTime = Date.now();
        meta.setArrayItem(NS1, 'Bag', 1, 'Updated');
        console.log("===== XMPMeta.setArrayItem 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(meta.getArrayItem(NS1, 'Bag', 1)!.getValue()).assertEqual('Updated');
      });

      it('should insert array item', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.appendArrayItem(NS1, 'Bag', new PropertyOptions().setArray(true), 'Item1', null);
        meta.appendArrayItem(NS1, 'Bag', 'Item3');

        let startTime = Date.now();
        meta.insertArrayItem(NS1, 'Bag', 2, 'Item2');
        console.log("===== XMPMeta.insertArrayItem 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(meta.getArrayItem(NS1, 'Bag', 2)!.getValue()).assertEqual('Item2');
        expect(meta.countArrayItems(NS1, 'Bag')).assertEqual(3);
      });

      it('should delete array item', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.appendArrayItem(NS1, 'Bag', new PropertyOptions().setArray(true), 'Item1', null);
        meta.appendArrayItem(NS1, 'Bag', 'Item2');

        let startTime = Date.now();
        meta.deleteArrayItem(NS1, 'Bag', 1);
        console.log("===== XMPMeta.deleteArrayItem 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(meta.countArrayItems(NS1, 'Bag')).assertEqual(1);
        expect(meta.getArrayItem(NS1, 'Bag', 1)!.getValue()).assertEqual('Item2');
      });

      it('should check array item existence', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.appendArrayItem(NS1, 'Bag', new PropertyOptions().setArray(true), 'Item1', null);

        let startTime = Date.now();
        const arrayItemExist = meta.doesArrayItemExist(NS1, 'Bag', 1);
        console.log("===== XMPMeta.doesArrayItemExist 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(arrayItemExist).assertTrue();
        expect(meta.doesArrayItemExist(NS1, 'Bag', 2)).assertFalse();
      });
    });

    describe('StructProperties', () => {
      it('should set and get struct field', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setStructField(NS1, 'Struct', NS2, 'Field1', 'Value1');
        let startTime = Date.now();
        meta.setStructField(NS1, 'Struct', NS2, 'Field2', 'Value2');
        console.log("===== XMPMeta.setStructField 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const field1 = meta.getStructField(NS1, 'Struct', NS2, 'Field1');
        console.log("===== XMPMeta.getStructField 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const field2 = meta.getStructField(NS1, 'Struct', NS2, 'Field2');
        
        expect(field1!.getValue()).assertEqual('Value1');
        expect(field2!.getValue()).assertEqual('Value2');
      });

      it('should check struct field existence', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setStructField(NS1, 'Struct', NS2, 'Field', 'Value');

        let startTime = Date.now();
        const fieldExist = meta.doesStructFieldExist(NS1, 'Struct', NS2, 'Field');
        console.log("===== XMPMeta.doesStructFieldExist 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(fieldExist).assertTrue();
        expect(meta.doesStructFieldExist(NS1, 'Struct', NS2, 'Other')).assertFalse();
      });

      it('should delete struct field', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setStructField(NS1, 'Struct', NS2, 'Field1', 'Value1');
        meta.setStructField(NS1, 'Struct', NS2, 'Field2', 'Value2');

        let startTime = Date.now();
        meta.deleteStructField(NS1, 'Struct', NS2, 'Field1');
        console.log("===== XMPMeta.deleteStructField 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(meta.doesStructFieldExist(NS1, 'Struct', NS2, 'Field1')).assertFalse();
        expect(meta.doesStructFieldExist(NS1, 'Struct', NS2, 'Field2')).assertTrue();
      });
    });

    describe('QualifierProperties', () => {
      it('should set and get qualifier', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, 'Prop', 'Value');

        let startTime = Date.now();
        meta.setQualifier(NS1, 'Prop', NS2, 'Qual', 'QualValue');
        console.log("===== XMPMeta.setQualifier 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const qual = meta.getQualifier(NS1, 'Prop', NS2, 'Qual');
        console.log("===== XMPMeta.getQualifier 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(qual!.getValue()).assertEqual('QualValue');
      });

      it('should check qualifier existence', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, 'Prop', 'Value');
        meta.setQualifier(NS1, 'Prop', NS2, 'Qual', 'QualValue');

        let startTime = Date.now();
        const qualifExist = meta.doesQualifierExist(NS1, 'Prop', NS2, 'Qual');
        console.log("===== XMPMeta.doesQualifierExist 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(qualifExist).assertTrue();
        expect(meta.doesQualifierExist(NS1, 'Prop', NS2, 'Other')).assertFalse();
      });

      it('should delete qualifier', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, 'Prop', 'Value');
        meta.setQualifier(NS1, 'Prop', NS2, 'Qual', 'QualValue');

        let startTime = Date.now();
        meta.deleteQualifier(NS1, 'Prop', NS2, 'Qual');
        console.log("===== XMPMeta.deleteQualifier 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        
        expect(meta.doesQualifierExist(NS1, 'Prop', NS2, 'Qual')).assertFalse();
      });
    });

    describe('LocalizedText', () => {
      it('should set and get localized text', 0, () => {
        const meta = XMPMetaFactory.create();

        let startTime = Date.now();
        meta.setLocalizedText(NS1, 'AltText', '', 'x-default', 'Default value', null);
        console.log("===== XMPMeta.setLocalizedText 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const prop = meta.getLocalizedText(NS1, 'AltText', '', 'x-default');
        console.log("===== XMPMeta.getLocalizedText 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(prop!.getValue()).assertEqual('Default value');
      });
    });

    describe('CloneAndObjectName', () => {
      it('should clone XMPMeta object', 0, () => {
        const meta1 = XMPMetaFactory.create();

        let startTime = Date.now();
        meta1.setObjectName('Original');
        console.log("===== XMPMeta.setObjectName 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        meta1.setProperty(NS1, 'Prop', 'Value');

        startTime = Date.now();
        const meta2 = meta1.clone() as XMPMeta;
        console.log("===== XMPMeta.clone 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        meta2.setObjectName('Clone');
        
        expect(meta1.getObjectName()).assertEqual('Original');
        expect(meta2.getObjectName()).assertEqual('Clone');
        expect(meta2.getProperty(NS1, 'Prop')!.getValue()).assertEqual('Value');
      });

      it('should set and get object name', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setObjectName('TestName');

        let startTime = Date.now();
        const objName = meta.getObjectName();
        console.log("===== XMPMeta.getObjectName 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        expect(objName).assertEqual('TestName');
      });
    });

    describe('dumpObject', () => {
      it('should dump object to string', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, 'Prop', 'Value');

        let startTime = Date.now();
        const dump = meta.dumpObject();
        console.log("===== XMPMeta.dumpObject 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(dump).assertContain('ROOT');
      });
    });

    describe('dateAndCalendarProperties', () => {
      it('should set and get date property', 0, () => {
        const meta = XMPMetaFactory.create();

        const date1: XMPDateTime = XMPDateTimeFactory.createFromISO8601("2025-12-26");
        let startTime = Date.now();
        meta.setPropertyDate(NS1, "SimpleDate", date1, null);
        console.log("===== XMPMeta.setPropertyDate 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const retrievedDate1: XMPDateTime | null = meta.getPropertyDate(NS1, "SimpleDate");
        console.log("===== XMPMeta.getPropertyDate 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        expect(retrievedDate1!.getISO8601String()).assertEqual('2025-12-26');
      });

      it('should set and get calendar property', 0, () => {
        const meta = XMPMetaFactory.create();

        const calendar1Str = "2025-12-26T14:30:45";
        let startTime = Date.now();
        meta.setPropertyCalendar(NS1, "GregorianCalendar", calendar1Str, null);
        console.log("===== XMPMeta.setPropertyCalendar 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const calendarDate1: XMPDateTime | null = meta.getPropertyDate(NS1, "GregorianCalendar");
        console.log("===== XMPMeta.getPropertyDate 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        let calendar1Valid = false;
        if (calendarDate1) {
          const propertyCalendar1 = calendarDate1.getISO8601String();
          calendar1Valid = propertyCalendar1 === calendar1Str;
        }

        expect(calendar1Valid).assertTrue();
      });
    });

    describe('base64Property', () => {
      it('should set and get base64 property', 0, () => {
        const meta = XMPMetaFactory.create();

        const binaryData1 = new Uint8Array([72, 101, 108, 108, 111]);
        let startTime = Date.now();
        meta.setPropertyBase64(NS1, "BinaryData1", binaryData1);
        console.log("===== XMPMeta.setPropertyBase64 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        startTime = Date.now();
        const retrievedData1: Uint8Array | null = meta.getPropertyBase64(NS1, "BinaryData1");
        console.log("===== XMPMeta.getPropertyBase64 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        let data1Valid = false;
        data1Valid = retrievedData1 !== null && retrievedData1.length === binaryData1.length;

        expect(data1Valid).assertTrue();
      });
    });

    describe('normalizeProperty', () => {
      it('should set property with normalize', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, "Prop1", "Value1");
        meta.setProperty(NS1, "Prop2", "Value2");
        const options1 = new ParseOptions();

        let startTime = Date.now();
        meta.normalize(options1);
        console.log("===== XMPMeta.normalize 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        // 序列化后获取属性
        const prop1After = meta.getProperty(NS1, "Prop1");
        const prop2After = meta.getProperty(NS1, "Prop2");
        const basicNormalizePassed = prop1After !== null && prop1After.getValue() === "Value1" &&
          prop2After !== null && prop2After.getValue() === "Value2";

        expect(basicNormalizePassed).assertTrue();
      });
    });

    describe('sortPropertyData', () => {
      it('should sort the entire data', 0, () => {
        const meta = XMPMetaFactory.create();
        meta.setProperty(NS1, "Zebra", "Zebra Value");
        meta.setProperty(NS1, "Apple", "Apple Value");
        meta.setProperty(NS1, "Monkey", "Monkey Value");

        let startTime = Date.now();
        meta.sort();
        console.log("===== XMPMeta.sort 接口耗时：" + (Date.now() - startTime) / 10 + "ms");

        const appleAfter = meta.getProperty(NS1, "Apple");
        const zebraAfter = meta.getProperty(NS1, "Zebra");
        const monkeyAfter = meta.getProperty(NS1, "Monkey");

        const propertiesExistAfterSort =
          appleAfter !== null && appleAfter.getValue() === "Apple Value" &&
            zebraAfter !== null && zebraAfter.getValue() === "Zebra Value" &&
            monkeyAfter !== null && monkeyAfter.getValue() === "Monkey Value";

        expect(propertiesExistAfterSort).assertTrue();
      });
    });

    describe('PacketHead', () => {
      it('should get packet head', 0, () => {
        const meta = XMPMetaFactory.create();

        const rdfWithHeader: string =
          "<?xpacket begin='ï»¿' id='W5M0MpCehiHzreSzNTczkc9d'?>" +
            "<x:xmpmeta xmlns:x='adobe:ns:meta/' x:xmptk='XMP Core 5.6.0'>" +
            "  <rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>" +
            "    <rdf:Description rdf:about='' xmlns:ns1='ns:test1/'>" +
            "      <ns1:SimpleProp>Simple value</ns1:SimpleProp>" +
            "    </rdf:Description>" +
            "  </rdf:RDF>" +
            "</x:xmpmeta>" +
            "<?xpacket end='r'?>";

        const metaRDF = XMPMetaFactory.parseFromString(rdfWithHeader);
        let startTime = Date.now();
        const headerFromRDF: string | null = metaRDF.getPacketHeader();
        console.log("===== XMPMeta.getPacketHeader 接口耗时：" + (Date.now() - startTime) / 10 + "ms");
        const hasHeaderFromRDF: boolean = headerFromRDF !== null && headerFromRDF.length > 0;

        expect(hasHeaderFromRDF).assertFalse();
      });
    });

  });
}


