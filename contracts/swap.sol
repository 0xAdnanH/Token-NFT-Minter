// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TokenSwap is ERC721 {
    uint256 public nftCounter;
    address public USDC;
    uint256 public pricePerNFT;

    // Struct to store swap records
    struct SwapRecord {
        uint256 timestamp;
        uint256 amountTokenSpent;
    }

    // Mapping to store swap records
    mapping(uint256 => SwapRecord) public swapRecords;

    event NFTMinted(
        address indexed user,
        uint256 indexed tokenId,
        uint256 timestamp,
        uint256 tokenAmount
    );

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _nftCounter,
        address _tokenAddress,
        uint256 _pricePerNFT
    ) ERC721(_name, _symbol) {
        _nftCounter = 1;
        nftCounter = _nftCounter;
        USDC = _tokenAddress;
        pricePerNFT = _pricePerNFT;
    }

    function swap(uint256 tokenAmount) external {
        require(
            IERC20(USDC).balanceOf(msg.sender) >= tokenAmount,
            "Insufficient USDC Balance"
        );

        IERC20(USDC).transferFrom(
            msg.sender,
            address(this),
            pricePerNFT * tokenAmount
        );
        uint256 tokenId = nftCounter;
        _mint(msg.sender, tokenId);

        nftCounter++;

        swapRecords[tokenId] = SwapRecord({
            timestamp: block.timestamp,
            amountTokenSpent: tokenAmount
        });
        emit NFTMinted(msg.sender, tokenId, block.timestamp, tokenAmount);
    }

    function getSwapRecord(
        uint256 tokenId
    ) external view returns (SwapRecord memory) {
        return swapRecords[tokenId];
    }
}
