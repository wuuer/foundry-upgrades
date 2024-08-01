// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {BoxV1} from "../../src/BoxV1.sol";
import {BoxV2} from "../../src/BoxV2.sol";
import {Deploy} from "../../script/Deploy.s.sol";
import {Upgrade} from "../../script/Upgrade.s.sol";

contract DeployAndUpgrade is Test {
    address private owner = makeAddr("owner");
    address private proxy;

    function setUp() external {
        Deploy deploy = new Deploy();
        proxy = deploy.run();
    }

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(1);
    }

    function testUpgrades() public {
        BoxV2 boxv2 = new BoxV2();
        Upgrade upgrade = new Upgrade();
        proxy = upgrade.upgradeBox(proxy, address(boxv2));
        assertEq(2, BoxV2(proxy).version());
    }

    function testNumberPersistedAfterUpgrade() public {
        uint256 number = BoxV1(proxy).getNumber();
        BoxV2 boxv2 = new BoxV2();
        Upgrade upgrade = new Upgrade();
        proxy = upgrade.upgradeBox(proxy, address(boxv2));
        assertEq(number, BoxV2(proxy).getNumber());
    }
}
