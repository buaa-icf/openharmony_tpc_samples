/* eslint-disable no-console */
'use strict'

let printed = {}

function warnOnce(message) {
    if (printed[message]) {
        return
    }
    printed[message] = true

    if (typeof console !== 'undefined' && console.warn) {
        console.warn(message)
    }
}

export { warnOnce }

export default warnOnce
