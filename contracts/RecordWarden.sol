// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@thirdweb-dev/contracts/extension/Permissions.sol";

enum CaseStatus {
    Open,
    Closed
}

struct Document {
    uint256 id;
    string name;
    string cid;
    address[] authorized;
    uint256 uploadedAt;
    address uploadedBy;
}

struct Case {
    uint256 id;
    string description;
    CaseStatus status;
    address client;
    uint256 createdAt;
    uint256 closedAt;
    uint256 updatedAt;
    address updatedBy;
    uint256 nextHearing;
    uint256[] documents;
    address[] lawyers;
}

struct User {
    string name;
    string username;
    string avatar;
    string bio;
    string location;
    string email;
}

contract RecordWarden is Permissions {
    bytes32 public constant LawyerRole = keccak256("Lawyer");
    bytes32 public constant JudgeRole = keccak256("Judge");
    bytes32 public constant DetectiveRole = keccak256("Detective");

    mapping(address => User) public users;
    mapping(uint256 => Case) public cases;
    mapping(uint256 => Document) private documents;

    uint256 public caseCount;
    uint256 public documentCount;

    event CaseCreated(uint256 indexed id, address indexed lawyer, Case c);
    event CaseClosed(uint256 indexed id, address indexed lawyer, Case c);
    event CaseUpdated(uint256 indexed id, address indexed lawyer, Case c);

    event UserCreated(address indexed user, User u);
    event UserUpdated(address indexed user, User u);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    //User Functions
    function createUser(
        string memory name,
        string memory username,
        string memory avatar,
        string memory bio,
        string memory location,
        string memory email
    ) external {
        require(
            bytes(users[msg.sender].username).length == 0,
            "User already exists"
        );
        require(
            bytes(users[msg.sender].username).length == 0,
            "Username already taken"
        );

        users[msg.sender] = User(name, username, avatar, bio, location, email);
        emit UserCreated(msg.sender, users[msg.sender]);
    }

    function updateUserField(
        string memory field,
        string memory value
    ) external {
        User memory user = users[msg.sender];

        if (keccak256(bytes(field)) == keccak256(bytes("name"))) {
            user.name = value;
        } else if (keccak256(bytes(field)) == keccak256(bytes("username"))) {
            require(bytes(user.username).length == 0, "Username already taken");
            user.username = value;
        } else if (keccak256(bytes(field)) == keccak256(bytes("avatar"))) {
            user.avatar = value;
        } else if (keccak256(bytes(field)) == keccak256(bytes("bio"))) {
            user.bio = value;
        } else if (keccak256(bytes(field)) == keccak256(bytes("location"))) {
            user.location = value;
        } else if (keccak256(bytes(field)) == keccak256(bytes("email"))) {
            user.email = value;
        } else {
            revert("Invalid field name");
        }

        users[msg.sender] = user;

        emit UserUpdated(msg.sender, user);
    }

    // Case Functions
    function createCase(
        string memory description,
        address client,
        uint256 nextHearing
    ) external {
        require(
            hasRole(LawyerRole, msg.sender),
            "Must have Lawyer role to create a case"
        );

        uint256 caseID = caseCount + 1;

        Case memory c = Case(
            caseID,
            description,
            CaseStatus.Open,
            client,
            block.timestamp,
            0,
            block.timestamp,
            msg.sender,
            nextHearing,
            new uint256[](0),
            new address[](0)
        );

        cases[caseID] = c;
        caseCount++;

        cases[c.id] = c;

        emit CaseCreated(c.id, msg.sender, c);
    }

    function closeCase(uint256 id) external {
        require(
            hasRole(LawyerRole, msg.sender) || hasRole(JudgeRole, msg.sender),
            "Must have Lawyer/Judge role to close a case"
        );
        require(
            cases[id].status == CaseStatus.Open,
            "Case must be open to close"
        );

        cases[id].status = CaseStatus.Closed;
        cases[id].closedAt = block.timestamp;

        emit CaseClosed(id, msg.sender, cases[id]);
    }

    function updateNextHearing(uint256 id, uint256 nextHearing) external {
        require(
            hasRole(JudgeRole, msg.sender),
            "Must have Judge role to update a next hearing"
        );

        cases[id].nextHearing = nextHearing;
        cases[id].updatedAt = block.timestamp;
        cases[id].updatedBy = msg.sender;

        emit CaseUpdated(id, msg.sender, cases[id]);
    }

    function updateCaseDescription(
        uint256 id,
        string memory description
    ) external {
        require(
            hasRole(LawyerRole, msg.sender) || hasRole(JudgeRole, msg.sender),
            "Must have Lawyer/Judge role to update a case"
        );

        cases[id].description = description;
        cases[id].updatedAt = block.timestamp;
        cases[id].updatedBy = msg.sender;

        emit CaseUpdated(id, msg.sender, cases[id]);
    }

    //Document Functions
    function addCaseDocument(
        uint256 id,
        string memory name,
        string memory cid
    ) external {
        Case storage c = cases[id];
        bool authorized = false;

        for (uint256 i = 0; i < c.lawyers.length; i++) {
            if (c.lawyers[i] == msg.sender) {
                authorized = true;
                break;
            }
        }

        require(
            c.client == msg.sender || authorized,
            "Must be client or lawyer to add document"
        );

        Document memory d = Document(
            documentCount,
            name,
            cid,
            new address[](0),
            block.timestamp,
            msg.sender
        );

        documents[documentCount] = d;
        documentCount++;

        c.documents.push(d.id);
        c.updatedAt = block.timestamp;
        c.updatedBy = msg.sender;

        cases[id] = c;

        emit CaseUpdated(id, msg.sender, c);
    }

    function deleteCaseDocument(uint256 id, uint256 docId) external {
        Case memory c = cases[id];
        Document memory d = documents[docId];
        bool authorized = false;

        for (uint256 i = 0; i < d.authorized.length; i++) {
            if (d.authorized[i] == msg.sender) {
                authorized = true;
                break;
            }
        }

        require(
            c.client == msg.sender || authorized,
            "Must be client or lawyer to delete document"
        );

        delete documents[docId];

        c.updatedAt = block.timestamp;
        c.updatedBy = msg.sender;

        cases[id] = c;

        emit CaseUpdated(id, msg.sender, c);
    }

    function addDocumentAuthorized(
        uint256 id,
        uint256 docId,
        address user
    ) external {
        Case memory c = cases[id];
        require(
            c.client == msg.sender,
            "Must be client to add authorized user"
        );

        for (uint256 i = 0; i < c.documents.length; i++) {
            if (c.documents[i] == docId) {
                documents[docId].authorized.push(user);
                break;
            }
        }

        c.updatedAt = block.timestamp;
        c.updatedBy = msg.sender;

        cases[id] = c;

        emit CaseUpdated(id, msg.sender, c);
    }

    function deleteDocumentAuthorized(
        uint256 id,
        uint256 docId,
        address user
    ) external {
        Case memory c = cases[id];
        require(
            c.client == msg.sender,
            "Must be client to delete authorized user"
        );

        for (uint256 i = 0; i < c.documents.length; i++) {
            if (c.documents[i] == docId) {
                for (
                    uint256 j = 0;
                    j < documents[docId].authorized.length;
                    j++
                ) {
                    if (documents[docId].authorized[j] == user) {
                        documents[docId].authorized[j] = documents[docId]
                            .authorized[documents[docId].authorized.length - 1];
                        documents[docId].authorized.pop();
                        break;
                    }
                }
                break;
            }
        }

        c.updatedAt = block.timestamp;
        c.updatedBy = msg.sender;

        cases[id] = c;

        emit CaseUpdated(id, msg.sender, c);
    }

    function addCaseLawyer(uint256 id, address lawyer) external {
        Case storage c = cases[id];
        require(c.client == msg.sender, "Must be client to add lawyer to case");

        c.lawyers.push(lawyer);
        c.updatedAt = block.timestamp;
        c.updatedBy = msg.sender;

        cases[id] = c;

        emit CaseUpdated(id, msg.sender, c);
    }

    function deleteCaseLawyer(uint256 id, address lawyer) external {
        Case storage c = cases[id];
        require(
            c.client == msg.sender,
            "Must be client to delete lawyer from case"
        );

        for (uint256 i = 0; i < c.lawyers.length; i++) {
            if (c.lawyers[i] == lawyer) {
                c.lawyers[i] = c.lawyers[c.lawyers.length - 1];
                c.lawyers.pop();
                break;
            }
        }

        c.updatedAt = block.timestamp;
        c.updatedBy = msg.sender;

        cases[id] = c;

        emit CaseUpdated(id, msg.sender, c);
    }

    function getDocumentCID(uint256 id) external view returns (string memory) {
        Document memory d = documents[id];
        bool authorized = false;

        for (uint256 i = 0; i < d.authorized.length; i++) {
            if (d.authorized[i] == msg.sender) {
                authorized = true;
                break;
            }
        }

        require(
            msg.sender == d.uploadedBy ||
                authorized ||
                hasRole(JudgeRole, msg.sender) ||
                hasRole(DetectiveRole, msg.sender),
            "Must have Client/Lawyer/Judge/Detective role to get document cid"
        );

        return d.cid;
    }
}
