import _ from 'underscore';

Promise.prototype.also = also;
exports.nfcall = function(func) {
    var args = Array.prototype.slice.call(arguments, 1);
    return new Promise(function(resolve, reject) {
        args.push(function(err, result) {
            if (err) {
                reject(err);
            } else {
                resolve(result);
            }
        });
        func.apply(null, args);
    });
};

// todo 不支持bluebird.prototype.caught
// bluebird.prototype.fail = bluebird.prototype.caught;

// todo 不支持bluebird.prototype.also
// bluebird.prototype.also = function(func) {
//     return this.then(function(value) {
//         var returnValue = _.extend({}, value, func(value));
//         return bluebird.props(returnValue);
//     });
// };

function defer() {
    var resolve;
    var reject;
    var promise = new Promise(function(resolveArg, rejectArg) {
        resolve = resolveArg;
        reject = rejectArg;
    });
    // var promise = new bluebird.Promise(function(resolveArg, rejectArg) {
    //     resolve = resolveArg;
    //     reject = rejectArg;
    // });

    return {
        resolve: resolve,
        reject: reject,
        promise: promise
    };
}
/**
 * 对象属性 Promise 化
 * 等待对象中所有 Promise 属性完成
 */
function props(obj) {
    var keys = Object.keys(obj);
    var values = keys.map(function(key) {
        return obj[key];
    });

    return Promise.all(values).then(function(results) {
        var resultObj = {};
        results.forEach(function(result, index) {
            resultObj[keys[index]] = result;
        });
        return resultObj;
    });
}
/**
 * 扩展结果对象 - 合并新的异步结果到现有对象
 */
function also(func) {
    var self = this;

    return this.then(function(value) {
        var extension = func(value);

        // 检查 extension 是否为 Promise 或具有 then 方法的对象
        if (extension && typeof extension.then === 'function') {
            return extension.then(function(extendedResult) {
                // 合并结果
                if (_.isObject(value) && _.isObject(extendedResult)) {
                    return _.extend({}, value, extendedResult);
                } else if (_.isArray(value) && _.isArray(extendedResult)) {
                    return value.concat(extendedResult);
                } else {
                    // 非对象类型，返回扩展结果或原始值
                    return extendedResult !== undefined ? extendedResult : value;
                }
            });
        } else {
            // 处理同步情况或非 Promise 对象
            if (_.isObject(value) && _.isObject(extension)) {
                return _.extend({}, value, extension);
            } else if (_.isArray(value) && _.isArray(extension)) {
                return value.concat(extension);
            } else {
                // 如果 extension 是 undefined，返回原始值
                return extension !== undefined ? extension : value;
            }
        }
    });
}

const when = Promise.resolve;
const resolve = (value) => Promise.resolve(value);
const all = Promise.all;
// const props = Promise.props; // todo 不确定与all有何区别
const reject = Promise.reject;
const promisify =()=>{
    // Promise.promisify   // todo 不支持
    console.info("Promise promisify!")
};
const mapSeries =()=>{
    // Promise.mapSeries   // todo 不支持
    console.info("Promise mapSeries!")
};
const attempt =()=>{
    // Promise.attempt   // todo 不支持
    console.info("Promise attempt!")
};

export {
    defer,
    when,
    resolve,
    all,
    props,
    reject,
    promisify,  // todo
    mapSeries,  // todo
    attempt  // todo
};
