import { TlsOptions } from 'tls'
import Connection from './Connection'
import {
  Article,
  ArticleResponse,
  AuthInfoResponse,
  AuthInfoSaslResponse,
  CapabilitiesResponse,
  Command,
  DateResponse,
  DistributionPatternsResponse,
  GroupResponse,
  GroupsResponse,
  HelpResponse,
  ListHeadersResponse,
  NewnewsResponse,
  NntpResponse,
  OverviewFormatResponse,
  PostResponse,
  Range,
  StartTlsResponse
} from './model'
import { parse } from './parse'

const rangeToString = (range: Range): string => `${range.start}-${range.end ? range.end : ''}`

/** Converts ISO 8601 strings to { date: yyyymmdd, time: hhmmss } format */
const parseIsoString = (isoDateTime: string): { date: string; time: string } => {
  const parsed = new Date(Date.parse(isoDateTime))
  if (!parsed) throw new Error('Invalid date')
  const year = `${parsed.getUTCFullYear()}`
  const month = `${parsed.getUTCMonth() + 1}`.padStart(2, '0')
  const day = `${parsed.getUTCDate()}`.padStart(2, '0')
  const date = year + month + day
  const hours = `${parsed.getUTCHours()}`.padStart(2, '0')
  const minutes = `${parsed.getUTCMinutes()}`.padStart(2, '0')
  const seconds = `${parsed.getUTCSeconds()}`.padStart(2, '0')
  const time = hours + minutes + seconds
  return { date, time }
}

const articleToString = (article: Article): string =>
  [
    ...Object.keys(article.headers).map((h: string) => `${h}: ${article.headers[h]}`),
    '',
    ...article.body.map(line => (line.startsWith('.') ? `.${line}` : line)),
    '.',
    ''
  ].join('\r\n')

export interface Options {
  host: string
  port?: number
  tlsPort?: boolean
  responseInterceptor?: (response: any) => any
  tlsOptions?: TlsOptions
}

const encode = (data: string) => Buffer.from(data).toString('base64')

class Client {
  public _connection: Connection
  private _interceptor: (response: any) => any

  constructor(options: Options) {
    const {
      host,
      port = 119,
      tlsPort = false,
      responseInterceptor = (r: any) => r,
      tlsOptions = {}
    } = options
    this._connection = new Connection(host, port, tlsPort, tlsOptions)
    this._interceptor = responseInterceptor
  }

  public connect = async (): Promise<any> => {
    const socket = await this._connection.connect()
    const response = await this.sendData(Command.GREETING)
    return {
      ...response,
      socket
    }
  }

  public disconnect = () => this._connection.disconnect()

  public command = (command: Command, ...args: Array<string | void>) => {
    return this.sendData(
      command,
      [command as string].concat(args.filter(arg => !!arg) as string[]).join(' ') + '\r\n'
    )
  }

  // RFC 2980
  // xreplic = () => {}
  // listSubscriptions = () => {}
  // xgtitle = (wildmat?: string) => {} // note: conflict in response codes
  // xhdr = () => {}
  // xindex = () => {}
  // xover = () => {}
  // xpat = () => {}
  // xpath = () => {}
  // xrover = () => {}
  // xthread = () => {}

  // RFC 6048
  // public listCounts = () => {}
  // public listDistributions = () => {}
  // public listModerators = () => {}
  // public listMessageOfTheDay = () => {}
  // public listSubscriptions = () => {}
  // and list active additions

  /**
   * TODO: should reject an Error object
   */
  public sendData = async (command: Command, payload?: string): Promise<any> => {
    const p = new Promise((resolve, reject) => {
      this._connection.addCallback((text: string) => parse(command, text), resolve, reject)
    })
    if (payload) {
      await this._connection.write(payload)
    }
    return p
      .then(this._interceptor)
      .then(response => (response.code < 400 ? response : Promise.reject(response)))
  }
}

interface Client {
  // rfc 977 (original, deprecated)
  slave(): Promise<NntpResponse>

  // rfc 1036

  // rfc 2980 extensions to rfc 977

