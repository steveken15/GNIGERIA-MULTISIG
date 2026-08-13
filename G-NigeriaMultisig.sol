// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract GNigeriaMultisig {

//TRANSACTION STRUCT
struct Transaction {
    address target;
    bytes data;
    bool executed;
    uint256 approvalCount;
}


//STATE VARIABLES
address[] public signers;
uint256 public requiredApprovals;
uint256 public transactionCount;
mapping(address => bool) public isSigner;
mapping(uint256 => Transaction) public transactions;
mapping(uint256 => mapping(address => bool)) public approved;


//CONSTRUCTOR
constructor(
    address[] memory _signers,
    uint256 _requiredApprovals
)  {
    require(
        _signers.length > 0, "No signers provided"
);
    require(
        _requiredApprovals > 0 && _requiredApprovals <= _signers.length,
        "Invalid approval requirement"
    );
     for (
        uint256 i = 0; i < _signers.length; i++
     ) {
        address signer = _signers[i];
        require(
            signer != address(0), "Invalid signer"
        );
        require(
            !isSigner[signer], "Duplicate signer"
        );
        isSigner[signer] = true;
        signers.push(signer);
     }
     requiredApprovals = _requiredApprovals;
}

//EVENTS
event TransactionSubmitted(
    uint256 indexed transactionid,
    address indexed proposer,
    address target
);

event TransactionApproved(
    uint256 indexed transactionid,
    address indexed signer
);

event TransactionExecuted(
    uint256 indexed transactionid
);


//SIGNERS MODIFIER
modifier onlySigner() {
    require(
        isSigner[msg.sender], "Not a signer"
    );
    _;
}


//SUBMIT TRANSACTION
function submitTransaction(
    address target, bytes calldata data
)
external onlySigner returns (uint256) {
   require(
    target != address(0), "Invalid target"
   );
   uint256 transactionId = transactionCount;
   transactions[transactionId] = Transaction({
    target: target,
    data: data,
    executed: false,
    approvalCount: 0
   });
   transactionCount++;
   emit TransactionSubmitted(
    transactionId,
    msg.sender,
    target
   );
   return transactionId;
}


//APPROVE TRANSACTION
function approveTransaction(
    uint256 transactionId
)
external onlySigner {
    Transaction storage transaction = transactions[transactionId];
    require(
        transaction.target != address(0), "Transaction does not exist"
    );
    require(
        !approved[transactionId] [msg.sender], "Already approved"
    );
    approved[transactionId] [msg.sender] = true;
    transaction.approvalCount++;
    emit TransactionApproved(
        transactionId, msg.sender
    );
}


//EXECUTE TRANSACTION
function executeTransaction(
    uint256 transactionId
)
external onlySigner {
Transaction storage transaction = transactions[transactionId];
require(
    transaction.target != address(0), "Transaction does not exist"
);
require(
    !transaction.executed, "Transaction already exist"
);
require(
    transaction.approvalCount >= requiredApprovals, "Not enough approvals"
);
transaction.executed = true; (bool success, ) = transaction.target.call(
    transaction.data
);
require(
    success, "Transaction execution failed"
);
emit TransactionExecuted(
    transactionId
);
}


//GET SIGNERS
function getSigners()
external view returns (address[] memory) {
    return signers;
}


//GET TRANSACTION
function getTransaction(
    uint256 transactionId
)
external view returns (
    address target,
    bytes memory data,
    bool executed,
    uint256 approvalCount
)  {
    Transaction memory transaction  = transactions[transactionId];
    return (
        transaction.target,
        transaction.data,
        transaction.executed,
        transaction.approvalCount
    );
}


//CHECK WHETHER A SIGNER APPROVED
function hasApproved(
    uint256 transactionId, address signer
)
external view  returns (bool) {
    return approved[transactionId] [signer];
}
}