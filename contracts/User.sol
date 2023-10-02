// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@thirdweb-dev/contracts/extension/Permissions.sol";
import "./Case.sol";
import "./Document.sol";
import "./User.sol";

struct User {
    string name;
    string username;
    string avatar;
    string bio;
    string location;
    string email;
}

contract Users {
    Permissions public permissions;
    Cases public cases;
    Users public user;
    Documents public documents;

    constructor(address _permissions){
        permissions = Permissions(_permissions);
    }
}
