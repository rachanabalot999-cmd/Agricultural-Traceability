const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contract with the account:", deployer.address);
  console.log("Account balance:", (await hre.ethers.provider.getBalance(deployer.address)).toString());

  // 1. Get the Contract Factory for AgriculturalTraceability
  const AgriculturalTraceability = await hre.ethers.getContractFactory("AgriculturalTraceability");

  // 2. Deploy the contract (no constructor arguments needed)
  const traceability = await AgriculturalTraceability.deploy();

  // 3. Wait for the deployment to be confirmed on the network
  await traceability.waitForDeployment();
  
  const contractAddress = await traceability.getAddress();

  // 4. Log the deployed address for future interaction
  console.log("AgriculturalTraceability deployed to:", contractAddress);
}

// Execute the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


