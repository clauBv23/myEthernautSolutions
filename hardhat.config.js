require('dotenv').config();

module.exports = {
  networks: {
    hardhat: {
      tags: ['local'],
      allowUnlimitedContractSize: true,
    },
    localhost: {
      url: 'http://127.0.0.1:7545',
      tags: ['local'],
    },
  },
  mocha: {
    timeout: 999999,
  },
  solidity: {
    compilers: [
      {
        version: '0.8.17',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
};