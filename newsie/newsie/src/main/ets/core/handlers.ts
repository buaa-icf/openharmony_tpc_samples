import { Article, Command } from './model'

export interface Block {
  lines: string[]
  _i: number
}

export interface Handler {
  multiLine: boolean
  numberOfArgs: number
  callback: (args: string[], block?: Block) => any
}

const parseHeaders = (lines: string[]) =>
  lines.reduce((obj: any, line: string) => {
    const i = line.indexOf(': ')
    obj[line.slice(0, i).toUpperCase()] = line.slice(i + 2)
    return obj
  }, {})

const parseArticle = (lines: string[]) => {
  const pivot = lines.indexOf('') // empty line divides header and article
  return {
    headers: parseHeaders(lines.slice(0, pivot)),
    body: lines.slice(pivot + 1)
  }
}

const parseGroups = (lines: string[]) =>
  lines.map(line => {
    // separated from each other by one or more spaces
    const fields = line.split(/ +/)
    return {
      name: fields[0],
      high: parseInt(fields[1]),
      low: parseInt(fields[2]),
      status: fields[3]
    }
  })

const parseUnixTime = (unixTime: number): string => new Date(unixTime * 1000).toISOString()

/**
 * TODO: Client should have a list of patterns and capability labels, ie:
 * command 'OVER .*' requires 'OVER' label
 *
 * this is unrelated to response handling and does not belong here
 */
enum CapabilityLabel {
  MANDATORY = 'MANDATORY',
  READER = 'READER',
  NEWNEWS = 'NEWNEWS',
  COMPRESS = 'COMPRESS',
  POST = 'POST',
  IHAVE = 'IHAVE',
  OVER = 'OVER'
}

interface Commands {
  [command: string]: {
    // TODO: use enum values here, when supported by TypeScript
    indicatingCapability?: CapabilityLabel
    [code: number]: Handler
  }
}

export const build = (description: string): Handler => ({
  multiLine: false,
  numberOfArgs: 0,
  callback: args => ({ description })
})

