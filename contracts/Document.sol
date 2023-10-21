// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./RecordWarden.sol";
import "./Case.sol";
import "./Document.sol";
import "./User.sol";

struct Document {
    // mapping(uint256 => address) authorized;
    // uint256 authorizedCount;
    
    uint256 id;
    string name;
    string cid;
    
    uint256 uploadedAt;
    address uploadedBy;
} 

contract Documents {
    RecordWarden public recordWarden;
    Cases public cases;
    Users public users;
    Documents public documents;

    constructor(address _recordWarden){
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