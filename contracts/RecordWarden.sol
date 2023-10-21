// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@thirdweb-dev/contracts/extension/Permissions.sol";
import "./Case.sol";
import "./Document.sol";
import "./User.sol";

contract RecordWarden is Permissions {
    Cases public cases;
    Users public users;
    Documents public documents;

    //Roles
    bytes32 public constant LAWYER_ROLE = keccak256("LAWYER_ROLE");
    bytes32 public constant JUDGE_ROLE = keccak256("JUDGE_ROLE");
    bytes32 public constant DETECTIVE_ROLE = keccak256("DETECTIVE_ROLE");
    bytes32 public constant CLIENT_ROLE = keccak256("CLIENT_ROLE");

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        address RecordWardenAddress = address(this);

        cases = new Cases(RecordWardenAddress);
        users = new Users(RecordWardenAddress);
        documents = new Documents(RecordWardenAddress);

        address casesAddress = address(cases);
        address userAddress = address(users);
        address documentsAddress = address(documents);

        cases.linkContracts(casesAddress, userAddress, documentsAddress);
        users.linkContracts(casesAddress, userAddress, documentsAddress);
        documents.linkContracts(casesAddress, userAddress, documentsAddress);
    }

    function isAdmin (address _address) public view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, _address);
    }

    function isLawyer (address _address) public view returns (bool) {
        return hasRole(LAWYER_ROLE, _address);
    }

    function isJudge (address _address) public view returns (bool) {
        return hasRole(JUDGE_ROLE, _address);
    }

    function isDetective (address _address) public view returns (bool) {
        return hasRole(DETECTIVE_ROLE, _address);
    }

    function isClient (address _address) public view returns (bool) {
        return hasRole(CLIENT_ROLE, _address);
    }
}
