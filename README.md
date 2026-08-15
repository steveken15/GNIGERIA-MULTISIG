# G-Nigeria MultiSig

## Overview

G-Nigeria MultiSig is a blockchain-based token management system built with Solidity.

The project combines an ERC-20 token, role-based access control, blacklist functionality, and a MultiSig wallet mechanism to provide controlled and secure execution of privileged token operations.

The main idea is that sensitive operations on the G-Nigeria token should not be performed by a single wallet. Instead, authorized signers must approve a transaction before the MultiSig contract can execute it.

This project was developed and tested using Remix IDE and Solidity.

---

## Project Objectives

The project was designed to demonstrate:

- ERC-20 token creation and management
- - Role-based access control
  - - Governor-controlled token operations
    - - Address blacklisting
      - - Token minting and burning
        - - Token transfers and approvals
          - - Multi-signature transaction approval
            - - Secure execution of privileged operations
             
              - ---

              ## Architecture

              The project contains two main smart contracts:

              ### 1. G-Nigeria (`G-Nigeria.sol`)

              The G-Nigeria contract is an ERC-20 token contract.

              It uses OpenZeppelin's:

              - ÈRC20
              - 
- ÀccessControl
- 

The contract has two important roles:

### Governor Role

The Governor role is responsible for privileged token-management operations such as:

- Minting tokens
- - Adding addresses to the blacklist
  - - Removing addresses from the blacklist
   
    - ### Default Admin Role
   
    - The deployer receives the `DEFAULT_ADMIN_ROLE`.
   
    - The admin is responsible for managing role permissions through OpenZeppelin's AccessControl system.
   
    - ---

    ## 2. G-Nigeria MultiSig (`G-NigeriaMultisig.sol`)

    The MultiSig contract is designed to prevent a single signer from executing sensitive operations alone.

    Multiple authorized signers are configured when the MultiSig contract is deployed.

    A transaction follows this process:

    ```text
    Submit Transaction

    Signer 1 Approves

    Signer 2 Approves

    Required Approvals Reached

    Execute Transaction

    G-Nigeria Contract Performs Action


    ## Deployed contract addresses for testing

 0xAFB353a10EF4e3707AfC6f8cF4C147341a5aB253
g-nigeria deployed contract address

0x3b814bE3e1c7Cd963c8D46a7f897c3bAeab0A7b0
multisig contract address   


