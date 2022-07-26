const mongoose = require('mongoose');

const BarsSchema = new mongoose.Schema({
    name:{
        type: String,
        require: true
    },
    city:{
        type: String,
        require: true
    },
    address:{
        type: String,
        require: true
    },
    location: {
        type: {
          type: String, 
          enum: ['Point'],
          required: true
        },
        coordinates: {
          type: [Number],
          required: true
        }
    },
    place_id:{
        type: String,
        require: true,
        unique: true
    },
    website:{
        type: String,
        require: false
    },
    social:{
        facebook:{
            type: String,
            require: false
        },
        instagram:{
            type: String,
            require: false
        },
        twitter:{
            type: String,
            required: false
        },
    },
    openingTimes: [
        {
            mon: {
                open: String,
                close: String,
            },
            tue: {
                open: String,
                close: String,
            },
            wed: {
                open: String,
                close: String,
            },
            thu: {
                open: String,
                close: String,
            },
            fri: {
                open: String,
                close: String,
            },
            sat: {
                open: String,
                close: String,
            },
            sun: {
                open: String,
                close: String,
            },
        }
    ],
    imgUrl:{
        type: String,
        require: false
    },
    imgUrls:{
        type: [String],
        require: false
    },
    lastUpdated:{
        type: String,
        require: false
    },
    announcement: {
        type: {
            post: { 
                type: String,
                required: true
            },
            time: { 
                type: String,
                required: true
            }
        },
        required:false
    },
    validated:{
        type: Boolean,
        require: true
    },
    deals:{
        type: [{
            startTime:{
                type: String,
                require: true
            },
            endTime:{
                type: String,
                require: true
            },
            weekDays:{
                type: [Number],
                required: true
            },
            description:{
                type: [String],
                require: true
            },
            fullDescription:{
                type: String,
                require: true
            }
        }],
        required: true
    }
});

module.exports = mongoose.model('Bar', BarsSchema);