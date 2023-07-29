const AWS = require('aws-sdk');

const sesConfig = {
    apiVersion: '2010-12-01',
    region: 'eu-west-2',
};
const ses = new AWS.SES(sesConfig);

exports.handler =  async (event, context, callback) => {
    
    // console.log("TTTTTTTT: " + JSON.stringify(event));
    
    const params = {
        Destination: {
            ToAddresses: ["hapihour.io@gmail.com"],
        },
        Message: {
            Body: {
                Html: {
                    Charset: 'UTF-8',
                    Data: "Please signup: " + event.queryStringParameters['emailAddress'],
                },
            },
            Subject: {
                Charset: 'UTF-8',
                Data: "NEW HAPIHOIUR SIGNUP!",
            }
        },
        Source: "thomasmorris823@gmail.com"
    };
    
    await ses.sendEmail(params).promise().then((data) => {

        console.log(data);
        const response = {
            "statusCode": 200,
            "body": JSON.stringify(data),
            "isBase64Encoded": false
        };
        callback(null, response);

    }).catch((err) => {
    
        console.error(err);
        const response = {
            "statusCode": 501,
            "body": JSON.stringify(err),
            "isBase64Encoded": false
        };
        callback(err,response);

    });
};