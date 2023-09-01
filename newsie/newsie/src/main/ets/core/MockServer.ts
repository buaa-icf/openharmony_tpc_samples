import * as fs from 'fs'
import * as net from 'net'
import * as path from 'path'
import * as tls from 'tls'

export type Handler = (socket: net.Socket | tls.TLSSocket, line: string) => boolean
export type SimpleHandler = (command: string, args: string[]) => string | void

/* tslint:disable:no-console */

/**
 * Mock NNTP server suitable for integration testing an NNTP client. Not
 * intended to be used as a real server. Only supports one client at a time.
 */
export class Server {
  private _handlers: Handler[] = []
  private _port: number
  private _server: net.Server
  private _socket: net.Socket | tls.TLSSocket

  constructor(port: number = 0) {
    this._port = port
    this.resetHandlers()
  }

  public getListeningPort = () => {
    if (!this._server) throw new Error('[server] not yet listening on port')
    return (this._server.address() as net.AddressInfo).port
  }

  public listen = (): Promise<void> => {
    // Create server that adds handlers to new connections
    this._server = net.createServer(socket => {
      // TODO: warning, the following code only supports a single connection from a single client
      this._socket = socket
      this._listener(Buffer.from('GREETING'))
      socket.on('data', this._listener)
      socket.on('error', this._errorListener)
      socket.on('end', () => {
        const msg = '[server] CONNECTED CLOSED UNEXPECTEDLY'
        console.error(msg)
        this._errorListener(Buffer.from(msg))
      })
    })

    // Listen for connections
    return new Promise(resolve =>
      this._server.listen(this._port, 'localhost', undefined, () => resolve())
    )
  }

  public upgradeTls = () => {
    this._socket = new tls.TLSSocket(this._socket, {
      isServer: true,
      server: this._server,
      key: fs.readFileSync(path.join(__dirname, '../test/fixtures/private-key.pem')),
      cert: fs.readFileSync(path.join(__dirname, '../test/fixtures/cert.pem'))
    } as any)
    this._socket.on('data', this._listener)
    this._socket.on('error', this._errorListener)
    this._socket.on('end', () => {
      const msg = '[server] TLS CONNECTION CLOSED UNEXPECTEDLY'
      console.error(msg)
      this._errorListener(Buffer.from(msg))
    })
    this._socket.on('tlsClientError', this._errorListener)
  }

  public close = (): Promise<void> =>
    new Promise(resolve => {
      this._server.close(() => {
        this._server.unref()
        resolve()
      })
      this._socket.end()
      this._socket.destroy()
      this._socket.removeAllListeners()
      this._socket.unref()
    })

  public resetHandlers = () => {
    this._handlers = []
    this.addHandler(this.quitHandler)
    this.addSimpleHandler(this.greetingHandler)
  }

  public addHandler = (handler: Handler) => {
    this._handlers.push(handler)
  }

  public addSimpleHandler = (simpleHandler: SimpleHandler) => {
    this._handlers.push((socket, line) => {
      const s = line.trim().split(' ')
      const response = simpleHandler(s[0], s.slice(1))
      if (response) {
        this._socket.write(response)
      }
      return !!response
    })
  }

  private _errorListener = (chunk: Buffer) => {
    const line = chunk.toString('utf8')
    console.error(`[server] ERROR FOUND, CLOSING CONNECTION: ${line}`)
    this.close()
  }

  private _listener = (chunk: Buffer) => {
    const line = chunk.toString('utf8')
    const h = this._handlers.find(h => h(this._socket, line))
    if (!h) {
      console.error(`[server] UNHANDLED DATA RECEIVED: '${line}'`)
      this._socket.write('500 Unknown command\r\n')
    }
  }

  private greetingHandler: SimpleHandler = (command, args) =>
    command === 'GREETING' ? '200 posting permitted\r\n' : undefined

  private quitHandler: Handler = (socket, line) => {
    if (line.startsWith('QUIT')) {
      this._socket.write('205 NNTP Service exits normally\r\n')
      this.close()
      return true
    }
    return false
  }
}
