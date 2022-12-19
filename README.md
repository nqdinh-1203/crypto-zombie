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

### Chapter 10: Zombie Victory 😄
Now that we have a `winCount` and `lossCount`, we can update them depending on which zombie wins the fight.

In chapter 6 we calculated a random number from 0 to 100. Now let's use that number to determine who wins the fight, and update our stats accordingly.

### Chapter 11: Zombie Loss 😞
Now that we've coded what happens when your zombie wins, let's figure out what happens when it <b>loses</b>.

In our game, when zombies lose, they don't level down — they simply add a loss to their `lossCount`, and their cooldown is triggered so they have to wait a day before attacking again.

## Lesson 5: ERC721 & Crypto-Collectibles
### Chapter 1: Tokens on Ethereum
### Chapter 2: ERC721 Standard, Multiple Inheritance
### Chapter 3: balanceOf & ownerOf
### Chapter 4: Refactoring
### Chapter 5: ERC721: Transfer Logic
Great, we've fixed the conflict!

Now we're going to continue our ERC721 implementation by looking at transfering ownership from one person to another.

Note that the ERC721 spec has 2 different ways to transfer tokens:

`function transferFrom(address _from, address _to, uint256 _tokenId) external payable;`

and

`function approve(address _approved, uint256 _tokenId) external payable;`
`function transferFrom(address _from, address _to, uint256 _tokenId) external payable;`

The first way is the token's owner calls `transferFrom` with his `address` as the `_from` parameter, the `address` he wants to transfer to as the `_to` parameter, and the `_tokenId` of the token he wants to transfer.

The second way is the token's owner first calls `approve` with the address he wants to transfer to, and the `_tokenID`. The contract then stores who is approved to take a token, usually in a `mapping (uint256 => address)`. Then, when the owner or the approved address calls `transferFrom`, the contract checks if that `msg.sender` is the owner or is approved by the owner to take the token, and if so it transfers the token to him.

Notice that both methods contain the same transfer logic. In one case the sender of the token calls the `transferFrom` function; in the other the owner or the approved receiver of the token calls it.

So it makes sense for us to abstract this logic into its own private function, `_transfer`, which is then called by `transferFrom`.

### Chapter 6: ERC721: Transfer Cont'd
1. First, we want to make sure only the owner or the approved address of a token/zombie can transfer it. Let's define a mapping called zombieApprovals. It should map a uint to an address. This way, when someone that is not the owner calls transferFrom with a _tokenId, we can use this mapping to quickly look up if he is approved to take that token.
2. Next, let's add a require statement to transferFrom. It should make sure that only the owner or the approved address of a token/zombie can transfer it.
3. Lastly, don't forget to call _transfer.