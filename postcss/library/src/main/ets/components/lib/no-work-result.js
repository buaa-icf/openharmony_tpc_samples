'use strict'

import MapGenerator from './map-generator';
import parse from './parse';
import Result from './result';
import stringify from './stringify';
import warnOnce from './warn-once';

class NoWorkResult {
    constructor(processor, css, opts) {
        css = css.toString()
        this.stringified = false

        this._processor = processor
        this._css = css
        this._opts = opts
        this._map = undefined
        let root

        let str = stringify
        this.result = new Result(this._processor, root, this._opts)
        this.result.css = css

        let self = this
        Object.defineProperty(this.result, 'root', {
            get() {
                return self.root
            }
        })

        let map = new MapGenerator(str, root, this._opts, css)
        if (map.isMap()) {
            let [generatedCSS, generatedMap] = map.generate()
            if (generatedCSS) {
                this.result.css = generatedCSS
            }
            if (generatedMap) {
                this.result.map = generatedMap
            }
        } else {
            map.clearAnnotation()
            this.result.css = map.css
        }
    }

    async() {
        if (this.error) {
            return Promise.reject(this.error)
        }
        return Promise.resolve(this.result)
    }

    catch(onRejected) {
        return this.async().catch(onRejected)
    }

    finally(onFinally) {
        return this.async().then(onFinally, onFinally)
    }

    sync() {
        if (this.error) {
            throw this.error
        }
        return this.result
    }

    then(onFulfilled, onRejected) {
        return this.async().then(onFulfilled, onRejected)
    }

    toString() {
        return this._css
    }

    warnings() {
        return []
    }

    get content() {
        return this.result.css
    }

    get css() {
        return this.result.css
    }

    get map() {
        return this.result.map
    }

    get messages() {
        return []
    }

    get opts() {
        return this.result.opts
    }

    get processor() {
        return this.result.processor
    }

    get root() {
        if (this._root) {
            return this._root
        }

        let root
        let parser = parse

        try {
            root = parser(this._css, this._opts)
        } catch (error) {
            this.error = error
        }

        if (this.error) {
            throw this.error
        } else {
            this._root = root
            return root
        }
    }

    get [Symbol.toStringTag]() {
        return 'NoWorkResult'
    }
}

export { NoWorkResult }

export default NoWorkResult
