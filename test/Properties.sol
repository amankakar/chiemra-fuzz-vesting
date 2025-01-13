// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {SecondSwap_StepVesting} from "../src/SecondSwap_StepVesting.sol";
import {SecondSwap_VestingDeployer} from "../src/SecondSwap_VestingDeployer.sol";
import {SecondSwap_VestingManager} from "../src/SecondSwap_VestingManager.sol";
import {TestToken1} from "../src/USDT.sol";


abstract contract Properties is BeforeAfter, Asserts {
    // example property test that gets run after each call in sequence
    function  echidna_vesting_balance() public view returns(bool){
        uint256 amount;
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            if (vested[user] > 0) {
                amount += (vested[user] - claimed[user]);
            }
        }
        assert(token.balanceOf(vesting) == amount);
        return true;
    }
    function  echidna_vesting_total() public view returns(bool){
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            if (vested[user] > 0) {
                uint256 total = SecondSwap_StepVesting(vesting).total(user);
                assert(total == vested[user]);
            }
        }
        return true;

    }

    function  echidna_claimed_balance() public view returns(bool){
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            if (claimed[user] > 0) {
                assert(token.balanceOf(user) == claimed[user]);
            }
        }

        return true;

    }


     function  echidna_avaliable() public view returns(bool){
        for (uint256 i = 0; i < users.length; i++) {
            address user = users[i];
            if (vested[user] > 0) {
                assert(SecondSwap_StepVesting(vesting).available(user) == vested[user] - claimed[user]);
                assert(SecondSwap_StepVesting(vesting).total(user) == vested[user]);
            }
        }
        return true;

    }}