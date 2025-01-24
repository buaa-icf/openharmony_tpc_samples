'use strict'

import Document from './document';
import LazyResult from './lazy-result';
import NoWorkResult from './no-work-result';
import Root from './root';

class Processor {
    constructor(plugins = []) {
        this.version = '8.4.49'
        this.plugins = this.normalize(plugins)
    }

    normalize(plugins) {
        let normalized = []
        for (let i of plugins) {
            if (i.postcss === true) {
                i = i()
            } else if (i.postcss) {
                i = i.postcss
            }

            if (typeof i === 'object' && Array.isArray(i.plugins)) {
                normalized = normalized.concat(i.plugins)
            } else if (typeof i === 'object' && i.postcssPlugin) {
                normalized.push(i)
            } else if (typeof i === 'function') {
                normalized.push(i)
            } else {
                throw new Error(i + ' is not a PostCSS plugin')
            }
        }
        return normalized
    }

    process(css, opts = {}) {
        if (
            !this.plugins.length &&
                !opts.parser &&
                !opts.stringifier &&
                !opts.syntax
        ) {
            return new NoWorkResult(this, css, opts)
        } else {
            return new LazyResult(this, css, opts)
        }
    }

    use(plugin) {
        this.plugins = this.plugins.concat(this.normalize([plugin]))
        return this
    }
}

export { Processor }

export default Processor

Root.registerProcessor(Processor)
Document.registerProcessor(Processor)
