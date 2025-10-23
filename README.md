🌾 Agricultural Traceability on Blockchain

A transparent and immutable system for tracking agricultural products (e.g., crops, produce) across the entire supply chain, from the initial farm stage to the final retailer.

📝 Project Overview

This Solidity smart contract establishes a foundation for decentralized Supply Chain Traceability. By leveraging the Ethereum Virtual Machine (EVM), we ensure that the lifecycle of every product batch is logged and immutable. This gives consumers, regulators, and supply chain partners verifiable proof of origin, handling steps, and current ownership.

Workflow Summary

The system logs a product through the following steps:

Registration: The product is created by the farmer and registered as Planted.

Ownership Transfer: The current owner transfers control of the batch record to the next party (e.g., from Farmer to Processor).

Stage Updates: The new owner updates the product's status (e.g., to Harvested, Processed, Shipped).

⚙️ Technology and Features

Core Technologies

Solidity (v0.8.0+): The programming language for the smart contract.

Ethereum Virtual Machine (EVM): The deployment and execution environment.

keccak256: Used to generate unique, verifiable IDs for each product batch.

Smart Contract Features (Traceability.sol)

Function/Feature

Description

Visibility

registerBatch()

Initiates traceability by creating a new ProductBatch and setting the stage to Planted.

public

updateStage()

Allows the current owner to move the batch to the next sequential Stage. Logs location and timestamp.

public

transferOwnership()

Transfers the digital control of the batch record to the next entity in the supply chain (e.g., from a Harvester to a Processor).

public

productBatches

A public mapping used to retrieve full details (current stage, location, owner) of any batch using its unique ID.

public view

Stage Enum

Defines the fixed lifecycle steps: Planted, Harvested, Processed, Shipped, ReceivedByRetailer.

Internal

💡 Traceability Workflow Example

This example demonstrates the key steps of ownership and stage progression for a batch of corn:

Farmer A registers the batch: registerBatch("Organic Corn", "FARM-001", "Field 5"). (Stage: Planted)

Farmer A updates the status: updateStage(productId, Stage.Harvested, "Barn Storage").

Farmer A transfers control: transferOwnership(productId, ProcessorB_Address).

Processor B receives control and updates: updateStage(productId, Stage.Processed, "Processing Plant").

...The process continues until the product is marked as ReceivedByRetailer.

⚠️ Security and Development Notes

Identity Management: This contract relies on the honesty of the transacting addresses (msg.sender). For real-world use, a system with stronger off-chain identity verification (KYC) would be required to tie addresses to legal entities.

Data Integrity: The blockchain ensures the history of updates is immutable, but it cannot verify the truthfulness of the data (e.g., whether the reported location is accurate). This relies on the integrity of the current batch owner.

🚀 Getting Started

To compile and deploy this contract locally:

Compilation (using solc):

npx solc --bin Traceability.sol


Deployment: Deploy the compiled bytecode to an EVM-compatible network (like Sepolia or a local development chain). The deploying address automatically becomes the owner with administrative rights.
