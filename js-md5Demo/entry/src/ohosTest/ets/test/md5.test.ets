import { describe, it, expect } from '@ohos/hypium';
import { md5 } from 'js-md5';

class HexConverter {
  static toHexString(array: Uint8Array): string {
    let hex = '';
    for (let i = 0; i < array.length; ++i) {
      const c = array[i].toString(16).padStart(2, '0');
      hex += c;
    }
    return hex;
  }
}

// 修改后的类型定义
interface TestVector {
  expectedHash: string;
  input: string | number[] | Uint8Array;
}

interface TestSuite {
  ascii: TestVector[];
  ascii_more_than_64_bytes: TestVector[];
  utf8: TestVector[];
  UTF8_more_than_64_bytes: TestVector[];
  specialLength: TestVector[];
  Array: TestVector[]
}

// 重构后的测试用例结构
const testCases: TestSuite = {
  ascii: [
    { expectedHash: 'd41d8cd98f00b204e9800998ecf8427e', input: '' },
    { expectedHash: '9e107d9d372bb6826bd81d3542a419d6', input: 'The quick brown fox jumps over the lazy dog' },
    { expectedHash: 'e4d909c290d0fb1ca068ffaddf22cbd0', input: 'The quick brown fox jumps over the lazy dog.' }
  ],
  ascii_more_than_64_bytes: [
    {
      expectedHash: 'f63872ef7bc97a8a8eadba6f0881de53',
      input: 'The MD5 message-digest algorithm is a widely used cryptographic hash function producing a 128-bit (16-byte) hash value, typically expressed in text format as a 32 digit hexadecimal number. MD5 has been utilized in a wide variety of cryptographic applications, and is also commonly used to verify data integrity.'
    }
  ],
  utf8: [
    { expectedHash: 'a7bac2239fcdcb3a067903d8077c4a07', input: '中文' },
    { expectedHash: 'ec3edbf3b05a449fc206a0138c739c3b', input: 'aécio' },
    { expectedHash: 'b90869aaf121210f6c563973fa855650', input: '𠜎' }
  ],
  UTF8_more_than_64_bytes: [
    {
      expectedHash: 'edce615b179e6e29be23145b77ebbd61',
      input: '訊息摘要演算法第五版（英語：Message-Digest Algorithm 5，縮寫為MD5），是當前電腦領域用於確保資訊傳輸完整一致而廣泛使用的雜湊演算法之一'
    },
    {
      expectedHash: 'ad36c9ab669a0ba9ce46d3ce9134de34',
      input: '訊息摘要演算法第五版（英語：Message-Digest Algorithm 5，縮寫為MD5），是當前電腦領域用於確保資訊傳輸完整一致而廣泛使用的雜湊演算法之一（又譯雜湊演算法、摘要演算法等），主流程式語言普遍已有MD5的實作。'
    }
  ],
  specialLength: [
    {
      expectedHash: 'a119de63e4b2398427da06dd780263b3',
      input: '0123456780123456780123456780123456780123456780123456780'
    },
    {
      expectedHash: 'ddafd84ebe63aebc4626b037a569d78b',
      input: '01234567801234567801234567801234567801234567801234567801'
    },
    {
      expectedHash: '9ea04d743618797ce464445b5785a630',
      input: '0123456780123456780123456780123456780123456780123456780123456780'
    },
    {
      expectedHash: '658d914ae42c4938874b2e786ccda479',
      input: '01234567801234567801234567801234567801234567801234567801234567801234567'
    },
    {
      expectedHash: 'a083a3710d685793f1f17988bfe3c175',
      input: '012345678012345678012345678012345678012345678012345678012345678012345678'
    },
    {
      expectedHash: '2b21a843cfc31c8026a0d835bc91bc98',
      input: '012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678'
    },
    { expectedHash: 'd02ebde979264c79e141559fc9f6b65c', input: '012345678901234567' },
    {
      expectedHash: '1ced811af47ead374872fcca9d73dd71',
      input: '012345678901234567890123456789012345678901234567890123456789'
    },
    { expectedHash: 'ffb81a243a60dac45929300873e05287', input: '012345678901234567中文' }
  ],
  Array: [
    { expectedHash: 'd41d8cd98f00b204e9800998ecf8427e', input: [] },
    { expectedHash: '93b885adfe0da089cdf634904fd59f71', input: [0] },
    {
      expectedHash: '9e107d9d372bb6826bd81d3542a419d6',
      input: [84, 104, 101, 32, 113, 117, 105, 99, 107, 32, 98, 114, 111, 119, 110, 32, 102, 111, 120, 32, 106, 117,
        109, 112, 115, 32, 111, 118, 101, 114, 32, 116, 104, 101, 32, 108, 97, 122, 121, 32, 100, 111, 103]
    }
  ]
};

