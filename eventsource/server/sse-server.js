const express = require('express')
const fs =require('fs')
const serveStatic = require('serve-static')
const { default: SseStream } = require('ssestream')

const app = express()
app.use(serveStatic(__dirname))
app.get('/sse', (req, res) => {
  console.log('new connection')
  console.log('URL:', req.url)
  console.log('Headers:', JSON.stringify(req.headers, null, 2))
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
const PORT = process.env.PORT || 9000
app.listen(PORT, '0.0.0.0', (err) => {
  if (err) throw err
  console.log(`server ready on http://0.0.0.0:${PORT}`)
})