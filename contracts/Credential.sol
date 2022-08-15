// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./interfaces/ICredential.sol";

contract Credential is ICredential {
    address public issuer;
    string public name;

    event IssuerSet(address issuer);

    mapping(uint256 => string) public credentialRoots;

    modifier onlyIssuer() {
        require(msg.sender == issuer);
        _;
    }

    constructor(string memory _name) {
        name = _name;
        issuer = msg.sender;
        emit IssuerSet(issuer);
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

    function credentialRoot(uint256 credentialId)
        external
        view
        returns (string memory)
    {
        return credentialRoots[credentialId];
    }

    function changeIssuer(address newIssuer) external onlyIssuer {
        issuer = newIssuer;
        emit IssuerSet(newIssuer);
    }
}
