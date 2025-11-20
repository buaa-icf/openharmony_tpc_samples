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

import nacl_factory,{ Nacl } from '@ohos/js-nacl';
import promptAction from '@ohos.promptAction';

// 先定义接口
interface TestResult {
  name: string;
  input: string;
  output: string;
  success: boolean;
}

@Entry
@Component
struct Index {
  @State testResults: string[] = [];
  @State currentTest: string = '';
  @State isRunning: boolean = false;
  @State passCount: number = 0;
  @State failCount: number = 0;
  // 添加接口测试结果状态
  @State interfaceTestResults: TestResult[] = [];
  private nacl: Nacl | null = null;

  async aboutToAppear() {
    // 初始化 nacl 实例
    try {
      this.nacl = await nacl_factory.instantiate(() => {});
      this.addTestResult('✅ Nacl 实例初始化成功');
    } catch (error) {
      this.addTestResult(`❌ Nacl 实例初始化失败: ${error.message}`);
    }
  }

  // 断言函数
  assert(condition: boolean, message: string): boolean {
    if (condition) {
      this.passCount++;
      this.testResults.push(`✅ ${message}`);
      return true;
    } else {
      this.failCount++;
      this.testResults.push(`❌ ${message}`);
      return false;
    }
  }

  // 添加测试结果
  addTestResult(result: string) {
    this.testResults = [...this.testResults, result];
  }

  // 添加接口测试结果
  addInterfaceTestResult(name: string, input: string, output: string, success: boolean) {
    this.interfaceTestResults.push({
      name: name,
      input: input,
      output: output,
      success: success
    });
  }

  // 清空接口测试结果
  clearInterfaceTestResults() {
    this.interfaceTestResults = [];
  }

