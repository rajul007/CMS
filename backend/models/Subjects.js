const mongoose = require('mongoose');
const {Schema} = mongoose;

const SubjectSchema = new Schema({
    courseCode:{
        type: String,
        required: true,
        unique: true
    },
    courseName:{
        type: String,
        required: true,
    },
    credits:{
        type: Number,
        required: true
    },
    teacher:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user'
    },
  });

  const Subject = mongoose.model('subject', SubjectSchema);

  module.exports = Subject