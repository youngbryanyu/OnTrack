/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: ['**/tests/**/*.test.ts'],
  coverageProvider: 'babel',
  coverageThreshold: { /* TODO: set thresholds to 80% after finishing register tests */
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  collectCoverage: true,  /* force tests to pass coverage or else will exit with error */
  collectCoverageFrom: [
    'src/**/*.ts',        /* include all files in src directory*/
    '!src/**/index.ts',   /* exclude index.ts files */
    '!src/**/models/**',  /* exclude data models */
    '!src/config/**',     /* exclude config and constants */
    '!src/logging/**',     /* exclude logging setup */
    // '!src/**/rateLimit/**' /* exclude rate limiting setup files */
  ],
  setupFilesAfterEnv: ['./jest.setup.js'] /* Global set up file */,
  // workerIdleMemoryLimit: '512mb'          /* Set worker process idle memory limit */
};