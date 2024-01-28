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
    let success = false;
    try {
        const subject = await Subjects.findOne({courseCode: req.params.courseCode});
        if(!subject){
            success=false;
            return res.status(404).json({success, error: "Course Not Found" });
        }

        const marks = await Marks.findOne({subject: subject._id, student: req.user.id})
        if(!marks){
            success=false;
            return res.status(403).json({success, error: "Not Enrolled" });
        }

        success=true;
        res.json({success,marks});
    } catch (error) {
        console.error(error.message);
        res.status(500).send("Internal Server Error");
    }
})

module.exports = router