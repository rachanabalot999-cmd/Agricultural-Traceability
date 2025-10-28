const hre = require("hardhat");

async function main() {
  console.log("Deploying Project contract...");

  const Project = await hre.ethers.getContractFactory("Project");
  const project = await Project.deploy();

  await project.deployed();

  console.log("Project deployed to:", project.address);
  // Optionally print etherscan link or explorer link if known for Core Testnet 2
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  });



