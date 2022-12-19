# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

## Lesson 4: Zombie Battle System

### Chapter 1: Payable
### Chapter 2: Withdraws
### Chapter 3: Zombie Battles
Declare a new contract called `ZombieAttack` that inherits from `ZombieHelper`
### Chapter 4: Random Number
<b>Random number</b> generation via `keccak256`  
We could do something like the following to generate a random number:

```c
uint randNonce = 0;
uint random = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 100;
randNonce++;
uint random2 = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 100;
```

### Chapter 5: Zombie Fightin'
Our zombie battles will work as follows:
- You choose one of your zombies, and choose an opponent's zombie to attack.
- If you're the attacking zombie, you will have a 70% chance of winning. The defending zombie will have a 30% chance of winning.
- All zombies (attacking and defending) will have a winCount and a lossCount that will increment depending on the outcome of the battle.
- If the attacking zombie wins, it levels up and spawns a new zombie.
- If it loses, nothing happens (except its lossCount incrementing).
- Whether it wins or loses, the attacking zombie's cooldown time will be triggered.

### Chapter 6: Refactoring Common Logic
Whoever calls our `attack` function — we want to make sure the user actually owns the zombie they're attacking with. It would be a security concern if you could attack with someone else's zombie!

Can you think of how we would add a check to see if the person calling this function is the owner of the `_zombieId` they're passing in?

### Chapter 7: More Refactoring
We have a couple more places in `zombiehelper.sol` where we need to implement our new `modifier ownerOf`.

### Chapter 8: Back to Attack!
Enough refactoring — back to `zombieattack.sol`.

We're going to continue defining our `attack` function, now that we have the `ownerOf` modifier to use.

### Chapter 9: Zombie Wins and Losses
For our zombie game, we're going to want to keep track of how many battles our zombies have won and lost. That way we can maintain a "zombie leaderboard" in our game state.

We could store this data in a number of ways in our DApp — as individual mappings, as leaderboard Struct, or in the `Zombie` struct itself.

Each has its own benefits and tradeoffs depending on how we intend on interacting with the data. In this tutorial, we're going to store the stats on our `Zombie` struct for simplicity, and call them `winCount` and `lossCount`.