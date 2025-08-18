import { LogUtil } from './logUtil';
import { Buffer } from 'buffer/';
import { Type } from './types';
import { Constructed } from './encodings';
import { Serializer } from './serializer';

function jsonify(content) {
  const contentType = typeof content;
  switch (contentType) {
    case 'string':case 'number':case 'boolean':
      LogUtil.info(`Content is a ${contentType}:${content}`);
      return content;
    case 'object':
      {
        if (Array.isArray(content)) {
          LogUtil.debug(`Content is an array: ${content}`);
          return content.map(item => jsonify(item));
        }
        if (Buffer.isBuffer(content)) {
          LogUtil.debug(`Content is a buffer, converting to base64`);
          return content.toString('base64');
        }
        if (typeof content.toString === 'function' && !(content instanceof Type)) {
          LogUtil.debug(`Content has a toString method, calling it`);
          return content.toString();
        }
        LogUtil.error(`No mechanism to serialize content object: "${content}"`);
        throw new Error(`No mechanism to serialize content object: "${content}"`);
      }
    default:
      LogUtil.error(`Illegal ASN.1 object model content type "${contentType}"`);
      throw new Error(`Illegal ASN.1 object model content type "${contentType}"`);
  }
}

export class JSONSerializer extends Serializer {
  serializationImpl(aom) {
    if (Array.isArray(aom)) {
      LogUtil.debug(`Input is an array, processing each item`);
      return aom.map(item => this.serializationImpl(item));
    }

    const {
      tagClass,
      type,
      encoding,
      content
    } = aom;
    const { type: tagClassName } = tagClass;
    const { type: encodingName } = encoding;
    LogUtil.info(`Serializing object with tagClass: ${tagClassName}, type:${type}, encoding: ${encodingName}`);
    const serialized = {
      tagClass: tagClassName,
      type,
      encoding: encodingName
    };

    if (content != null) {
      LogUtil.debug(`Object has content, processing content`);
      serialized.content = encoding.type === Constructed.type ? this.serializationImpl(content) : jsonify(content);
    }

    return serialized;
  }
}
