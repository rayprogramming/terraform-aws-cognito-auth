module.exports = {
  testEnvironment: 'node',
  modulePathIgnorePatterns: ['<rootDir>/dist/', '<rootDir>/build/'],
  testMatch: ['**/*.test.js', '*.test.js'],
  moduleDirectories: ["node_modules", "src"],
  moduleNameMapper: {
    "^[\$]e-(.*)": "<rootDir>/tests/events/$1",
    "^[\$](.*)": "<rootDir>/src/$1",
  },
  transform: {
    "^.+\\.(js|jsx)$": "babel-jest",
  }
}
