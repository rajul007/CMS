const express = require('express');
const router = express.Router();
const Marks = require('../models/Marks');
const Subjects = require('../models/Subjects');
const fetchuser = require('../middleware/fetchuser');
const { body, validationResult } = require('express-validator');


// ROUTE: Get Student marks in particular subject using: GET "/api/marks/my-marks/:subjectId" 
// Login Required
// Student Only
router.get('/my-marks/:courseCode', fetchuser, async (req, res) => {
    try {
        const subject = await Subjects.findOne({courseCode: req.params.courseCode});
        if(!subject){
            return res.status(404).json({ error: "Course Not Found" });
        }

        const marks = await Marks.findOne({subject: subject._id, student: req.user.id})
        if(!marks){
            return res.status(403).json({ error: "Not Enrolled" });
        }

        res.json(marks);
    } catch (error) {
        console.error(error.message);
        res.status(500).send("Internal Server Error");
    }
})

module.exports = router