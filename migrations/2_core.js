const GNS = artifacts.require('GNS');

module.exports = (deployer, network, accounts) => {

    deployer
        .then(_ => deployer.deploy(GNS))
        .catch(console.error);
};
