// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract Land is ERC721 {
    uint256 private NUM = 120;
    uint256 [] buildings;

    struct Metadata {
        string name;
        uint category;
        string description;
    }
    Metadata metadata;

    constructor () ERC721("Land", "LA") {
        buildings = new uint256 [] (NUM);
        for(uint i=0; i<NUM; i++) {
            _mint(msg.sender, i);
            buildings[i] = 0;
        }
        metadata = Metadata("Land", 0, "volaverse lands");
    }
    function getOwners() public view returns (address[] memory) {
        address[] memory owners = new address[] (NUM);
        for(uint i=0; i<NUM; i++) {
            owners[i] = ownerOf(i);
        }
        return owners;
    }
    function getBuildings() public view returns (uint256[] memory) {
        return buildings;
    }
    function build(uint256 landId) public {
        require(ownerOf(landId) == msg.sender, "not owner");
        buildings[landId]+=1;
    }
    function getMetaData() public view returns (Metadata memory ) {
        return metadata; 
    }
}
