// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@thirdweb-dev/contracts/extension/recordWarden.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Case.sol";
import "./Document.sol";
import "./User.sol";

enum CaseStatus {
    Open,
    Closed
}

struct Case {
    // mapping(uint256 => uint256) hearings;
    // uint256 hearingsCount;
    // mapping(uint256 => address) lawyers;
    // uint256 lawyersCount;

    uint256 id;
    string description;
    CaseStatus status;
    address client;
    uint256 createdAt;
    uint256 closedAt;
    uint256 updatedAt;
    address updatedBy;
    uint256 nextHearing;
}

contract Cases {
    RecordWarden recordWarden;

    constructor(address _recordWarden){
        recordWarden = RecordWarden(_recordWarden);
    }

    function linkContracts(address _cases, address _users, address _documents) public {
        require(recordWarden.hasRole(recordWarden.DEFAULT_ADMIN_ROLE, msg.sender), "u are gay");

        cases = Cases(_cases);
        users = Users(_users);
        documents = Documents(_documents);
    }
}