import { network } from "hardhat";

async function main() {
  const tokenAddress = process.env.TOKEN_ADDRESS || "";

  if (!tokenAddress) {
    throw new Error("TOKEN_ADDRESS is required");
  }

  const { ethers } = await network.create();
  const token = await ethers.getContractAt("AURIXNetwork", tokenAddress);

  const name = await token.name();
  const symbol = await token.symbol();
  const decimals = await token.decimals();
  const totalSupply = await token.totalSupply();
  const owner = await token.owner();

  console.log("Token Address:", tokenAddress);
  console.log("Name:", name);
  console.log("Symbol:", symbol);
  console.log("Decimals:", decimals.toString());
  console.log("Total Supply:", ethers.formatUnits(totalSupply, decimals));
  console.log("Owner:", owner);
}

main().catch(function (error) {
  console.error(error);
  process.exitCode = 1;
});
