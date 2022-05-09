// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract FirstWearableHat is ERC721 {
    struct Metadata {
        string name;
        uint category;
        string description;
        string link;
    }
    Metadata metadata;
    constructor () ERC721("FirstWearableHat", "FWH") {
        for(uint i=0; i<30; i++) {
            _mint(msg.sender, i);
        }
        metadata = Metadata("Stylish Hat", 1, "handcrafted designer hats for your beautiful avatar","");
    }
    function getMetaData() public view returns (Metadata memory ) {
        return metadata; 
    }
    function updateLink(string memory l) public {
        metadata.link = l;
    }
}
