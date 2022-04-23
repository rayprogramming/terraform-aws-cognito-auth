import AWSXRay from "aws-xray-sdk-core";
import AWSNoXRay from "aws-sdk";
import dotenv from "dotenv";
import hashSecret from "./helpers/hashSecret";

const AWS = AWSXRay.captureAWS(AWSNoXRay);

dotenv.config();

const provider = new AWS.CognitoIdentityServiceProvider({
  region: "us-east-2"
});


exports.handler = async function(event) {
  const segment = new AWSXRay.Segment("confirm_register_user");
  var params = {
    ClientId: process.env.CLIENT_ID,
    ConfirmationCode: event.body.confirmation_code,
    Username: event.body.username
  };
  hashSecret(params);
  let res;
  await provider.confirmSignUp(params).promise()
    .then(data => {
      res = data;
    })
    .catch(err => {
      res = {
        error: "There was an error.",
        message: err.message
      };
    });
  segment.close();
  console.log(res);
  return res;
};
