const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");

describe("Recursion Contract", function () {
  it("Deploy and call recursive functions", async () => {
    const contractFact = await ethers.getContractFactory("Coin");
    const recurContract = await contractFact.deploy();
    await recurContract.deployed();

    let mint = await recurContract.getMint();

    let prebal = 400;
    await recurContract.mint(mint,prebal);

    let bal = await recurContract.getBalances(mint);
    expect(BigNumber.from(prebal)).to.equal(bal);

    const otherAddr = '0x51378e88a9055561250000701d3a1fb4ce41e2b6'

    let txval = 100
    await recurContract.send(otherAddr,txval);

    let otherbal = await recurContract.getBalances(otherAddr);

    expect(BigNumber.from(txval)).to.equal(otherbal);

  });
});

/**
 * How to run this?
 * > npx hardhat test test/Coin --network gw_devnet_v1
 */
