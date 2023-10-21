// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./RecordWarden.sol";

struct TestCase {
    mapping(uint256 => uint256) hearings;
    uint256 hearingsCount;
    mapping(uint256 => address) lawyers;
    uint256 lawyersCount;
    uint256 id;
    string description;
    address client;
    uint256 createdAt;
    uint256 closedAt;
    uint256 updatedAt;
    address updatedBy;
    uint256 nextHearing;
}

contract Test {
    mapping(uint256 => TestCase) public cases;

    constructor() {}

    // function linkContracts(
    //     address _cases,
    //     address _users,
    //     address _documents
    // ) public {
    //     require(
    //         recordWarden.hasRole(recordWarden.DEFAULT_ADMIN_ROLE, msg.sender),
    //         "u are gay"
    //     );

    //     cases = TestCase(_cases);
    //     users = Users(_users);
    //     documents = Documents(_documents);
    // }

    // Case Functions
    function createCase() external {
        TestCase storage c = cases[1];
        c.id = 1;
        c.client = msg.sender;
        c.description = "ur mom";
        c.lawyersCount = 0;
    }

    function addLawyer(uint256 caseId, address lawyer) public {
        TestCase storage c = cases[caseId];
        c.lawyers[c.lawyersCount] = lawyer;
        c.lawyersCount++;
    }

    // function fetchLawyers(
    //     uint256 caseId
    // ) public view returns (address[] memory) {
    //     Case storage c = cases[caseId];
    //     address[] memory lawyers = new address[](c.lawyersCount);
    //     for (uint256 i = 0; i < c.lawyersCount; i++) {
    //         lawyers[i] = c.lawyers[i];
    //     }
    //     return lawyers;
    // }

    // function removeThatBastard(uint256 caseId, address lawyer) public {
    //     Case storage c = cases[caseId];
    //     for (uint256 i = 0; i < c.lawyersCount; i++) {
    //         if (c.lawyers[i] == lawyer) {
    //             c.lawyers[i] = c.lawyers[c.lawyersCount - 1];
    //             delete c.lawyers[c.lawyersCount - 1];
    //             c.lawyersCount--;
    //             break;
    //         }
    //     }
    // }
}
