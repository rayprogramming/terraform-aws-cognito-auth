const register = require("$register");
const fs = require("fs");
import registerEmpty from "$e-registerEmpty.json"
import registerGood from "$e-registerGood.json"

test("All failures", async () => {
  let response = await register.handler(registerEmpty, null);
  expect(response).toContain('Email empty')
  expect(response).toContain('Username empty')
  expect(response).toContain('Password empty')
  expect(response).toContain('Phone Number empty')
});
test("Registers User", async () => {
  let response = await register.handler(registerGood, null);
  expect(response).not.toContain('Email empty')
  expect(response).not.toContain('Username empty')
  expect(response).not.toContain('Password empty')
  expect(response).not.toContain('Phone Number empty')
  expect_or(
    () => expect(response.UserSub).toBeTruthy(),
    () => expect(response.message).toContain('User already exists')
  )
});

function expect_or(...tests) {
  try {
    tests.shift()();
  } catch(e) {
    if (tests.length) expect_or(...tests);
    else throw e;
  }
}
