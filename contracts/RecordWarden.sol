// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@thirdweb-dev/contracts/extension/Permissions.sol";

enum CaseStatus {
    Open,
    Closed
}

struct Document {
    uint256 id;
    uint256[] cases;
    string title;
    string description;
    address uploadedBy;
    uint256 uploadedAt;
    string content; //IPFS Url
    //Permissions
    bool isPublic;
}

struct Case {
    uint256 id;
    string description;
    address[] lawyers;
    uint256 creationDate;
    uint256 updatedDate;
    CaseStatus status;
}

contract RecordWarden is Permissions {
    bytes32 public constant LawyerRole = keccak256("Lawyer");
    bytes32 public constant JudgeRole = keccak256("Judge");

    uint256 public totalCases = 0;
    uint256 public totalDocuments = 0;

    mapping(uint256 => Document) documents;
    mapping(uint256 => Case) cases;

    event CaseCreated(Case);
    event CaseUpdated(Case);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function grantLawyerRole(address user) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(LawyerRole, user);
    }

    function grantJudgeRole(address user) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(JudgeRole, user);
    }

    function getNextCaseId() private returns (uint256) {
        totalCases++;
        return totalCases;
    }

    function createCase(
        string memory description,
        address lawyer
    ) public onlyRole(LawyerRole) returns (Case memory) {
        uint256 id = getNextCaseId();
        address[] memory lawyersArray = new address[](1);
        lawyersArray[0] = lawyer;

        Case memory creatingCase = Case(
            id,
            description,
            lawyersArray,
            block.timestamp,
            block.timestamp,
            CaseStatus.Open
        );
        cases[id] = creatingCase;

        emit CaseCreated(creatingCase);

        return creatingCase;
    }

    modifier onlyCaseLawyerOrJudge(uint256 caseId) {
        bool isLawyer = false;
        bool isJudge = false;

        // Check if the msg.sender is a lawyer
        for (uint256 i = 0; i < cases[caseId].lawyers.length; i++) {
            if (cases[caseId].lawyers[i] == msg.sender) {
                isLawyer = true;
                break;
            }
        }

        // Check if the msg.sender is a judge
        if (hasRole(JudgeRole, msg.sender)) {
            isJudge = true;
        }

        require(
            isLawyer || isJudge,
            "Only lawyers or judges can perform this action"
        );
        _;
    }

    function changeCaseDescription(
        uint256 caseId,
        string memory description
    ) public onlyCaseLawyerOrJudge(caseId) returns (Case memory) {
        require(cases[caseId].id == caseId, "Case does not exist");
        cases[caseId].description = description;
        cases[caseId].updatedDate = block.timestamp;

        return cases[caseId];
    }

    function changeCaseStatus(
        uint256 caseId,
        bool closed
    ) public onlyRole(JudgeRole) {
        require(cases[caseId].id == caseId, "Case does not exist");
        require(
            closed && cases[caseId].status == CaseStatus.Closed,
            "The case is already closed"
        );
        require(
            !closed && cases[caseId].status == CaseStatus.Open,
            "The case is already open"
        );

        cases[caseId].status = closed ? CaseStatus.Closed : CaseStatus.Open;
    }

    // Function to add a document to a case
    function addDocument(
        uint256 caseId,
        string memory title,
        string memory description,
        string memory content,
        bool isPublic
    ) public onlyCaseLawyerOrJudge(caseId) returns (Document memory) {
        // Check if the case exists
        require(cases[caseId].id == caseId, "Case does not exist");

        // Generate a unique document ID
        uint256 docId = getNextDocumentId();

        // Create the document
        uint256[] memory caseIds = new uint256[](1); // Create a dynamic array
        caseIds[0] = caseId; // Add the caseId to the array

        Document memory newDocument = Document({
            id: docId,
            cases: caseIds, // Assign the dynamic array
            title: title,
            description: description,
            uploadedBy: msg.sender,
            uploadedAt: block.timestamp,
            content: content,
            isPublic: isPublic
        });

        // Store the document in the mapping
        documents[docId] = newDocument;

        return newDocument;
    }

    modifier onlyDocLawyerOrJudge(uint256 docId) {
        bool isLawyer = false;
        bool isJudge = false;

        // Check if the msg.sender is a lawyer
        if (documents[docId].uploadedBy == msg.sender) {
            isLawyer = true;
        }

        // Check if the msg.sender is a judge
        if (hasRole(JudgeRole, msg.sender)) {
            isJudge = true;
        }

        require(
            isLawyer || isJudge,
            "Only lawyers or judges can perform this action"
        );
        _;
    }

    // Function to get the next document ID
    function getNextDocumentId() private returns (uint256) {
        uint256 id = totalDocuments;
        totalDocuments++;
        return id;
    }

    function changeDocumentVisibility(
        uint256 docId,
        bool isPublic
    ) public onlyDocLawyerOrJudge(docId) {
        require(
            documents[docId].isPublic == isPublic,
            "The visibility is same"
        );

        documents[docId].isPublic = isPublic;
    }

    function changeDocumentTitle(
        uint256 docId,
        string memory title
    ) public onlyDocLawyerOrJudge(docId) {
        documents[docId].title = title;
    }
}
