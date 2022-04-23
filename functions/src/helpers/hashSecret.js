import crypto from "crypto";

export default (params) => {
  let secretHash = crypto
    .createHmac("SHA256", process.env.CLIENT_SECRET)
    .update(params.Username + process.env.CLIENT_ID)
    .digest("base64");
  params.SecretHash = secretHash;
  return params;
};
