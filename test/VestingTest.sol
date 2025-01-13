// // SPDX-License-Identifier: Apache

// pragma solidity ^0.8.24;

// import {SecondSwap_StepVesting} from "../src/SecondSwap_StepVesting.sol";
// import {SecondSwap_VestingDeployer} from "../src/SecondSwap_VestingDeployer.sol";
// import {SecondSwap_VestingManager} from "../src/SecondSwap_VestingManager.sol";
// import {TestToken1} from "../src/USDT.sol";
// import "@crytic/properties/contracts/util/Hevm.sol";
// import {CryticAsserts} from "@chimera/CryticAsserts.sol";

// contract VestingTest {
//     address admin = address(0x23457643);
//     address[] public users;

//     SecondSwap_VestingManager vestingManager;
//     SecondSwap_VestingDeployer vestingDeployer;
//     TestToken1 token;
//     address vesting;

//     // ghost mapping
//     mapping(address => uint256) public vested;
//     mapping(address => uint256) public claimed;
//     constructor() {
//         users.push(address(0x1));
//         users.push(address(0x2));
//         users.push(address(0x3));

//         hevm.prank(admin);
//         token = new TestToken1();
//         token.mint(admin, 10000000000000000 ether);
//         hevm.prank(admin);
//         vestingManager = new SecondSwap_VestingManager();
//         hevm.prank(admin);
//         vestingManager.initialize(admin);
//         hevm.prank(admin);
//         vestingDeployer = new SecondSwap_VestingDeployer();
//         hevm.prank(admin);
//         vestingDeployer.initialize(admin, address(vestingManager));
//         hevm.prank(admin);
//         vestingDeployer.setTokenOwner(address(token), admin);
//         hevm.prank(admin);
//         vestingManager.setVestingDeployer(address(vestingDeployer));
//         hevm.prank(admin);
//         vesting = vestingDeployer.deployVesting(
//             address(token),
//             block.timestamp,
//             block.timestamp + 365 days,
//             12,
//             "myVestingId"
//         );

//     }

//     function create_vesting(uint256 userIndex, uint256 amount) public {
//         hevm.assume(userIndex < users.length);
//         address user = users[userIndex];
//         hevm.assume(amount <= token.balanceOf(admin));

//         hevm.prank(admin);
//         token.approve(vesting, amount);

//         hevm.prank(admin);
//         vestingDeployer.createVesting(user, amount, vesting);

//         vested[user] += amount;

//     }

//     function claim_vested_token(uint256 userIndex, uint16 _days) public {
//         hevm.assume(userIndex < users.length);
//         address user = users[userIndex];
//         // increase time
//         hevm.warp(block.timestamp + _days);

//         (uint256 claimableAmount, ) = SecondSwap_StepVesting(vesting).claimable(
//             user
//         );

//         hevm.prank(user);
//         SecondSwap_StepVesting(vesting).claim();

//         claimed[user] += claimableAmount;
//     }
  

//     function reallocate_vested_token(uint8 userIndex,uint8 userIndex2,uint256 amount) public {
//         hevm.assume(userIndex < users.length);
//         address user = users[userIndex];

//         uint256 total =  vested[user] - claimed[user]; 
//         hevm.assume(amount < total);

//         hevm.assume(userIndex2 < users.length);
//         address user2 = users[userIndex2];
        
//         hevm.prank(admin);
//         vestingDeployer.transferVesting(user,user2,amount,vesting,"myVestingId");
        
//         vested[user2] += amount;
//         vested[user] -= amount;
//     }

//     function echidna_vesting_balance() public view returns(bool){

//         uint256 amount;
//         for (uint256 i = 0; i < users.length; i++) {
//             address user = users[i];
//             if (vested[user] > 0) {
//                 amount += (vested[user] - claimed[user]);
//             }
//         }
//         assert(token.balanceOf(vesting) == amount);
//         return true;
//     }
//     function echidna_vesting_total() public view returns(bool){
//         for (uint256 i = 0; i < users.length; i++) {
//             address user = users[i];
//             if (vested[user] > 0) {
//                 uint256 total = SecondSwap_StepVesting(vesting).total(user);
//                 assert(total == vested[user]);
//             }
//         }

//                 return true;

//     }

//     function echidna_claimed_balance() public view returns(bool){
//         for (uint256 i = 0; i < users.length; i++) {
//             address user = users[i];
//             if (claimed[user] > 0) {
//                 assert(token.balanceOf(user) == claimed[user]);
//             }
//         }

//                 return true;

//     }


//      function echidna_avaliable() public view returns(bool){
//         for (uint256 i = 0; i < users.length; i++) {
//             address user = users[i];
//             if (vested[user] > 0) {
//                 assert(SecondSwap_StepVesting(vesting).available(user) == vested[user] - claimed[user]);
//                 assert(SecondSwap_StepVesting(vesting).total(user) == vested[user]);
//             }
//         }
//                 return true;

//     }
// }
