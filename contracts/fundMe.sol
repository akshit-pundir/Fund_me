// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {priceConverter} from "./priceConverter.sol";

contract fundeMe {
    using priceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmount;

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minimumUsd,
            "didn't send enough ETH"
        );                                            // 1e18 = 1 ETH = 1 * 10 ** 18 wei
        funders.push(msg.sender);
        addressToAmount[msg.sender] =
            addressToAmount[msg.sender] + msg.value.getConversionRate() / 1e16;
    }

    function withdraw() public onlyOwner {


        for (uint256 funderIdx = 0; funderIdx < funders.length; funderIdx++) {
            address funderAddress = funders[funderIdx];
            addressToAmount[funderAddress] = 0;
        }

        funders = new address[](0);
        // there are 3 ways to withdraw the funds
        /* 
           1. transfer
           2. send 
           3. call
        */
       
        /*
            payable(msg.sender).transfer(address(this).balance); //transfer

            bool sendSuccess = payable(msg.sender).send(address(this).balance); //send
            require(sendSuccess, "Send Failed");
        */

        (bool callSuccess, ) = payable(msg.sender).call {
            value: address(this).balance
        }("");                                                //call  ## mostly used
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner(){
        require(msg.sender == owner,"Unauthorized! you can't withraw the funds");
        _;
    }

}
