// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/access/Ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
        // up level when win battle combat => have more abilities
        uint32 level;
        // time period between attacking/feeding time
        uint32 readyTime;
    }

    Zombie[] public zombies;

    // declare mappings here
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    uint cooldownTime = 1 days;

    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime)));
        uint id = zombies.length - 1;

        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        emit NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "Error");
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
