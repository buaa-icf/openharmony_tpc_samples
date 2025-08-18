import { LogUtil } from './logUtil';
import {
  Deserializer,
  findType,
  findTagClass,
  Primitive,
  findEncoding
} from '.';

const TAG = 'asn1Demo-deserializer-json';

function validateJSON(json, root = true) {
    if (json === null) {
        LogUtil.error('ASN.1 abstract JSON must not be null');
        throw new Error('ASN.1 abstract JSON must not be null');
    }
    if (json === undefined) {
        LogUtil.error('ASN.1 abstract JSON must not be undefined');
        throw new Error('ASN.1 abstract JSON must not be undefined');
    }
    if (typeof json !== 'object') {
        LogUtil.error('ASN.1 abstract JSON must be an object');
        throw new Error('ASN.1 abstract JSON must be an object');
    }
    if (!Array.isArray(json) && Object.keys(json).length < 1) {
        LogUtil.error('ASN.1 abstract JSON must not be empty object');
        throw new Error('ASN.1 abstract JSON must not be empty object');
    }
    if (root && Array.isArray(json) && json.length < 1) {
        LogUtil.error('ASN.1 abstract JSON root must not be empty array');
        throw new Error('ASN.1 abstract JSON root must not be empty array');
    }
  // TODO schema validation
}

export class JSONDeserializer extends Deserializer {
  deserializationImpl(json, root = true) {
    LogUtil.debug(`deserializationImpl called with json: ${JSON.stringify(json)}, root: ${root}`);
    validateJSON(json, root);
    if (Array.isArray(json)) {
        LogUtil.info('Processing array');
        return json.map(item => this.deserializationImpl(item, false));
    }
    const {
      tagClass: tagClassValue,
      encoding: encodingValue,
      type: typeValue,
      content: contentValue
    } = json;
    LogUtil.debug(`Extracted values: tagClassValue: ${tagClassValue}, encodingValue: ${encodingValue}, typeValue: ${typeValue}, contentValue: ${JSON.stringify(contentValue)}`);
    const tagClass = (0, findTagClass)(tagClassValue);
    const encoding = (0, findEncoding)(encodingValue);
    LogUtil.debug(`Found tagClass: ${tagClass}, encoding: ${encoding}`);
    const content = encoding.type === Primitive.type ? contentValue : this.deserializationImpl(contentValue, false);
    LogUtil.debug(`Content: ${JSON.stringify(content)}`);
    if (typeof typeValue === 'string') {
        const Type = (0, findType)(typeValue);
        LogUtil.info(`Found Type: ${Type}`);
        return new Type(content);
    }
    LogUtil.debug(`Creating new instance with tagClass: ${tagClass}, typeValue: ${typeValue}, content: ${JSON.stringify(content)}, encoding: ${encoding}`);
    return new tagClass(typeValue, content, encoding); // eslint-disable-line new-cap
  }
}
