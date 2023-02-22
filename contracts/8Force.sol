// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {
  /*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/
}

// deploy contract and send some ether
contract SendEthDestructingContract {
  address payable contractAddr = payable(0xBC8f28d5Ff3eFE17053a6B82b3566d13E94A3848);

  constructor() payable {}

  function destructContractToSendEth() external {
    selfdestruct(contractAddr);
  }

  receive() external payable {}
}
