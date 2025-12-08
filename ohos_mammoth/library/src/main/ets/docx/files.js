import fs from '@ohos.file.fs';
import url from '@ohos.url';
import isAbsolutePath from '../path-is-absolut.js';

export function Files(options) {
    options = options || {};
    if (!options.externalFileAccess) {
        return {
            read: function(uri) {
                return Promise.reject(new Error("could not read external image '" + uri + "', external file access is disabled"));
            }
        };
    }

    var base = options.relativeToFile ? options.relativeToFile : null;

    function read(uri, encoding) {
        return resolveUri(uri).then(function(path) {
            return  readFile(path, encoding).catch((error)=>{
                    var message = "could not open external image: '" + uri + "' (document directory: '" + base + "')\n" + error.message;
                    return Promise.reject(new Error(message));
            })
            // todo 不支持caught
            // return readFile(path, encoding).caught(function(error) {
            //     var message = "could not open external image: '" + uri + "' (document directory: '" + base + "')\n" + error.message;
            //     return Promise.reject(new Error(message));
            // });
        });
    }

    function resolveUri(uri) {
        var path = uriToPath(uri);
        if (isAbsolutePath(path)) {
            return Promise.resolve(path);
        } else if (base) {
            // todo 暂未明确使用场景
            // return Promise.resolve(resolvePath(base, path));
            return Promise.resolve(path);
        } else {
            return Promise.reject(new Error("could not find external image '" + uri + "', path of input document is unknown"));
        }
    }

    return {
        read: read
    };
}


// var readFile = promises.promisify(fs.readFile.bind(fs));
var readFile = ()=>{
    let filePath = "/test.txt";
    return fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
}


export function uriToPath(uriString, platform) {
    var uri;
    try{
        uri = url.URL.parseURL(uriString);
    }catch (e) {
        uri = {
            pathname: uriString,
            href: uriString,
            protocol: null,
            host: null
        }
    }
    if (isLocalFileUri(uri) || isRelativeUri(uri)) {
        var path = decodeURIComponent(uri.pathname);
        if (platform === "win32" && /^\/[a-z]:/i.test(path)) {
            return path.slice(1);
        } else {
            return path;
        }
    } else {
        throw new Error("Could not convert URI to path: " + uriString);
    }
}

function isLocalFileUri(uri) {
    return uri.protocol === "file:" && (!uri.host || uri.host === "localhost");
}

function isRelativeUri(uri) {
    return !uri.protocol && !uri.host;
}
