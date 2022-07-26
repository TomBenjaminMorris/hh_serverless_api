'use strict';

const connectToDatabase = require('./db');
const Bar = require('./models/Bar');
require('dotenv').config({ path: './variables.env' });

//// GET ////
// Get single bar info
module.exports.getOne = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  connectToDatabase()
    .then(() => {
      if(!event.queryStringParameters['place_id']){
        return Promise.reject('missing URL param: place_id');
      }

      Bar.findOne({
        place_id: event.queryStringParameters['place_id']
      })
        .then(bar => callback(null, {
          statusCode: 200,
          body: JSON.stringify(bar)
        }))
        .catch(err => callback(null, {
          statusCode: err.statusCode || 500,
          headers: { 'Content-Type': 'text/plain' },
          body: 'Could not fetch the bar.'
        }));
    });
};

// Get all bars info
module.exports.getAll = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  connectToDatabase()
    .then(() => {
      Bar.find()
        .then(bars => callback(null, {
          statusCode: 200,
          body: JSON.stringify(bars)
        }))
        .catch(err => callback(null, {
          statusCode: err.statusCode || 500,
          headers: { 'Content-Type': 'text/plain' },
          body: 'Could not fetch the bars.'
        }))
    });
};

// Get locations
module.exports.getLocations = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  connectToDatabase()
    .then(() => {
      Bar.find({ location: { $nearSphere: { $geometry: { type: "Point", coordinates: [event.queryStringParameters['lat'], event.queryStringParameters['long']]}, $maxDistance: event.queryStringParameters['miles'] * 1609.34 }}})
        .then(bars => callback(null, {
          statusCode: 200,
          body: JSON.stringify(bars)
        }))
        .catch(err => callback(null, {
          statusCode: err.statusCode || 500,
          headers: { 'Content-Type': 'text/plain' },
          body: 'Could not fetch the bars.'
        }))
    });
};

// Find by name
module.exports.findByName = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  connectToDatabase()
    .then(() => {
      Bar.find({ "name" : { $regex: event.queryStringParameters['name'], $options: 'i' }}).select({ "name": 1, "place_id": 1, "_id": 0})
        .then(bars => callback(null, {
          statusCode: 200,
          body: JSON.stringify(bars)
        }))
        .catch(err => callback(null, {
          statusCode: err.statusCode || 500,
          headers: { 'Content-Type': 'text/plain' },
          body: 'Could not fetch the bars.'
        }))
    });
};

//// POST ////
// Create one bar
module.exports.createOne = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  if(!event.body){
    return Promise.reject('Request body is missing');
  }

  connectToDatabase()
    .then(() => {
      Bar.create(JSON.parse(event.body))
        .then(bar => callback(null, {
          statusCode: 200,
          body: JSON.stringify(bar)
        }))
        .catch(err => callback(null, {
          statusCode: err.statusCode || 500,
          headers: { 'Content-Type': 'text/plain' },
          body: 'Could not create the bar.'
        }));
    });
};

//// PUT ////
// Update one bar
module.exports.updateOne = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  connectToDatabase()
    .then(() => {
      Bar.findOneAndUpdate({
        place_id: event.queryStringParameters['place_id']
      }, JSON.parse(event.body), { new: true })
        .then(bar => callback(null, {
          statusCode: 200,
          body: JSON.stringify(bar)
        }))
        .catch(err => callback(null, {
          statusCode: err.statusCode || 500,
          headers: { 'Content-Type': 'text/plain' },
          body: 'Could not fetch the bar.'
        }));
    });
};

//// DELETE ////
// Delete one bar
module.exports.deleteOne = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  connectToDatabase()
    .then(() => {
      Bar.findOneAndRemove({
        place_id: event.queryStringParameters['place_id']
      })
        .then(bar => callback(null, {
          statusCode: 200,
          body: JSON.stringify({ message: 'Removed bar with id: ' + bar.place_id, bar: bar })
        }))
        .catch(err => callback(null, {
          statusCode: err.statusCode || 500,
          headers: { 'Content-Type': 'text/plain' },
          body: 'Could not fetch the bars.'
        }));
    });
};