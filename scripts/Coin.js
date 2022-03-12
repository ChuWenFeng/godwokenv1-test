const { expect } = require("chai");
const { BigNumber } = require("ethers");

async function main() {
// const mintaddr = '0x0C1EfCCa2Bcb65A532274f3eF24c044EF4ab6D73'
  const contractFact = await ethers.getContractFactory("Coin");
  const recurContract = await contractFact.deploy();

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
