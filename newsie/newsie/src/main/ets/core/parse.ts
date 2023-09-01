import findHandler from './handlers'
import { Command } from './model'

const parseLine = (reply: string): string | void => {
  const m = /^(.*?\r\n)/.exec(reply)
  return m ? m[1] : undefined
}

const parseCode = (reply: string): number | void => {
  const m = /^(\d{3}).*?\r\n/.exec(reply)
  return m ? parseInt(m[1]) : undefined
}

const parseBlock = (reply: string): any => {
  // empty block
  if (reply.startsWith('.\r\n')) {
    return { lines: [], _i: 3 }
  }

  // non-empty block
  const i = reply.indexOf('\r\n.\r\n')
  if (i === -1) return undefined
  const block = reply.slice(0, i)
  const lines = block.split('\r\n').map(l => (l.startsWith('.') ? l.slice(1) : l)) // "dot-stuffing" MUST be undone
  return { lines, _i: i + 5 }
}

const parseArgs = (line: string, numArgs: number): any => {
  const s = line.slice(0, line.length - 2).split(' ')
  const args = s.slice(1, numArgs + 1)
  const comment = s.slice(numArgs + 1).join(' ')
  return { args, comment }
}

export interface Response {
  _i: number
  code: number
  comment: string
}

const parse = (command: Command, buffer: string): Response | void => {
  const line = parseLine(buffer)
  if (!line) return undefined
  const code = parseCode(line)
  if (!code) return undefined

  const handler = findHandler(command, code)
  if (!handler) throw new Error(`Unhandled command ${command} and code ${code} combination`)

  let block
  if (handler.multiLine) {
    block = parseBlock(buffer.slice(line.length))
    if (!block) return undefined
  }

  const parsedArgs = parseArgs(line, handler.numberOfArgs)
  const response = handler.callback(parsedArgs.args, block)
  return {
    _i: line.length + (block ? block._i : 0),
    code,
    comment: parsedArgs.comment,
    ...response
  }
}

export { parse }
