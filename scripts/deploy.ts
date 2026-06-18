import { network } from "hardhat";

async function main() {
  console.log("Deploying AURIX Network...");

  const { ethers } = await network.create();

  const token = await ethers.deployContract("AURIXNetwork");

  await token.waitForDeployment();

  const tokenAddress = await token.getAddress();

  console.log("AURIX Network deployed to:", tokenAddress);
  console.log("Token Name: AURIX Network");
  console.log("Symbol: AURX");
  console.log("Decimals: 18");
  console.log("Total Supply: 10,000,000,000 AURX");
}

main().catch(function (error) {
  console.error(error);
  process.exitCode = 1;
});
