//SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.0;

//pragma abicoder v2;

contract MultiSigWallet {
    address deployer;
    address[3] public owners = [0xaE8232Cd573641E8394829fBB7eA8fa7dcE4bA3F,
                                0x015a3f4423cF66b32c5fbc670638b6Cb74257d7B,
                                0xCffA36F10E99a92EAc91F11aCF3B2FD2E800B8eC];
    modifier onlyowners() {
        bool owner = false;
        for (uint256 i; i < owners.length; i++) {
            if (msg.sender == owners[i]) owner = true;
        }
        require(owner == true);
        _;
    }

    struct transaction {
        address payable to;
        uint256 amount;
        uint256 id;
        uint256 approvals;
        bool hasbeensent;
    }
    transaction[] public transactions;

    mapping(address => mapping(uint256 => bool)) addrapproval;
    uint256 aCount;
    uint256 public nOA = 2;

    constructor(/*uint256 _numberofApprovals, address[] memory _owners*/) payable {
        deployer = msg.sender;
    //    nOA = _numberofApprovals;
    //    owners = _owners;
    }

    //    receive() external payable {}
    function deposit() public payable {}

    function addtransaction(address payable _to, uint256 _amount)
        public
        onlyowners
    {
        transactions.push(
            transaction(_to, _amount, transactions.length, 0, false)
        );
        addrapproval[msg.sender][transactions.length] = false;
    }

    function approve(uint256 _id) public payable onlyowners {
        require(
            addrapproval[msg.sender][_id] == false,
            "you have already voted"
        );
        (addrapproval[msg.sender][_id] == true);
        transactions[_id].approvals++;
        if (transactions[_id].approvals >= nOA) {
            transactions[_id].hasbeensent == true;
            transactions[_id].to.transfer(transactions[_id].amount);
        }
    }

    function getbalance() public view returns (uint256) {
        return address(this).balance;
    }
}
