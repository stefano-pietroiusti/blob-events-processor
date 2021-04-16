const fs = require('fs');
const path = require('path');
const sinon = require('sinon');
const env = require('env2')('./blob-events-processor.env');
const logEntries = require('../src/gateways/logentries');
const logHelper = require('../src/utils/logHelper');

const sandbox = sinon.createSandbox();

/**
 * Stubs logentries.
 */
const stubLogEntries = () => {
  sandbox.stub(logEntries, 'createLog').returns();
};

/**
 * Creates a file with the build info.
 */
const addBuildInfoFile = () => {
  try {
    const pathFileName = path.resolve(__dirname, '../src/build.txt');

    if (fs.existsSync(pathFileName)) {
      fs.unlinkSync(pathFileName);
    }

    const content = 'repo: file-manager.processor, build: n/a, branch: AIT2-3122, commit: 47fc5cf';
    fs.appendFileSync(pathFileName, content);
  } catch (error) {
    logHelper.log('testUnitHelper_addBuildInfoFile', error);
    throw error;
  }
};

/**
 * Removes the file with the build info.
 */
const removeBuildInfoFile = () => {
  const pathFileName = path.resolve(__dirname, '../src/build.txt');

  fs.unlinkSync(pathFileName);
};


const sandboxRestore = () => sandbox.restore();


module.exports = {
  stubLogEntries,
  sandboxRestore,
  addBuildInfoFile,
  removeBuildInfoFile
};