  // rfc 3977 base, deprecates 977
  capabilities(keyword?: string): Promise<CapabilitiesResponse>
  modeReader(): Promise<NntpResponse>
  quit(): Promise<NntpResponse>
  group(group?: string): Promise<GroupResponse>
  listGroup(group?: string, range?: Range): Promise<GroupResponse>
  last(): Promise<ArticleResponse>
  next(): Promise<ArticleResponse>
  article(articleNumberOrMessageId?: number | string): Promise<ArticleResponse>
  head(articleNumberOrMessageId?: number | string): Promise<ArticleResponse>
  body(articleNumberOrMessageId?: number | string): Promise<ArticleResponse>
  stat(articleNumberOrMessageId?: number | string): Promise<ArticleResponse>
  post(): Promise<PostResponse>
  ihave(messageId: string): Promise<PostResponse>
  date(): Promise<DateResponse>
  help(this: Client): Promise<HelpResponse>
  newgroups(this: Client, isoDateTime: string): Promise<GroupsResponse>
  newnews(this: Client, wildmat: string, isoDateTime: string): Promise<NewnewsResponse>
  list(this: Client): Promise<GroupsResponse>
  listActive(this: Client, wildmat?: string): Promise<GroupsResponse>
  listActiveTimes(this: Client, wildmat?: string): Promise<GroupsResponse>
  listDistribPats(this: Client, wildmat?: string): Promise<DistributionPatternsResponse>
  listNewsgroups(this: Client, wildmat?: string): Promise<GroupsResponse>
  over(messageIdOrRange?: string | Range | number): Promise<GroupsResponse>
  listOverviewFmt(wildmat?: string): Promise<OverviewFormatResponse>
  hdr(field: string, messageIdOrRange?: string | Range): Promise<ArticleResponse>
  listHeaders(argument?: 'MSGID' | 'RANGE'): Promise<ListHeadersResponse>

  // rfc 4642 encryption
  startTls(): Promise<StartTlsResponse>

  // rfc 4643 authentication
  authInfoUser(username: string): Promise<AuthInfoResponse>
  authInfoSasl(mechanism: string, initialResponse?: string): Promise<AuthInfoSaslResponse>
  authInfoSaslPlain(
    authzid: string | void,
    authcid: string,
    passwd: string
  ): Promise<AuthInfoSaslResponse>

  // rfc 8054 compression
  compressDeflate(): Promise<any>

  // rfc 4644 asynchronous/streaming article transfers
  modeStream(): Promise<NntpResponse>
  check(messageId: string): Promise<ArticleResponse>
  takeThis(article: Article): Promise<ArticleResponse>

  // rfc 6048 list extensions
}

function rfc977() {
  /**
   * @deprecated from RFC 977 removed in RFC 3977
   */
  Client.prototype.slave = function (this: Client) {
    return this.command(Command.SLAVE)
  }
}

function rfc3977() {
  // 5.  Session Administration Commands
  Client.prototype.capabilities = function (this: Client, keyword?: string) {
    return this.command(Command.CAPABILITIES, keyword)
  }
  Client.prototype.modeReader = function (this: Client) {
    return this.command(Command.MODE_READER)
  }
  Client.prototype.quit = function (this: Client) {
    return this.command(Command.QUIT)
  }
  // 6.  Article Posting and Retrieval
  Client.prototype.group = function (this: Client, group: string) {
    return this.command(Command.GROUP, group)
  }
  Client.prototype.listGroup = function (group?: string, range?: Range) {
    if (!group && range) throw new Error('Cannot define range without group')
    return this.command(Command.LISTGROUP, group, range && rangeToString(range))
  }
  Client.prototype.last = function (this: Client) {
    return this.command(Command.LAST)
  }
  Client.prototype.next = function (this: Client) {
    return this.command(Command.NEXT)
  }
  Client.prototype.article = function (this: Client, articleNumberOrMessageId?: number | string) {
    return this.command(
      Command.ARTICLE,
      articleNumberOrMessageId ? `${articleNumberOrMessageId}` : undefined
    )
  }
  Client.prototype.head = function (this: Client, articleNumberOrMessageId?: number | string) {
    return this.command(
      Command.HEAD,
      articleNumberOrMessageId ? `${articleNumberOrMessageId}` : undefined
    )
  }
  Client.prototype.body = function (this: Client, articleNumberOrMessageId?: number | string) {
    return this.command(
      Command.BODY,
      articleNumberOrMessageId ? `${articleNumberOrMessageId}` : undefined
    )
  }
  Client.prototype.stat = function (this: Client, articleNumberOrMessageId?: number | string) {
    return this.command(
      Command.STAT,
      articleNumberOrMessageId ? `${articleNumberOrMessageId}` : undefined
    )
  }
  Client.prototype.post = function (this: Client) {
    return this.command(Command.POST).then(response => ({
      ...response,
      send: (article: Article) => this.sendData(Command.POST_SEND, articleToString(article))
    }))
  }
  Client.prototype.ihave = function (this: Client, messageId: string) {
    return this.command(Command.IHAVE, messageId).then(response => ({
      ...response,
      send: (article: Article) => this.sendData(Command.IHAVE_SEND, articleToString(article))
    }))
  }
  // 7.  Information Commands
  Client.prototype.date = function (this: Client) {
    return this.command(Command.DATE)
  }
  Client.prototype.help = function (this: Client) {
    return this.command(Command.HELP)
  }
  Client.prototype.newgroups = function (this: Client, isoDateTime: string) {
    const { date, time } = parseIsoString(isoDateTime)
    return this.command(Command.NEWGROUPS, date, time, 'GMT')
  }
  Client.prototype.newnews = function (this: Client, wildmat: string, isoDateTime: string) {
    const { date, time } = parseIsoString(isoDateTime)
    return this.command(Command.NEWNEWS, wildmat, date, time, 'GMT')
  }
  Client.prototype.list = function (this: Client) {
    return this.command(Command.LIST)
  }
  Client.prototype.listActive = function (this: Client, wildmat?: string) {
    return this.command(Command.LIST_ACTIVE, wildmat)
  }
  Client.prototype.listActiveTimes = function (this: Client, wildmat?: string) {
    return this.command(Command.LIST_ACTIVE_TIMES, wildmat)
  }
  Client.prototype.listDistribPats = function (this: Client, wildmat?: string) {
    return this.command(Command.LIST_DISTRIB_PATS, wildmat)
  }
  Client.prototype.listNewsgroups = function (this: Client, wildmat?: string) {
    return this.command(Command.LIST_NEWSGROUPS, wildmat)
  }
  // 8.  Article Field Access Commands
  Client.prototype.over = function (this: Client, messageIdOrRange?: string | Range | number) {
    const params: string[] = []
    if (typeof messageIdOrRange === 'string' || messageIdOrRange instanceof String) {
      params.push(messageIdOrRange as string)
    }
    if (typeof messageIdOrRange === 'number' || messageIdOrRange instanceof Number) {
      params.push(`${messageIdOrRange}`)
    }
    if (messageIdOrRange instanceof Object) {
      params.push(rangeToString(messageIdOrRange as Range))
    }
    return this.command(Command.OVER, ...params)
  }
  Client.prototype.listOverviewFmt = function (this: Client, wildmat?: string) {
    return this.command(Command.LIST_OVERVIEW_FMT, wildmat)
  }
  Client.prototype.hdr = function (this: Client, field: string, messageIdOrRange?: string | Range) {
    const params = [field]
    if (typeof messageIdOrRange === 'string' || messageIdOrRange instanceof String) {
      params.push(messageIdOrRange as string)
    }
    if (messageIdOrRange instanceof Object) {
      params.push(rangeToString(messageIdOrRange as Range))
    }
    return this.command(Command.HDR, ...params)
  }
  Client.prototype.listHeaders = function (this: Client, argument?: 'MSGID' | 'RANGE') {
    return this.command(Command.LIST_HEADERS, argument)
  }
}

