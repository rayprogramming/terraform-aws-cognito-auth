import AWSXRay from "aws-xray-sdk-core";
import AWSNoXRay from "aws-sdk";
import dotenv from "dotenv";
import hashSecret from "./helpers/hashSecret";

const AWS = AWSXRay.captureAWS(AWSNoXRay);

dotenv.config();

const verifyBody = function(body) {
  let errors = [];
  if (!body.email || body.email == "") {
    errors.push("Email empty");
  }
  if (!body.username || body.username == "") {
    errors.push("Username empty");
  }
  if (!body.password || body.password == "") {
    errors.push("Password empty");
  }
  if (!body.phone_number || body.phone_number == "") {
    errors.push("Phone Number empty");
  }
  if (errors.length > 0) {
    throw errors;
  }
  return true;
};

// Create client outside of handler to reuse
const provider = new AWS.CognitoIdentityServiceProvider({
  region: "us-east-2"
});

// Handler
exports.handler = function(event, callback) {
  const segment = new AWSXRay.Segment("register_user");
  try {
    verifyBody(event.body);
  } catch (error) {
    callback(new Error(error));
    return false;
  }
  var params = {
    ClientId: process.env.CLIENT_ID,
    Password: event.body.password,
    Username: event.body.email,
    UserAttributes: [
      {
        Name: "email",
        Value: event.body.email
      },
      {
        Name: "phone_number",
        Value: event.body.phone_number
      }
    ]
  };
  hashSecret(params);
  provider.signUp(params).promise()
    .then(data => {
      segment.close();
      callback(null, {
        success: true,
        data: data
      });
      return true;
    })
    .catch(err => {
      segment.close();
      callback(new Error(err));
      return false;
    }).finally(() => {
      segment.close();
    });
  return false;
};
