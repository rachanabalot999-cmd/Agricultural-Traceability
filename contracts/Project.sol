
pragma solidity ^0.8.0;

contract AgriculturalTraceability {
    // --- STATE VARIABLES ---

    // Define the different stages a product can be in
    enum Stage {
        Planted,
        Harvested,
        Processed,
        Shipped,
        ReceivedByRetailer
    }

    // A structure to hold the details of a tracked product batch
    struct ProductBatch {
        string productName;
        string batchId;
        address owner;
        Stage currentStage;
        uint256 timestamp;
        string location;
    }

    // Mapping from a unique ID (hash of batchId) to the ProductBatch details
    mapping(bytes32 => ProductBatch) public productBatches;

    // Address of the contract deployer (the 'Owner')
    address public owner;

    // --- EVENTS ---
    event ProductRegistered(bytes32 indexed productId, string batchId, address indexed owner, Stage stage);
    event StageUpdated(bytes32 indexed productId, Stage newStage, address indexed updater, string location);
    // [NEW EVENT] Added for transparency in fund withdrawal
    event BalanceWithdrawn(address indexed recipient, uint256 amount);


    // --- MODIFIER ---

    // Restricts a function's execution to only the contract owner/deployer
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }

    // --- CONSTRUCTOR ---
    constructor() {
        owner = msg.sender;
    }

    // --- CORE FUNCTIONS ---

    /**
     * @notice Registers a new product batch into the system, typically by the farmer.
     * @param _name The name of the product (e.g., "Organic Apples").
     * @param _id A unique identifier for the batch (e.g., "FARM-B1-2025").
     * @param _location The initial planting location.
     */
    function registerBatch(string memory _name, string memory _id, string memory _location) public {
        bytes32 productId = keccak256(abi.encodePacked(_id));
        
        // Ensure this batch ID hasn't been used yet
        require(productBatches[productId].owner == address(0), "Batch ID already registered.");
        
        productBatches[productId] = ProductBatch({
            productName: _name,
            batchId: _id,
            owner: msg.sender,
            currentStage: Stage.Planted,
            timestamp: block.timestamp,
            location: _location
        });

        emit ProductRegistered(productId, _id, msg.sender, Stage.Planted);
    }

    /**
     * @notice Updates the stage of a product batch in the supply chain.
     * @param _productId The unique hash ID of the batch.
     * @param _newStage The new stage (e.g., Harvested, Processed, Shipped).
     * @param _location The physical location where the update occurred.
     */
    function updateStage(bytes32 _productId, Stage _newStage, string memory _location) public {
        ProductBatch storage batch = productBatches[_productId];
        
        // Ensure the batch exists and the caller is the current owner
        require(batch.owner != address(0), "Batch not found.");
        require(batch.owner == msg.sender, "Only the current batch owner can update the stage.");
        
        // Ensure the new stage is logically after the current stage
        require(_newStage > batch.currentStage, "Stage update must be sequential.");

        // Update the batch details
        batch.currentStage = _newStage;
        batch.timestamp = block.timestamp;
        batch.location = _location;

        emit StageUpdated(_productId, _newStage, msg.sender, _location);
    }
    
    /**
     * @notice Allows the current owner of the batch to transfer ownership to the next party.
     * @param _productId The unique hash ID of the batch.
     * @param _newOwner The address of the next party in the supply chain.
     */
    function transferOwnership(bytes32 _productId, address _newOwner) public {
        ProductBatch storage batch = productBatches[_productId];
        
        require(batch.owner == msg.sender, "Only the current batch owner can transfer ownership.");
        require(_newOwner != address(0), "New owner address cannot be zero.");
        
        batch.owner = _newOwner;
    }

    /**
     * @notice View function to retrieve the current stage string for a batch.
     * @param _productId The unique hash ID of the batch.
     */
    function getCurrentStageString(bytes32 _productId) public view returns (string memory) {
        Stage stage = productBatches[_productId].currentStage;
        
        if (stage == Stage.Planted) return "Planted";
        if (stage == Stage.Harvested) return "Harvested";
        if (stage == Stage.Processed) return "Processed";
        if (stage == Stage.Shipped) return "Shipped";
        if (stage == Stage.ReceivedByRetailer) return "Received By Retailer";
        
        return "Unknown";
    }
    
    // [NEW FUNCTION] Added to handle accidental Ether sent to the contract
    /**
     * @notice Allows the owner to withdraw any Ether accidentally sent to the contract.
     */
    function withdrawBalance() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Contract balance is zero.");

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Withdrawal failed.");
        
        emit BalanceWithdrawn(owner, balance);
    }
}
