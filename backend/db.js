const mongoose = require('mongoose');
require('dotenv').config();
const mongoURI = process.env.ATLAS_URI;

const connectToMongo = ()=>{
    mongoose.connect(mongoURI);

    mongoose.connection.on('connected', () => {
        console.log("Connected to MongoDB successfully");
    });

    mongoose.connection.on('error', (error) => {
        console.error("Error connecting to MongoDB:", error.message);
    });
}

module.exports = connectToMongo;