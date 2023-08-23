// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TokenSwap is ERC721, ERC721URIStorage {
    using Strings for *;
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
        nftCounter = _nftCounter;
        USDC = _tokenAddress;
        pricePerNFT = _pricePerNFT;
    }

    function swap(uint256 tokenAmount) external payable {
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

        _setTokenURI(tokenId, _generateTokenURI(tokenAmount));

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

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _generateTokenURI(
        uint256 tokenAmount
    ) internal view returns (string memory) {
        bytes memory image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    abi.encodePacked(
                        '<?xml version="1.0" encoding="UTF-8"?>',
                        '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" viewBox="0 0 400 400" preserveAspectRatio="xMidYMid meet">',
                        '<style type="text/css"><![CDATA[text { font-family: monospace; font-size: 21px;} .h1 {font-size: 20px; font-weight: 300;}]]></style>',
                        '<rect width="300" height="300" fill="#ffffff" />',
                        '<text class="h1" x="30" y="50"> ',
                        "Timestamp:",
                        block.timestamp.toString(),
                        "</text>",
                        '<text class="h1" x="70" y="100" >',
                        "Amount Spent:",
                        tokenAmount.toString(),
                        "</text>",
                        "</svg>"
                    )
                )
            )
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"Test", "image":"',
                                image,
                                unicode'", "description": "Test Test"}'
                            )
                        )
                    )
                )
            );
    }
}
