const { expect } = require("chai");
const { BigNumber } = require("ethers");

async function main() {
  const contractFact = await ethers.getContractFactory("TokenCreator");
  const recurContract = await contractFact.deploy();

  let tokenAddress = await recurContract.createToken('0x1234');
    console.log(tokenAddress)

    console.log("success!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

/**
 * How to run this?
 * > npx hardhat run scripts/Coin.js --network gw_devnet_v1
 */
