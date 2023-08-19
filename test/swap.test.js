const { expect } = require("chai");
const { ethers } = require("hardhat");

let buyer;
let contract;
let mockContract;
before(async () => {
  [buyer] = await ethers.getSigners();
  const factory = await ethers.getContractFactory("TokenSwap");
  const Mockfactory = await ethers.getContractFactory("mintToken");
  mockContract = await Mockfactory.deploy("minttoken", "MTK");
  contract = await factory.deploy("Token", "TKN", 1, mockContract);
});

describe("Constructor Test", () => {
  it("should set params correctly", async () => {
    expect(await contract.name()).to.equal("Token");
    expect(await mockContract.name()).to.equal("minttoken");
    expect(await contract.nftCounter()).to.equal(1);
  });
});
describe("Nft Buy", () => {
  it("should buy nft successfully", async () => {
    await mockContract.mint(buyer, 1000);
    expect(await mockContract.balanceOf(buyer)).to.equal(1000);
    await mockContract.connect(buyer).approve(contract, 1000);

    await contract.connect(buyer).swap(500);
    expect(await contract.nftCounter()).to.equal(2);
    expect(await contract.ownerOf(1)).to.equal(buyer.address);
    expect(await mockContract.balanceOf(buyer)).to.equal(500);
  });
});
describe("Testing error", () => {
  it("should revert tokenBalance", async () => {
    await mockContract.connect(buyer).approve(contract, 500);
    await expect(contract.connect(buyer).swap(770)).to.be.revertedWith(
      "Insufficient USDC Balance"
    );
  });
});
