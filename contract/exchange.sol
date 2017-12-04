pragma solidity ^0.4.11;

contract Exchange {
    address public owner;
    struct Voucher {
        bool used;
        bool isFrom;
    }
    //mapping(address => mapping(bytes32 => Voucher)) public vouchers;
    mapping(bytes32 => Voucher) public vouchers;
    mapping(address => bool) public swaps;

    event EventDestroyToken(address _toAddr,bytes32 _voucher,uint256 _amount);
    event EventSaveSwap(bool success);
    event EventSaveVoucher(bool success);
    event EventGetToken(bool success);

    function Exchange() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner)
            revert();
        _;
    }

    function destroyToken(address _toAddr,uint256 _amount) external {
        //destroy token done
        voucher = makeVoucher(_toAddr,_amount);
        vouchers[voucher].used = false;
        vouchers[voucher].isFrom = false;
        EventDestroyToken(_toAddr,voucher,_amount);
    }

    function getToken(uint256 _amount) external returns (bool success) {
        bytes32 memory voucher = makeVoucher(msg.sender,_amount);
        require(
            vouchers[voucher].isFrom == true &&
            vouchers[voucher].used == false
            );
        vouchers[voucher].used = true;
        //issue token done
        success = true;
        EventGetToken(true);
    }

    function saveVoucher(address _toAddr,bytes32 _voucher) external {
        require(swaps[msg.sender]);
        vouchers[_voucher].used = false;
        vouchers[_voucher].isFrom = true;
        EventSaveVoucher(true);
    }

    function saveSwap(address _addr,bool alive) onlyOwner external {
        swaps[_addr] = alive;
        EventSaveSwap(true);
    }

    function makeVoucher(address _toAddr,uint256 _amount) internal returns (bytes32 voucher) {
        string memory tempString = new string(64);
        bytes memory tempBytes = bytes(tempString);
        uint k = 0;
        for (uint i = 0; i < 32; i++) tempBytes[k++] = bytes32(_toAddr)[i];
        for (i = 0; i < 32; i++) tempBytes[k++] = bytes32(_amount)[i];
        voucher = keccak256(tempString);
    }

}