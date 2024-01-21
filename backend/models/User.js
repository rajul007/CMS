const mongoose = require('mongoose');
const {Schema} = mongoose;

const UserSchema = new Schema({
    name:{
        type: String,
        required: true
    },
    email:{
        type: String,
        required: true,
        unique: true
    },
    password:{
        type: String,
        required: true
    },
    date:{
        type: Date,
        default: Date.now
    },
    username:{
        type: String,
        required: true,
        unique: true
    },
    address:{
        type: String,
        required: true,
    },
    userType:{
        type: String,
        required: true,
    },
    phonenumber:{
        type: String,
        required: true,
        unique:true,
    },
  });

  const User = mongoose.model('user', UserSchema);

  module.exports = User