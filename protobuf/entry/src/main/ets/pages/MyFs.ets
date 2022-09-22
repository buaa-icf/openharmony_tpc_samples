/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import fileIO from "@ohos.fileio";
import util from '@ohos.util';

export class MyFs {

  public static switchProtoBufFetch(protobuf:any){
    protobuf.Util.fetch = function (path, callback) {
      if (callback && typeof callback != 'function')
      callback = null;
      if (callback) {
        this.readFile(path, function (err, data) {
          if (err)
          callback(null);
          else
          callback("" + data);
        });
      } else
      try {
        return this.readFileSync(path);
      } catch (e) {
        return null;
      }
    }
  }

  public static writeFileSync(path, content) {
    const fd = fileIO.openSync(path, 0o102, 0o666);
    fileIO.writeSync(fd, content);
    fileIO.closeSync(fd);
  }

  public static readFileSync(path) {
    console.log("polyfill ---readFileSynctart")
    const fd = fileIO.openSync((path), 0o102, 0o666);
    const { size } = fileIO.statSync((path));
    var buf = new ArrayBuffer(size);
    fileIO.readSync(fd, buf);
    let resStr = new util.TextDecoder("utf-8", {
      ignoreBOM: true
    });
    let protoStr = resStr.decode(new Uint8Array(buf));
    return protoStr;
  }

  public static readFile(path, callback) {
    console.log("polyfill ---readFilestart")
    if (callback != null) {
      const fd = fileIO.openSync(path, 0o102, 0o666);
      const { size } = fileIO.statSync(path);
      var buf = new ArrayBuffer(size);
      console.log("polyfill ---readFile")
      fileIO.read(fd, buf, function (err, readOut) {
        console.log("polyfill ---readFileing")
        if (readOut) {
          let resStr = new util.TextDecoder("utf-8", {
            ignoreBOM: true
          });
          let protoStr = resStr.decode(new Uint8Array(readOut.buffer));
          return callback(null, protoStr)
        } else {
          callback(Error("readOut is Null"))
        }
        console.log("polyfill ---readFileend")
      });
    } else {
      return this.readFileSync(path);
    }
  }
}

