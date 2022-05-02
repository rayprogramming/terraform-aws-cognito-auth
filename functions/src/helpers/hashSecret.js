import crypto from "crypto";

export default (params, usernameKey = "Username", secretKey = "SecretHash") => {
  let secretHash = crypto
    .createHmac("SHA256", process.env.CLIENT_SECRET)
    .update(params[usernameKey] + process.env.CLIENT_ID)
    .digest("base64");
  params[secretKey] = secretHash;
  return params;
};
