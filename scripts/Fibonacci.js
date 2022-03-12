const { expect } = require("chai");

async function main() {
  const contractFact = await ethers.getContractFactory("Fibonacci");

  const recurContract = await contractFact.deploy();

  const txOverride = {
    gasPrice: 100,
    gasLimit: 1_000_000_000_000_002,
    nonce: 0
  };
  const maxDepth = 11
  for (let i = 1; i <= maxDepth; i++) {
    let pureIndexNum = await recurContract.pureIndexNum(i,txOverride);
    // console.log("call:", contractFact.interface.encodeFunctionData("sum", [64]));
    let indexNum = await recurContract.indexNum(i,txOverride);

    console.log("depth:", i);
    console.log("\t Fibonacci number = ", parseInt(indexNum));
    expect(indexNum).to.equal(pureIndexNum);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

/**
 * How to run this?
 * > npx hardhat run scripts/Fibonacci.js --network gw_devnet_v1
 */
