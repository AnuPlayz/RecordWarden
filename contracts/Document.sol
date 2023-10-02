// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@thirdweb-dev/contracts/extension/Permissions.sol";
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
    Permissions public permissions;
    Cases public cases;
    Users public user;
    Documents public documents;

    constructor(address _permissions){
        permissions = Permissions(_permissions);
    }
}