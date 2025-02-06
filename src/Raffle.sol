// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

/**
 * @title Raffle Smart Contract
 * @author Salman Izzuddin
 * @notice The Contract is for simulating simple raffle
 * @dev Implementing Chainlink VRF v2.5
 */

contract Raffle {
    error Raffle__SendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval; // the duration of the lottery in seconds
    uint256 private s_lastTimeStamp;
    address payable[] private s_players;

    /* Events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entraceFee, uint256 interval) {
        i_entranceFee = entraceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRafle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    function pickWinner() external {
        if ((block.timestamp - s_lastTimeStamp) > i_interval) {
            revert();
        }
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
    }

    /** Getter Functions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
