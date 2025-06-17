//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol"; // foundry test kütüphanesi
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe; // kontratı yeniden oluşturuyor ediyor gibi

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant START_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    // ilk önce setUp çalışır
    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // yeniden test için deploy etmiyeceğiz normal deploy ettiğimizi kullanacağız
        vm.deal(USER, START_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18); // 5 dolara eşit mi
    }

    function testOwnerIsMsgSender() public view {
        console.log(fundMe.getOwner()); // fundme kontratını deploy eden adress
        console.log(msg.sender); // şuan test için gönderene address
        // assertEq(fundMe.i_owner(), address(this)); // fundme kontratı test için burada deploy edildi
        // o yüzden bu address

        // artık deploy edilen kontratı kullandığımız için
        assertEq(fundMe.getOwner(), msg.sender); // burası doğru olur
    }

    function testPriceFeedVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function test_FundMeFailsWithoutETH() public {
        vm.expectRevert(); // kesinlikle geri dönüş olacak
        fundMe.fund(); // fund fonk. için değer göndermek gerek fakat döndermedik geri dönecek
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderFundToArrayOfFunders() public {
        vm.prank(USER); // BU ADDRESLE KONT. ÇALIŞTIRMa
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        // sadece user ile addrese para atacak
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        //ARRANGE - TEST İÇİN HAZIRLIK DÜZENLEME
        uint256 startOwnerBalance = fundMe.getOwner().balance;
        uint256 startFundMeBalance = address(fundMe).balance;

        //ACT - EYLEMİ GERÇEKLEŞTİRME
        uint256 gasStart = gasleft(); // sol. özlü ne kadar gas kaldığını hesaplıyor
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice; // o anlık gas ücreti
        console.log(gasUsed);
        //ASSERT - DOĞRULAMA
        uint256 endOwnerBalance = fundMe.getOwner().balance;
        uint256 endFundMeBalance = address(fundMe).balance;
        assertEq(endFundMeBalance, 0);
        assertEq(startOwnerBalance + startFundMeBalance, endOwnerBalance);
    }

    function testWithdrawWithAMultiFunder() public {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1; // index ilerlemesi

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE); // address oluşturup para yükleme
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }
}
