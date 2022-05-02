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
  const segment = new AWSXRay.Segment("confirm_register_user");
  var body;
  if (event.body !== null && event.body !== undefined) {
    body = JSON.parse(event.body);
  } else{
    callback(new Error("Expected post Body"));
  }
  var confirm_code;
  if (typeof body.confirmation_code === "string" || body.confirmation_code instanceof String){
    confirm_code = body.confirmation_code;
  }else {
    confirm_code = body.confirmation_code.toString();
  }
  var params = {
    ClientId: process.env.CLIENT_ID,
    ConfirmationCode: confirm_code,
    Username: body.username
  };
  hashSecret(params);

  provider.confirmSignUp(params).promise()
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
      callback(null, parseAWSError(err));
      return false;
    }).finally(() => {
      segment.close();
    });
  return false;
};
