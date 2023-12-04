// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MagicNum {
  address public solver;

  constructor() {}

  function setSolver(address _solver) public {
    solver = _solver;
  }

  /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}

contract MySolver {
  constructor() {
    assembly {
      /**
    

        // store 42 on memory
       0x60 PUSH1 2a  (602a)   2a = 42 push the value 
       0x60 PUSH1 0   (6000)   push the memory offset (any value can be setted)
       0x52 MSTORE    (52)     pop offset and value from the stack

       // return the value in memory
       0x60 PUSH1 20   (6020)  20 = 32 the value size, a memory slot 32 bytes
       0x60 PUSH1 0    (6000)  push the memory offset (the position when the value was stored)
       0xf3 RETURN     (f3)    pop the offset and the size from stack

        602a60005260206000f3  lenght 10 = 0a
        offset 22 = 16

    */

      mstore(0, 0x602a60005260206000f3)
      return(0x16, 0x0a)
    }
  }
}
