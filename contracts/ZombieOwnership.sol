// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ZombieAttack.sol";
import "./IERC721.sol";

contract ZombieOwnership is ZombieAttack, IERC721 {
    function balanceOf(
        address _owner
    ) external view returns (uint256) {
        return ownerZombieCount[_owner];
    }

    function ownerOf(
        uint256 _tokenId
    ) external view returns (address) {
        return zombieToOwner[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable override {}

    function approve(
        address _approved,
        uint256 _tokenId
    ) external payable override {}
}