// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./interfaces/ICredential.sol";

contract Credential is ICredential {
    // wallet address of the issuer
    address public issuer;
    // name of the credential
    string public name;
    // uri that returns information about the issuer and the credential.
    string public credentialURI;

    event IssuerSet(address issuer);
    event CredentialURI(string uri);

    mapping(uint256 => string) public credentialRoots;

    modifier onlyIssuer() {
        require(msg.sender == issuer);
        _;
    }

    constructor(string memory _name, string memory _credentialURI) {
        name = _name;
        issuer = msg.sender;
        credentialURI = _credentialURI;
        emit IssuerSet(issuer);
        emit CredentialURI(_credentialURI);
    }

    function issue(uint256 credentialId, string memory root)
        external
        onlyIssuer
    {
        require(bytes(root).length != 0, "INVALID_ROOT");
        require(
            bytes(credentialRoots[credentialId]).length == 0,
            "CERTIFICATE_CREATED"
        );
        credentialRoots[credentialId] = root;
        emit Issued(credentialId, root);
    }

    function changeIssuer(address newIssuer) external onlyIssuer {
        issuer = newIssuer;
        emit IssuerSet(newIssuer);
    }

    function updateCredentialURI(string memory _newURI) external onlyIssuer {
        credentialURI = _newURI;
        emit CredentialURI(_newURI);
    }

    function credentialRoot(uint256 credentialId)
        external
        view
        returns (string memory)
    {
        return credentialRoots[credentialId];
    }
}
