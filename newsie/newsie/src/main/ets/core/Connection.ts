import { createConnection, Socket } from 'net'
// import {
//   connect as tlsConnect,
//   ConnectionOptions as TlsConnectionOptions,
//   TlsOptions,
//   TLSSocket
// } from 'tls'
// import * as zlib from 'zlib'

interface ResponseHandler {
  callback: Function
  resolve: Function
  reject: Function
}

/**
 * TODO: reject on promises on timeout
 * TODO: support compression (doesn't yet work)
 */

class Connection {
  private _compress: any
  private _socket: Socket | TLSSocket
  private _tlsPort: boolean
  private _tlsOptions: TlsOptions
  // tslint:disable-next-line
  private _tlsPromiseReject: Function | void
  private _host: string
  private _port: number
  private _queue: ResponseHandler[]
  private _frames: string

  constructor(host: string, port: number, tlsPort: boolean, tlsOptions: TlsOptions) {
    this._host = host
    this._port = port
    this._tlsPort = tlsPort
    this._tlsOptions = tlsOptions
    this._queue = []
    this._frames = ''
    this._compress = undefined
  }

  public connect = (): Promise<Socket | TLSSocket> => {
    this._socket = createConnection(this._port, this._host)
    this._addSocketHandlers()
    return Promise.resolve(this._socket);
    return this._tlsPort ? this.upgradeTls() : Promise.resolve(this._socket)
  }

  public disconnect = () => {
    // Close connection
    this._socket.end()
    this._socket.destroy()
    this._socket.removeAllListeners()
    this._socket.unref()
    if (this._tlsPromiseReject) {
      this._tlsPromiseReject()
    }

    // Empty the queue
    this._queue.forEach(h => h.reject(new Error('Disconnected from server')))
    this._queue = []
  }

  public write = (str: string): Promise<void> => {
    // if (this._compress) {
    //   str = zlib.deflateSync(str).toString('base64')
    // }
    return new Promise((resolve, reject) =>
      this._socket.write(str, 'utf8', err => (err ? reject(err) : resolve()))
    )
  }

  public addCallback = (callback: Function, resolve: Function, reject: Function) => {
    this._queue.push({ callback, resolve, reject })
  }

  public upgradeTls = (): Promise<Socket | TLSSocket> =>
  {
    // return   new Promise((resolve, reject) => {
    //   this._tlsPromiseReject = reject
    //   this._socket = tlsConnect(
    //     ({
    //       ...this._tlsOptions,
    //       socket: this._socket
    //     } as unknown) as TlsConnectionOptions, // tslint:disable-line
    //     () => {
    //       this._tlsPromiseReject = undefined
    //       resolve(this._socket)
    //     }
    //   )
    //   this._addSocketHandlers()
    // })
  }
  

  public enableCompression = () => {
    this._compress = 'deflate'
    /* tslint:disable:no-console */
    this._socket.on('drain', () => console.log('drain'))
    this._socket.on('end', () => console.log('end'))
    this._socket.on('lookup', () => console.log('lookup'))
    this._socket.on('timeout', () => console.log('timeout'))
    /* tslint:enable:no-console */
  }

  private _handler = (frame: string): void => {
    // if (this._compress) {
    //   frame = zlib.inflateSync(Buffer.from(frame)).toString()
    // }
    this._frames += frame
    const responseHandler = this._queue[0]

    let response
    try {
      response = responseHandler.callback(this._frames)
    } catch (err) {
      // TODO: remove console.error method
      // tslint:disable-next-line
      console.error('Fatal parse error, terminating connection', err)
      this.disconnect()
      return
    }
    if (!response) {
      return
    }
    this._frames = this._frames.slice(response._i)
    this._queue.shift()
    delete response._i
    responseHandler.resolve(response)

    // Handle pipelined responses sent in single frame
    if (this._frames !== '') {
      this._handler('')
    }
  }

  private _addSocketHandlers = (): void => {
    this._socket.on('data', this._handler)
    this._socket.on('error', err => {
      this._queue.forEach(h => h.reject(err))
      this.disconnect()
      throw err
    })
    this._socket.on('end', () => {
      const err = new Error('Received FIN packet from server, closing connection automatically')
      this._queue.forEach(h => h.reject(err))
      this.disconnect()
    })
    this._socket.on('tlsClientError', err => {
      this._queue.forEach(h => h.reject(err))
      this.disconnect()
      throw err
    })
    this._socket.once('close', () => {
      this._queue.forEach(h => h.reject(new Error('Connection closed')))
      this._socket.removeAllListeners()
    })
  }
}

export default Connection
