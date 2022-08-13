// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "./interfaces/ICertificate.sol";

contract Certificate is ICertificate {
    address public issuer;
    string public name;
    string public issuerURI;

    // event Issued(uint256 certificateId, string certificateURI);
    // event Claimed(uint256 certificateID, address receiver);
    // event Request(uint256 certificateId, address receiver);
    event OwnerSet(address owner);

    mapping(uint256 => string) public tokenURIs;
    mapping(uint256 => address) public receivers;

    mapping(uint256 => address[]) claims;

    modifier onlyIssuer() {
        require(msg.sender == issuer);
        _;
    }

    constructor(string memory _name, string memory _issuerURI) {
        name = _name;
        issuerURI = _issuerURI;
        issuer = msg.sender;
        emit OwnerSet(issuer);
    }

    function issue(uint256 certificateId, string memory uri)
        external
        onlyIssuer
    {
        require(bytes(uri).length != 0, "INVALID_URI");
        require(
            bytes(tokenURIs[certificateId]).length == 0,
            "CERTIFICATE_CREATED"
        );
        tokenURIs[certificateId] = uri;
        emit Issued(certificateId, uri);
    }

    function issue(
        uint256 certificateId,
        string memory uri,
        address receiver
    ) external onlyIssuer {
        require(bytes(uri).length != 0, "INVALID_URI");
        require(
            bytes(tokenURIs[certificateId]).length == 0,
            "CERTIFICATE_CREATED"
        );
        tokenURIs[certificateId] = uri;
        receivers[certificateId] = receiver;
        emit Issued(certificateId, uri);
        emit Claimed(certificateId, receiver);
    }

    function requestClaim(uint256 certificateId, address receiver) external {
        require(receivers[certificateId] == address(0), "CLAIMED_CERTIFICATE");
        claims[certificateId].push(receiver);
        emit Request(certificateId, receiver);
    }

    function approveClaim(uint256 certificateId, address receiver) external {
        require(receivers[certificateId] == address(0), "CLAIMED_CERTIFICATE");
        receivers[certificateId] = receiver;
        emit Claimed(certificateId, receiver);
    }

    function certificateURI(uint256 certificateId)
        external
        view
        returns (string memory)
    {
        return tokenURIs[certificateId];
    }
}
