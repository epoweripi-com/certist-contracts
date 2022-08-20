// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

interface ICredential {
    event Issued(uint256 credentialId, string credentialRoot);

    function name() external view returns (string memory);

    function issuer() external view returns (address);

    function issue(uint256 credentialId, string memory credentialRoot) external;

    function credentialRoot(uint256 credentialId)
        external
        view
        returns (string memory);
}
