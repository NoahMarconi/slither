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


import {ITransferProxy} from "./ITransferProxy.sol";
import {IAstariaRouter} from "./IAstariaRouter.sol";
import {ILienToken} from "./ILienToken.sol";


import {IClearingHouse} from "./IClearingHouse.sol";

interface ConsiderationInterface {}
interface ConduitControllerInterface {}
interface ICollateralToken{

  struct Asset {
    bool deposited;
    address clearingHouse;
    address tokenContract;
    uint256 tokenId;
    bytes32 auctionHash;
  }

  struct CollateralStorage {
    ITransferProxy TRANSFER_PROXY;
    ILienToken LIEN_TOKEN;
    IAstariaRouter ASTARIA_ROUTER;
    ConsiderationInterface SEAPORT;
    ConduitControllerInterface CONDUIT_CONTROLLER;
    address CONDUIT;
    bytes32 CONDUIT_KEY;
    mapping(uint256 => bytes32) collateralIdToAuction;
    mapping(address => bool) flashEnabled;
    //mapping of the collateralToken ID and its underlying asset
    mapping(uint256 => Asset) idToUnderlying;
    //mapping of a security token hook for an nft's token contract address
    mapping(address => address) securityHooks;
  }

  struct ListUnderlyingForSaleParams {
    ILienToken.Stack[] stack;
    uint256 listPrice;
    uint56 maxDuration;
  }

  enum FileType {
    NotSupported,
    AstariaRouter,
    SecurityHook,
    FlashEnabled,
    Seaport
  }

  struct File {
    FileType what;
    bytes data;
  }

  struct AuctionVaultParams {
    address settlementToken;
    uint256 collateralId;
    uint256 maxDuration;
    uint256 startingPrice;
    uint256 endingPrice;
  }

  enum InvalidCollateralStates {
    NO_AUTHORITY,
    NO_AUCTION,
    FLASH_DISABLED,
    AUCTION_ACTIVE,
    INVALID_AUCTION_PARAMS,
    ACTIVE_LIENS
  }

}
