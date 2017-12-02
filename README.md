# tokenCrossBlockchain
token Cross Blockchain transaction,use solidity

1.open https://remix.ethereum.org/#version=soljson-v0.4.19+commit.c4cbbb05.js /contract/exchange.sol Ctrl + C ,Ctrl + V;

2.click Create;

3.fill owner address in saveSwap, and click;

4.fill owner address and amount in destroyToken and click to make voucher;

5.fill owner address and voucher in saveVoucher, and click;

6.fill correct amount in getToken, and click;

Flow Description

1.Consumers a call destroyToken on blockchain A to destroy Token, then use makeVoucher (address _toAddr, uint256 _amount) create and throw voucher;

2.owner call saveSwap storage swap_addr on blockchian B;

3.swap receive the voucher, call saveVoucher to store voucher on blockchain B;

4.Consumer b call getToken on blockchian B, enter amount to use makeVoucher (msg.sender,amount) to verify voucher, if it's corret ,Consumer b get the token.
