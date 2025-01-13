// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import "forge-std/console2.sol";

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();

        targetContract(address(this));

        // handler functions to target during invariant tests
      bytes4[] memory selectors = new bytes4[](3);
      selectors[0] = this.create_vesting.selector;
      selectors[1] = this.claim_vested_token.selector;
      selectors[2] = this.reallocate_vested_token.selector;

      targetSelector(FuzzSelector({ addr: address(this), selectors: selectors }));
    }

    function invariant_vesting_balance() public {
        assertTrue(echidna_vesting_balance());
    }
    function invariant_vesting_total() public {
        assertTrue(echidna_vesting_total());
    }
    function invariant_claimed_balance() public {
        assertTrue(echidna_claimed_balance());
    }

    function invariant_avaliable() public {
        assertTrue(echidna_avaliable());
    }
}
