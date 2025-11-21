// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract fundeMe {
    
    uint256 public minimumUsd = 5; // same as 5e18
    
    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmount;
    uint256 public val;

    function fund() public payable {
        // allow user to send money
        // have a minimum $ sent

        val = msg.value;
        require( getConversionRate(msg.value/1e18) >= minimumUsd, "didn't send enough ETH" ); // 1e18 = 1 ETH = 1 * 10 ** 18 wei
        funders.push(msg.sender);
        addressToAmount[msg.sender] = addressToAmount[msg.sender] + getConversionRate(msg.value/1e18);
    }

    // function withdraw() public {}

    function getPrice() public view returns (uint256) {
        // address -> 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
        
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        
        uint256 ethPrice = getPrice();
        uint256 ethPriceInUsd = (ethPrice * ethAmount)/1e18;
        return ethPriceInUsd;
    }


}











