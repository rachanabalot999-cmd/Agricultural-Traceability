# agricultural tracebillity

## Project Description
Agricultural Tracebillity is a lightweight blockchain-based traceability registry for agricultural batches. It enables recording, updating, and retrieving trace entries for produce batches (farmer, origin, status, timestamp and details), stored immutably on-chain.

## Project Vision
To provide a simple, auditable, on-chain trail for agricultural goods so supply-chain participants (farmers, processors, distributors, and consumers) can verify origin and status of produce and reduce fraud or mislabeling.

## Key Features
- Record new trace entries with batch ID, farmer, location, details, and status.
- Update trace status and details (e.g., mark as shipped or processed).
- Retrieve full trace details by internal ID and get the latest entry for a batch ID.
- Small, auditable contract: minimal logic to keep gas costs low.
- Ready-to-deploy on Core Testnet 2.

## Future Scope
- Access control: role-based updates (farmer, processor, inspector).
- Off-chain indexing + events + subgraph for easy querying.
- Batch-level history retrieval and pagination.
- Integration with IoT sensors / QR-code generation for consumers.
- Data confidentiality options (e.g., store sensitive details off-chain, keep hashes on-chain).

## Setup & Deployment
1. Clone the repo and `cd agricultural-tracebillity`.
2. `cp .env.example .env` and set `PRIVATE_KEY` and optionally `CORE_TESTNET2_RPC`.
3. `npm install` (or `yarn`).
4. `npx hardhat compile`
5. `npx hardhat run scripts/deploy.js --network coreTestnet2`

## Files Included
- `contracts/Project.sol` — main smart contract.
- `scripts/deploy.js` — deploy script for Core Testnet 2.
- `hardhat.config.js` — network config (Core Testnet 2 RPC).
- `.gitignore`, `.env.example`, `package.json`.

## Notes
- This repository is a starting point; add role-based access control for production.
- Keep your deployer private key offline or in a secure signer for mainnet deployments.



