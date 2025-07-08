import { ASN1 } from './types';
import { Errors } from './errors';
import Buffer from '@ohos.buffer';
import { LogUtil } from './logUtil';
///--- Globals

var InvalidAsn1Error = Errors.InvalidAsn1Error;

var DEFAULT_OPTS = {
	size: 1024,
	growthFactor: 8
};
const TAG = 'asn1_ber_writer';
function merge(from, to) {
	// 确保 from 和 to 都是对象
	if (typeof from !== 'object' || from === null || typeof to !== 'object' || to === null) {
		LogUtil.error('Both arguments must be objects and not null');
		throw new TypeError('Both arguments must be objects and not null');
	}

	var keys = Object.getOwnPropertyNames(from);
	keys.forEach(function (key) {
		if (to[key]) {
			return;
		}

		var value = Object.getOwnPropertyDescriptor(from, key);
		Object.defineProperty(to, key, value);
	});
	LogUtil.debug(`Merged options: ${JSON.stringify(to)}`);
	return to;
}


///--- API

function Writer(options) {
	options = merge(DEFAULT_OPTS, options || {});

	this._buf = Buffer.alloc(options.size || 1024);
	this._size = this._buf.length;
	this._offset = 0;
	this._options = options;

	// A list of offsets in the buffer where we need to insert
	// sequence tag/len pairs.
	this._seq = [];
	LogUtil.debug(`Created new Writer with buffer size: ${this._size}`);
}

Object.defineProperty(Writer.prototype, 'buffer', {
	get: function () {
		if (this._seq.length) {
			LogUtil.warn(`${this._seq.length} unended sequence(s)`);
			throw InvalidAsn1Error(this._seq.length + ' unended sequence(s)');
		}

		LogUtil.info(`Returning buffer of length: ${this._offset}`);
		return (this._buf.subarray(0, this._offset));
	}
});

Writer.prototype.writeByte = function (b) {
	if (typeof (b) !== 'number') {
		LogUtil.error(`argument must be a Number`);
		throw new TypeError('argument must be a Number');
	}

	this._ensure(1);
	this._buf[this._offset++] = b;
};

Writer.prototype.writeInt = function (i, tag) {
	if (!Number.isInteger(i)) {
		LogUtil.error(`argument must be an integer`);
		throw new TypeError('argument must be an integer');
	}
	if (typeof (tag) !== 'number') {
		tag = ASN1.Integer;
	}

	let bytes = [];
	while (i < -0x80 || i >= 0x80) {
		bytes.push(i & 0xff);
		i = Math.floor(i / 0x100);
	}
	bytes.push(i & 0xff);

	this._ensure(2 + bytes.length);
	this._buf[this._offset++] = tag;
	this._buf[this._offset++] = bytes.length;

	while (bytes.length) {
		this._buf[this._offset++] = bytes.pop();
	}
	LogUtil.info(`Wrote integer: ${i} with tag: ${tag}`);
};

Writer.prototype.writeNull = function () {
	this.writeByte(ASN1.Null);
	this.writeByte(0x00);
	LogUtil.debug(`Wrote null value`);
};


Writer.prototype.writeEnumeration = function (i, tag) {
	if (typeof (i) !== 'number') {
		LogUtil.error(`argument must be a Number`);
		throw new TypeError('argument must be a Number');
	}
	if (typeof (tag) !== 'number') {
		tag = ASN1.Enumeration;
	}

	return this.writeInt(i, tag);
};


Writer.prototype.writeBoolean = function (b, tag) {
	if (typeof (b) !== 'boolean') {
		LogUtil.error('argument must be a Boolean');
		throw new TypeError('argument must be a Boolean');
	}
	if (typeof (tag) !== 'number') {
		tag = ASN1.Boolean;
	}

	this._ensure(3);
	this._buf[this._offset++] = tag;
	this._buf[this._offset++] = 0x01;
	this._buf[this._offset++] = b ? 0xff : 0x00;
};


