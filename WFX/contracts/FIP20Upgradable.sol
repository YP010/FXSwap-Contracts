// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./interface/IFIP20Upgradable.sol";


contract FIP20Upgradable is Initializable, ContextUpgradeable, UUPSUpgradeable, OwnableUpgradeable, IFIP20Upgradable, IFIP20MetadataUpgradeable {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balanceOf;
    mapping(address => mapping(address => uint256)) private _allowance;

    address private _module;

    function name() external view override returns (string memory){
        return _name;
    }

    function symbol() external view override returns (string memory){
        return _symbol;
    }

    function decimals() external view override returns (uint8){
        return _decimals;
    }

    function totalSupply() external view override returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256){
        return _balanceOf[account];
    }

    function allowance(address owner, address spender) external view override returns (uint256){
        return _allowance[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        uint256 currentAllowance = _allowance[sender][_msgSender()];
        require(currentAllowance >= amount, "transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);
        _transfer(sender, recipient, amount);
        return true;
    }

    function transferCrossChain(string memory recipient, uint256 amount, uint256 fee, bytes32 target) external override notContract returns (bool) {
        _transferCrossChain(_msgSender(), recipient, amount, fee, target);
        return true;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }

    function module() external view returns (address){
        return _module;
    }

    modifier notContract(){
        require(!_isContract(_msgSender()), "caller cannot be contract");
        _;
    }

    function _isContract(address _addr) internal view returns (bool){
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "transfer from the zero address");
        require(recipient != address(0), "transfer to the zero address");
        uint256 senderBalance = _balanceOf[sender];
        require(senderBalance >= amount, "transfer amount exceeds balance");
        _balanceOf[sender] = senderBalance - amount;
        _balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "mint to the zero address");
        _totalSupply += amount;
        _balanceOf[account] += amount;

        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "burn from the zero address");
        uint256 accountBalance = _balanceOf[account];
        require(accountBalance >= amount, "burn amount exceeds balance");
        _balanceOf[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(address sender, address spender, uint256 amount) internal {
        require(sender != address(0), "approve from the zero address");
        _allowance[sender][spender] = amount;
    }

    function _transferCrossChain(address sender, string memory recipient, uint256 amount, uint256 fee, bytes32 target) internal {
        require(sender != address(0), "transfer from the zero address");
        require(bytes(recipient).length > 0, "invalid recipient");
        require(target != bytes32(0), "invalid target");

        _transfer(sender, _module, amount + fee);
        emit TransferCrossChain(sender, recipient, amount, fee, target);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function initialize(string memory name_, string memory symbol_, uint8 decimals_, address module_) public virtual initializer {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _module = module_;

        __Ownable_init();
        __UUPSUpgradeable_init();
    }
}