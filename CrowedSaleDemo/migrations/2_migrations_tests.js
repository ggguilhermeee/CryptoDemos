const SimpleToken = artifacts.require("SimpleToken");

module.exports = function (deployer) {
  deployer.deploy(SimpleToken, 0);
};
