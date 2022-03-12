const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Fibonacci Contract", function () {
  it("Deploy and call fibonacci functions", async () => {
    const contractFact = await ethers.getContractFactory("Fibonacci");
    const recurContract = await contractFact.deploy();
    await recurContract.deployed();

    const maxDepth = 10
    for (let i = 1; i <= maxDepth; i++) {
      let pureIndexNum = await recurContract.pureIndexNum(i);

      let indexNum = await recurContract.indexNum(i);

      console.log("depth:", i);
      console.log("\t Fibonacci number = ", parseInt(indexNum));
      expect(indexNum).to.equal(pureIndexNum);
    }

    // depth 1024
    // Error: Transaction reverted: contract call run out of gas and made the transaction revert

  });
});

/**
 * How to run this?
 * > npx hardhat test test/Fibonacci --network gw_devnet_v1
 */
