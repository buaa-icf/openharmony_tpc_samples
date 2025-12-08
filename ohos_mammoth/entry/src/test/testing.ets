import fs from '@ohos.file.fs';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { readFile } from '../../../main/ets/utils/FileUtils';
import { buffer as Buffer, util } from '@kit.ArkTS';
import underscore from 'underscore';

const _: ESObject = underscore;

export const testPath = (filename: string): string => {
  return "test-data/" + filename
}

export const testData = (testDataPath: string): string=> {
  const delegator = abilityDelegatorRegistry.getAbilityDelegator();
  // 获取测试上下文
  const context = delegator.getAppContext();

  let fullPath = testPath(testDataPath);
  let data =   context.resourceManager.getRawFileContentSync(fullPath);
  let textDecoderOptions: util.TextDecoderOptions = {
    fatal: false,
    ignoreBOM: true
  }
  let textDecoder = util.TextDecoder.create("utf-8", textDecoderOptions);
  let str = textDecoder.decodeToString(data)
  return str;
}

interface DocxFile {
  read: Promise<ESObject>
  exists: (path: string) => ESObject

}

export const createFakeDocxFile = (files: ESObject) => {
  const exists = (path: string) => {
    return !!files[path];
  }

  let res: DocxFile = {
    read: createRead(files),
    exists: exists
  };
  return res
}

const createRead = (files: ESObject): ESObject => {
  const read = (path: string, encoding: string): ESObject => {
    const fileContent:ESObject = files[path];

    return Promise.resolve(fileContent).then((buffer: Buffer.Buffer):ESObject=> {
      if (typeof buffer === 'string') {
        buffer = Buffer.from(buffer);
      }

      if (!Buffer.isBuffer(buffer)) {
        return Promise.reject(new Error("file was not a buffer"));
      } else if (encoding) {
        return Promise.resolve(buffer.toString(encoding));
      } else {
        // 注意：buffer.buffer 返回的是底层的 ArrayBuffer
        // 如果没有这个属性，直接返回 buffer
        return Promise.resolve(buffer.buffer || buffer);
      }
    });
  }
  return read;
}


