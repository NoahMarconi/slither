pragma solidity ^0.8.0;

import { IStructsChild } from "./IStructsChild.sol";

contract Structs {

    struct Parent {
        address addy;
        uint256 num;
        IStructsChild.Child child;
    }

    function passThrough(Parent calldata parent) public returns (address) {
        return parent.addy;
    }
}
