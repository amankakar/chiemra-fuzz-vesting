// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import {SecondSwap_StepVesting} from "../src/SecondSwap_StepVesting.sol";
import {SecondSwap_VestingDeployer} from "../src/SecondSwap_VestingDeployer.sol";
import {SecondSwap_VestingManager} from "../src/SecondSwap_VestingManager.sol";
import {TestToken1} from "../src/USDT.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract Setup is BaseSetup {
    address admin = address(0x23457643);
    address[] public users;

    SecondSwap_VestingManager vestingManager;
    SecondSwap_VestingDeployer vestingDeployer;
    TestToken1 token;
    address vesting;

    // ghost mapping
    mapping(address => uint256) public vested;
    mapping(address => uint256) public claimed;

    function setup() internal virtual override {
        users.push(address(0x1));
        users.push(address(0x2));
        users.push(address(0x3));

        vm.prank(admin);
        token = new TestToken1();
        token.mint(admin, 10000000000000000 ether);
        vm.prank(admin);
        vestingManager = new SecondSwap_VestingManager();
        vm.prank(admin);
        vestingManager.initialize(admin);
        vm.prank(admin);
        vestingDeployer = new SecondSwap_VestingDeployer();
        vm.prank(admin);
        vestingDeployer.initialize(admin, address(vestingManager));
        vm.prank(admin);
        vestingDeployer.setTokenOwner(address(token), admin);
        vm.prank(admin);
        vestingManager.setVestingDeployer(address(vestingDeployer));
        vm.prank(admin);
        vesting = vestingDeployer.deployVesting(
            address(token),
            block.timestamp,
            block.timestamp + 365 days,
            12,
            "myVestingId"
        );
    }
}