export default (err) => {
  return {
    "statusCode": parseInt(err.statusCode),
    "headers": {
      "content-type": "application/json"
    },
    "body": JSON.stringify({
      "code": err.code,
      "message": err.message
    })
  };
};
