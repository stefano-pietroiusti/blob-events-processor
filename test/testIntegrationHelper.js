const R = require('ramda');
const uuidv4 = require('uuid/v4');
const sinon = require('sinon');
const config = require('../src/utils/config');
const env = require('env2')('./blob-events-processor.env');
// const fileMetadataStatusStages = require('./__resource__/fileMetadata').fileMetadataStatusStages;

/**
 * Require this for each integration test file ensures the config is cached before the tests
 * are run and has a 2 minute timeout so the local runs can do interactive login in time
 */

const sandbox = sinon.createSandbox();

/**
 * Stubs logentries.
 */
const stubLogEntries = () => {
  sandbox.stub(logEntries, 'createLog').returns();
};

const generateRandomIds = () => ({
  fileId: `${uuidv4().replace(/^.{8}/, 'ffffffff')}`,
  orgId: `ip_${uuidv4().replace(/^.{8}/, 'ffffffff')}`
});

/**
 * Generates a ramdom file name with special characters and a blank space
 */
const generateRamdomFileName = () => {
  const specialChars = R.repeat(String.fromCharCode(0x30A0 + Math.random()
    * (0x30FF - 0x30A0 + 1)), 3).toString();

  return R.replace(/,/g, '', R.concat(R.concat(R.concat(specialChars, ' '), specialChars), '.txt'));
};

const sandboxRestore = () => sandbox.restore();

module.exports = {
  // fileMetadataStatusStages,
  generateRandomIds,
  generateRamdomFileName
};
