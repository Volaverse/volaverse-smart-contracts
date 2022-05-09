// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract NftManager {
    mapping (address => mapping(uint256 => NftInfo)) public nfts;
    mapping (address => Mdata) nft_data;
    address [] established;

    struct Mdata {
        uint maxId;
        uint category;
        string ipfsHash;
    }

    struct NftInfo {
        address owner;
        bool onSale;
        uint256 price;
        bool valid;
    }

    struct Detail {
        address owner;
        bool onSale;
        uint256 price;
        uint category;
        uint tokenId;
        address contractAddress;
        string ipfsHash;
    }
    constructor () {
        established = new address [] (0);
    }
    function establish(address contractAddress, uint category, uint num, string memory ipfsHash) public {
        require(category == 0 || // land
        category == 1 || // wearable
        category == 2, // decoration
        "not valid category"); 

        for(uint i=0; i<num; i++) {
            nfts[contractAddress][i].owner = msg.sender;
            nfts[contractAddress][i].onSale = false;
            nfts[contractAddress][i].price = 0;
            nfts[contractAddress][i].valid = true;
        }
        nft_data[contractAddress] = Mdata(num, category, ipfsHash);
        established.push(contractAddress);
    }
    function startSale(uint256 price, address contractAddress, uint256 tokenId) public {
        require(nfts[contractAddress][tokenId].valid, "not established");
        ERC721 token = ERC721(contractAddress);
        require( token.ownerOf(tokenId) == msg.sender, "sender does not own that token!");
        require( token.isApprovedForAll(msg.sender, address(this)), "not approved");
        nfts[contractAddress][tokenId].onSale = true;
        nfts[contractAddress][tokenId].price = price;
    }
    // No security here !!
    // what if NFT transfer fails
    function purchase(address contractAddress, uint256 tokenId) public payable {
        NftInfo memory item = nfts[contractAddress][tokenId];
        require(item.valid, "no such established nft");
        require(item.onSale, "not currently on Sale");
        require (msg.value >= item.price, "insufficient funds");

        nfts[contractAddress][tokenId].onSale = false;
        nfts[contractAddress][tokenId].owner = msg.sender;
        nfts[contractAddress][tokenId].price = 0;

        ERC721 token = ERC721(contractAddress);
        token.safeTransferFrom(item.owner, msg.sender, tokenId);
        payable(item.owner).transfer(item.price);
    }

    function closeSale(address contractAddress, uint256 tokenId) public {
        ERC721 token = ERC721(contractAddress);
        require( token.ownerOf(tokenId) == msg.sender, "sender does not own that token!");
        require(nfts[contractAddress][tokenId].valid, "not established");
        require(nfts[contractAddress][tokenId].onSale, "not on sale");
        nfts[contractAddress][tokenId].onSale = false;
    }
    function getNFTs(uint category) public view returns (Detail [] memory) {
        uint max_size = 0;
        for(uint i=0; i<established.length; i++) {
            if (nft_data[established[i]].category == category || category == 3)
                max_size += nft_data[established[i]].maxId;
        }
        Detail [] memory result = new Detail [] (max_size);
        uint count = 0;
        for(uint i=0; i<established.length; i++) {
            if (nft_data[established[i]].category == category || category == 3) {
                for(uint j=0; j<nft_data[established[i]].maxId; j++) {
                    result[count].owner = nfts[established[i]][j].owner;
                    result[count].onSale = nfts[established[i]][j].onSale;
                    result[count].price = nfts[established[i]][j].price;
                    result[count].category = nft_data[established[i]].category;
                    result[count].tokenId = j;
                    result[count].contractAddress = established[i];
                    result[count].ipfsHash = nft_data[established[i]].ipfsHash;
                    count++;
                }   
            }
        }
        return result;
    }
    function testforWorking() public view returns (uint) {
        return established.length;
    }
    function getInfo(address contractAddress, uint tokenId) public view returns (Detail memory) {
        Detail memory detail = Detail (
            nfts[contractAddress][tokenId].owner,
            nfts[contractAddress][tokenId].onSale,
            nfts[contractAddress][tokenId].price,
            nft_data[contractAddress].category,
            tokenId,
            contractAddress,
            nft_data[contractAddress].ipfsHash
        );
        return detail;
    }
}
