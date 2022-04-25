import AWSXRay from "aws-xray-sdk-core";
import AWSNoXRay from "aws-sdk";
import dotenv from "dotenv";

const AWS = AWSXRay.captureAWS(AWSNoXRay);

dotenv.config();

const provider = new AWS.CognitoIdentityServiceProvider({
  region: "us-east-2"
});


exports.handler = function(event, callback) {
  const segment = new AWSXRay.Segment("login_user");
  if (!event.body || !event.body.email || !event.body.password) {
    callback(new Error("Invalid parameters."));
    return false;
  }

  var poolData = {
    UserPoolId: process.env.POOL_ID,
    ClientId: process.env.CLIENT_ID
  };

  var userPool = provider.CognitoUserPool(poolData);
  var authData = {
    Username: event.body.email,
    Password: event.body.password
  };

  var authDetails = provider.AuthenticationDetails(authData);
  var userData = {
    Username: event.body.email,
    Pool: userPool
  };

  var cognitoUser = provider.CognitoUser(userData);

  cognitoUser.authenticateUser(authDetails).promise()
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
