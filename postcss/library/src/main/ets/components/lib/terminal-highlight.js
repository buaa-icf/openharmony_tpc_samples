'use strict'

import tokenizer from './tokenize.js'

let Input

function registerInput(dependant) {
    Input = dependant
}

const HIGHLIGHT_THEME = {
    ';': 'yellow',
    ':': 'yellow',
    '(': 'cyan',
    ')': 'cyan',
    '[': 'yellow',
    ']': 'yellow',
    '{': 'yellow',
    '}': 'yellow',
    'at-word': 'cyan',
    'brackets': 'cyan',
    'call': 'cyan',
    'class': 'yellow',
    'comment': 'gray',
    'hash': 'magenta',
    'string': 'green'
}

function getTokenType([type, value], processor) {
    if (type === 'word') {
        if (value[0] === '.') {
            return 'class'
        }
        if (value[0] === '#') {
            return 'hash'
        }
    }

    if (!processor.endOfFile()) {
        let next = processor.nextToken()
        processor.back(next)
        if (next[0] === 'brackets' || next[0] === '(') {
            return 'call'
        }
    }

    return type
}

function terminalHighlight(css) {
    let processor = tokenizer(new Input(css), { ignoreErrors: true })
    let result = ''
    while (!processor.endOfFile()) {
        let token = processor.nextToken()
        let color = HIGHLIGHT_THEME[getTokenType(token, processor)]
        if (color) {
            result += token[1]
                .split(/\r?\n/)
                .map(i => color(i))
                .join('\n')
        } else {
            result += token[1]
        }
    }
    return result
}

terminalHighlight.registerInput = registerInput

export { terminalHighlight }

export default terminalHighlight
