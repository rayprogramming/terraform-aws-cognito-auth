import AWSXRay from "aws-xray-sdk-core";
import AWSNoXRay from "aws-sdk";
import dotenv from "dotenv";
import hashSecret from "./helpers/hashSecret";
import parseAWSError from "./helpers/parseAWSError";

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
exports.handler = function(event, context, callback) {
  var body;
  if (event.body !== null && event.body !== undefined) {
    body = JSON.parse(event.body);
  } else{
    callback(new Error("Expected post Body"));
  }

  const segment = new AWSXRay.Segment("register_user");
  try {
    verifyBody(body);
  } catch (error) {
    callback(new Error(error));
    return false;
  }
  var params = {
    ClientId: process.env.CLIENT_ID,
    Password: body.password,
    Username: body.email,
    UserAttributes: [
      {
        Name: "email",
        Value: body.email
      },
      {
        Name: "phone_number",
        Value: body.phone_number
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
      callback(null, parseAWSError(err));
      segment.close();
      return true;
    }).finally(() => {
      segment.close();
    });
  return false;
};
