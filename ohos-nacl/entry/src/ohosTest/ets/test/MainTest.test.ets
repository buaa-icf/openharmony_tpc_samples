/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import nacl_factory, { Nacl } from '@ohos/js-nacl';

export default function mainTest() {
  let nacl: Nacl;

  describe('MainTest', () => {
    beforeAll(async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Test suite started');
      // 初始化 nacl 实例
      try {
        nacl = await nacl_factory.instantiate(() => {});
        hilog.info(0x0000, 'testTag', '%{public}s', 'Nacl instance initialized successfully');
      } catch (error) {
        hilog.error(0x0000, 'testTag', 'Nacl instance initialization failed: %{public}s', error.message);
      }
    })

    afterAll(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Test suite finished');
    })

    it('basicTest', 0, () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Basic test started');
      expect(1).assertEqual(1);
      hilog.info(0x0000, 'testTag', '%{public}s', 'Basic test passed');
    })

    it('stringTest', 0, () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'String test started');
      let a = 'hello';
      let b = 'ell';
      expect(a).assertContain(b);
      hilog.info(0x0000, 'testTag', '%{public}s', 'String test passed');
    })

    // 1. 数据转换接口测试 - 使用test_simple.html的测试数据的
    // 数据和main/pages/Index.ets的一样
    it('dataConversionTest', 0, async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Data conversion test started');

      if (!nacl) {
        hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
        expect(false).assertTrue();
        return;
      }

      try {
        // 1.1 to_hex 测试 - 使用 "hello" 转换为 hex
        const originalText = "hello";
        const binaryData = nacl.encode_utf8(originalText);
        const hex = nacl.to_hex(binaryData);
        expect(hex).assertEqual('68656c6c6f');
        hilog.info(0x0000, 'testTag', '%{public}s', '1.1 to_hex test passed');

        // 1.2 from_hex 测试 - 从hex转换回 "hello"
        const hexString = '68656c6c6f';
        const binary = nacl.from_hex(hexString);
        const text = nacl.decode_utf8(binary);
        expect(text).assertEqual('hello');
        hilog.info(0x0000, 'testTag', '%{public}s', '1.2 from_hex test passed');

        // 1.3 encode_utf8 测试 - 'Hello js-nacl!'
        const originalText2 = 'Hello js-nacl!';
        const encoded = nacl.encode_utf8(originalText2);
        const decoded = nacl.decode_utf8(encoded);
        expect(decoded).assertEqual('Hello js-nacl!');
        hilog.info(0x0000, 'testTag', '%{public}s', '1.3 encode_utf8 test passed');

        // 1.4 decode_utf8 测试 - '测试中文'
        const chineseText = '测试中文';
        const encodedChinese = nacl.encode_utf8(chineseText);
        const decodedChinese = nacl.decode_utf8(encodedChinese);
        expect(decodedChinese).assertEqual('测试中文');
        hilog.info(0x0000, 'testTag', '%{public}s', '1.4 decode_utf8 test passed');

        // 1.5 encode_latin1 和 decode_latin1 测试
        const latin1Text = 'Test latin1';
        const latin1Bytes = nacl.encode_latin1(latin1Text);
        const latin1String = nacl.decode_latin1(latin1Bytes);
        expect(latin1String).assertEqual('Test latin1');
        hilog.info(0x0000, 'testTag', '%{public}s', '1.5 encode_latin1 and decode_latin1 test passed');
        hilog.info(0x0000, 'testTag', '%{public}s', 'All data conversion tests passed');
      } catch (error) {
        hilog.error(0x0000, 'testTag', 'Data conversion test failed: %{public}s', error.message);
        expect(false).assertTrue();
      }
    })

    // 2. 哈希函数测试 - 使用test_simple.html的测试数据的
    // 数据和main/pages/Index.ets的一样
    it('hashTest', 0, async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Hash test started');

      if (!nacl) {
        hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
        expect(false).assertTrue();
        return;
      }

      try {
        // 2.1 crypto_hash (SHA-512) 测试 - 使用 'hello'
        const testData = nacl.encode_utf8('hello');
        const hash = nacl.crypto_hash(testData);
        expect(hash.length).assertEqual(64);
        hilog.info(0x0000, 'testTag', '%{public}s', '2.1 crypto_hash (SHA-512) test passed');

        // 2.3 crypto_hash_sha256 测试
        const hash256 = nacl.crypto_hash_sha256(testData);
        expect(hash256.length).assertEqual(32);
        hilog.info(0x0000, 'testTag', '%{public}s', '2.3 crypto_hash_sha256 test passed');

        hilog.info(0x0000, 'testTag', '%{public}s', 'All hash tests passed');
      } catch (error) {
        hilog.error(0x0000, 'testTag', 'Hash test failed: %{public}s', error.message);
        expect(false).assertTrue();
      }
    })

    // 3. 随机数生成测试 - 使用test_simple.html的测试数据
    // 数据和main/pages/Index.ets的一样
    it('randomBytesTest', 0, async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Random bytes test started');

      if (!nacl) {
        hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
        expect(false).assertTrue();
        return;
      }

      try {
        // 3.1 random_bytes 测试
        const random = nacl.random_bytes(32);
        expect(random.length).assertEqual(32);
        hilog.info(0x0000, 'testTag', '%{public}s', '3.1 random_bytes test passed');

        hilog.info(0x0000, 'testTag', '%{public}s', 'All random bytes tests passed');
      } catch (error) {
        hilog.error(0x0000, 'testTag', 'Random bytes test failed: %{public}s', error.message);
        expect(false).assertTrue();
      }
    })

    // 4. 数字签名测试 - 使用test_simple.html的测试数据
    // 数据和main/pages/Index.ets的一样
    it('signatureTest', 0, async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Signature test started');

      if (!nacl) {
        hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
        expect(false).assertTrue();
        return;
      }

      try {
        // 4.1 crypto_sign_keypair 测试
        const kp = nacl.crypto_sign_keypair();
        expect(kp.signPk !== null && kp.signSk !== null).assertTrue();
        hilog.info(0x0000, 'testTag', '%{public}s', '4.1 crypto_sign_keypair test passed');

        // 4.2 crypto_sign_seed_keypair 测试 - 使用32字节种子
        // 创建32字节的种子数据
        const seedString = "sign_seed_keypair_test"; // 原始字符串
        const seed = new Uint8Array(32); // 创建32字节的数组
        const seedData = nacl.encode_utf8(seedString); // 将字符串编码为字节数组
        // 将原始种子数据复制到32字节数组中（如果超过32字节则截断）
        seed.set(seedData.length <= 32 ? seedData : seedData.subarray(0, 32));
        const seedKp = nacl.crypto_sign_seed_keypair(seed);
        expect(seedKp.signPk !== null && seedKp.signSk !== null).assertTrue();
        hilog.info(0x0000, 'testTag', '%{public}s', '4.2 crypto_sign_seed_keypair test passed');

        // 4.3 crypto_sign 和 crypto_sign_open 测试 - 使用 'message'
        const originalText = "message";
        const message = nacl.encode_utf8(originalText);

        const c = nacl.crypto_sign(message, kp.signSk);
        const m = nacl.crypto_sign_open(c, kp.signPk);
        const decryptedText = m ? nacl.decode_utf8(m) : null;
        expect(decryptedText).assertEqual(originalText);
        hilog.info(0x0000, 'testTag', '%{public}s', '4.3 crypto_sign 和 crypto_sign_open test passed');

        // 4.4 crypto_sign_detached 和 crypto_sign_verify_detached 测试
        const detached_sig = nacl.crypto_sign_detached(message, kp.signSk);
        const valid = nacl.crypto_sign_verify_detached(detached_sig, message, kp.signPk);
        expect(valid).assertTrue();
        hilog.info(0x0000, 'testTag', '%{public}s', '4.4 crypto_sign_detached test passed');

        hilog.info(0x0000, 'testTag', '%{public}s', 'All signature tests passed');
      } catch (error) {
        hilog.error(0x0000, 'testTag', 'Signature test failed: %{public}s', error.message);
        expect(false).assertTrue();
      }
    })

    // 5. 非对称加密(Box)测试 - 使用test_simple.html的测试数据
    // 数据和main/pages/Index.ets的一样
    it('boxTest', 0, async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Box test started');

      if (!nacl) {
        hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
        expect(false).assertTrue();
        return;
      }

      try {
        // 5.1 crypto_box_keypair 测试
        const kp = nacl.crypto_box_keypair();
        expect(kp.boxPk !== null && kp.boxSk !== null).assertTrue();
        hilog.info(0x0000, 'testTag', '%{public}s', '5.1 crypto_box_keypair test passed');

        // 5.2 crypto_box_seed_keypair 测试 - 使用 'hello' 种子（与js-nacl保持一致）
        // 修复：确保种子是32字节长度
        const seedString = "hello"; // 原始字符串
        const seed = new Uint8Array(32); // 创建32字节的数组
        const seedData = nacl.encode_utf8(seedString); // 将字符串编码为字节数组
        // 将原始种子数据复制到32字节数组中（如果超过32字节则截断）
        seed.set(seedData.length <= 32 ? seedData : seedData.subarray(0, 32));
        const kp2 = nacl.crypto_box_seed_keypair(seed);
        expect(kp2.boxPk !== null && kp2.boxSk !== null).assertTrue();
        hilog.info(0x0000, 'testTag', '%{public}s', '5.2 crypto_box_seed_keypair test passed');

        // 5.3 crypto_box_precompute 测试 - 与 js-nacl 保持一致
        const selfShared = nacl.crypto_box_precompute(kp2.boxPk, kp2.boxSk);
        expect(selfShared.boxK !== null).assertTrue();
        hilog.info(0x0000, 'testTag', '%{public}s', '5.3 crypto_box_precompute test passed');

        // 5.4 crypto_box 和 crypto_box_open 测试 - 与 js-nacl 原库保持一致
        const nonce = new Uint8Array(24); // 使用零nonce模拟测试
        const plaintext = "box test";
        const cipher = nacl.crypto_box(nacl.encode_utf8(plaintext), nonce, kp2.boxPk, kp2.boxSk);
        // 修复参数顺序：crypto_box_open(cipher, nonce, senderPublicKey, recipientSecretKey)
        // 在这个测试用例中，kp2.boxPk是发送方公钥，kp2.boxSk是接收方私钥
        const decrypted = nacl.crypto_box_open(cipher, nonce, kp2.boxPk, kp2.boxSk);
        const decryptedText = nacl.decode_utf8(decrypted);
        expect(decryptedText).assertEqual(plaintext);
        hilog.info(0x0000, 'testTag', '%{public}s', '5.4 crypto_box 和 crypto_box_open test passed');

        // 5.5 crypto_box_precomputed 测试
        const c2 = nacl.crypto_box_precomputed(nacl.encode_utf8(plaintext), nonce, selfShared);
        const m2 = nacl.crypto_box_open_precomputed(c2, nonce, selfShared);
        const decryptedText2 = nacl.decode_utf8(m2);
        expect(decryptedText2).assertEqual(plaintext);
        hilog.info(0x0000, 'testTag', '%{public}s', '5.5 crypto_box_precomputed test passed');

        // 5.6 crypto_box_random_nonce 测试
        const randomNonce = nacl.crypto_box_random_nonce();
        expect(randomNonce.length).assertEqual(24);
        hilog.info(0x0000, 'testTag', '%{public}s', '5.6 crypto_box_random_nonce test passed');

        // 5.7 crypto_box_keypair_from_raw_sk 测试
        const sk = nacl.random_bytes(32);
        const kp3 = nacl.crypto_box_keypair_from_raw_sk(sk);
        expect(kp3.boxPk !== null && kp3.boxSk !== null).assertTrue();
        hilog.info(0x0000, 'testTag', '%{public}s', '5.7 crypto_box_keypair_from_raw_sk test passed');

        hilog.info(0x0000, 'testTag', '%{public}s', 'All box tests passed');
      } catch (error) {
        hilog.error(0x0000, 'testTag', 'Box test failed: %{public}s', error.message);
        expect(false).assertTrue();
      }
    })

    // 6. 对称加密(SecretBox)测试 - 使用test_simple.html的测试数据
    // 数据和main/pages/Index.ets的一样
    it('secretBoxTest', 0, async () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Secret box test started');

      if (!nacl) {
        hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
        expect(false).assertTrue();
        return;
      }

      try {
        // 6.1 crypto_secretbox 和 crypto_secretbox_open 测试 - 使用 'hello' 和 'thekey'
        const nonce = new Uint8Array(24); // 使用零nonce模拟测试
        const secretboxkey = nacl.crypto_hash(nacl.encode_utf8("thekey")).subarray(0, 32);
        const plaintext = "hello";
        const c = nacl.crypto_secretbox(nacl.encode_utf8(plaintext), nonce, secretboxkey);
        const m = nacl.crypto_secretbox_open(c, nonce, secretboxkey);
        const decryptedText = nacl.decode_utf8(m);
        expect(decryptedText).assertEqual(plaintext);
        hilog.info(0x0000, 'testTag', '%{public}s', '6.1 crypto_secretbox 和 crypto_secretbox_open test passed');

        hilog.info(0x0000, 'testTag', '%{public}s', 'All secret box tests passed');
      } catch (error) {
        hilog.error(0x0000, 'testTag', 'Secret box test failed: %{public}s', error.message);
        expect(false).assertTrue();
      }
    })

    // // 7. 流加密测试
    // // 数据和main/pages/Index.ets的一样
    // it('streamTest', 0, async () => {
    //   hilog.info(0x0000, 'testTag', '%{public}s', 'Stream test started');
    //
    //   if (!nacl) {
    //     hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
    //     expect(false).assertTrue();
    //     return;
    //   }
    //
    //   try {
    //     // 7.1 crypto_stream 测试
    //     const key = nacl.random_bytes(32);
    //     const nonce = nacl.random_bytes(24); // 使用crypto_stream_random_nonce生成nonce
    //     const streamLength = 64;
    //     const stream = nacl.crypto_stream(streamLength, nonce, key);
    //     expect(stream.length).assertEqual(streamLength);
    //     hilog.info(0x0000, 'testTag', '%{public}s', '7.1 crypto_stream test passed');
    //
    //     // 7.2 crypto_stream_xor 测试
    //     const message = nacl.encode_utf8("stream test message");
    //     const encrypted = nacl.crypto_stream_xor(message, nonce, key);
    //     const decrypted = nacl.crypto_stream_xor(encrypted, nonce, key);
    //     const decryptedText = nacl.decode_utf8(decrypted);
    //     expect(decryptedText).assertEqual("stream test message");
    //     hilog.info(0x0000, 'testTag', '%{public}s', '7.2 crypto_stream_xor test passed');
    //
    //     hilog.info(0x0000, 'testTag', '%{public}s', 'All stream tests passed');
    //   } catch (error) {
    //     hilog.error(0x0000, 'testTag', 'Stream test failed: %{public}s', error.message);
    //     expect(false).assertTrue();
    //   }
    // })
    //
    // // 8. 认证加密测试
    // // 数据和main/pages/Index.ets的一样
    // it('authTest', 0, async () => {
    //   hilog.info(0x0000, 'testTag', '%{public}s', 'Auth test started');
    //
    //   if (!nacl) {
    //     hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
    //     expect(false).assertTrue();
    //     return;
    //   }
    //
    //   try {
    //     // 8.1 crypto_auth 测试
    //     const key = nacl.random_bytes(32);
    //     const message = nacl.encode_utf8("auth test message");
    //     const tag = nacl.crypto_auth(message, key);
    //     expect(tag.length).assertEqual(32);
    //     hilog.info(0x0000, 'testTag', '%{public}s', '8.1 crypto_auth test passed');
    //
    //     // 8.2 crypto_auth_verify 测试
    //     const isValid = nacl.crypto_auth_verify(tag, message, key);
    //     expect(isValid).assertTrue();
    //     hilog.info(0x0000, 'testTag', '%{public}s', '8.2 crypto_auth_verify test passed');
    //
    //     // 8.3 crypto_auth_verify 失败测试
    //     const wrongMessage = nacl.encode_utf8("wrong message");
    //     const isInvalid = nacl.crypto_auth_verify(tag, wrongMessage, key);
    //     expect(isInvalid).assertFalse();
    //     hilog.info(0x0000, 'testTag', '%{public}s', '8.3 crypto_auth_verify failure test passed');
    //
    //     hilog.info(0x0000, 'testTag', '%{public}s', 'All auth tests passed');
    //   } catch (error) {
    //     hilog.error(0x0000, 'testTag', 'Auth test failed: %{public}s', error.message);
    //     expect(false).assertTrue();
    //   }
    // })
    //
    // // 9. 一次性认证测试
    // // 数据和main/pages/Index.ets的一样
    // it('onetimeAuthTest', 0, async () => {
    //   hilog.info(0x0000, 'testTag', '%{public}s', 'Onetime auth test started');
    //
    //   if (!nacl) {
    //     hilog.error(0x0000, 'testTag', '%{public}s', 'Nacl instance not initialized');
    //     expect(false).assertTrue();
    //     return;
    //   }
    //
    //   try {
    //     // 9.1 crypto_onetimeauth 测试
    //     const key = nacl.random_bytes(32);
    //     const message = nacl.encode_utf8("onetimeauth test message");
    //     const tag = nacl.crypto_onetimeauth(message, key);
    //     expect(tag.length).assertEqual(16);
    //     hilog.info(0x0000, 'testTag', '%{public}s', '9.1 crypto_onetimeauth test passed');
    //
    //     // 9.2 crypto_onetimeauth_verify 测试
    //     const isValid = nacl.crypto_onetimeauth_verify(tag, message, key);
    //     expect(isValid).assertTrue();
    //     hilog.info(0x0000, 'testTag', '%{public}s', '9.2 crypto_onetimeauth_verify test passed');
    //
    //     // 9.3 crypto_onetimeauth_verify 失败测试
    //     const wrongMessage = nacl.encode_utf8("wrong message");
    //     const isInvalid = nacl.crypto_onetimeauth_verify(tag, wrongMessage, key);
    //     expect(isInvalid).assertFalse();
    //     hilog.info(0x0000, 'testTag', '%{public}s', '9.3 crypto_onetimeauth_verify failure test passed');
    //
    //     hilog.info(0x0000, 'testTag', '%{public}s', 'All onetime auth tests passed');
    //   } catch (error) {
    //     hilog.error(0x0000, 'testTag', 'Onetime auth test failed: %{public}s', error.message);
    //     expect(false).assertTrue();
    //   }
    // })
  })
}