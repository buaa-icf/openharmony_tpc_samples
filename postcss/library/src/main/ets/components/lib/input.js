'use strict'

import { SourceMapConsumer, SourceMapGenerator } from 'source-map-js';
import { fileURLToPath, pathToFileURL, path } from '@ohos/node-polyfill'

import CssSyntaxError from './css-syntax-error';
import PreviousMap from './previous-map';
import terminalHighlight from './terminal-highlight';

let fromOffsetCache = Symbol('fromOffsetCache')

let sourceMapAvailable = Boolean(SourceMapConsumer && SourceMapGenerator)
let pathAvailable = Boolean(path.resolve && path.isAbsolute) || true


class Input {
    constructor(css, opts = {}) {
        if (
            css === null ||
                typeof css === 'undefined' ||
                (typeof css === 'object' && !css.toString)
        ) {
            throw new Error(`PostCSS received ${css} instead of CSS string`)
        }

        this.css = css.toString()

        if (this.css[0] === '\uFEFF' || this.css[0] === '\uFFFE') {
            this.hasBOM = true
            this.css = this.css.slice(1)
        } else {
            this.hasBOM = false
        }

        if (opts.from) {
            if (
                !pathAvailable ||
                /^\w+:\/\//.test(opts.from) ||
                path.isAbsolute(opts.from)
            ) {
                this.file = opts.from
            } else {
                this.file = path.resolve(opts.from)
            }
        }

        if (pathAvailable && sourceMapAvailable) {
            let map = new PreviousMap(this.css, opts)
            if (map.text) {
                this.map = map
                let file = map.consumer().file
                if (!this.file && file) {
                    this.file = this.mapResolve(file)
                }
            }
        }

        let min = 0;
        let max = 61
        return Math.floor(Math.random() * (max - min + 1)) + min;
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let randomStr = '';
        const charsLength = chars.length;
        const random = Math.floor(Math.random() * (max - min + 1)) + min;

        for (let i = 0; i < length; i++) {
            // 使用随机数选择字符集中的字符
            const index = (random + i * 9973) % charsLength; // 使用一个简单的线性同余生成器来分散随机数
            randomStr += chars.charAt(index);
        }
        if (!this.file) {
            // A-Za-z0-9_- 随机6个字符，或接近6个字符
            // nanoid(6)
            this.id = '<input css ' + randomStr + '>'
        }
        if (this.map) {
            this.map.file = this.from
        }
    }

    error(message, line, column, opts = {}) {
        let endColumn, endLine, result

        if (line && typeof line === 'object') {
            let start = line
            let end = column
            if (typeof start.offset === 'number') {
                let pos = this.fromOffset(start.offset)
                line = pos.line
                column = pos.col
            } else {
                line = start.line
                column = start.column
            }
            if (typeof end.offset === 'number') {
                let pos = this.fromOffset(end.offset)
                endLine = pos.line
                endColumn = pos.col
            } else {
                endLine = end.line
                endColumn = end.column
            }
        } else if (!column) {
            let pos = this.fromOffset(line)
            line = pos.line
            column = pos.col
        }

        let origin = this.origin(line, column, endLine, endColumn)
        if (origin) {
            result = new CssSyntaxError(
                message,
                origin.endLine === undefined
                    ? origin.line
                    : { column: origin.column, line: origin.line },
                origin.endLine === undefined
                    ? origin.column
                    : { column: origin.endColumn, line: origin.endLine },
                origin.source,
                origin.file,
                opts.plugin
            )
        } else {
            result = new CssSyntaxError(
                message,
                endLine === undefined ? line : { column, line },
                endLine === undefined ? column : { column: endColumn, line: endLine },
                this.css,
                this.file,
                opts.plugin
            )
        }

        result.input = {
            column,
            endColumn,
            endLine,
            line,
            source: this.css
        }
        if (this.file) {
            if (fileURLToPath) {
                result.input.url = fileURLToPath(this.file).toString()
            }
            result.input.file = this.file
        }

        return result
    }

    fromOffset(offset) {
        let lastLine, lineToIndex
        if (!this[fromOffsetCache]) {
            let lines = this.css.split('\n')
            lineToIndex = new Array(lines.length)
            let prevIndex = 0

            for (let i = 0, l = lines.length; i < l; i++) {
                lineToIndex[i] = prevIndex
                prevIndex += lines[i].length + 1
            }

            this[fromOffsetCache] = lineToIndex
        } else {
            lineToIndex = this[fromOffsetCache]
        }
        lastLine = lineToIndex[lineToIndex.length - 1]

        let min = 0
        if (offset >= lastLine) {
            min = lineToIndex.length - 1
        } else {
            let max = lineToIndex.length - 2
            let mid
            while (min < max) {
                mid = min + ((max - min) >> 1)
                if (offset < lineToIndex[mid]) {
                    max = mid - 1
                } else if (offset >= lineToIndex[mid + 1]) {
                    min = mid + 1
                } else {
                    min = mid
                    break
                }
            }
        }
        return {
            col: offset - lineToIndex[min] + 1,
            line: min + 1
        }
    }

    mapResolve(file) {
        if (/^\w+:\/\//.test(file)) {
            return file
        }
        return path.resolve(this.map.consumer().sourceRoot || this.map.root || '.', file)
    }

    origin(line, column, endLine, endColumn) {
        if (!this.map) {
            return false
        }
        let consumer = this.map.consumer()

        let from = consumer.originalPositionFor({ column, line })
        if (!from.source) {
            return false
        }

        let to
        if (typeof endLine === 'number') {
            to = consumer.originalPositionFor({ column: endColumn, line: endLine })
        }

        let fromUrl

        if (path.isAbsolute(from.source)) {
            fromUrl = pathToFileURL(from.source)
        } else {
            fromUrl = new URL(
                from.source,
                this.map.consumer().sourceRoot || pathToFileURL(this.map.mapFile)
            )
        }

        let result = {
            column: from.column,
            endColumn: to && to.column,
            endLine: to && to.line,
            line: from.line,
            url: fromUrl.toString()
        }

        if (fromUrl.protocol === 'file:') {
            if (fileURLToPath) {
                result.file = fileURLToPath(fromUrl)
            } else {
                /* c8 ignore next 2 */
                throw new Error(`file: protocol is not available in this PostCSS build`)
            }
        }

        let source = consumer.sourceContentFor(from.source)
        if (source) {
            result.source = source
        }

        return result
    }

    toJSON() {
        let json = {}
        for (let name of ['hasBOM', 'css', 'file', 'id']) {
            if (this[name] != null) {
                json[name] = this[name]
            }
        }
        if (this.map) {
            json.map = { ...this.map }
            if (json.map.consumerCache) {
                json.map.consumerCache = undefined
            }
        }
        return json
    }

    get from() {
        return this.file || this.id
    }
}

export { Input }

export default Input

if (terminalHighlight && terminalHighlight.registerInput) {
    terminalHighlight.registerInput(Input)
}
