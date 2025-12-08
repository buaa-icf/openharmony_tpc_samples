'use strict';

function posix(path) {
    return path.charAt(0) === '/';
}

function win32(path) {
    // https://github.com/nodejs/node/blob/b3fcc245fb25539909ef1d5eaa01dbf92e168633/lib/path.js#L56
    var splitDeviceRe = /^([a-zA-Z]:|[\\/]{2}[^\\/]+[\\/]+[^\\/]+)?([\\/])?([\s\S]*?)$/;
    var result = splitDeviceRe.exec(path);
    var device = result[1] || '';
    var isUnc = Boolean(device && device.charAt(1) !== ':');

    // UNC paths are always absolute
    return Boolean(result[2] || isUnc);
}

export { win32 as default, posix, win32 };
