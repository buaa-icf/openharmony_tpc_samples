/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
const DOMAIN = 0xFE42;
const TAG = 'OHOS_NTP';

import { socket } from '@kit.NetworkKit';
import buffer from '@ohos.buffer';
import { BusinessError } from '@ohos.base';
import { hilog } from '@kit.PerformanceAnalysisKit';

export const getNetworkTime = (config: NTPConfig): Promise<Date> => {
  return new Promise<Date>((resolve, reject) => {
    hilog.info(DOMAIN, TAG, "getNetworkTime: config is %{public}s", JSON.stringify(config));
    let udp: socket.UDPSocket = socket.constructUDPSocketInstance();
    let netAddress: socket.NetAddress = {
      address: config.server,
      port: config.port,
      family: 1
    };

    const delayTime = setTimeout(() => {
      udp.close();
      hilog.error(DOMAIN, TAG, "getNetworkTime: NTP response not received within the expected timeframe.");
      reject('NTP response not received within the expected timeframe.');
      isTimeoutTriggered = true;
    }, config.delayTime);

    udp.bind({
      address: '0.0.0.0', port: 1234, family: 1
    }, (err) => {
      if (err) {
        hilog.error(DOMAIN, TAG, "getNetworkTime: udp bind err! err is %{public}s", JSON.stringify(err));
        reject(err.message);
      }
    });

    let isTimeoutTriggered = false;

    udp.on('error', err => {
      hilog.error(DOMAIN, TAG, "getNetworkTime: udp connect err! err is %{public}s", JSON.stringify(err));
      if (isTimeoutTriggered) {
        return;
      }
      isTimeoutTriggered = true;
      clearTimeout(delayTime);
      reject(err.message);
    });

    udp.on('message', message => {
      hilog.info(DOMAIN, TAG, "getNetworkTime: udp recv msg, msg is %{public}s", JSON.stringify(message));
      const messageBuffer = buffer.from(message.message);
      clearTimeout(delayTime);
      udp.close();

      const transmitTimeOffset = 40;

      const integerPart = Array(4).fill(0).reduce((accumulator, _, index) => {
        return 256 * accumulator + messageBuffer[transmitTimeOffset + index];
      }, 0);

      const fractionalPart = Array(4).fill(0).reduce((accumulator, _, index) => {
        return 256 * accumulator + messageBuffer[transmitTimeOffset + 4 + index];
      }, 0);

      const totalMilliseconds = integerPart * 1000 + (fractionalPart * 1000) / 0x100000000;
      const referenceDate = new Date(Date.UTC(1900, 0, 1));
      hilog.info(DOMAIN, TAG, "getNetworkTime: get timestamp is %{public}d", totalMilliseconds);
      referenceDate.setUTCMilliseconds(referenceDate.getUTCMilliseconds() + totalMilliseconds);
      hilog.info(DOMAIN, TAG, "getNetworkTime: set Date is %{public}s", referenceDate.toString());
      resolve(referenceDate);
    });

    const ntpData = buffer.alloc(48);
    ntpData[0] = 0x1b;
    const arrayBufferNtpData = ntpData.buffer;

    udp.send({
      data: arrayBufferNtpData, address: netAddress
    }, (err: BusinessError) => {
      if (err) {
        hilog.error(DOMAIN, TAG, "getNetworkTime: udp send err! err is %{public}s", JSON.stringify(err));
        if (isTimeoutTriggered) {
          return;
        }
        clearTimeout(delayTime);
        isTimeoutTriggered = true;
        udp.close();
        reject(JSON.stringify(err.message));
      }
    });
  })
}

export interface NTPConfig {
  server: string;
  port: number;
  delayTime: number;
}