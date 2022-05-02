import AWSXRay from "aws-xray-sdk-core";
import AWSNoXRay from "aws-sdk";
import dotenv from "dotenv";
import hashSecret from "./helpers/hashSecret";
import parseAWSError from "./helpers/parseAWSError";

const AWS = AWSXRay.captureAWS(AWSNoXRay);

dotenv.config();

const provider = new AWS.CognitoIdentityServiceProvider({
  region: "us-east-2"
});


exports.handler = function(event, context, callback) {
  var body;
  if (event.body !== null && event.body !== undefined) {
    body = JSON.parse(event.body);
  } else{
    callback(new Error("Expected post Body"));
  }
  const segment = new AWSXRay.Segment("login_user");
  if (!body || !body.email || !body.password) {
    callback(new Error("Invalid parameters."));
    return false;
  }

  var params = {
    "AuthFlow": "USER_PASSWORD_AUTH",
    "ClientId": process.env.CLIENT_ID,
    "AuthParameters": {
      "USERNAME": body.email,
      "PASSWORD": body.password
    }
  };
  hashSecret(params.AuthParameters, "USERNAME", "SECRET_HASH");
  console.log(params);
  provider.initiateAuth(params).promise()
    .then(data => {
      segment.close();
      console.log(data);
      callback(null, {
        success: true,
        data: data
      });
      return true;
    })
    .catch(err => {
      segment.close();
      console.log(err);
      callback(null, parseAWSError(err));
      return false;
    }).finally(() => {
      segment.close();
    });
  console.log("other");
  return false;
};
