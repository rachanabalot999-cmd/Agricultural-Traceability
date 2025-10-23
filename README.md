🌾 Agricultural Traceability on Blockchain

A transparent and immutable system for tracking agricultural products (e.g., crops, produce) across the entire supply chain, from the initial farm stage to the final retailer.

📝 Project Overview

This Solidity smart contract establishes a foundation for decentralized Supply Chain Traceability. By leveraging the Ethereum Virtual Machine (EVM), we ensure that the lifecycle of every product batch is logged and immutable, providing verifiable proof of origin and handling history.

⚙️ Technology and Features

Core Technologies

Solidity (v0.8.0+): The smart contract programming language.

Ethereum Virtual Machine (EVM): The deployment and execution environment.

Smart Contract Features (Traceability.sol)

This table shows the primary functions and their purpose in the supply chain workflow:

Function/Feature

Description

Visibility

registerBatch()

Initiates traceability by creating a new ProductBatch and setting the stage to Planted.

public

updateStage()

Allows the current owner to move the batch to the next sequential Stage (e.g., Harvested, Processed). Logs location and timestamp.

public

transferOwnership()

Transfers the digital control of the batch record to the next entity in the supply chain (e.g., from a Farmer to a Processor).

public

withdrawBalance()

Owner-only function to withdraw any Ether accidentally sent to the contract.

public onlyOwner

productBatches

Public mapping used to retrieve full details (current stage, location, owner) of any batch using its unique ID.

public view

💡 Traceability Workflow Example

The system enforces a sequential process, requiring ownership transfer and stage updates to maintain a verifiable audit trail:

Farmer A calls registerBatch(). (Stage: Planted)

Farmer A calls updateStage(Stage.Harvested).

Farmer A transfers control: transferOwnership(ProcessorB_Address).

Processor B calls updateStage(Stage.Processed).

...The product moves through the chain until marked as ReceivedByRetailer.

🚀 Getting Started

If you are setting up this project, you will need to compile the Solidity code (Traceability.sol) and deploy it to an EVM-compatible network.

Compilation

# Example command using Hardhat or Truffle configuration
npx hardhat compile
# or
truffle compile


Deployment

The address that deploys the contract is automatically set as the owner with administrative rights (like the ability to run withdrawBalance()).



Deployment: Deploy the compiled bytecode to an EVM-compatible network (like Sepolia or a local development chain). The deploying address automatically becomes the owner with administrative rights.
