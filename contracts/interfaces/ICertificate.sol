// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

interface ICertificate {
    event Issued(uint256 certificateId, string certificateURI);
    event Claimed(uint256 certificateId, address receiver);
    event Request(uint256 certificateId, address receiver);

    function name() external view returns (string memory);

    function issuer() external view returns (address);

    function issue(uint256 certificateId, string memory certificateURI)
        external;

    function requestClaim(uint256 certificateId, address receiver) external;

    function approveClaim(uint256 certificateId, address receiver) external;

    function certificateURI(uint256 certificateId)
        external
        view
        returns (string memory);
}
