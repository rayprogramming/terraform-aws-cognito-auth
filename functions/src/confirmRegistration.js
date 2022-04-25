import AWSXRay from "aws-xray-sdk-core";
import AWSNoXRay from "aws-sdk";
import dotenv from "dotenv";
import hashSecret from "./helpers/hashSecret";

const AWS = AWSXRay.captureAWS(AWSNoXRay);

dotenv.config();

const provider = new AWS.CognitoIdentityServiceProvider({
  region: "us-east-2"
});


exports.handler = function(event, callback) {
  const segment = new AWSXRay.Segment("confirm_register_user");
  var params = {
    ClientId: process.env.CLIENT_ID,
    ConfirmationCode: event.body.confirmation_code,
    Username: event.body.username
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
      callback(new Error(err));
      return false;
    }).finally(() => {
      segment.close();
    });
  return false;
};
