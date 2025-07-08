import {ASN1} from './types';
import {  Errors} from './errors';
import Buffer from '@ohos.buffer';
import { LogUtil } from './logUtil';


///--- Globals

var InvalidAsn1Error = Errors.InvalidAsn1Error;


const TAG = 'asn1_ber_reader';
///--- API

function Reader(data) {
    if (!data || !Buffer.isBuffer(data)) {
        LogUtil.error('data must be a node Buffer');
        throw new TypeError('data must be a node Buffer');
    }

	LogUtil.debug(`Creating new Reader with buffer size: ${data.length}`);
	this._buf = data;
	this._size = data.length;

	// These hold the "current" state
	this._len = 0;
	this._offset = 0;
}

Object.defineProperty(Reader.prototype, 'length', {
	enumerable: true,
	get: function () {
		LogUtil.debug(`Current length: ${this._len}`);
		return (this._len);
	}
});

Object.defineProperty(Reader.prototype, 'offset', {
	enumerable: true,
	get: function () {
		LogUtil.debug(`Current offset: ${this._offset}`);
		return (this._offset);
	}
});

Object.defineProperty(Reader.prototype, 'remain', {
	get: function () {
		LogUtil.debug(`Remaining bytes: ${this._size - this._offset}`);
		return (this._size - this._offset);
	}
});

Object.defineProperty(Reader.prototype, 'buffer', {
	get: function () {
		LogUtil.debug(`Buffer slice from offset: ${this._offset}`);
		return (this._buf.slice(this._offset));
	}
});


/**
 * Reads a single byte and advances offset; you can pass in `true` to make this
 * a "peek" operation (i.e., get the byte, but don't advance the offset).
 *
 * @param {Boolean} peek true means don't move offset.
 * @return {Number} the next byte, null if not enough data.
 */
Reader.prototype.readByte = function(peek) {
	LogUtil.debug(`Attempting to read byte at offset ${this._offset}, peek=${peek}`);
	if (this._size - this._offset < 1) {
		LogUtil.warn('Not enough data to read byte');
		return null;
	}

	var b = this._buf[this._offset] & 0xff;
	LogUtil.debug(`Read byte: 0x${b.toString(16)}`);

	if (!peek) {
		this._offset += 1;
		LogUtil.debug(`Advanced offset to ${this._offset}`);
	}

	return b;
};


Reader.prototype.peek = function() {
	LogUtil.debug('Peeking next byte');
	return this.readByte(true);
};


/**
 * Reads a (potentially) variable length off the BER buffer.  This call is
 * not really meant to be called directly, as callers have to manipulate
 * the internal buffer afterwards.
 *
 * As a result of this call, you can call `Reader.length`, until the
 * next thing called that does a readLength.
 *
 * @return {Number} the amount of offset to advance the buffer.
 * @throws {InvalidAsn1Error} on bad ASN.1
 */
Reader.prototype.readLength = function(offset) {
	LogUtil.debug(`Reading length at offset ${offset || this._offset}`);
	if (offset === undefined)
		offset = this._offset;

	if (offset >= this._size) {
		LogUtil.warn('Offset beyond buffer size');
		return null;
	}

	var lenB = this._buf[offset++] & 0xff;
	if (lenB === null) {
		LogUtil.warn('Null length byte encountered');
		return null;
	}

	if ((lenB & 0x80) == 0x80) {
		LogUtil.debug('Variable length detected');
		lenB &= 0x7f;

		if (lenB == 0) {
			LogUtil.error('Indefinite length not supported');
			throw InvalidAsn1Error('Indefinite length not supported');
		}

		// Caused problems for node-net-snmp issue #172
		// if (lenB > 4)
		// 	throw InvalidAsn1Error('encoding too long');

		if (this._size - offset < lenB) {
			LogUtil.warn('Not enough data for variable length');
			return null;
		}

		this._len = 0;
		for (var i = 0; i < lenB; i++) {
			this._len *= 256;
			this._len += (this._buf[offset++] & 0xff);
			LogUtil.debug(`Accumulated length: ${this._len}`);
		}

	} else {
		// Wasn't a variable length
		LogUtil.debug('Fixed length detected');
		this._len = lenB;
	}

	LogUtil.info(`Set length to ${this._len}`);
	return offset;
};


/**
 * Parses the next sequence in this BER buffer.
 *
 * To get the length of the sequence, call `Reader.length`.
 *
 * @return {Number} the sequence's tag.
 */
Reader.prototype.readSequence = function(tag) {
	LogUtil.debug(`Reading sequence, expected tag ${tag}`);
	var seq = this.peek();
	if (seq === null) {
		LogUtil.warn('No sequence to read');
		return null;
	}
	if (tag !== undefined && tag !== seq) {
		LogUtil.error(`Expected tag 0x${tag.toString(16)}, got 0x${seq.toString(16)}`);
		throw InvalidAsn1Error('Expected 0x' + tag.toString(16) +
			': got 0x' + seq.toString(16));
	}

	var o = this.readLength(this._offset + 1); // stored in `length`
	if (o === null) {
		LogUtil.warn('Failed to read sequence length');
		return null;
	}

	this._offset = o;
	LogUtil.info(`Read sequence tag: 0x${seq.toString(16)}`);
	return seq;
};


Reader.prototype.readInt = function(tag) {
	// if (typeof(tag) !== 'number')
	// 	tag = ASN1.Integer;
	LogUtil.debug(`Reading integer, tag=${tag}`);
	return this._readTag(tag);
};


