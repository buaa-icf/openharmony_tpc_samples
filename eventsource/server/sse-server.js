const express = require('express')
const fs =require('fs')
const serveStatic = require('serve-static')
const { default: SseStream } = require('ssestream')

const app = express()
app.use(serveStatic(__dirname))
app.get('/sse', (req, res) => {
  console.log('new connection')
  console.log(req.url)
   res.setHeader(  'Content-Type', 'application/octet-stream' ); 
  const sseStream = new SseStream(req)
  sseStream.pipe(res)
  const pusher = setInterval(() => {
    sseStream.write({
      event: 'server-time',
      data: new Date().toTimeString()
    })
  }, 2000)
  res.on('close', () => {
    console.log('lost connection')
    clearInterval(pusher)
    sseStream.unpipe(res)
  })
})
app.listen(8080, (err) => {
  if (err) throw err
  console.log('server ready on http://localhost:8080')
})