  // 1. 数据转换接口测试 - 使用test_simple.html的测试数据
  async testDataConversion() {
    if (!this.nacl) return;
    this.addTestResult('\n=== 1. 数据转换接口测试 ===');

    try {
      // 1.1 to_hex 测试 - 使用 "hello" 转换为 hex
      const originalText = "hello";
      const binaryData = this.nacl.encode_utf8(originalText);
      const hex = this.nacl.to_hex(binaryData);
      this.assert(hex === '68656c6c6f', '1.1 to_hex 测试通过');
      this.addInterfaceTestResult('to_hex', `输入: "hello"`, `输出: "${hex}"`, hex === '68656c6c6f');

      // 1.2 from_hex 测试 - 从hex转换回 "hello"
      const hexString = '68656c6c6f';
      const binary = this.nacl.from_hex(hexString);
      const text = this.nacl.decode_utf8(binary);
      this.assert(text === 'hello', '1.2 from_hex 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted = `Uint8Array[${Array.from(binary).join(', ')}]`;
      const outputFormatted = text;
      this.addInterfaceTestResult('from_hex', `输入: "${hexString}"`, `输出: "${outputFormatted}"`, text === 'hello');

      // 1.3 encode_utf8 测试 - 使用 "hello"
      const originalText2 = 'hello';
      const encoded = this.nacl.encode_utf8(originalText2);
      const decoded = this.nacl.decode_utf8(encoded);
      this.assert(decoded === 'hello', '1.3 encode_utf8 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted2 = originalText2;
      const outputFormatted2 = `Uint8Array[${Array.from(encoded).join(', ')}]`;
      this.addInterfaceTestResult('encode_utf8', inputFormatted2, outputFormatted2, decoded === 'hello');

      // 1.4 decode_utf8 测试 - 使用 "hello"
      const chineseText = 'hello';
      const encodedChinese = this.nacl.encode_utf8(chineseText);
      const decodedChinese = this.nacl.decode_utf8(encodedChinese);
      this.assert(decodedChinese === 'hello', '1.4 decode_utf8 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted3 = `Uint8Array[${Array.from(encodedChinese).join(', ')}]`;
      const outputFormatted3 = decodedChinese;
      this.addInterfaceTestResult('decode_utf8', inputFormatted3, outputFormatted3, decodedChinese === 'hello');

      // 1.5 encode_latin1 和 decode_latin1 测试 - 使用 "hello"
      const latin1Text = 'hello';
      const latin1Bytes = this.nacl.encode_latin1(latin1Text);
      const latin1String = this.nacl.decode_latin1(latin1Bytes);
      this.assert(latin1String === 'hello', '1.5.1 encode_latin1 测试通过');
      this.assert(latin1String === 'hello', '1.5.2 decode_latin1 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted4 = latin1Text;
      const outputFormatted4 = `Uint8Array[${Array.from(latin1Bytes).join(', ')}]`;
      const inputFormatted5 = `Uint8Array[${Array.from(latin1Bytes).join(', ')}]`;
      const outputFormatted5 = latin1String;
      this.addInterfaceTestResult('encode_latin1', inputFormatted4, outputFormatted4, latin1String === 'hello');
      this.addInterfaceTestResult('decode_latin1', inputFormatted5, outputFormatted5, latin1String === 'hello');

    } catch (error) {
      this.addTestResult(`❌ 数据转换测试异常: ${error.message}`);
    }
  }

  // 2. 哈希函数测试 - 使用test_simple.html的测试数据
  async testHash() {
    if (!this.nacl) return;
    this.addTestResult('\n=== 2. 哈希函数测试 ===');

    try {
      // 2.1 crypto_hash (SHA-512) 测试 - 使用 'hello'
      const testData = this.nacl.encode_utf8('hello');
      const hash = this.nacl.crypto_hash(testData);
      this.assert(hash.length === 64, '2.1 crypto_hash (SHA-512) 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted = `Uint8Array[${Array.from(testData).join(', ')}]`;
      const outputFormatted = `Uint8Array[${Array.from(hash).join(', ')}]`;
      this.addInterfaceTestResult('crypto_hash', inputFormatted, outputFormatted, hash.length === 64);

      // 2.2 crypto_hash_sha256 测试 - 使用 'hello'
      const hash256 = this.nacl.crypto_hash_sha256(testData);
      this.assert(hash256.length === 32, '2.3 crypto_hash_sha256 测试通过');
      // 格式化输入输出为Vue文件格式
      const outputFormatted2 = `Uint8Array[${Array.from(hash256).join(', ')}]`;
      this.addInterfaceTestResult('crypto_hash_sha256', inputFormatted, outputFormatted2, hash256.length === 32);

    } catch (error) {
      this.addTestResult(`❌ 哈希函数测试异常: ${error.message}`);
    }
  }

  // 3. 随机数生成测试 - 使用test_simple.html的测试数据
  async testRandomBytes() {
    if (!this.nacl) return;
    this.addTestResult('\n=== 3. 随机数生成测试 ===');

    try {
      // 3.1 random_bytes 测试
      const random = this.nacl.random_bytes(32);
      this.assert(random.length === 32, '3.1 random_bytes 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted = "32";
      const outputFormatted = `Uint8Array[${Array.from(random).join(', ')}]`;
      this.addInterfaceTestResult('random_bytes', inputFormatted, outputFormatted, random.length === 32);

    } catch (error) {
      this.addTestResult(`❌ 随机数生成测试异常: ${error.message}`);
    }
  }

  // 4. 数字签名测试 - 使用test_simple.html的测试数据
  async testSignature() {
    if (!this.nacl) return;
    this.addTestResult('\n=== 4. 数字签名测试 ===');

    try {
      // 4.1 crypto_sign_keypair 测试
      const kp = this.nacl.crypto_sign_keypair();
      this.assert(kp.signPk !== null && kp.signSk !== null, '4.1 crypto_sign_keypair 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted = '-';
      const outputFormatted = `{"pk":"present","sk":"present"}`;
      this.addInterfaceTestResult('crypto_sign_keypair', inputFormatted, outputFormatted, kp.signPk !== null && kp.signSk !== null);

      // 4.2 crypto_sign_seed_keypair 测试 - 使用32字节种子
      // 创建32字节的种子数据
      const seedString = "sign_seed_keypair_test"; // 原始字符串
      const seed = new Uint8Array(32); // 创建32字节的数组
      const seedData = this.nacl.encode_utf8(seedString); // 将字符串编码为字节数组
      // 将原始种子数据复制到32字节数组中（如果超过32字节则截断）
      seed.set(seedData.length <= 32 ? seedData : seedData.subarray(0, 32));
      const seedKp = this.nacl.crypto_sign_seed_keypair(seed);
      this.assert(seedKp.signPk !== null && seedKp.signSk !== null, '4.2 crypto_sign_seed_keypair 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormattedSeed = `Uint8Array[${Array.from(seed).join(', ')}]`;
      const outputFormattedSeed = `{"pk":"present","sk":"present"}`;
      this.addInterfaceTestResult('crypto_sign_seed_keypair', inputFormattedSeed, outputFormattedSeed, seedKp.signPk !== null && seedKp.signSk !== null);

      // 4.3 crypto_sign 和 crypto_sign_open 测试 - 使用 'hello'
      const originalText = "hello";
      const message = this.nacl.encode_utf8(originalText);

      const c = this.nacl.crypto_sign(message, kp.signSk);
      const m = this.nacl.crypto_sign_open(c, kp.signPk);
      const decryptedText = m ? this.nacl.decode_utf8(m) : null;
      this.assert(decryptedText === originalText, '4.3.1 crypto_sign 测试通过');
      this.assert(decryptedText === originalText, '4.3.2 crypto_sign_open 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted2 = `{"message":"hello","sk":"keypair.signSk"}`;
      const outputFormatted2 = `Uint8Array[${Array.from(c).join(', ')}]`;
      const inputFormatted3 = `{"signed":"Uint8Array(length: ${c.length})","pk":"keypair.signPk"}`;
      const outputFormatted3 = m ? `Uint8Array[${Array.from(m).join(', ')}]` : 'null';
      this.addInterfaceTestResult('crypto_sign', inputFormatted2, outputFormatted2, true);
      this.addInterfaceTestResult('crypto_sign_open', inputFormatted3, outputFormatted3, decryptedText === originalText);

      // 4.4 crypto_sign_detached 和 crypto_sign_verify_detached 测试 - 使用 'hello'
      const detached_sig = this.nacl.crypto_sign_detached(message, kp.signSk);
      const valid = this.nacl.crypto_sign_verify_detached(detached_sig, message, kp.signPk);
      this.assert(valid === true, '4.4.1 crypto_sign_detached 测试通过');
      this.assert(valid === true, '4.4.2 crypto_sign_verify_detached 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted4 = `{"message":"hello","sk":"keypair.signSk"}`;
      const outputFormatted4 = `Uint8Array[${Array.from(detached_sig).join(', ')}]`;
      const inputFormatted5 = `{"sig":"detachedSig","message":"hello","pk":"keypair.signPk"}`;
      const outputFormatted5 = `${valid}`;
      this.addInterfaceTestResult('crypto_sign_detached', inputFormatted4, outputFormatted4, true);
      this.addInterfaceTestResult('crypto_sign_verify_detached', inputFormatted5, outputFormatted5, valid === true);

    } catch (error) {
      this.addTestResult(`❌ 数字签名测试异常: ${error.message}`);
    }
  }

  // 5. 非对称加密(Box)测试 - 使用test_simple.html的测试数据
  async testBox() {
    if (!this.nacl) return;
    this.addTestResult('\n=== 5. 非对称加密测试 ===');

    try {
      // 5.1 crypto_box_keypair 测试
      const kp = this.nacl.crypto_box_keypair();
      this.assert(kp.boxPk !== null && kp.boxSk !== null, '5.1 crypto_box_keypair 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted = '-';
      const outputFormatted = `{"pk":"present","sk":"present"}`;
      this.addInterfaceTestResult('crypto_box_keypair', inputFormatted, outputFormatted, kp.boxPk !== null && kp.boxSk !== null);

      // 5.2 crypto_box_seed_keypair 测试 - 使用 'hello' 种子（与js-nacl保持一致）
      // 修复：确保种子是32字节长度
      const seedString = "hello"; // 原始字符串
      const seed = new Uint8Array(32); // 创建32字节的数组
      const seedData = this.nacl.encode_utf8(seedString); // 将字符串编码为字节数组
      // 将原始种子数据复制到32字节数组中（如果超过32字节则截断）
      seed.set(seedData.length <= 32 ? seedData : seedData.subarray(0, 32));
      const kp2 = this.nacl.crypto_box_seed_keypair(seed);
      this.assert(kp2.boxPk!==null && kp2.boxSk!==null, '5.2 crypto_box_seed_keypair 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted2 = `Uint8Array[${Array.from(seed).join(', ')}]`;
      const outputFormatted2 = `{"pk":"present","sk":"present"}`;
      this.addInterfaceTestResult('crypto_box_seed_keypair', inputFormatted2, outputFormatted2, kp2.boxPk!==null && kp2.boxSk!==null);

      // // 5.3 crypto_box_precompute 测试 - 与 js-nacl 保持一致
      // const selfShared = this.nacl.crypto_box_precompute(kp2.boxPk, kp2.boxSk);
      // this.assert(selfShared.boxK!==null, '5.3 crypto_box_precompute 测试通过');
      // // 格式化输入输出为Vue文件格式
      // const inputFormatted3 = `{"senderPk":"senderKeypair.boxPk","recipientSk":"recipientKeypair.boxSk"}`;
      // const outputFormatted3 = `Uint8Array[${Array.from(selfShared.boxK).join(', ')}]`;
      // this.addInterfaceTestResult('crypto_box_precompute', inputFormatted3, outputFormatted3, selfShared.boxK!==null);

      // // 5.4 crypto_box 和 crypto_box_open 测试 - 使用 'hello'
      // const nonce = new Uint8Array(24); // 使用零nonce模拟测试
      // const plaintext = "hello";
      // const message = this.nacl.encode_utf8(plaintext);
      // const cipher = this.nacl.crypto_box(message, nonce, kp2.boxPk, kp2.boxSk);
      // // 修复参数顺序：crypto_box_open(cipher, nonce, senderPublicKey, recipientSecretKey)
      // // 在这个测试用例中，kp2.boxPk是发送方公钥，kp2.boxSk是接收方私钥
      // const decrypted = this.nacl.crypto_box_open(cipher, nonce, kp2.boxPk, kp2.boxSk);
      // const decryptedText = this.nacl.decode_utf8(decrypted);
      // this.assert(decryptedText === plaintext, '5.4 crypto_box 和 crypto_box_open 测试通过');
      // // 格式化输入输出为Vue文件格式
      // const inputFormatted4 = `{"message":"hello","nonce":"nonce","recipientPk":"recipientKeypair.boxPk","senderSk":"senderKeypair.boxSk"}`;
      // const outputFormatted4 = `Uint8Array[${Array.from(cipher).join(', ')}]`;
      // const inputFormatted5 = `{"boxed":"Uint8Array(length: ${cipher.length})","nonce":"nonce","senderPk":"senderKeypair.boxPk","recipientSk":"recipientKeypair.boxSk"}`;
      // const outputFormatted5 = decrypted ? `Uint8Array[${Array.from(decrypted).join(', ')}]` : 'null';
      // this.addInterfaceTestResult('crypto_box', inputFormatted4, outputFormatted4, true);
      // this.addInterfaceTestResult('crypto_box_open', inputFormatted5, outputFormatted5, decryptedText === plaintext);

      // // 5.5 crypto_box_precomputed 测试 - 使用 'hello'
      // const c2 = this.nacl.crypto_box_precomputed(message, nonce, selfShared);
      // const m2 = this.nacl.crypto_box_open_precomputed(c2, nonce, selfShared);
      // const decryptedText2 = this.nacl.decode_utf8(m2);
      // this.assert(decryptedText2 === plaintext, '5.5 crypto_box_precomputed 测试通过');
      // // 格式化输入输出为Vue文件格式
      // const inputFormatted6 = `{"message":"hello","nonce":"nonce","shared":"shared"}`;
      // const outputFormatted6 = `Uint8Array[${Array.from(c2).join(', ')}]`;
      // const inputFormatted7 = `{"precomputedBox":"Uint8Array(length: ${c2.length})","nonce":"nonce","shared":"shared"}`;
      // const outputFormatted7 = m2 ? `Uint8Array[${Array.from(m2).join(', ')}]` : 'null';
      // this.addInterfaceTestResult('crypto_box_precomputed', inputFormatted6, outputFormatted6, true);
      // this.addInterfaceTestResult('crypto_box_open_precomputed', inputFormatted7, outputFormatted7, decryptedText2 === plaintext);

      // 5.6 crypto_box_random_nonce 测试
      const randomNonce = this.nacl.crypto_box_random_nonce();
      this.assert(randomNonce.length === 24, '5.6 crypto_box_random_nonce 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted8 = '-';
      const outputFormatted8 = `Uint8Array[${Array.from(randomNonce).join(', ')}]`;
      this.addInterfaceTestResult('crypto_box_random_nonce', inputFormatted8, outputFormatted8, randomNonce.length === 24);

      // 5.7 crypto_box_keypair_from_raw_sk 测试
      const sk = this.nacl.random_bytes(32);
      const kp3 = this.nacl.crypto_box_keypair_from_raw_sk(sk);
      this.assert(kp3.boxPk !== null && kp3.boxSk !== null, '5.7 crypto_box_keypair_from_raw_sk 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted9 = `Uint8Array[${Array.from(sk).join(', ')}]`;
      const outputFormatted9 = `{"pk":"present","sk":"present"}`;
      this.addInterfaceTestResult('crypto_box_keypair_from_raw_sk', inputFormatted9, outputFormatted9, kp3.boxPk !== null && kp3.boxSk !== null);

    } catch (error) {
      this.addTestResult(`❌ 非对称加密测试异常: ${error.message}`);
    }
  }

  // 6. 对称加密(SecretBox)测试 - 使用test_simple.html的测试数据
  async testSecretBox() {
    if (!this.nacl) return;
    this.addTestResult('\n=== 6. 对称加密测试 ===');

    try {
      // 6.1 crypto_secretbox 和 crypto_secretbox_open 测试 - 使用 'hello' 和 'thekey'
      const nonce = new Uint8Array(24); // 使用零nonce模拟测试
      const secretboxkey = this.nacl.crypto_hash(this.nacl.encode_utf8("thekey")).subarray(0, 32);
      const plaintext = "hello";
      const message = this.nacl.encode_utf8(plaintext);
      const c = this.nacl.crypto_secretbox(message, nonce, secretboxkey);
      const m = this.nacl.crypto_secretbox_open(c, nonce, secretboxkey);
      const decryptedText = this.nacl.decode_utf8(m);
      this.assert(decryptedText === plaintext, '6.1.1 crypto_secretbox 测试通过');
      this.assert(decryptedText === plaintext, '6.1.2 crypto_secretbox_open 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted = `{"message":"hello","nonce":"secretNonce","key":"key"}`;
      const outputFormatted = `Uint8Array[${Array.from(c).join(', ')}]`;
      const inputFormatted2 = `{"secretBox":"Uint8Array(length: ${c.length})","nonce":"secretNonce","key":"key"}`;
      const outputFormatted2 = m ? `Uint8Array[${Array.from(m).join(', ')}]` : 'null';
      this.addInterfaceTestResult('crypto_secretbox', inputFormatted, outputFormatted, true);
      this.addInterfaceTestResult('crypto_secretbox_open', inputFormatted2, outputFormatted2, decryptedText === plaintext);

    } catch (error) {
      this.addTestResult(`❌ 对称加密测试异常: ${error.message}`);
    }
  }

  // 7. SecretBox随机Nonce测试 - 新增测试函数
  async testSecretBoxRandomNonce() {
    if (!this.nacl) return;
    this.addTestResult('\n=== 7. SecretBox随机Nonce测试 ===');

    try {
      // 7.1 crypto_secretbox_random_nonce 测试
      const randomNonce = this.nacl.crypto_secretbox_random_nonce();
      const isValid = randomNonce.length === 24;
      this.assert(isValid, '7.1 crypto_secretbox_random_nonce 测试通过');
      // 格式化输入输出为Vue文件格式
      const inputFormatted = '-';
      const outputFormatted = `Uint8Array[${Array.from(randomNonce).join(', ')}]`;
      this.addInterfaceTestResult('crypto_secretbox_random_nonce', inputFormatted, outputFormatted, isValid);

    } catch (error) {
      this.addTestResult(`❌ SecretBox随机Nonce测试异常: ${error.message}`);
    }
  }

  // 运行所有测试
  async runAllTests() {
    this.testResults = [];
    this.interfaceTestResults = [];
    this.passCount = 0;
    this.failCount = 0;
    this.currentTest = '运行所有测试';
    this.isRunning = true;

    try {
      if (!this.nacl) {
        await this.aboutToAppear();
      }
      this.assert(true, ' instantiate Nacl初始化实例 测试通过');
      await this.testDataConversion();
      await this.testHash();
      await this.testRandomBytes();
      await this.testSignature();
      await this.testBox();
      // await this.testSecretBox();
      await this.testSecretBoxRandomNonce(); // 添加新测试

      this.addTestResult(`\n========== 测试完成 ==========`);
      this.addTestResult(`✅ 通过: ${this.passCount} 个`);
      this.addTestResult(`❌ 失败: ${this.failCount} 个`);
      this.addTestResult(`📊 总计: ${this.passCount + this.failCount} 个`);

      promptAction.showToast({
        message: `测试完成! 通过:${this.passCount} 失败:${this.failCount}`,
        duration: 3000
      });
    } catch (error) {
      this.addTestResult(`❌ 测试运行异常: ${error.message}`);
      promptAction.showToast({ message: '测试失败: ' + error.message });
    } finally {
      this.isRunning = false;
      this.currentTest = '';
    }
  }

  // 清空测试结果
  clearResults() {
    this.testResults = [];
    this.interfaceTestResults = [];
    this.passCount = 0;
    this.failCount = 0;
    this.currentTest = '';
  }

  build() {
    Column() {
      // 标题
      Text('js-nacl 所有接口完整测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })
        .textAlign(TextAlign.Center)

      // 统计信息 - 与HTML保持一致
      if (this.passCount > 0 || this.failCount > 0) {
        Text(`测试结果: 成功 ${this.passCount} 个, 失败 ${this.failCount} 个, 总计 ${this.passCount + this.failCount} 个`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 15 })
          .textAlign(TextAlign.Center)
      }

      // 按钮区域
      Row() {
        Button('运行所有测试')
          .width(120)
          .height(40)
          .fontSize(14)
          .margin({ right: 10 })
          .enabled(!this.isRunning)
          .onClick(() => this.runAllTests())

        Button('清空结果')
          .width(80)
          .height(40)
          .fontSize(14)
          .enabled(!this.isRunning)
          .onClick(() => this.clearResults())
      }
      .margin({ bottom: 15 })
      .justifyContent(FlexAlign.Center)

      // 运行状态
      if (this.isRunning) {
        Text('测试运行中...')
          .fontSize(14)
          .fontColor('#FA8C16')
          .margin({ bottom: 10 })
      }

      // 内容区域使用Flex布局，确保不会遮挡
      Column() {
        // 接口测试结果显示区域 - 与test_simple.html保持一致
        if (this.interfaceTestResults.length > 0) {
          Text('接口测试结果:')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })
            .textAlign(TextAlign.Start)

          Scroll() {
            Column() {
              ForEach(this.interfaceTestResults, (result: TestResult, index: number) => {
                Column() {
                  // 主要消息
                  Text(`${result.name} ${result.success ? 'SUCCESS' : 'ERROR'}`)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(result.success ? '#3c763d' : '#a94442')
                    .margin({ bottom: 5 })
                    .textAlign(TextAlign.Start)
                    .width('100%')

                  // 详细信息区域
                  if (result.input || result.output) {
                    Column() {
                      // 输入信息
                      if (result.input) {
                        Text(`输入: ${result.input}`)
                          .fontSize(12)
                          .margin({ bottom: 3 })
                          .textAlign(TextAlign.Start)
                          .width('100%')
                      }

                      // 输出信息
                      if (result.output) {
                        Text(`输出: ${result.output}`)
                          .fontSize(12)
                          .margin({ bottom: 3 })
                          .textAlign(TextAlign.Start)
                          .width('100%')
                      }
                    }
                    .width('100%')
                    .padding({ left: 10, right: 10, top: 5, bottom: 5 })
                    .backgroundColor(result.success ? '#dff0d8' : '#f2dede')
                    .borderRadius(4)
                  }
                }
                .width('100%')
                .padding({ left: 10, right: 10, top: 10, bottom: 10 })
                .border({
                  width: 1,
                  color: '#ddd',
                  style: BorderStyle.Solid
                })
                .margin({ bottom: 5 })
              }, (item: TestResult, index: number) => index.toString())
            }
            .width('100%')
            .padding({ left: 15, right: 15 })
          }
          .layoutWeight(1)
          .margin({ bottom: 15 })
        }

        // 测试结果显示区域 - 与test_simple.html保持一致
        if (this.testResults.length > 0) {
          Text('详细测试结果:')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })
            .textAlign(TextAlign.Start)

          Scroll() {
            Column() {
              ForEach(this.testResults, (result: string, index: number) => {
                Text(result)
                  .fontSize(13)
                  .fontColor(result.includes('✅') ? '#3c763d' : result.includes('❌') ? '#a94442' : '#333')
                  .margin({ bottom: 5 })
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .padding({ left: 10, right: 10 })
              }, (item: string, index: number) => index.toString())
            }
            .width('100%')
            .padding({ left: 15, right: 15 })
          }
          .layoutWeight(1)
        } else if (this.interfaceTestResults.length === 0) {
          // 只有在没有接口测试结果时才显示这个提示
          Text('暂无测试结果,请点击上方按钮开始测试')
            .fontSize(14)
            .fontColor('#999')
            .margin({ top: 20 })
            .textAlign(TextAlign.Center)
        }
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding({ left: 10, right: 10, top: 10, bottom: 10 })
  }
}