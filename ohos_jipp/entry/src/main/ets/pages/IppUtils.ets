/*
  * Copyright (c) 2025 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

import { http } from '@kit.NetworkKit';
import { JobState, Tag, Types, URI } from 'jsipp';
import { Name } from 'jsipp';
import { Operation } from 'jsipp';
import { IppPacket } from 'jsipp';

/**
 * 查询打印机属性
 * @param printerIpAddress 打印机IP
 * @param callback 查询结果回调函数
 */
export function queryPrinterAttributes(
  printerIpAddress: String,
  callback: (ippPacket: IppPacket | null, error: Error | null) => void
) {
  console.log(`Call queryPrinterAttributes(${printerIpAddress})`)

  // 创建一个用来查询打印机所有属性的IppPacket
  let queryIppPacket = new IppPacket.Builder(Operation.Code.getPrinterAttributes)
    .putOperationAttributes([
      Types.printerUri.of(new URI(`ipps://${printerIpAddress}:631/ipp/print`)),
      Types.requestingUserName.of(new Name("HarmonyOS", null)),
      Types.requestedAttributes.of(["all"])
    ]).build()

  ippRequest(printerIpAddress, queryIppPacket)
    .then((ippPacket) => {
      callback(ippPacket, null)
    })
    .catch((error: Error) => {
      callback(null, error)
    })
}

/**
 * 发送打印任务请求
 * @param printerIpAddress 打印机IP
 * @param content 打印内容
 * @param callback 打印任务结果的回调函数
 */
export function printJob(
  printerIpAddress: String,
  content: Promise<Uint8Array>,
  callback: (ippPacket: IppPacket | null, error: Error | null) => void
) {
  content.then((documentData: Uint8Array) => {
    console.log(`Call printJob(${printerIpAddress}, content(${documentData.length}))`)

    // 创建一个用来发送打印任务的IppPacket
    let printJobIppPacket = new IppPacket.Builder(Operation.Code.printJob)
      .putOperationAttributes([
        Types.printerUri.of(new URI(`ipps://${printerIpAddress}:631/ipp/print`)),
        Types.requestingUserName.of(new Name("HarmonyOS", null)),
        Types.documentFormat.of("application/octet-stream")
      ]).build()
    return [printJobIppPacket, documentData]
  }).then((extraData) => {
    return ippRequest(printerIpAddress, extraData[0] as IppPacket, extraData[1] as Uint8Array)
  }).then((ippPacket: IppPacket) => {
    callback(ippPacket, null)
    // 获取打印任务的属性
    let jobAttributes = ippPacket?.get(Tag.Companion.jobAttributes)
    if (jobAttributes) {
      // 获取打印任务的任务ID
      let jobId = jobAttributes.getValue(Types.jobId)
      if (jobId) {
        // 轮询打印任务的状态
        rollJobState(printerIpAddress, jobId, callback)
      }
    }
  }).catch((error: Error) => {
    callback(null, error)
  })
}

/**
 * 发送取消打印任务请求
 * @param printerIpAddress 打印机IP
 * @param jobId 打印任务ID
 * @param callback 取消任务结果的回调函数
 */
export function cancelJob(
  printerIpAddress: String,
  jobId: number,
  callback: (ippPacket: IppPacket | null, error: Error | null) => void
) {
  console.log(`Call cancelJob(${printerIpAddress}, jobId(${jobId}))`)
  // 创建一个取消打印任务的IppPacket
  let cancelJobIppPacket = new IppPacket.Builder(Operation.Code.cancelJob)
    .putOperationAttributes([
      Types.printerUri.of(new URI(`ipps://${printerIpAddress}:631/ipp/print`)),
      Types.requestingUserName.of(new Name("HarmonyOS", null)),
      Types.jobId.of(jobId)
    ]).build()
  ippRequest(printerIpAddress, cancelJobIppPacket)
    .then((ippPacket) => {
      callback(ippPacket, null)
    })
    .catch((error: Error) => {
      callback(null, error)
    })
}

