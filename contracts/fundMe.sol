// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract fundeMe {
    
    uint256 public minimumUsd = 5;

    function fund() public payable {
        // allow user to send money
        // have a minimum $ sent

        require(msg.value > minimumUsd, "didn't send enough ETH" ); // 1e18 = 1 ETH = 1 * 10 ** 18
        

    }

    // function withdraw() public {}


}











