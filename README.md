# Mint with castles example

Based on [Loot for forkers](https://github.com/jamiew/loot-fork)



## Setup

Checkout this repo and install dependencies

```
git clone https://github.com/CastleDAO/mint-with-castle
cd mint-with-castle
npm install
```

Compile the contract and deploy to the internal `hardhat` network

```
npx hardhat compile
npx hardhat run scripts/deploy.js
```

Run tests

```
npx hardhat test
```



## Here's the next level

a real example requires you to run a local Ganache blockchain simulator (AKA the `localhost` network, chainId `31337`):

```shell
# in one terminal, run a lil blockchain
npx hardhat node --show-stack-traces

# in another terminal, deploy the contract and copy the deployed address
npx hardhat run --network localhost scripts/deploy.js
```

then start `npx hardhat console` and you can interact with said contract

```shell
npx hardhat console --network localhost
```

in the console, connect to our newly deployed `ExampleContract`:

```javascript
const Contract = await ethers.getContractFactory('ExampleContract');
const contract = await Contract.attach("ADDRESS_FROM_DEPLOYMENT_GOES_HERE");
```

then let's call some contract methods:

```javascript
(await contract.name()).toString()
// 'ExampleContract'

(await contract.totalSupply()).toString();
// '0'
// (because we haven't minted anything yet)

(await contract.getItem(1)).toString();

```

if you want some mints, mint them to one of the default accounts setup by `hardhat node` (ganache). they cryptorich, they got like 10k ETH each

```javascript
let tokenId = 8012;
let account = (await ethers.getSigners())[0];
let txn = (await contract.connect(account).mint(tokenId));
let receipt = (await txn.wait());
console.log(receipt.events[0].args)
/*
[
  from: '0x0000000000000000000000000000000000000000',
  to: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
  tokenId: BigNumber { _hex: '0x03', _isBigNumber: true }
]
*/
```

did it work though?
```javascript
(await contract.totalSupply()).toString();
// '1'

```



## Deploy


This largely requires funding a wallet and registering API keys with [Alchemy](https://docs.alchemy.com/alchemy/introduction/getting-started) and [Etherscan]()

Copy `.env.sample` to `.env` and edit in your keys.

Then:

```shell
npx hardhat run scripts/deploy.js --network rinkeby

```

You can interact with this contract via `npx hardhat console` the same way as above, just substitute `--network rinkeby` for `--network localhost`

You can also use the `hardhat-etherscan-verify` plugin to verify the contract on Etherscan

```
npx hardhat verify --network rinkeby <YOUR_CONTRACT_ADDRESS>
```

### Arbitrum

```shell
npx hardhat run scripts/deploy.js --network arbitrummainnet

```




# more reading

* [Hardhat docs](https://hardhat.org/getting-started/)
* [OpenZeppelin docs](https://docs.openzeppelin.com/openzeppelin/)
