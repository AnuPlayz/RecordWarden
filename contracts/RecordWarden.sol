// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@thirdweb-dev/contracts/extension/Permissions.sol";
import "./Case.sol";
import "./Document.sol";
import "./User.sol";

contract RecordWarden is Permissions {
    Cases public cases;
    Users public user;
    Documents public documents;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        address RecordWardenAddress = address(this);

        cases = Cases(RecordWardenAddress);
        user = Users(RecordWardenAddress);
        documents = Documents(RecordWardenAddress);
    }
}
