// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract FirstDecorationTable is ERC721 {
    uint256 private NUM = 10;
    struct Metadata {
        string name;
        uint category;
        string description;
        string link;
    }
    Metadata metadata;
    constructor () ERC721("FirstDecorationTable", "FDT") {
        for(uint i=0; i<5; i++) {
            _mint(msg.sender, i);
        }
        metadata = Metadata("Designer Table", 2, "handcrafted designer tables for your beautiful house","QmVF9WmYyPYE9KCwjkdGuPGofWULW3mRFfdXXE5rgTrHYt");
    }
    function getMetaData() public view returns (Metadata memory ) {
        return metadata; 
    }
    // function updateImage(string memory hash) public {
    //     metadata.image = hash;
    // }
    // To be removed later
    function updateLink(string memory l) public {
        metadata.link = l;
    }
}
