//SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GasContest is ERC721, Ownable {
    using ECDSA for bytes32;
    using Strings for uint256;
    uint256 private tokenSupply = 1;
    address private publicMintingAddress; // hardcoding not allowed because we need to be able to disable public mint

    constructor()
        ERC721("GasContest", "GC")
    // solhint-disable-next-line no-empty-blocks
    {

    }

    function setPublicMintAddress(address _address) external onlyOwner {
        publicMintingAddress = _address;
    }

    function publicMint(bytes calldata _signature) external payable {
        uint256 _tokenSupply = tokenSupply; // uint256 private tokenSupply = 1;
        require(_tokenSupply < 7778, "max supply"); // because 7778 - 1 = 7777
        require(
            publicMintingAddress ==
                keccak256(
                    abi.encodePacked(
                        "\x19Ethereum Signed Message:\n32",
                        bytes32(uint256(uint160(msg.sender)))
                    )
                ).recover(_signature),
            "not allowed"
        );
        require(ERC721._balances[msg.sender] < 2, "too many");
        require(msg.value == 0.06 ether, "wrong price");

        _mint(msg.sender, _tokenSupply);
        unchecked {
            _tokenSupply++;
        }
        tokenSupply = _tokenSupply;
    }

    // functions for users to get information
    function tokenURI(uint256 _tokenId)
        public
        pure
        override
        returns (string memory)
    {
        return "placeholder.com/metadata.json"
    }

    function totalSupply() external view returns (uint256) {
        return tokenSupply - 1; // token supply is 1 when nothing has been minted
    }
}