/**
 * 轮询打印任务的状态
 * @param printerIpAddress 打印机IP
 * @param jobId 打印任务ID
 * @param callback 轮询打印任务结果的回调函数
 */
function rollJobState(
  printerIpAddress: String,
  jobId: number,
  callback: (ippPacket: IppPacket | null, error: Error | null) => void
) {
  let timer = setInterval(() => {
    console.log(`Call rollJobState(${printerIpAddress}, jobId(${jobId}))`)
    // 打印任务完成时的三种状态吗
    let jobCompleted = [JobState.Code.completed, JobState.Code.canceled, JobState.Code.aborted]
    // 创建一个查询打印任务状态的IppPacket
    let getJobAttrIppPacket = new IppPacket.Builder(Operation.Code.getJobAttributes)
      .putOperationAttributes([
        Types.printerUri.of(new URI(`ipps://${printerIpAddress}:631/ipp/print`)),
        Types.jobId.of(jobId),
        Types.requestedAttributes.of(["all"])
      ]).build()
    ippRequest(printerIpAddress, getJobAttrIppPacket)
      .then((ippPacket: IppPacket) => {
        // 获取打印任务当前的状态码
        let jobAttributes = ippPacket?.get(Tag.Companion.jobAttributes)
        let jobStateCode = jobAttributes?.getValue(Types.jobState)?.code
        if (jobStateCode && jobCompleted.indexOf(jobStateCode) != -1) {
          // 打印任务完成时取消轮询
          clearInterval(timer)
        }
        callback(ippPacket, null)
      })
      .catch((error: Error) => {
        callback(null, error)
      })
  }, 2000)
}

/**
 * 发送IPP请求
 * @param ipAddress 打印机IP
 * @param ippPacket IPP请求
 * @param documentData 打印任务的内容
 * @param timeout 发送打印任务时需要花费更多时间
 */
function ippRequest(
  ipAddress: String,
  ippPacket: IppPacket,
  documentData: Uint8Array | null = null,
  timeout: number = 10000
): Promise<IppPacket> {
  return new Promise<IppPacket>((resolve: Function, reject: Function) => {
    let url = `http://${ipAddress}:631/ipp/print`
    console.log(`<--- Request(${url}): \n${ippPacket.prettyPrint(100, "  ")}`)

    let extraData = ippPacket.toIpp()
    if (documentData) {
      const newRes = new ArrayBuffer(extraData.byteLength + documentData.byteLength);
      const resView = new Uint8Array(newRes);
      resView.set(extraData);
      resView.set(documentData, extraData.byteLength);
      extraData = resView
    }

    let httpRequest = http.createHttp();
    let res = new ArrayBuffer(0);
    httpRequest.on('dataReceive', (data: ArrayBuffer) => {
      const newRes = new ArrayBuffer(res.byteLength + data.byteLength);
      const resView = new Uint8Array(newRes);
      resView.set(new Uint8Array(res));
      resView.set(new Uint8Array(data), res.byteLength);
      res = newRes;
    });
    httpRequest.on('dataEnd', () => {
      console.info('No more data in response, data receive end');
      // 解析IPP数据包
      let ippPacket = IppPacket.fromIpp(new Uint8Array(res))
      console.log(`---> Response(${url}): \n${ippPacket.prettyPrint(100, "  ")}`)
      resolve(ippPacket)
    });

    let streamInfo: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: {
        // 表示这是一个IPP请求
        'Content-Type': 'application/ipp'
      },
      // IPP请求的内容
      extraData: extraData.buffer,
      connectTimeout: 10000,
      readTimeout: timeout,
    }

    httpRequest.requestInStream(url, streamInfo)
      .then(() => {
        httpRequest.off('dataReceive');
        httpRequest.off('dataEnd');
        httpRequest.destroy();
      }).catch((err: Error) => {
      console.info("requestInStream ERROR : err = " + JSON.stringify(err))
      reject(err)
    })
  })
}