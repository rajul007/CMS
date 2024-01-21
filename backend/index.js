const connectToMongo = require('./db');

connectToMongo();

const express = require('express')

const app = express()
const port = 5000


// Middleware (To use req.body)
app.use(express.json());

// Available Routes
app.use('/api/auth', require('./routes/auth'))

app.listen(port, () => {
  console.log(`CMS_Backend backend listening at http://localhost:${port}`)
})