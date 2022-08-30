pragma solidity >=0.5.0;

interface IWFX {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(address payable to, uint256 value) external;
}
