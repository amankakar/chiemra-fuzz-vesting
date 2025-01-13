// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";
import {SecondSwap_StepVesting} from "../src/SecondSwap_StepVesting.sol";
import {SecondSwap_VestingDeployer} from "../src/SecondSwap_VestingDeployer.sol";
import {SecondSwap_VestingManager} from "../src/SecondSwap_VestingManager.sol";
import {TestToken1} from "../src/USDT.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties {
    function create_vesting(uint256 userIndex, uint256 amount) public {
        if (userIndex > users.length) {
            userIndex = clampLte(0, users.length);
        }
        address user = users[userIndex];
        if(amount > token.balanceOf(admin)){
            amount = clampLte(100 ether,1e18);
        }

        vm.prank(admin);
        token.approve(vesting, amount);

        vm.prank(admin);
        vestingDeployer.createVesting(user, amount, vesting);

        vested[user] += amount;
        // vm.warp(block.timestamp + 100 days);
    }

    function claim_vested_token(uint256 userIndex, uint16 _days) public {
        if (userIndex > users.length) {
            userIndex = clampLte(users.length,0);
        }
        address user = users[userIndex];
        // increase time
        vm.warp(block.timestamp + _days);

        (uint256 claimableAmount, ) = SecondSwap_StepVesting(vesting).claimable(
            user
        );

        vm.prank(user);
        SecondSwap_StepVesting(vesting).claim();

        claimed[user] += claimableAmount;
    }

    function reallocate_vested_token(
        uint8 userIndex,
        uint8 userIndex2,
        uint256 amount
    ) public {
        if (userIndex > users.length) {
            userIndex = clampLte(0, users.length);
        }
        address user = users[userIndex];

        uint256 total = vested[user] - claimed[user];
        if(amount > total){
            amount = clampLte(total,1);

            // amount = total;
        }

        if (userIndex2 > users.length) {
        userIndex2 = clampLte(0, users.length);
        }
        address user2 = users[userIndex2];

        vm.prank(admin);
        vestingDeployer.transferVesting(
            user,
            user2,
            amount,
            vesting,
            "myVestingId"
        );

        vested[user] -= amount;
        vested[user2] += amount;
    }

    function clampLte(uint256 a, uint256 b) internal returns (uint8) {
        if (!(a <= b)) {
            uint256 value = a % (b + 1);
            return uint8(value);
        }
        return uint8(a);
    }
    //     function clampLte(uint256 a, uint256 b) internal returns (uint256) {
    //     if (!(a <= b)) {
    //         uint256 value = a % (b + 1);
    //         return uint256(value);
    //     }
    //     return uint256(a);
    // }
}
