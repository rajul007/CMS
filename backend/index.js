const connectToMongo = require('./db');

connectToMongo();

const express = require('express')

const app = express()
const port = 5000


// Middleware (To use req.body)
app.use(express.json());


app.listen(port, () => {
  console.log(`CMS_Backend backend listening at http://localhost:${port}`)
})