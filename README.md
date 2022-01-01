# Gas Contest

Can you improve the gas efficiency of minting DonkeVerse NFTs? If so, you may get a prize! We've set up this repository to get you started. Head over to our [discord](https://discord.gg/CbH7ywUc) in #dev-talks to discuss!

## step one
install everything with `npm install`

## step two

You will need to open `node_modules/openzeppelin/contracts/token/ERC721/ERC721.sol`

and comment out or delete lines 281-284

```
require(to != address(0), "ERC721: mint to the zero address");
require(!_exists(tokenId), "ERC721: token already minted");

_beforeTokenTransfer(address(0), to, tokenId);
```

and change line 33

```
mapping(address => uint256) private _balances;
```

to 


```
mapping(address => uint256) internal _balances;
```

## step three

measure the gas with

```shell
REPORT_GAS=true npx hardhat test
```

You should see a gas cost of 80949. We've already set the optimization level in the solidity compiler to 1000 but feel free to change that number

## step four

Improve the gas cost! Even tiny improvements are acceptable! Top two submissions will receive a free NFT and the next top four will receive a whitelist. We expect to increase the reward pool in the future.


HINTS:

- There are two known gas improvements that we have not implemented but we have witheld to make the contest interesting and make sure someone will win something. We suspect there is a 3rd one that will work. You will need to think outside the box for one of them.

NOTES/RULES:

- There is no public mint switch because minting can only be
  done by getting the address signed via the website quiz
- unchecked \_tokenSupply++ is safe as long as the maximum
  supply is less than the max uint size. Using assembly doesn't save gas.
- \_tokenSupply is loaded into memory first because it is used more than
  once. It is cheaper to load storage to memory once and read from memory
  twice than to load from storage twice
- we use hardcoded constants because solc doesn't optimize constants
- \_safeMint is not necessary because we are not minting to smart contracts
- As few function calls as possible because SOLC doesn't optimize them
- per above, we reimplement toEthSignedMessageHash to save gas
- hashing Ethereum Signed Message is technically not necessary, but it is not
  cryptographic best practice to sign arbitrary
  messages without a salt or to recover ECDSA signatures from anything other
  than the value of a hash
  Don't change the signing scheme or it won't be compatible with eip 191
- Signing address must be 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (second account in hardhat)
- please give DonkeVerse credit if you find this useful :-)

1. Gas will be measured by hardhat 2.6.8
2. You must use Solidity 8.10
3. You may use whatever optimizations on the Solidity compiler you like as long as it is known to be secure
4. You must use this account for signing (second in Hardhat)
Account #1: 0x70997970c51812dc3a010c7d01b50e0d17dc79c8
Private Key: 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
5. Assembly is allowed if you can demonstrate it is secure
6. Using unbounded loops to fulfill ERC721 functionality (or any functionality) is not accepted
7. Wallets cannot mint more than two pieces
8. Total supply is 7777
9. Price is 0.06 ether
10. Alternatives to public signature whitelisting will be considered, but it must be secure. Map based public mints that require us to whitelist individual addresses isn't accepted because the cost is too high when the users are in thousands.
11. There must be no security bugs
12. There are two known improvements we have not shared. If you discover them first, you get a whitelist for each of the two. If nobody can improve on our gas cost, you will be upgraded to a free mint.
13. Cryptographic solutions must follow best practices. Recovering signatures from ECDSA must be from hashes. Signed messages must be salted according to EIP191.
14. We reserve the right to make the final decision about what solutions are accepted. We reserve the right to reward innovative solutions at our discretion.
15. Solutions must be submitted before January 24 Midnight UTC to allow time to be incorporated into the audit.
16. We will pay the gas for people who recieve a free mint.