Writer.prototype.writeString = function (s, tag) {
	if (typeof (s) !== 'string') {
		LogUtil.error('argument must be a string (was: ' + typeof (s) + ')');
		throw new TypeError('argument must be a string (was: ' + typeof (s) + ')');
	}
	if (typeof (tag) !== 'number') {
		tag = ASN1.OctetString;
	}

	var len = Buffer.byteLength(s);
	this.writeByte(tag);
	this.writeLength(len);
	if (len) {
		this._ensure(len);
		this._buf.write(s, this._offset);
		this._offset += len;
	}
};


Writer.prototype.writeBuffer = function (buf, tag) {
	if (!Buffer.isBuffer(buf)) {
		LogUtil.error('argument must be a buffer');
		throw new TypeError('argument must be a buffer');
	}

	// If no tag is specified we will assume `buf` already contains tag and length
	if (typeof (tag) === 'number') {
		this.writeByte(tag);
		this.writeLength(buf.length);
	}

	if (buf.length > 0) {
		this._ensure(buf.length);
		buf.copy(this._buf, this._offset, 0, buf.length);
		this._offset += buf.length;
	}
	LogUtil.debug(`Wrote buffer of length: ${buf.length} with tag: ${tag}`);
};


Writer.prototype.writeStringArray = function (strings, tag) {
	if (!(strings instanceof Array)) {
		LogUtil.error('argument must be an Array[String]');
		throw new TypeError('argument must be an Array[String]');
	}

	var self = this;
	strings.forEach(function (s) {
		self.writeString(s, tag);
	});
	LogUtil.info(`Wrote string array with tag: ${tag}`);
};

// This is really to solve DER cases, but whatever for now
Writer.prototype.writeOID = function (s, tag) {
	if (typeof (s) !== 'string') {
		LogUtil.error('argument must be a string');
		throw new TypeError('argument must be a string');
	}
	if (typeof (tag) !== 'number') {
		tag = ASN1.OID;
	}

	if (!/^([0-9]+\.){0,}[0-9]+$/.test(s)) {
		LogUtil.error('argument is not a valid OID string');
		throw new Error('argument is not a valid OID string');
	}

	function encodeOctet(bytes, octet) {
		if (octet < 128) {
			bytes.push(octet);
		} else if (octet < 16384) {
			bytes.push((octet >>> 7) | 0x80);
			bytes.push(octet & 0x7F);
		} else if (octet < 2097152) {
			bytes.push((octet >>> 14) | 0x80);
			bytes.push(((octet >>> 7) | 0x80) & 0xFF);
			bytes.push(octet & 0x7F);
		} else if (octet < 268435456) {
			bytes.push((octet >>> 21) | 0x80);
			bytes.push(((octet >>> 14) | 0x80) & 0xFF);
			bytes.push(((octet >>> 7) | 0x80) & 0xFF);
			bytes.push(octet & 0x7F);
		} else {
			bytes.push(((octet >>> 28) | 0x80) & 0xFF);
			bytes.push(((octet >>> 21) | 0x80) & 0xFF);
			bytes.push(((octet >>> 14) | 0x80) & 0xFF);
			bytes.push(((octet >>> 7) | 0x80) & 0xFF);
			bytes.push(octet & 0x7F);
		}
	}

	var tmp = s.split('.');
	var bytes = [];
	bytes.push(parseInt(tmp[0], 10) * 40 + parseInt(tmp[1], 10));
	tmp.slice(2).forEach(function (b) {
		encodeOctet(bytes, parseInt(b, 10));
	});

	var self = this;
	this._ensure(2 + bytes.length);
	this.writeByte(tag);
	this.writeLength(bytes.length);
	bytes.forEach(function (b) {
		self.writeByte(b);
	});
	LogUtil.info(`Wrote OID: ${s} with tag: ${tag}`);
};


