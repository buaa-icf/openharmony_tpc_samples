import { Socket } from 'net'
import { TLSSocket } from 'tls'

export interface Article {
  articleNumber?: number
  messageId?: string
  headers?: { [header: string]: string }
  metadata?: { [metadata: string]: string | number }
  body?: string[]
  /**
   * Part of hdr response
   */
  fieldContents?: string
}

export interface Group {
  name: string
  low: number
  high: number
  /**
   * Part of group() response
   */
  number?: number
  /**
   * Part of listGroup() response
   */
  articleNumbers?: number[]
  /**
   * Part of newgroups() response
   */
  status?: string
  /**
   * Part of listActiveTimes() response
   */
  created?: string
  /**
   * Part of listActiveTimes() response
   */
  creator?: string
  /**
   * Part of listNewsgroups() response
   */
  description?: string
}

export interface Range {
  start: number
  end?: number
}

export enum Command {
  ARTICLE = 'ARTICLE',
  BODY = 'BODY',
  CAPABILITIES = 'CAPABILITIES',
  DATE = 'DATE',
  GROUP = 'GROUP',
  HDR = 'HDR',
  HEAD = 'HEAD',
  HELP = 'HELP',
  LAST = 'LAST',
  LIST = 'LIST',
  LIST_ACTIVE_TIMES = 'LIST ACTIVE.TIMES',
  LIST_ACTIVE = 'LIST ACTIVE',
  LIST_DISTRIB_PATS = 'LIST DISTRIB.PATS',
  LIST_HEADERS = 'LIST HEADERS',
  LIST_NEWSGROUPS = 'LIST NEWSGROUPS',
  LIST_OVERVIEW_FMT = 'LIST OVERVIEW.FMT',
  LISTGROUP = 'LISTGROUP',
  MODE_READER = 'MODE READER',
  NEWGROUPS = 'NEWGROUPS',
  NEWNEWS = 'NEWNEWS',
  NEXT = 'NEXT',
  OVER = 'OVER',
  POST = 'POST',
  POST_SEND = 'POST_SEND',
  IHAVE = 'IHAVE',
  IHAVE_SEND = 'IHAVE_SEND',
  QUIT = 'QUIT',
  STAT = 'STAT',
  GREETING = 'GREETING',
  AUTHINFO_USER = 'AUTHINFO USER',
  AUTHINFO_PASS = 'AUTHINFO PASS',
  STARTTLS = 'STARTTLS',
  AUTHINFO_SASL = 'AUTHINFO SASL',
  COMPRESS = 'COMPRESS',
  MODE_STREAM = 'MODE STREAM',
  CHECK = 'CHECK',
  TAKETHIS = 'TAKETHIS',
  SLAVE = 'SLAVE'
}

export enum CapabilityLabel {
  STARTTLS = 'STARTTLS',
  AUTHINFO = 'AUTHINFO',
  READER = 'READER',
  NEWNEWS = 'NEWNEWS',
  COMPRESS = 'COMPRESS',
  POST = 'POST',
  IHAVE = 'IHAVE',
  OVER = 'OVER',
  VERSION = 'VERSION',
  LIST = 'LIST',
  IMPLEMENTATION = 'IMPLEMENTATION',
  STREAMING = 'STREAMING',
  HDR = 'HDR',
  MODE_READER = 'MODE-READER'
}

export interface NntpResponse {
  code: number
  comment: string
  description: string
}

export interface NntpErrorResponse extends NntpResponse {
  /**
   * When the code is 401, the capabilityLabel may be defined to inform the
   * client to switch modes.
   */
  capabilityLabel?: CapabilityLabel
}

export interface GreetingResponse extends NntpResponse {
  /**
   * 200 => posting allowed
   * 201 => posting prohibited
   */
  code: 200 | 201
  socket: Socket
}

export interface CapabilitiesResponse extends NntpResponse {
  code: 101
  capabilities: { [Label in CapabilityLabel]: string[] }
}

export interface GroupResponse extends NntpResponse {
  code: 211
  group: Group
}

export interface ArticleResponse extends NntpResponse {
  /**
   * 220 => article
   * 221 => head
   * 222 => body
   * 223 => stat
   */
  code: 220 | 221 | 222 | 223
  article: Article
}

export interface PostResponse extends NntpResponse {
  /**
   * 335 => ihave
   * 340 => post
   */
  code: 335 | 340
  send: (article: Article) => NntpResponse
}

export interface DateResponse extends NntpResponse {
  code: 111
  isoDateTime: string
}

export interface HelpResponse extends NntpResponse {
  code: 100
  text: string[]
}

export interface GroupsResponse extends NntpResponse {
  /**
   * 215 => list
   * 231 => newgroups
   */
  code: 215 | 231
  newsgroups: Group[]
}

export interface NewnewsResponse extends NntpResponse {
  code: 230
  messageIds: string[]
}

export interface DistributionPatternsResponse extends NntpResponse {
  code: 215
  distributionPatterns: Array<{
    weight: number
    wildmat: string
    distributionHeader: string
  }>
}

export interface ArticlesResponse extends NntpResponse {
  /**
   * 224 => over
   * 225 => hdr
   */
  code: 224 | 225
  articles: Article[]
}

export interface OverviewFormatResponse extends NntpResponse {
  code: 215
  headerFields: string[]
  metadataFields: string[]
}

export interface ListHeadersResponse extends NntpResponse {
  code: 215
  /**
   * May include both headers and metadata
   */
  fields: string[]
}

export interface StartTlsResponse extends NntpResponse {
  code: 382
  socket: TLSSocket
}

export interface AuthInfoResponse extends NntpResponse {
  /**
   * 281 => AUTHINFO USER or AUTHINFO PASS
   * 381 => AUTHINFO USER
   */
  code: 281 | 381
  /**
   * Defined if code === 381
   */
  authInfoPass?: (password: string) => Promise<NntpResponse>
}

export interface AuthInfoSaslResponse extends NntpResponse {
  code: 281 | 283 | 383
  continue: (clientResponse: string) => Promise<AuthInfoSaslResponse>
  cancel: () => Promise<NntpErrorResponse>
  challenge: string
}
