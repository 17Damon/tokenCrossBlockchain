pragma solidity ^0.4.11;

contract Exchange {
    address public owner;
    struct Voucher {
        bytes32 voucher;
        address toAddress;
        uint256 amount;
        bool userd;
        bool isFrom;
    }
    mapping(address => Voucher) public vouchers;
    mapping(address => bool) public swaps;

    event EventDestroyToken(address _toAddr,bytes32 _voucher,uint256 _amount);
    event EventSaveSwap(bool success);
    event EventSaveVoucher(bool success);
    event EventGetToken(bool success);

    function Exchange()
    {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner)
            revert();
        _;
    }

    function destroyToken(address _toAddr,uint256 _amount) external returns (address toAddr,bytes32 voucher){
        //destroy token done
        toAddr = _toAddr;
        voucher = makeVoucher(_toAddr,_amount);
        EventDestroyToken(_toAddr,voucher,_amount);
    }

    function getToken(uint256 _amount) external returns (bool success){
        require(vouchers[msg.sender].isFrom == true);
        require(vouchers[msg.sender].voucher == makeVoucher(msg.sender,_amount));
        vouchers[msg.sender].userd = true;
        //issue token done
        success = true;
        EventGetToken(true);
    }

    function saveVoucher(address _toAddr,bytes32 _voucher,uint256 _amount) external{
        require(swaps[msg.sender] == true);
        vouchers[_toAddr].voucher = _voucher;
        vouchers[_toAddr].toAddress = _toAddr;
        vouchers[_toAddr].amount = _amount;
        vouchers[_toAddr].userd = false;
        vouchers[_toAddr].isFrom = true;
        EventSaveVoucher(true);
    }

    function saveSwap(address _addr) onlyOwner external{
        swaps[_addr] = true;
        EventSaveSwap(true);
    }

    function makeVoucher(address _toAddr,uint256 _amount) internal returns (bytes32 voucher){
        string memory tempString = new string(64);
        bytes memory tempBytes = bytes(tempString);
        uint k = 0;
        for (uint i = 0; i < 32; i++) tempBytes[k++] = bytes32(_toAddr)[i];
        for (i = 0; i < 32; i++) tempBytes[k++] = bytes32(_amount)[i];
        voucher = keccak256(tempString);
        vouchers[msg.sender].voucher = voucher;
        vouchers[msg.sender].toAddress = _toAddr;
        vouchers[msg.sender].amount = _amount;
        //vouchers[msg.sender].userd = false;
        vouchers[msg.sender].isFrom = false;
    }

}