Reader.prototype.readBoolean = function(tag) {
	if (typeof(tag) !== 'number')
		tag = ASN1.Boolean;

	LogUtil.debug(`Reading boolean, tag=${tag}`);
	return (this._readTag(tag) === 0 ? false : true);
};


Reader.prototype.readEnumeration = function(tag) {
	if (typeof(tag) !== 'number')
		tag = ASN1.Enumeration;

	LogUtil.debug(`Reading enumeration, tag=${tag}`);
	return this._readTag(tag);
};


Reader.prototype.readString = function(tag, retbuf) {
	if (!tag)
		tag = ASN1.OctetString;

	LogUtil.debug(`Reading string, tag=${tag}, return buffer=${retbuf}`);
	var b = this.peek();
	if (b === null) {
		LogUtil.warn('No string to read');
		return null;
	}

	if (b !== tag) {
		LogUtil.error(`Expected tag 0x${tag.toString(16)}, got 0x${b.toString(16)}`);
		throw InvalidAsn1Error('Expected 0x' + tag.toString(16) +
			': got 0x' + b.toString(16));
	}
	var o = this.readLength(this._offset + 1); // stored in `length`

	if (o === null) {
		LogUtil.warn('Failed to read string length');
		return null;
	}

	if (this.length > this._size - o) {
		LogUtil.warn('String length exceeds buffer size');
		return null;
	}

	this._offset = o;

	if (this.length === 0) {
		LogUtil.debug('Empty string');
		return retbuf ? Buffer.alloc(0) : '';
	}

	var str = this._buf.subarray(this._offset, this._offset + this.length);
	this._offset += this.length;

	LogUtil.info(`Read string of length ${this.length}`);
	return retbuf ? str : str.toString('utf8');
};

Reader.prototype.readOID = function(tag) {
	if (!tag)
		tag = ASN1.OID;

	LogUtil.debug(`Reading OID, tag=${tag}`);
	var b = this.readString(tag, true);
	if (b === null) {
		LogUtil.warn('No OID to read');
		return null;
	}

	var values = [];
	var value = 0;

	for (var i = 0; i < b.length; i++) {
		var byte = b[i] & 0xff;

		value <<= 7;
		value += byte & 0x7f;
		if ((byte & 0x80) == 0) {
			values.push(value >>> 0);
			value = 0;
		}
	}

	value = values.shift();
	values.unshift(value % 40);
	values.unshift((value / 40) >> 0);

	LogUtil.info(`Read OID: ${values.join('.')}`);
	return values.join('.');
};

Reader.prototype.readBitString = function(tag) {
	if (!tag)
		tag = ASN1.BitString;

	LogUtil.debug(`Reading bit string, tag=${tag}`);
	var b = this.peek();
	if (b === null) {
		LogUtil.warn('No bit string to read');
		return null;
	}

	if (b !== tag) {
		LogUtil.error(`Expected tag 0x${tag.toString(16)}, got 0x${b.toString(16)}`);
		throw InvalidAsn1Error('Expected 0x' + tag.toString(16) +
			': got 0x' + b.toString(16));
	}

	var o = this.readLength(this._offset + 1);

	if (o === null) {
		LogUtil.warn('Failed to read bit string length');
		return null;
	}

	if (this.length > this._size - o) {
		LogUtil.warn('Bit string length exceeds buffer size');
		return null;
	}

	this._offset = o;

	if (this.length === 0) {
		LogUtil.debug('Empty bit string');
		return '';
	}

	var ignoredBits = this._buf[this._offset++];
	LogUtil.debug(`Ignored bits: ${ignoredBits}`);

	var bitStringOctets = this._buf.subarray(this._offset, this._offset + this.length - 1);
	var bitString = (parseInt(bitStringOctets.toString('hex'), 16).toString(2)).padStart(bitStringOctets.length * 8, '0');
	this._offset += this.length - 1;

	LogUtil.info(`Read bit string: ${bitString.substring(0, bitString.length - ignoredBits)}`);
	return bitString.substring(0, bitString.length - ignoredBits);
};

Reader.prototype._readTag = function(tag) {
	// assert.ok(tag !== undefined);
	var b = this.peek();

	if (b === null) {
		LogUtil.warn('No tag to read');
		return null;
	}

	if (tag !== undefined && b !== tag) {
		LogUtil.error(`Expected tag 0x${tag.toString(16)}, got 0x${b.toString(16)}`);
		throw InvalidAsn1Error('Expected 0x' + tag.toString(16) +
			': got 0x' + b.toString(16));
	}

	var o = this.readLength(this._offset + 1); // stored in `length`
	if (o === null) {
		LogUtil.warn('Failed to read tag length');
		return null;
	}

	if (this.length === 0) {
		LogUtil.error('Zero-length integer');
		throw InvalidAsn1Error('Zero-length integer');
	}

	if (this.length > this._size - o) {
		LogUtil.warn('Tag length exceeds buffer size');
		return null;
	}
	this._offset = o;

	var value = this._buf.readInt8(this._offset++);
	for (var i = 1; i < this.length; i++) {
		value *= 256;
		value += this._buf[this._offset++];
	}

	if ( ! Number.isSafeInteger(value) ) {
		LogUtil.error('Integer not representable as javascript number');
		throw InvalidAsn1Error('Integer not representable as javascript number');
	}

	LogUtil.info(`Read tag value: ${value}`);
	return value;
};



///--- Exported API

export  default  Reader;
