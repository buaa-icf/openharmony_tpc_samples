import { LogUtil } from './logUtil';
'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Serializer = undefined;

const TAG = 'asn1Demo-serializer';

function validateAOM(aom) {
    if (aom === null) {
        LogUtil.error('ASN.1 object model must not be null');
        throw new Error('ASN.1 object model must not be null');
    }
    if (aom === undefined) {
        LogUtil.error('ASN.1 object model must not be undefined');
        throw new Error('ASN.1 object model must not be undefined');
    }
    if (typeof aom !== 'object') {
        LogUtil.error('ASN.1 object model must be an object');
        throw new Error('ASN.1 object model must be an object');
    }
    if (Array.isArray(aom) && aom.length < 1) {
        LogUtil.error('ASN.1 object model is empty');
        throw new Error('ASN.1 object model is empty');
    }
}

class Serializer {
  constructor() {
    return this.serialize.bind(this);
  }

  serialize(aom, params) {
    validateAOM(aom);
    return this.serializationImpl(aom, params);
  }
}
exports.Serializer = Serializer;