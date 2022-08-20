const Credential = artifacts.require("Credential");

module.exports = function (deployer) {
  deployer.deploy(Credential, "Certist Credential", "");
};