const base64TestCases: TestSuite = {
  ascii: [
    { expectedHash: '1B2M2Y8AsgTpgAmY7PhCfg==', input: '' },
    { expectedHash: 'nhB9nTcrtoJr2B01QqQZ1g==', input: 'The quick brown fox jumps over the lazy dog' },
    { expectedHash: '5NkJwpDQ+xygaP+t3yLL0A==', input: 'The quick brown fox jumps over the lazy dog.' }
  ],
  ascii_more_than_64_bytes: [
    {
      expectedHash: '9jhy73vJeoqOrbpvCIHeUw==',
      input: 'The MD5 message-digest algorithm is a widely used cryptographic hash function producing a 128-bit (16-byte) hash value, typically expressed in text format as a 32 digit hexadecimal number. MD5 has been utilized in a wide variety of cryptographic applications, and is also commonly used to verify data integrity.'
    }
  ],
  utf8: [
    { expectedHash: 'p7rCI5/NyzoGeQPYB3xKBw==', input: '中文' },
    { expectedHash: '7D7b87BaRJ/CBqATjHOcOw==', input: 'aécio' },
    { expectedHash: 'uQhpqvEhIQ9sVjlz+oVWUA==', input: '𠜎' },
  ],
  UTF8_more_than_64_bytes: [
    {
      expectedHash: '7c5hWxeebim+IxRbd+u9YQ==',
      input: '訊息摘要演算法第五版（英語：Message-Digest Algorithm 5，縮寫為MD5），是當前電腦領域用於確保資訊傳輸完整一致而廣泛使用的雜湊演算法之一'
    },
    {
      expectedHash: 'rTbJq2aaC6nORtPOkTTeNA==',
      input: '訊息摘要演算法第五版（英語：Message-Digest Algorithm 5，縮寫為MD5），是當前電腦領域用於確保資訊傳輸完整一致而廣泛使用的雜湊演算法之一（又譯雜湊演算法、摘要演算法等），主流程式語言普遍已有MD5的實作。'
    },
  ],
  specialLength: [
    { expectedHash: 'oRneY+SyOYQn2gbdeAJjsw==', input: '0123456780123456780123456780123456780123456780123456780' },
    { expectedHash: '3a/YTr5jrrxGJrA3pWnXiw==', input: '01234567801234567801234567801234567801234567801234567801' },
    {
      expectedHash: 'nqBNdDYYeXzkZERbV4WmMA==',
      input: '0123456780123456780123456780123456780123456780123456780123456780'
    },
    {
      expectedHash: 'ZY2RSuQsSTiHSy54bM2keQ==',
      input: '01234567801234567801234567801234567801234567801234567801234567801234567'
    },
    {
      expectedHash: 'oIOjcQ1oV5Px8XmIv+PBdQ==',
      input: '012345678012345678012345678012345678012345678012345678012345678012345678'
    },
    {
      expectedHash: 'KyGoQ8/DHIAmoNg1vJG8mA==',
      input: '012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678012345678'
    },
    { expectedHash: '0C696XkmTHnhQVWfyfa2XA==', input: '012345678901234567' },
    { expectedHash: 'HO2BGvR+rTdIcvzKnXPdcQ==', input: '012345678901234567890123456789012345678901234567890123456789' },
    { expectedHash: '/7gaJDpg2sRZKTAIc+BShw==', input: '012345678901234567中文' },
  ],
  Array: [
    { expectedHash: '1B2M2Y8AsgTpgAmY7PhCfg==', input: [] },
    { expectedHash: 'k7iFrf4NoInN9jSQT9WfcQ==', input: [0] },
    {
      expectedHash: 'nhB9nTcrtoJr2B01QqQZ1g==',
      input: [84, 104, 101, 32, 113, 117, 105, 99, 107, 32, 98, 114, 111, 119, 110, 32, 102, 111, 120, 32, 106, 117,
        109, 112, 115, 32, 111, 118, 101, 114, 32, 116, 104, 101, 32, 108, 97, 122, 121, 32, 100, 111, 103]
    }
  ]
}


function runTestSuite(name: keyof TestSuite) {
  describe(`MD5 ${name}测试套件`, () => {
    // 使用类型安全的方式访问测试套件
    const suite: TestVector[] = (() => {
      switch(name) {
        case 'ascii': return testCases.ascii;
        case 'ascii_more_than_64_bytes': return testCases.ascii_more_than_64_bytes;
        case 'utf8': return testCases.utf8;
        case 'UTF8_more_than_64_bytes': return testCases.UTF8_more_than_64_bytes;
        case 'specialLength': return testCases.specialLength;
        case 'Array': return testCases.Array;
        default: throw new Error('Invalid test suite name');
      }
    })();
    suite.forEach((testCase, index) => {
      console.info('test:'+testCase.expectedHash.toString()+index)
      it(`测试用例#${index + 1}`, 0, () => {
        const result = md5(testCase.input);
        expect(result).assertEqual(testCase.expectedHash);
      });
    });
  });
  describe(`MD5base64 ${name}测试套件`, () => {
    // 使用类型安全的方式访问测试套件
    const suite: TestVector[] = (() => {
      switch(name) {
        case 'ascii': return base64TestCases.ascii;
        case 'ascii_more_than_64_bytes': return base64TestCases.ascii_more_than_64_bytes;
        case 'utf8': return base64TestCases.utf8;
        case 'UTF8_more_than_64_bytes': return base64TestCases.UTF8_more_than_64_bytes;
        case 'specialLength': return base64TestCases.specialLength;
        case 'Array': return base64TestCases.Array;
        default: throw new Error('Invalid test suite name');
      }
    })();
    suite.forEach((base64TestCases, index) => {
      console.info('test:'+base64TestCases.expectedHash.toString()+index)
      it(`测试用例#${index + 1}`, 0, () => {
        const result = md5(base64TestCases.input);
        expect(result).assertEqual(base64TestCases.expectedHash);
      });
    });
  });
}
// 修改主测试函数
export default function md5TestMain() {
  runTestSuite('ascii');
  runTestSuite('ascii_more_than_64_bytes');
  runTestSuite('utf8');
  runTestSuite('UTF8_more_than_64_bytes');
  runTestSuite('specialLength');
  runTestSuite('Array');
}


