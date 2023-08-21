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
  contract = await factory.deploy("Token", "TKN", 1, mockContract, 10);
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
    await mockContract.mint(buyer, 50000);
    expect(await mockContract.balanceOf(buyer)).to.equal(50000);
    await mockContract.connect(buyer).approve(contract, 50000);

    await contract.connect(buyer).swap(500);
    expect(await contract.nftCounter()).to.equal(2);
    expect(await contract.ownerOf(1)).to.equal(buyer.address);
    expect(await mockContract.balanceOf(buyer)).to.equal(45000);
  });
});
describe("Testing error", () => {
  it("should revert tokenBalance", async () => {
    await mockContract.connect(buyer).approve(contract, 45000);
    await expect(contract.connect(buyer).swap(500000)).to.be.revertedWith(
      "Insufficient USDC Balance"
    );
  });
});
