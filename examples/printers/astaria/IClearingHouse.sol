// SPDX-License-Identifier: BUSL-1.1

/**
 *  █████╗ ███████╗████████╗ █████╗ ██████╗ ██╗ █████╗
 * ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██║██╔══██╗
 * ███████║███████╗   ██║   ███████║██████╔╝██║███████║
 * ██╔══██║╚════██║   ██║   ██╔══██║██╔══██╗██║██╔══██║
 * ██║  ██║███████║   ██║   ██║  ██║██║  ██║██║██║  ██║
 * ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
 *
 * Astaria Labs, Inc
 */

pragma solidity =0.8.17;


interface IClearingHouse {

  struct AuctionStack {
    uint256 lienId;
    uint256 amountOwed;
    uint40 end;
  }

  struct AuctionData {
    uint256 startAmount;
    uint256 endAmount;
    uint48 startTime;
    uint48 endTime;
    address liquidator;
    address token;
    AuctionStack[] stack;
  }

  struct ClearingHouseStorage {
    AuctionData auctionData;
  }


}
