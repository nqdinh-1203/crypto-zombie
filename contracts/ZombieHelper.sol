// SPDX-License-Identifier:
pragma solidity ^0.8.17;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    // Start here
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level, "Level of zombie is less than this level");
        _;      
    }

    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId], "Caller does not own this Zombie");
        zombies[_zombieId].name = _newName;
    }

    function changeDNA(uint _zombieId, uint _newDNA) external aboveLevel(20, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId], "Caller does not own this Zombie");
        zombies[_zombieId].dna = _newDNA;
    }

    function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
        uint[] memory result = new uint[](ownerZombieCount[_owner]);

        return result;
    }
}
