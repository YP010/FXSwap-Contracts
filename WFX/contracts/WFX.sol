// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "./FIP20Upgradable.sol";

contract WFXUpgradable is FIP20Upgradable {

    receive() external payable {
        deposit();
    }

    fallback() external payable {
        deposit();
    }

    function deposit() public payable {
        _mint(_msgSender(), msg.value);
        emit Deposit(_msgSender(), msg.value);
    }

    function withdraw(address payable to, uint256 value) public {
        _burn(_msgSender(), value);
        to.transfer(value);
        emit Withdraw(_msgSender(), to, value);
    }

    event Deposit(address indexed from, uint256 value);
    event Withdraw(address indexed from, address indexed to, uint256 value);

    function initialize(string memory name_, string memory symbol_, uint8 decimals_, address module_) public override {
        super.initialize(name_, symbol_, decimals_, module_);
    }
}