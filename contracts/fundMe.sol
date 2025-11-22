// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import { priceConverter } from './priceConverter.sol';


contract fundeMe {
    
    using priceConverter for uint256;

    uint256 public minimumUsd = 5; 
    
    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmount;
    uint256 public val;

    function fund() public payable {
                
        require( msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH" ); // 1e18 = 1 ETH = 1 * 10 ** 18 wei
        funders.push(msg.sender);
        addressToAmount[msg.sender] = addressToAmount[msg.sender] + msg.value.getConversionRate()/1e16;
    }

    // function withdraw() public {}



}











