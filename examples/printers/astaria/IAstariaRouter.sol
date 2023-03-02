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

import {ICollateralToken} from "./ICollateralToken.sol";
import {ILienToken} from "./ILienToken.sol";


interface IAstariaRouter {
  enum FileType {
    FeeTo,
    LiquidationFee,
    ProtocolFee,
    StrategistFee,
    MinEpochLength,
    MaxEpochLength,
    MinInterestRate,
    MaxInterestRate,
    AuctionWindow,
    StrategyValidator,
    Implementation,
    CollateralToken,
    LienToken,
    TransferProxy
  }

  struct File {
    FileType what;
    bytes data;
  }

  struct RouterStorage {
    //slot 1
    uint32 auctionWindow;
    uint32 liquidationFeeNumerator;
    uint32 liquidationFeeDenominator;
    uint32 maxEpochLength;
    uint32 minEpochLength;
    uint32 protocolFeeNumerator;
    uint32 protocolFeeDenominator;
    //slot 2
    ICollateralToken COLLATERAL_TOKEN; //20
    ILienToken LIEN_TOKEN; //20
    ITransferProxy TRANSFER_PROXY; //20
    address feeTo; //20
    address BEACON_PROXY_IMPLEMENTATION; //20
    uint256 maxInterestRate; //6
    //slot 3 +
    address guardian; //20
    address newGuardian; //20
    mapping(uint8 => address) strategyValidators;
    mapping(uint8 => address) implementations;
    //A strategist can have many deployed vaults
    mapping(address => bool) vaults;
  }

  enum ImplementationType {
    PrivateVault,
    PublicVault,
    WithdrawProxy,
    ClearingHouse
  }

  enum LienRequestType {
    DEACTIVATED,
    UNIQUE,
    COLLECTION,
    UNIV3_LIQUIDITY
  }

  struct StrategyDetailsParam {
    uint8 version;
    uint256 deadline;
    address vault;
  }

  struct MerkleData {
    bytes32 root;
    bytes32[] proof;
  }

  struct NewLienRequest {
    StrategyDetailsParam strategy;
    ILienToken.Stack[] stack;
    bytes nlrDetails;
    MerkleData merkle;
    uint256 amount;
    uint8 v;
    bytes32 r;
    bytes32 s;
  }

  struct Commitment {
    address tokenContract;
    uint256 tokenId;
    NewLienRequest lienRequest;
  }




  enum LienState {
    HEALTHY,
    AUCTION
  }

  enum CollateralStates {
    AUCTION,
    NO_AUCTION,
    NO_DEPOSIT,
    NO_LIENS
  }

  enum CommitmentState {
    INVALID,
    INVALID_RATE,
    INVALID_AMOUNT,
    COLLATERAL_AUCTION,
    COLLATERAL_NO_DEPOSIT
  }

  enum VaultState {
    UNINITIALIZED,
    CORRUPTED,
    CLOSED,
    LIQUIDATED
  }
}