function rfc4642() {
  Client.prototype.startTls = function (this: Client) {
    return this.command(Command.STARTTLS).then(async response => ({
      ...response,
      socket: await this._connection.upgradeTls()
    }))
  }
}

function rfc4643() {
  Client.prototype.authInfoUser = function (this: Client, username: string) {
    return this.command(Command.AUTHINFO_USER, username).then(response =>
      response.code === 381
        ? {
            ...response,
            authInfoPass: (password: string) => this.command(Command.AUTHINFO_PASS, password)
          }
        : response
    )
  }

  Client.prototype.authInfoSasl = function (
    this: Client,
    mechanism: string,
    initialResponse?: string
  ) {
    const addMethods = (response: any) =>
      response.code === 383
        ? {
            ...response,
            continue: (clientResponse: string) =>
              this.sendData(Command.AUTHINFO_SASL, `${clientResponse}\r\n`).then(addMethods),
            cancel: () => this.sendData(Command.AUTHINFO_SASL, '*\r\n')
          }
        : response
    return this.command(Command.AUTHINFO_SASL, mechanism, initialResponse).then(addMethods)
  }

  /**
   * https://tools.ietf.org/html/rfc4616
   */
  Client.prototype.authInfoSaslPlain = function (
    this: Client,
    authzid: string | void,
    authcid: string,
    passwd: string
  ) {
    const initialResponse = encode(`${authzid || ''}\u0000${authcid}\u0000${passwd}`)
    return this.authInfoSasl('PLAIN', initialResponse)
  }
}

function rfc8054() {
  /**
   * WARNING: compression over TLS leaks information to eavesdroppers. Can still
   * improve efficiency if you're okay with information leaks.
   *
   * TODO: implement compression in Connection (it doesn't work yet)
   */
  Client.prototype.compressDeflate = async function (this: Client) {
    const response = await this.command(Command.COMPRESS, 'DEFLATE')
    this._connection.enableCompression()
    return response
  }
}

function rfc4644() {
  Client.prototype.modeStream = function (this: Client) {
    return this.command(Command.MODE_STREAM)
  }
  Client.prototype.check = function (this: Client, messageId: string) {
    return this.command(Command.CHECK, messageId)
  }
  Client.prototype.takeThis = function (this: Client, article: Article) {
    return this.sendData(
      Command.TAKETHIS,
      `${Command.TAKETHIS} ${article.messageId}\r\n${articleToString(article)}`
    )
  }
}

rfc977()
rfc3977()
rfc4642()
rfc4643()
rfc8054()
rfc4644()

export default Client
