// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Case.sol";
import "./Document.sol";
import "./User.sol";
import "./RecordWarden.sol";

struct User {
    string name;
    string username;
    string avatar;
    string bio;
    string location;
    string email;
}

contract Users {
    RecordWarden public recordWarden;
    Cases public cases;
    Users public users;
    Documents public documents;

    constructor(address _recordWarden) {
        recordWarden = RecordWarden(_recordWarden);
    }

    function linkContracts(address _cases, address _users, address _documents) external onlyAdmin {
        cases = Cases(_cases);
        users = Users(_users);
        documents = Documents(_documents);
    }

    modifier onlyAdmin() {
        require(recordWarden.isAdmin(msg.sender), "Caller is not an admin");
        _;
    }
}
