// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/*

Example ERC721 contract

*/

interface CastlesInterface {
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

contract ExampleContract is ERC721Enumerable, ReentrancyGuard, Ownable {

    uint256 public castlesPrice = 10000000000000000; // 0.01 ETH
    uint256 public price = 50000000000000000; //0.05 ETH

    //Castle Contract (arbitrum)
    address public castlesAddress = 0x71f5C328241fC3e03A8c79eDCD510037802D369c;
    CastlesInterface public castlesContract = CastlesInterface(castlesAddress);
    
    // Allow to extract from the smart contract, otherwise.. you're ded
    function ownerWithdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    string[] private randomItems = [
        "a",
        "b",
        "c"
    ];

    

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
        return string(abi.encodePacked(bytes(_a), bytes(_b)));
    }
   
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    // Returns a random item from the list, always the same for the same token ID
    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));

        return sourceArray[rand % sourceArray.length];
    }

    // example of how to get a random property from array
    function getItem(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ITEM", randomItems);
    }

    // example of how to get a random int
    function getRandomInt(uint256 tokenId) public view returns (uint256) {
        uint256 rand = random(string(abi.encodePacked("INT", toString(tokenId))));
        return rand % 99;
    }

     function mint(uint256 tokenId) public payable nonReentrant {
        require(tokenId > 0 && tokenId <= 10000, "Token ID invalid");
        require(price <= msg.value, "Ether value sent is not correct");
        _safeMint(_msgSender(), tokenId);
    }
    
    
    function mintWithcastle(uint256 tokenId) public payable nonReentrant {
        require(tokenId > 0 && tokenId <= 10000, "Token ID invalid");
        require(castlesPrice <= msg.value, "Ether value sent is not correct");
        require(castlesContract.ownerOf(tokenId) == msg.sender, "Not the owner of this castle");
        _safeMint(_msgSender(), tokenId);
    }
   
    // Allow the owner to claim in case some item remains unclaimed in the future
    function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
        require(tokenId <= 10000, "Token ID invalid");
        _safeMint(owner(), tokenId);
    }

    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    constructor() ERC721("ExampleContract", "ExampleContract") Ownable() {}
}
