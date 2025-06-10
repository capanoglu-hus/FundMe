//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol"; // foundry test kütüphanesi
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe; // kontratı yeniden oluşturuyor ediyor gibi

    // ilk önce setUp çalışır
    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // yeniden test için deploy etmiyeceğiz normal deploy ettiğimizi kullanacağız
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18); // 5 dolara eşit mi
    }

    function testOwnerIsMsgSender() public view {
        console.log(fundMe.i_owner()); // fundme kontratını deploy eden adress
        console.log(msg.sender); // şuan test için gönderene address
        // assertEq(fundMe.i_owner(), address(this)); // fundme kontratı test için burada deploy edildi
        // o yüzden bu address

        // artık deploy edilen kontratı kullandığımız için
        assertEq(fundMe.i_owner(), msg.sender); // burası doğru olur
    }

    function testPriceFeedVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
