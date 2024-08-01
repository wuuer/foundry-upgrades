// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract Upgrade is Script {
    address erc1967ProxyAddress = makeAddr("proxy"); // change this to the latest proxy address deployed !!

    function run() external returns (address) {
        vm.startBroadcast();
        BoxV2 box = new BoxV2();
        address proxy = upgradeBox(erc1967ProxyAddress, address(box));
        vm.stopBroadcast();
        return proxy;
    }

    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(proxyAddress);
        proxy.upgradeToAndCall(newBox, ""); // proxy contract now points to this new address
        vm.stopBroadcast();
        return address(proxy);
    }
}
