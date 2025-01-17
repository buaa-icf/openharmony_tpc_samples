'use strict'

import Container from './container';
import Input from './input';
import Parser from './parser';

function parse(css, opts) {
    let input = new Input(css, opts)
    let parser = new Parser(input)
    try {
        parser.parse()
    } catch (e) {
        throw e
    }

    return parser.root
}

export { parse }

export default parse

Container.registerParse(parse)
