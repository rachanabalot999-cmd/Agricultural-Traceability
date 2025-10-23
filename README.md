🌾 Project Title: Agricultural Traceability on Blockchain

A transparent and immutable system for tracking agricultural products (e.g., crops, produce) across the entire supply chain, from the initial farm stage to the final retailer.

📝 Description

This Solidity smart contract establishes a foundation for decentralized Supply Chain Traceability. Each batch of product is assigned a unique ID and its lifecycle is logged on the blockchain. This provides consumers, regulators, and supply chain partners with verifiable proof of origin, handling steps, and ownership history.

The process involves:

Registration: The farmer registers a batch as Planted.

Stage Updates: Parties (Harvester, Processor, Shipper) update the batch stage as it moves through the chain.

Ownership Transfer: Ownership must be transferred on-chain between successive parties to grant them update permissions.

⚙️ Technologies Used

Solidity (v0.8.0+): Contract logic.

Ethereum Virtual Machine (EVM): Deployment platform.

keccak256: Used to create immutable, unique IDs for product batches.

🛠️ Smart Contract Features

Function/Feature

Description

Visibility

registerBatch()

Creates a new ProductBatch record, marking the start of traceability (Stage: Planted).

public

updateStage()

Allows the current owner to move the batch to the next sequential Stage. Logs location and timestamp.

public

transferOwnership()

Transfers control of the batch record to the next entity in the supply chain.

public

productBatches

Public mapping to retrieve any batch details using its hash ID.

public view

Stage Enum

Defines the fixed lifecycle steps: Planted, Harvested, Processed, Shipped, ReceivedByRetailer.

Internal

🚀 Getting Started

To compile and deploy this contract, you would typically use a development framework like Hardhat or Truffle.

Compilation:

npx solc --bin Traceability.sol


Deployment Logic:
The contract needs to be deployed to an EVM-compatible network. The deploying address will be set as the owner.

💡 Traceability Workflow Example

Farmer A calls registerBatch("Organic Corn", "FARM-001", "Field 5").

Farmer A calls updateStage(productId, Stage.Harvested, "Barn Storage").

Farmer A calls transferOwnership(productId, ProcessorB_Address).

Processor B calls updateStage(productId, Stage.Processed, "Processing Plant").

...and so on, until the product is received by the retailer.

⚠️ Security Considerations

Identity Management: This contract assumes that the on-chain addresses (msg.sender) correctly map to real-world entities (Farmer, Processor, etc.). A full solution would require KYC/identity layers.

Data Integrity: All updates rely on the current owner providing accurate data (location, stage). Blockchain ensures the history is immutable, but not that the initial input is truthful.