Writer.prototype.writeLength = function (len) {
	if (typeof (len) !== 'number') {
		LogUtil.error('argument must be a Number');
		throw new TypeError('argument must be a Number');
	}

	this._ensure(4);

	if (len <= 0x7f) {
		this._buf[this._offset++] = len;
	} else if (len <= 0xff) {
		this._buf[this._offset++] = 0x81;
		this._buf[this._offset++] = len;
	} else if (len <= 0xffff) {
		this._buf[this._offset++] = 0x82;
		this._buf[this._offset++] = len >> 8;
		this._buf[this._offset++] = len;
	} else if (len <= 0xffffff) {
		this._buf[this._offset++] = 0x83;
		this._buf[this._offset++] = len >> 16;
		this._buf[this._offset++] = len >> 8;
		this._buf[this._offset++] = len;
	} else {
		LogUtil.error('Length too long (> 4 bytes)');
		throw InvalidAsn1Error('Length too long (> 4 bytes)');
	}
	LogUtil.debug(`Wrote length: ${len}`);
};

Writer.prototype.startSequence = function (tag) {
	if (typeof (tag) !== 'number') {
		tag = ASN1.Sequence | ASN1.Constructor;
	}

	this.writeByte(tag);
	this._seq.push(this._offset);
	this._ensure(3);
	this._offset += 3;
	LogUtil.debug(`Started sequence with tag: ${tag}`);
};


Writer.prototype.endSequence = function () {
	var seq = this._seq.pop();
	var start = seq + 3;
	var len = this._offset - start;

	if (len <= 0x7f) {
		this._shift(start, len, -2);
		this._buf[seq] = len;
	} else if (len <= 0xff) {
		this._shift(start, len, -1);
		this._buf[seq] = 0x81;
		this._buf[seq + 1] = len;
	} else if (len <= 0xffff) {
		this._buf[seq] = 0x82;
		this._buf[seq + 1] = len >> 8;
		this._buf[seq + 2] = len;
	} else if (len <= 0xffffff) {
		this._shift(start, len, 1);
		this._buf[seq] = 0x83;
		this._buf[seq + 1] = len >> 16;
		this._buf[seq + 2] = len >> 8;
		this._buf[seq + 3] = len;
	} else {
		LogUtil.error('Sequence too long');
		throw InvalidAsn1Error('Sequence too long');
	}
	LogUtil.info(`Ended sequence with length: ${len}`);
};

Writer.prototype._shift = function (start, len, shift) {
	// 检查 start 是否被定义
	if (start === undefined) {
		LogUtil.error('Missing required parameter "start"');
		throw new Error('Missing required parameter "start"');
	}

	// 检查 len 是否被定义
	if (len === undefined) {
		LogUtil.error('Missing required parameter "len"');
		throw new Error('Missing required parameter "len"');
	}

	// 检查 shift 是否为有效值（这里假设非零或负数即为有效）
	if (shift >= 0) {
		LogUtil.error('Invalid shift value, must be a positive number');
		throw new Error('Invalid shift value, must be a positive number');
	}

	// 执行实际的缓冲区操作
	this._buf.copy(this._buf, start + shift, start, start + len);
	this._offset += shift;
	LogUtil.debug(`Shifted buffer by: ${shift}`);
};

Writer.prototype._ensure = function (len) {
	// assert.ok(len);

	if (!len || len <= 0) {
		LogUtil.error('Invalid length, must be a positive number');
		// 抛出错误或进行其他错误处理
		throw new Error('Invalid length, must be a positive number');
	}
	if (this._size - this._offset < len) {
		var sz = this._size * this._options.growthFactor;
		if (sz - this._offset < len) {
			sz += len;
		}

		var buf = Buffer.alloc(sz);
		this._buf.copy(buf, 0, 0, this._offset);
		this._buf = buf;
		this._size = sz;
		LogUtil.debug(`Expanded buffer to size: ${sz}`);
	}
};


///--- Exported API

export default Writer;
