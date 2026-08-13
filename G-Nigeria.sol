// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


contract GNigeria is ERC20, AccessControl {
   //Roles
  bytes32 public constant GOVERNOR_ROLE = keccak256("GOVERNOR_ROLE");

// Constructor
constructor() ERC20("G-Naira", "gNGN") {
  
  // The account deploying the contract becomes the first governor
    _grantRole(GOVERNOR_ROLE, msg.sender);

    // The deployer also becomes the administrator of the AccessControl system
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
}


  //stores whether an address is blacklisted
  mapping(address => bool) private _blacklisted;

  //Events
  event AddressBlacklisted(address indexed account);
  event AddressUnBlacklisted(address indexed acount);

  // Mint token (G-Naira, gNGN)
 /**
 * @dev Creates new gNGN tokens.
 *
 *only an account with GOVERNOR_ROLE
 *can call this function.
 */

 function mint(
  address to, uint256 amount
 )
  external onlyRole(GOVERNOR_ROLE) {
    require(
      to != address(0), "cannot mint to zero address"
 );
    
    require(
      !_blacklisted[to], "Receipt is blacklisted"
    );
    _mint(to, amount);
  }


  //BURN token (G-Naira, gNGN)
  /**
  *@dev Destroys gNGN tokens from an address.
  *
  *Only an account with GOVERNOR_ROLE
  *can call this function.
  */

  function burn(
    address from, uint256 amount
  )
  external onlyRole(GOVERNOR_ROLE) {
    require(
      from != address(0), "Cannot burn fom zero address"
    );
    _burn(from, amount);
  }



  //BLACKLIST
  /**
  *@dev Adds an address to the blacklist.
  *
  *Only the GOVERNOR can blacklist an address.
  */

  function addtoBlacklist(
    address account
  )
  external onlyRole(GOVERNOR_ROLE) {
    require(
      account != address(0), "Invalid address"
    );
    _blacklisted[account] = true;
    emit AddressBlacklisted(account);
  }



  //CHECK BLACKLIST STATUS
  /**
  *@dev Returns true if an address is blacklisted.
  */

function isBlacklisted(
  address account
)
external view returns (bool) {
  return _blacklisted[account];
}



//TRANSFER PROTECTION
/**
*@dev prevents blacklisted addresses from
*sending or receiving gNGN.
*
*OpenZeppelin ERC20 uses _update() for
*transfer, minting and burning.
*/

function _update(
  address from, address to, uint256 amount
)
internal override {
  //if this is not a mint, check whether the sender is blacklisted.
    if (to != address(0)) {
      require(
        !_blacklisted[to], "Receiver is blacklisted"
      );
    }
   //Execute the normal ERC20 update.
   super._update(from, to, amount);
}
}