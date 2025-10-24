
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AgriculturalTraceability {
    enum Stage { Planted, Harvested, Processed, Shipped, ReceivedByRetailer }

    struct ProductBatch {
        uint256 batchId;
        address currentOwner;
        Stage currentStage;
        uint256 creationTimestamp;
        EventRecord[] history;
    }

    struct EventRecord {
        uint256 timestamp;
        Stage stage;
        string location;
        address entity;
        string description;
    }

    uint256 private nextBatchId = 1;
    mapping(uint256 => ProductBatch) public productBatches;

    event BatchRegistered(uint256 indexed batchId, address indexed harvester, uint256 timestamp);
    event StageUpdated(uint256 indexed batchId, Stage newStage, string location);
    event OwnershipTransferred(uint256 indexed batchId, address indexed oldOwner, address indexed newOwner);

    function registerBatch(string memory _location, string memory _description) public returns (uint256) {
        uint256 newId = nextBatchId;
        
        EventRecord memory initialEvent = EventRecord({
            timestamp: block.timestamp,
            stage: Stage.Planted,
            location: _location,
            entity: msg.sender,
            description: string(abi.encodePacked("Batch registered and planted: ", _description))
        });

        ProductBatch storage newBatch = productBatches[newId];
        newBatch.batchId = newId;
        newBatch.currentOwner = msg.sender;
        newBatch.currentStage = Stage.Planted;
        newBatch.creationTimestamp = block.timestamp;
        newBatch.history.push(initialEvent);

        nextBatchId++;

        emit BatchRegistered(newId, msg.sender, block.timestamp);
        return newId;
    }

    function updateStage(uint256 _batchId, string memory _location, string memory _description) public {
        ProductBatch storage batch = productBatches[_batchId];
        require(batch.batchId != 0, "Batch does not exist.");
        require(batch.currentOwner == msg.sender, "Only the current owner can update the stage.");
        require(uint8(batch.currentStage) < uint8(Stage.ReceivedByRetailer), "Batch has completed all stages.");

        Stage nextStage = Stage(uint8(batch.currentStage) + 1);
        batch.currentStage = nextStage;

        EventRecord memory newEvent = EventRecord({
            timestamp: block.timestamp,
            stage: nextStage,
            location: _location,
            entity: msg.sender,
            description: _description
        });
        batch.history.push(newEvent);

        emit StageUpdated(_batchId, nextStage, _location);
    }

    function transferOwnership(uint256 _batchId, address _newOwner) public {
        ProductBatch storage batch = productBatches[_batchId];
        require(batch.batchId != 0, "Batch does not exist.");
        require(batch.currentOwner == msg.sender, "Only the current owner can transfer ownership.");
        require(_newOwner != address(0), "New owner address cannot be zero.");

        address oldOwner = batch.currentOwner;
        batch.currentOwner = _newOwner;

        EventRecord memory newEvent = EventRecord({
            timestamp: block.timestamp,
            stage: batch.currentStage,
            location: "Ownership Transfer",
            entity: msg.sender,
            description: string(abi.encodePacked("Ownership transferred to: ", addressToString(_newOwner)))
        });
        batch.history.push(newEvent);

        emit OwnershipTransferred(_batchId, oldOwner, _newOwner);
    }

    function addressToString(address _addr) internal pure returns(string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    function getBatchHistory(uint256 _batchId) public view returns (EventRecord[] memory) {
        require(productBatches[_batchId].batchId != 0, "Batch does not exist.");
        return productBatches[_batchId].history;
    }
}

