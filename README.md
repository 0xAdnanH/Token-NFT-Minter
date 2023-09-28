# Token-NFT Minter

The Token-NFT Minter project focuses on the process of minting an NFT based on the deposit of a specific ERC20 token. The contract is designed for potential extension to incorporate additional utilities and benefits.

## Goals of the Project

The primary goal of the Token-NFT Minter project is to:

- **Establish a Link between ERC20 Deposits and NFT Minting:** Enable users to mint an ERC721 NFT upon depositing a specified amount of an ERC20 token. The NFT's tokenId is associated with the deposited amount and the deposit time.
- **Showcase how NFT metadata can be generated onchain with Smart Contract data as shown in the following image:** ![nft](https://github.com/0xAdnanH/Token-NFT-Minter/assets/123894765/0b8c36e9-cd30-4617-8632-db8dc5650312) . 


## Technicalities of the Project

- **Comprehensive Documentation Using Natspec:** The project is thoroughly documented using Natspec, offering detailed insights into the functions and overall operation of the NFT minter contract.

- **Unit Tests with ethers.js:** The project includes comprehensive unit tests written using `ethers.js`, ensuring the correctness and proper functionality of the NFT minting process.

- **Usage of Complex Data Types such as Structs:** The project employs complex data types, such as structs, to efficiently manage and represent data within the contract, promoting organized code structure.

- **Minting an NFT Timestamp Based on an ERC20 Deposit with `approve-transferFrom` Approach:** The project successfully implements NFT minting based on an ERC20 deposit. This is achieved using the `approve` and `transferFrom` mechanism, ensuring secure and transparent operations.

## Steps

The following steps outline the NFT minting process within the Token-NFT Minter project:

1. The Token Owner (e.g., USDC) approves the Minter Contract.
2. The token owner calls the `swap` function, specifying a specific token amount.
3. The Minter Contract mints an NFT for the caller, recording the deposited amount and deposit time on-chain.
4. Optionally, these details can be recorded off-chain via the generation of a special link using the tokenURI.

## Installation

### Cloning the Repository

To begin with the Token-NFT Minter project, clone the repository and install its dependencies:

```bash
$ git clone https://github.com/0xAdnanH/Token-NFT-Minter.git
$ cd ./Token-NFT-Minter
$ npm install
```

### Instructions

#### Compile

To Compile the contract run:

```bash
$ npx hardhat compile
```

#### Tests

To run the unit tests:

```bash
$ npx hardhat test
```
