// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract TokenSwap is ERC721 {
    uint256 public nftCounter;
    address public USDC;

    // Struct to store swap records
    struct SwapRecord {
        uint256 timestamp;
        uint256 amount;
    }

    // Mapping to store swap records
    mapping(uint256 => SwapRecord) public swapRecords;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _nftCounter,
        address _tokenAddress
    ) ERC721(_name, _symbol) {
        _nftCounter = 1;
        nftCounter = _nftCounter;
        USDC = _tokenAddress;
    }

    function swap(uint256 tokenAmount) external {
        require(
            IERC20(USDC).balanceOf(msg.sender) >= tokenAmount,
            "Insufficient USDC Balance"
        );

        IERC20(USDC).transferFrom(msg.sender, address(this), tokenAmount);
        uint256 tokenId = nftCounter;
        _mint(msg.sender, tokenId);

        // could be used to store data offchain
        /*
        _setTokenURI(tokenId,"");
        */

        nftCounter++;

        swapRecords[tokenId] = SwapRecord({
            timestamp: block.timestamp,
            amount: tokenAmount
        });
    }

    function getSwapRecord(
        uint256 tokenId
    ) external view returns (SwapRecord memory) {
        return swapRecords[tokenId];
    }
}
