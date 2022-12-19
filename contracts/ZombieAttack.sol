// SPDX-License-Identifier:
pragma solidity ^0.8.17;

import "./ZombieHelper.sol";

contract ZombieAttack is ZombieHelper {
    uint randNonce = 0;

    function randMod(uint _modulus) internal returns (uint) {
        randNonce++;
        return
            uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
}
