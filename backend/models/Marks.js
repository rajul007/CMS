const mongoose = require('mongoose');
const {Schema} = mongoose;

const MarksSchema = new Schema({
    student:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user'
    },
    subject:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'subject'
    },
    ct1:{
        type: Number,
        required: true,
    },
    ct2:{
        type: Number,
        required: true,
    },
    ca:{
        type: Number,
        required: true
    },
    dha:{
        type: Number,
        required: true
    },
    aa:{
        type: Number,
        required: true
    },
    attendance:{
        type: Number,
        required: true
    },
    attendance:{
        type: Number,
        required: true
    },
  });

  const Marks = mongoose.model('marks', MarksSchema);

  module.exports = Marks