/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { afterAll, beforeAll, describe, expect, it } from '@ohos/hypium';
import { libssh, SSH_KEYTYPES } from '@ohos/libssh';
import GlobalContext from './GlobalContext';


export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    let filesDir: string;
    let privateKeyPath: string;
    let publicKeyPath: string;
    let port: number = 9999;
    let sshServerIP: string = "47.122.65.73";

    beforeAll(() => {
      filesDir = GlobalContext.getContext().getValue('filesDir') as string;
      privateKeyPath = filesDir + "/privateKey";
      publicKeyPath = filesDir + "/publicKey";
    })

    it('TEST_keygen', 0, () => {
      let ssh2Napi = new libssh();
      let result = ssh2Napi.keygen(privateKeyPath, publicKeyPath, SSH_KEYTYPES.SSH_KEYTYPE_ECDSA);
      expect(result === 0).assertTrue()
    })

    it('TEST_setUser', 0, () => {
      let ssh2Napi = new libssh();
      let result = ssh2Napi.setUser("username", "password");
      expect(result === 0).assertTrue()
    })

    it('TEST_setSFTPKeyexChangeCer', 0, () => {
      let ssh2Napi = new libssh();
      let result = ssh2Napi.setSFTPKeyexChangeCer("curve25519-sha256");
      expect(result === 0).assertTrue()
    })

    it('TEST_setSFTPServerCer', 0, () => {
      let ssh2Napi = new libssh();
      let result = ssh2Napi.setSFTPServerCer("aes256-ctr,aes128-ctr,aes192-ctr");
      expect(result === 0).assertTrue()
    })

    it('TEST_getPublicKeyFingerprint', 0, async () => {
      let ssh2Napi = new libssh();
      ssh2Napi.keygen(privateKeyPath, publicKeyPath, SSH_KEYTYPES.SSH_KEYTYPE_ECDSA);
      let result = await ssh2Napi.getPublicKeyFingerprint(publicKeyPath);
      expect(result.length > 0).assertTrue()
    })

    it('TEST_startSFTPServer', 0, () => {
      let ssh2Napi = new libssh();
      let callback = (type: number) => {
        if (type === 2) {
          expect(type === 2).assertTrue()
        } else if (type === 3) {
          expect().assertFail()
        }
      }
      ssh2Napi.setUser("myuser", "mypassword");
      ssh2Napi.keygen(privateKeyPath, publicKeyPath, SSH_KEYTYPES.SSH_KEYTYPE_ECDSA);
      ssh2Napi.startSFTPServer(privateKeyPath, publicKeyPath, port, callback);
      setTimeout(()=>{
      },10000)
    })

    it('TEST_startSSHClient', 0, () => {
      let ssh2Napi = new libssh();
      let is_start: boolean = false;
      ssh2Napi.setUser("myuser", "mypassword");
      ssh2Napi.keygen(privateKeyPath, publicKeyPath, SSH_KEYTYPES.SSH_KEYTYPE_ECDSA);
      ssh2Napi.startSSHClient(sshServerIP, port, privateKeyPath, (type: number) => {
        if (type === 0) {
          is_start = true
        } else {
          is_start = false
        }
      });
      setTimeout(()=>{
        expect(is_start).assertEqual(true);
      },2000)
    })

  })
}