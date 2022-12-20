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

### Chapter 7: ERC721: Approve
Now, let's implement approve.

Remember, with approve the transfer happens in 2 steps:

1. You, the owner, call approve and give it the _approved address of the new owner, and the _tokenId you want them to take.

2. The new owner calls transferFrom with the _tokenId. Next, the contract checks to make sure the new owner has been already approved, and then transfers them the token.

Because this happens in 2 function calls, we need to use the zombieApprovals data structure to store who's been approved for what in between function calls.

### Chapter 8: ERC721: Approve

### Chapter 9: Preventing Overflows
Using SafeMath

To prevent this, OpenZeppelin has created a library called SafeMath that prevents these issues by default.

But before we get into that... What's a library?

A library is a special type of contract in Solidity. One of the things it is useful for is to attach functions to native data types.

For example, with the SafeMath library, we'll use the syntax using SafeMath for `uint256`. The SafeMath library has 4 functions — `add, sub, mul, and div`. And now we can access these functions from `uint256` as follows:

```solidity
using SafeMath for uint256;

uint256 a = 5;
uint256 b = a.add(3); // 5 + 3 = 8
uint256 c = a.mul(2); // 5 * 2 = 10
```
We'll look at what these functions do in the next chapter, but for now let's add the SafeMath library to our contract.

## Lesson 6: App Front-ends & Web3.

### Chapter 1: Intro to Web3.js
Remember, the Ethereum network is made up of nodes, with each containing a copy of the blockchain. When you want to call a function on a smart contract, you need to query one of these nodes and tell it:

The address of the smart contract
The function you want to call, and
The variables you want to pass to that function.
Ethereum nodes only speak a language called JSON-RPC, which isn't very human-readable. A query to tell the node you want to call a function on a contract looks something like this:

```json
// Yeah... Good luck writing all your function calls this way!
// Scroll right ==>
{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155","to":"0xd46e8dd67c5d32be8058bb8eb970870f07244567","gas":"0x76c0","gasPrice":"0x9184e72a000","value":"0x9184e72a","data":"0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"}],"id":1}
```

Luckily, Web3.js hides these nasty queries below the surface, so you only need to interact with a convenient and easily readable JavaScript interface.

Instead of needing to construct the above query, calling a function in your code will look something like this:

```js
CryptoZombies.methods.createRandomZombie("Vitalik Nakamoto 🤔")
  .send({ from: "0xb60e8dd61c5d32be8058bb8eb970870f07233155", gas: "3000000" })
```
We'll explain the syntax in detail over the next few chapters, but first let's get your project set up with Web3.js.

Getting started
Depending on your project's workflow, you can add Web3.js to your project using most package tools:

```bash
// Using NPM
npm install web3

// Using Yarn
yarn add web3

// Using Bower
bower install web3

// ...etc.
```

Or you can simply download the minified .js file from github and include it in your project:
```js
<script language="javascript" type="text/javascript" src="web3.min.js"></script>
```

Since we don't want to make too many assumptions about your development environment and what package manager you use, for this tutorial we're going to simply include Web3 in our project using a script tag as above.
### Chapter 2: Web3 Providers
Using Metamask's web3 provider
Metamask injects their web3 provider into the browser in the global JavaScript object web3. So your app can check to see if web3 exists, and if it does use `web3.currentProvider` as its provider.

Here's some template code provided by Metamask for how we can detect to see if the user has Metamask installed, and if not tell them they'll need to install it to use our app:
```js
window.addEventListener('load', function() {

  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    web3js = new Web3(web3.currentProvider);
  } else {
    // Handle the case where the user doesn't have web3. Probably
    // show them a message telling them to install Metamask in
    // order to use our app.
  }

  // Now you can start your app & access web3js freely:
  startApp()

})
```
You can use this boilerplate code in all the apps you create in order to require users to have Metamask to use your DApp.

### Chapter 3: Talking to Contracts
