# Gas Contest

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

You should see a gas cost of 80949.

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
- Only the first mint counts. The second mint will be cheaper due to the mechanics of the EVM 
  and that is not a valid submission.
- please give DonkeVerse credit if you find this useful :-)
