import fs from '@ohos.file.fs';
import * as zipfile from "./zipfile";

export function openZip(options) {
    if (options.path) {
        try {
            let file = fs.openSync(options.path, fs.OpenMode.READ_WRITE);
            let stat = fs.lstatSync(options.path);
            let buf = new ArrayBuffer(stat.size);
            let data = fs.readSync(file.fd, buf);
            return zipfile.openArrayBuffer(new Uint8Array(buf));
        }catch (e) {
            return Promise.reject(new Error("openZip failed"));
        }
        // return readFile(options.path).then(zipfile.openArrayBuffer);
    } else if (options.buffer) {
        return Promise.resolve(zipfile.openArrayBuffer(options.buffer.buffer));
        }
    else if (options.arrayBuffer) {
        return Promise.resolve(zipfile.openArrayBuffer(options.arrayBuffer));
    }
      else if (options.file) {
        return Promise.resolve(options.file);
    } else {
        return Promise.reject(new Error("Could not find file in options"));
    }
}