const commands: Commands = {
  // 3.2.1  Generic Response Codes
  '*': {
    400: build('service not available or no longer available'),
    401: {
      multiLine: false,
      numberOfArgs: 1,
      callback: args => ({
        capabilityLabel: args[0],
        description:
          'the server is in the wrong mode; the indicated capability should be used to change the mode.'
      })
    },
    403: build('internal fault or problem preventing action being taken'),
    480: build('command unavailable until the client has authenticated itself'),
    483: build('command unavailable until suitable privacy has been arranged'),
    500: build('unknown command'),
    501: build('syntax error in command'),
    502: build('command not permitted (and there is no way for the client to change this)'),
    503: build('feature not supported'),
    504: build('error in base64-encoding [RFC4648] of an argument')
  },
  // 5.1.  Initial Connection
  GREETING: {
    200: build('Service available, posting allowed'),
    201: build('Service available, posting prohibited'),
    400: build('Service temporarily unavailable'),
    502: build('Service permanently unavailable')
  },
  // 5.2.  CAPABILITIES
  CAPABILITIES: {
    101: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args, block) => {
        if (!block) throw new Error('block undefined')
        return {
          description: 'Capability list follows (multi-line)',
          capabilities: block.lines
            .map(l => l.toUpperCase()) // tokens are case insensitive
            .reduce((obj: any, line: string) => {
              const s = line.split(/[ \t]+/) // separated by one or more space or TAB characters
              obj[s[0]] = s.slice(1)
              return obj
            }, {})
        }
      }
    }
  },
  // 5.3.  MODE READER
  'MODE READER': {
    200: build('Posting allowed'),
    201: build('Posting prohibited'),
    502: build('Reading service permanently unavailable')
  },
  // 5.4.  QUIT
  QUIT: {
    205: build('Connection closing')
  },
  // 6.1.1.  GROUP
  GROUP: {
    211: {
      multiLine: false,
      numberOfArgs: 4,
      callback: args => ({
        description: 'Group successfully selected',
        group: {
          name: args[3],
          number: parseInt(args[0]),
          low: parseInt(args[1]),
          high: parseInt(args[2])
        }
      })
    },
    411: build('No such newsgroup')
  },
  // 6.1.2.  LISTGROUP
  LISTGROUP: {
    211: {
      multiLine: true,
      numberOfArgs: 4,
      callback: (args, block) => ({
        description: 'Article numbers follow (multi-line)',
        group: {
          name: args[3],
          number: parseInt(args[0]),
          low: parseInt(args[1]),
          high: parseInt(args[2]),
          articleNumbers: block.lines.map(n => parseInt(n))
        }
      })
    },
    411: build('No such newsgroup'),
    412: build('No newsgroup selected')
  },
  // 6.1.3.  LAST
  LAST: {
    223: {
      multiLine: false,
      numberOfArgs: 2,
      callback: args => ({
        description: 'Article found',
        article: {
          articleNumber: parseInt(args[0]),
          messageId: args[1]
        }
      })
    },
    412: build('No newsgroup selected'),
    420: build('Current article number is invalid'),
    422: build('No previous article in this group')
  },
  // 6.1.4.  NEXT
  NEXT: {
    223: {
      multiLine: false,
      numberOfArgs: 2,
      callback: args => ({
        description: 'Article found',
        article: {
          articleNumber: parseInt(args[0]),
          messageId: args[1]
        }
      })
    },
    412: build('No newsgroup selected'),
    420: build('Current article number is invalid'),
    421: build('No next article in this group')
  },
  // 6.2.1.  ARTICLE
  ARTICLE: {
    220: {
      multiLine: true,
      numberOfArgs: 2,
      callback: (args: string[], block: Block) => {
        const { headers, body } = parseArticle(block.lines)
        return {
          description: 'Article follows (multi-line)',
          article: {
            articleNumber: parseInt(args[0]),
            messageId: args[1],
            headers,
            body
          }
        }
      }
    },
    430: build('No article with that message-id'),
    412: build('No newsgroup selected'),
    423: build('No article with that number'),
    420: build('Current article number is invalid')
  },
  // 6.2.2.  HEAD
  HEAD: {
    221: {
      multiLine: true,
      numberOfArgs: 2,
      callback: (args: string[], block: Block) => ({
        description: 'Headers follow (multi-line)',
        article: {
          articleNumber: parseInt(args[0]),
          messageId: args[1],
          headers: parseHeaders(block.lines)
        }
      })
    },
    430: build('No article with that message-id'),
    412: build('No newsgroup selected'),
    423: build('No article with that number'),
    420: build('Current article number is invalid')
  },
  // 6.2.3.  BODY
  BODY: {
    222: {
      multiLine: true,
      numberOfArgs: 2,
      callback: (args: string[], block: Block) => ({
        description: 'Body follows (multi-line)',
        article: {
          articleNumber: parseInt(args[0]),
          messageId: args[1],
          body: block.lines
        }
      })
    },
    430: build('No article with that message-id'),
    412: build('No newsgroup selected'),
    423: build('No article with that number'),
    420: build('Current article number is invalid')
  },
  // 6.2.4.  STAT
  STAT: {
    223: {
      multiLine: false,
      numberOfArgs: 2,
      callback: args => ({
        description: 'Article exists',
        article: {
          articleNumber: parseInt(args[0]),
          messageId: args[1]
        }
      })
    },
    430: build('No article with that message-id'),
    412: build('No newsgroup selected'),
    423: build('No article with that number'),
    420: build('Current article number is invalid')
  },
  // 6.3.1.  POST
  POST: {
    indicatingCapability: CapabilityLabel.POST,
    340: build('Send article to be posted'),
    440: build('Posting not permitted')
  },
  POST_SEND: {
    240: build('Article received OK'),
    441: build('Posting failed')
  },
  // 6.3.2.  IHAVE
  IHAVE: {
    indicatingCapability: CapabilityLabel.IHAVE,
    335: build('Send article to be transferred'),
    435: build('Article not wanted'),
    436: build('Transfer not possible; try again later')
  },
  IHAVE_SEND: {
    235: build('Article transferred OK'),
    436: build('Transfer failed; try again later'),
    437: build('Transfer rejected; do not retry')
  },
  // 7.1.  DATE
  DATE: {
    111: {
      multiLine: false,
      numberOfArgs: 1,
      callback: args => {
        const m = /^(\d{4})(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)$/.exec(args[0])
        return {
          description: 'Server date and time',
          isoDateTime: new Date(
            Date.UTC(
              parseInt(m[1]),
              parseInt(m[2]) - 1, // mm is the month (01-12)
              parseInt(m[3]), // dd is the day of the month (01-31)
              parseInt(m[4]),
              parseInt(m[5]),
              parseInt(m[6])
            )
          ).toISOString()
        }
      }
    }
  },
  // 7.2.  HELP
  HELP: {
    100: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Help text follows (multi-line)',
        text: block.lines
      })
    }
  },
  NEWGROUPS: {
    indicatingCapability: CapabilityLabel.READER,
    231: {
      // Same as LIST ACTIVE
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'List of new newsgroups follows (multi-line)',
        newsgroups: parseGroups(block.lines)
      })
    }
  },
  NEWNEWS: {
    indicatingCapability: CapabilityLabel.NEWNEWS,
    230: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'List of new articles follows (multi-line)',
        messageIds: block.lines
      })
    }
  },
  'LIST ACTIVE': {
    215: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Information follows (multi-line)',
        newsgroups: parseGroups(block.lines)
      })
    }
  },
  LIST: {
    215: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Information follows (multi-line)',
        newsgroups: parseGroups(block.lines)
      })
    }
  },
  'LIST ACTIVE.TIMES': {
    215: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Information follows (multi-line)',
        newsgroups: block.lines.map(line => {
          const fields = line.split(/ +/)
          return {
            name: fields[0],
            created: parseUnixTime(parseInt(fields[1])),
            creator: fields[2]
          }
        })
      })
    }
  },
  'LIST DISTRIB.PATS': {
    215: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Information follows (multi-line)',
        distributionPatterns: block.lines.map(line => {
          const fields = line.split(':')
          return {
            weight: parseInt(fields[0]),
            wildmat: fields[1],
            distributionHeader: fields[2]
          }
        })
      })
    }
  },
  'LIST NEWSGROUPS': {
    215: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Information follows (multi-line)',
        newsgroups: block.lines.map(line => {
          const m = /(.+?)([ \t]+(.*))?$/.exec(line)
          if (!m) throw new Error('Regex not matched')
          const description = !m[3] ? '' : m[3]
          return {
            name: m[1],
            description
          }
        })
      })
    }
  },
  OVER: {
    indicatingCapability: CapabilityLabel.OVER,
    224: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Overview information follows (multi-line)',
        articles: block.lines.map(line => {
          const fields = line.split('\t')
          const article: Article = {
            articleNumber: parseInt(fields[0]),
            headers: {
              SUBJECT: fields[1],
              FROM: fields[2],
              DATE: fields[3],
              'MESSAGE-ID': fields[4],
              REFERENCES: fields[5]
            },
            metadata: {
              ':bytes': parseInt(fields[6]),
              ':lines': parseInt(fields[7])
            }
          }
          for (let i = 8; i < fields.length; i++) {
            const h = /^([^\s]+): (.*)$/.exec(fields[i])
            const m = /^(:.+?) (.*)$/.exec(fields[i])
            if (h) {
              article.headers[h[1].toUpperCase()] = h[2]
            } else if (m) {
              article.metadata[m[1].toLowerCase()] = m[2]
            } else if (fields[i] === '') {
              // skip empty lines; handle RFC's confusing
              // "missing "References" and Xref headers in the second line"
            } else {
              throw new Error('Unable to parse header or metadata in OVER command')
            }
          }
          return article
        })
      })
    },
    430: build('No article with that message-id'),
    412: build('No newsgroup selected'),
    423: build('No articles in that range'),
    420: build('Current article number is invalid')
  },
  'LIST OVERVIEW.FMT': {
    indicatingCapability: CapabilityLabel.OVER,
    215: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => {
        const lines = block.lines.map(line => {
          if (line.match(/^Bytes:/i)) return ':bytes'
          if (line.match(/^Lines:/i)) return ':lines'
          return line.replace(/:full$/i, ':')
        })
        const headerFields = lines
          .filter(line => line.endsWith(':'))
          .map(line => line.replace(':', '').toUpperCase())
        const metadataFields = lines
          .filter(line => line.startsWith(':'))
          .map(line => line.toLowerCase())
        return {
          description: 'Information follows (multi-line)',
          headerFields,
          metadataFields
        }
      }
    }
  },
  HDR: {
    225: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Headers follow (multi-line)',
        articles: block.lines.map(line => {
          // 1) The line consists of the article number, a space, and then the contents of the field
          const m = /^(\d+) (.*)$/.exec(line)
          // 2) the space after the article number MAY be retained or omitted
          const n = /^(\d+)/.exec(line)
          if (!m && !n) {
            throw new Error('Unable to parse field contents in HDR response')
          }
          return {
            articleNumber: parseInt(m ? m[1] : n[1]),
            fieldContents: m ? m[2] : ''
          }
        })
      })
    },
    430: build('No article with that message-id'),
    412: build('No newsgroup selected'),
    423: build('No articles in that range'),
    420: build('Current article number is invalid')
  },
  'LIST HEADERS': {
    215: {
      multiLine: true,
      numberOfArgs: 0,
      callback: (args: string[], block: Block) => ({
        description: 'Field list follows (multi-line)',
        fields: block.lines.map(line =>
          line.startsWith(':') ? line.toLowerCase() : line.toUpperCase()
        )
      })
    }
  },
  // [RFC 4642] 2.2. STARTTLS Command
  STARTTLS: {
    382: build('Continue with TLS negotiation'),
    502: build('Command unavailable'),
    580: build('Can not initiate TLS negotiation')
  },
  // [RFC 4643] 2.3.  AUTHINFO USER/PASS Command
  'AUTHINFO USER': {
    281: build('Authentication accepted'),
    381: build('Password required'),
    481: build('Authentication failed/rejected'),
    482: build('Authentication commands issued out of sequence'),
    502: build('Command unavailable')
  },
  'AUTHINFO PASS': {
    281: build('Authentication accepted'),
    481: build('Authentication failed/rejected'),
    482: build('Authentication commands issued out of sequence'),
    502: build('Command unavailable')
  },
  // [RFC 4643] 2.4.  AUTHINFO SASL Command
  'AUTHINFO SASL': {
    281: build('Authentication accepted'),
    283: {
      multiLine: false,
      numberOfArgs: 1,
      callback: (args: string[], block: Block) => ({
        description: 'Authentication accepted (with success data)',
        challenge: args[0]
      })
    },
    383: {
      multiLine: false,
      numberOfArgs: 1,
      callback: (args: string[], block: Block) => ({
        description: 'Continue with SASL exchange',
        challenge: args[0]
      })
    },
    481: build('Authentication failed/rejected'),
    482: build('SASL protocol error'),
    502: build('Command unavailable')
  },
  // [rfc8054] 2.2.  COMPRESS Command
  COMPRESS: {
    206: build('compression layer activated'),
    403: build('Unable to activate compression'),
    502: build('Command unavailable')
  },
  // [rfc4644] 2.3.  MODE STREAM Command
  'MODE STREAM': {
    203: build('Streaming permitted')
  },
  // [rfc4644] 2.4.  CHECK Command
  CHECK: {
    238: {
      multiLine: false,
      numberOfArgs: 1,
      callback: args => ({
        description: 'Send article to be transferred',
        article: {
          messageId: args[0]
        }
      })
    },
    431: {
      multiLine: false,
      numberOfArgs: 1,
      callback: args => ({
        description: 'Transfer not possible; try again later',
        article: {
          messageId: args[0]
        }
      })
    },
    438: {
      multiLine: false,
      numberOfArgs: 1,
      callback: args => ({
        description: 'Article not wanted',
        article: {
          messageId: args[0]
        }
      })
    }
  },
  // [rfc4644] 2.5.  TAKETHIS Command
  TAKETHIS: {
    239: {
      multiLine: false,
      numberOfArgs: 1,
      callback: args => ({
        description: 'Article transferred OK',
        article: {
          messageId: args[0]
        }
      })
    },
    439: {
      multiLine: false,
      numberOfArgs: 1,
      callback: args => ({
        description: 'Transfer rejected; do not retry',
        article: {
          messageId: args[0]
        }
      })
    }
  },
  // [rfc977] 3.12.  The SLAVE command
  SLAVE: {
    202: build('slave status noted')
  }
}

export const addHandler = (command: Command, code: number, handler: Handler): void => {
  commands[command] = commands[command] || ({} as any)
  commands[command][code] = handler
}

const findHandler = (command: Command, code: number): Handler => {
  const cmd = commands[command]
  if (!cmd) {
    return commands['*'][code]
  }
  return cmd[code] ? cmd[code] : commands['*'][code]
}

export default findHandler
