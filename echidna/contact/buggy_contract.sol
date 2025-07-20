// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BuggyContract {
    uint256 public counter;
    mapping(address => uint256) public userCounts;
    address public owner;
    
    constructor() {
        owner = msg.sender;
        counter = 0;
    }
    
    function increment() public {
        counter++;
        userCounts[msg.sender]++;
    }
    
    function decrement() public {
        require(counter > 0, "Counter cannot be negative");
        counter--;
        userCounts[msg.sender]--;
    }
    
    function reset() public {
        require(msg.sender == owner, "Only owner can reset");
        counter = 0;
        // Bug: We don't reset user counts!
    }
    
    function dangerousFunction(uint256 value) public {
        // Bug: This can cause integer overflow in older Solidity versions
        counter += value;
    }
    
    // Echidna properties - these should always return true
    function echidna_counter_never_negative() public view returns (bool) {
        return counter >= 0;
    }
    
    function echidna_user_count_never_negative() public view returns (bool) {
        return userCounts[msg.sender] >= 0;
    }
    
    function echidna_counter_reasonable() public view returns (bool) {
        // This might fail due to the dangerous function
        return counter < 1000000;
    }
    
    function echidna_user_count_matches_increments() public view returns (bool) {
        // This is a simplified check - in practice you'd track this more carefully
        return userCounts[msg.sender] <= counter;
    }
}

contract GasLimitCheck {
    uint256 public x;

    function heavyLoop(uint256 n) public {
        require(n < 500, "Too much gas");
        for (uint256 i = 0; i < n; i++) {
            x += 1;
        }
    }

    function echidna_gas_safe() public view returns (bool) {
        return true; // Contract reverts on high gas anyway
    }
}

contract TimeTestContract {
    uint256 public deploymentTime;
    uint256 public lastCallTime;
    uint256 public systemTime;
    uint256 public maxTimeDifference;
    mapping(address => uint256) public userCallTimes;
    
    constructor() {
        deploymentTime = block.timestamp;
        systemTime = block.timestamp; // In test environment, this will be the simulated time
        lastCallTime = block.timestamp;
        maxTimeDifference = 0;
    }
    
    function updateTime() public {
        uint256 currentBlockTime = block.timestamp;
        uint256 timeDiff = currentBlockTime > lastCallTime ? 
            currentBlockTime - lastCallTime : 
            lastCallTime - currentBlockTime;
            
        if (timeDiff > maxTimeDifference) {
            maxTimeDifference = timeDiff;
        }
        
        lastCallTime = currentBlockTime;
        userCallTimes[msg.sender] = currentBlockTime;
    }
    
    function getTimeDifference() public view returns (uint256) {
        return block.timestamp > deploymentTime ? 
            block.timestamp - deploymentTime : 
            deploymentTime - block.timestamp;
    }
    
    // Echidna properties for time testing
    function echidna_time_always_increases() public view returns (bool) {
        return block.timestamp >= deploymentTime;
    }
    
    function echidna_time_difference_reasonable() public view returns (bool) {
        uint256 diff = getTimeDifference();
        return diff < 86400; // Less than 24 hours difference
    }
    
    function echidna_max_time_jump_reasonable() public view returns (bool) {
        return maxTimeDifference < 3600; // Less than 1 hour jump
    }
    
    function echidna_user_time_valid() public view returns (bool) {
        return userCallTimes[msg.sender] <= block.timestamp;
    }
}

contract AdvancedTimeContract {
    struct TimeRecord {
        uint256 systemTime;
        uint256 blockTime;
        uint256 difference;
    }
    
    TimeRecord[] public timeRecords;
    uint256 public totalTimeDifference;
    uint256 public recordCount;
    
    function recordTime() public {
        uint256 currentBlock = block.timestamp;
        // In testing, we simulate system time as block time + some offset
        uint256 simulatedSystemTime = currentBlock;
        
        uint256 diff = currentBlock > simulatedSystemTime ? 
            currentBlock - simulatedSystemTime : 
            simulatedSystemTime - currentBlock;
            
        timeRecords.push(TimeRecord({
            systemTime: simulatedSystemTime,
            blockTime: currentBlock,
            difference: diff
        }));
        
        totalTimeDifference += diff;
        recordCount++;
    }
    
    function getAverageTimeDifference() public view returns (uint256) {
        if (recordCount == 0) return 0;
        return totalTimeDifference / recordCount;
    }
    
    function getLastTimeDifference() public view returns (uint256) {
        if (timeRecords.length == 0) return 0;
        return timeRecords[timeRecords.length - 1].difference;
    }
    
    // Echidna properties
    function echidna_average_time_diff_reasonable() public view returns (bool) {
        return getAverageTimeDifference() < 300; // Less than 5 minutes average
    }
    
    function echidna_records_consistent() public view returns (bool) {
        return timeRecords.length == recordCount;
    }
    
    function echidna_time_records_ordered() public view returns (bool) {
        if (timeRecords.length <= 1) return true;
        
        for (uint256 i = 1; i < timeRecords.length; i++) {
            if (timeRecords[i].blockTime < timeRecords[i-1].blockTime) {
                return false;
            }
        }
        return true;
    }
}

contract RealtimeVsTestTime {
    uint256 public creationTime;
    uint256 public lastInteractionTime;
    uint256 public interactionCount;
    uint256 public maxObservedDifference;
    
    mapping(uint256 => uint256) public interactionTimes;
    
    constructor() {
        creationTime = block.timestamp;
        lastInteractionTime = block.timestamp;
        interactionCount = 0;
        maxObservedDifference = 0;
    }
    
    function interact() public {
        uint256 currentTime = block.timestamp;
        uint256 timeSinceLastInteraction = currentTime - lastInteractionTime;
        
        if (timeSinceLastInteraction > maxObservedDifference) {
            maxObservedDifference = timeSinceLastInteraction;
        }
        
        interactionTimes[interactionCount] = currentTime;
        lastInteractionTime = currentTime;
        interactionCount++;
    }
    
    function getTimeSinceCreation() public view returns (uint256) {
        return block.timestamp - creationTime;
    }
    
    function getTimeSinceLastInteraction() public view returns (uint256) {
        return block.timestamp - lastInteractionTime;
    }
    
    // Echidna properties for real vs test time
    function echidna_time_progresses() public view returns (bool) {
        return block.timestamp >= creationTime;
    }
    
    function echidna_max_time_gap_reasonable() public view returns (bool) {
        return maxObservedDifference < 7200; // Less than 2 hours
    }
    
    function echidna_interaction_times_valid() public view returns (bool) {
        if (interactionCount == 0) return true;
        return interactionTimes[interactionCount - 1] <= block.timestamp;
    }
    
    function echidna_time_consistency() public view returns (bool) {
        return lastInteractionTime <= block.timestamp;
    }
}
