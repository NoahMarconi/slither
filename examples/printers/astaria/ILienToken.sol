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

import {IAstariaRouter} from "./IAstariaRouter.sol";
import {ICollateralToken} from "./ICollateralToken.sol";
import {ITransferProxy} from "./ITransferProxy.sol";

interface ILienToken {
  enum FileType {
    NotSupported,
    CollateralToken,
    AstariaRouter,
    BuyoutFee,
    BuyoutFeeDurationCap,
    MinInterestBPS,
    MinDurationIncrease
  }

  struct File {
    FileType what;
    bytes data;
  }

  event FileUpdated(FileType what, bytes data);

  struct LienStorage {
    uint8 maxLiens;
    ITransferProxy TRANSFER_PROXY;
    IAstariaRouter ASTARIA_ROUTER;
    ICollateralToken COLLATERAL_TOKEN;
    mapping(uint256 => bytes32) collateralStateHash;
    mapping(uint256 => LienMeta) lienMeta;
    uint32 buyoutFeeNumerator;
    uint32 buyoutFeeDenominator;
    uint32 durationFeeCapNumerator;
    uint32 durationFeeCapDenominator;
    uint32 minDurationIncrease;
    uint32 minInterestBPS;
  }

  struct LienMeta {
    address payee;
    bool atLiquidation;
  }

  struct Details {
    uint256 maxAmount;
    uint256 rate; //rate per second
    uint256 duration;
    uint256 maxPotentialDebt;
    uint256 liquidationInitialAsk;
  }

  struct Lien {
    uint8 collateralType;
    address token; //20
    address vault; //20
    bytes32 strategyRoot; //32
    uint256 collateralId; //32 //contractAddress + tokenId
    Details details; //32 * 5
  }

  struct Point {
    uint256 amount; //11
    uint40 last; //5
    uint40 end; //5
    uint256 lienId; //32
  }

  struct Stack {
    Lien lien;
    Point point;
  }

  struct LienActionEncumber {
    uint256 amount;
    address receiver;
    ILienToken.Lien lien;
    Stack[] stack;
  }

  struct LienActionBuyout {
    bool chargeable;
    uint8 position;
    LienActionEncumber encumber;
  }

  struct BuyoutLienParams {
    uint256 lienSlope;
    uint256 lienEnd;
  }

  enum StackAction {
    CLEAR,
    ADD,
    REMOVE,
    REPLACE
  }

  enum InvalidStates {
    NO_AUTHORITY,
    COLLATERAL_MISMATCH,
    ASSET_MISMATCH,
    NOT_ENOUGH_FUNDS,
    INVALID_LIEN_ID,
    COLLATERAL_AUCTION,
    COLLATERAL_NOT_DEPOSITED,
    LIEN_NO_DEBT,
    EXPIRED_LIEN,
    DEBT_LIMIT,
    MAX_LIENS,
    INVALID_HASH,
    INVALID_LIQUIDATION_INITIAL_ASK,
    INITIAL_ASK_EXCEEDED,
    EMPTY_STATE,
    PUBLIC_VAULT_RECIPIENT,
    COLLATERAL_NOT_LIQUIDATED
  }

}
