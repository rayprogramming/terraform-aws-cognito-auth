import AWSXRay from "aws-xray-sdk-core";

exports.handler = function(event, callback) {
  const segment = new AWSXRay.Segment("home_page");
  let res = {
    "message": "We are currently not taking in new registrations"
  };

  segment.close();
  callback(null, res);
};
