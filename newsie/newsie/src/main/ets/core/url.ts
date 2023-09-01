import { URL } from 'url'
import Client from './Client'

function parse(uri: string) {
  const parsed = new URL(uri)
  const path = parsed.pathname + parsed.search
  const parts = path.split('/')
  let group
  let articleNumber
  let messageId
  if (parsed.protocol === 'nntp:' || parsed.protocol === 'nntps:') {
    group = parts[1]
    if (parts.length > 2) {
      articleNumber = parseInt(parts[2])
    }
  } else if (parsed.protocol === 'news:' || parsed.protocol === 'snews:') {
    if (/\/.+@.+/.exec(path)) {
      messageId = path[1]
    } else {
      throw new Error('news and snews protocol support is only implemented to support messageIds')
    }
  } else {
    throw new Error('Unsupported protocol')
  }
  return {
    protocol: parsed.protocol,
    host: parsed.hostname,
    port: parsed.port ? parseInt(parsed.port) : 119,
    username: parsed.username || undefined,
    password: parsed.password || undefined,
    group,
    articleNumber,
    messageId
  }
}

/**
 * Given a URI string using nntp, nntps, news, or snews protocols, attempts
 * to list a group or fetch an article. Will attempt to use STARTTLS if
 * protocol is nntps or snews. Will attempt to authenticate with AUTHINFO USER
 * if an authority is provided.
 *
 * A server (host) must be specified in the URI; there is no default host.
 *
 * A news or snews URI requesting one or more newsgroups is not supported.
 *
 * @example
 * const article = await fetch('news://news.gmane.org/p0624081dc30b8699bf9b@%5B10.20.30.108%5D')
 */
export async function fetch(uri: string): Promise<any> {
  const parsed = parse(uri)

  // Connect to host on port
  const client = new Client({
    host: parsed.host,
    port: parsed.port,
    tlsPort: false
  })
  await client.connect()

  // Optionally upgrade to TLS
  const capabilities = await client.capabilities()
  if (parsed.protocol === 'nntps:' || parsed.protocol === 'snews:') {
    if (!capabilities.capabilities.STARTTLS) {
      throw new Error(
        `Server does not support STARTTLS, yet requested protocol was ${parsed.protocol}`
      )
    }
    await client.startTls()
  }

  // Optionally authenticate
  if (parsed.username || parsed.password) {
    if (!parsed.username || !parsed.password) {
      throw new Error('Must specify both username and password')
    }
    if (parsed.protocol !== 'nntps:' && parsed.protocol !== 'snews:') {
      throw new Error('Authentication over TLS is strongly recommended, use snews or nntps')
    }
    if (!capabilities.capabilities.AUTHINFO) {
      throw new Error('Server does not support AUTHINFO, yet received username/password')
    }
    if (!capabilities.capabilities.AUTHINFO.includes('USER')) {
      throw new Error('Server support AUTHINFO, but not AUTHINTO USER, unable to authenticate')
    }
    const response = await client.authInfoUser(parsed.username)
    await response.authInfoPass(parsed.password)
  }

  // Fetch group or article
  let response
  if (parsed.protocol === 'nntp:' || parsed.protocol === 'nntps:') {
    response = parsed.articleNumber
      ? await client.article(parsed.articleNumber)
      : await client.group(parsed.group)
  } else if (parsed.protocol === 'news:' || parsed.protocol === 'snews:') {
    response = await client.article(parsed.messageId)
  }

  // Close connection and return group or article
  await client.quit()
  return response
}
