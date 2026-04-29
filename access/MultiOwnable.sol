pragma solidity 0.4.23;

contract MultiOwnable {
    mapping(address => bool) public isOwner;
    address[] public owners;

    event OwnerAdded(address indexed owner);
    event OwnerRemoved(address indexed owner);

    error NotAnOwner();

    modifier onlyOwner() {
        if (isOwner[msg.sender] == false) {
             revert NotAnOwner();
        }
        _;
    }

    constructor() public {
        isOwner[msg.sender] = true;
        owners.push(msg.sender);
    }

    function addOwner(address _owner) external onlyOwner {
        require(_owner != address(0));
        require(!isOwner[_owner]);

        isOwner[_owner] = true;
        owners.push(_owner);

        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlyOwner {
        require(isOwner[_owner]);
        require(owners.length > 1); // prevent lockout

        isOwner[_owner] = false;

        // remove from array
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == _owner) {
                owners[i] = owners[owners.length - 1];
                owners.length--;
                break;
            }
        }

        emit OwnerRemoved(_owner);
    }
}