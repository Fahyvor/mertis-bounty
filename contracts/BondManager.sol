// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/* Interface Imports */
import { IBondManager } from "./IBondManager.sol";

/* Contract Imports */
import { Lib_AddressResolver } from "./Lib_AddressResolver.sol";

/**
 * @title BondManager
 * @dev This contract allows the "OVM_Proposer" to submit state root batches and 
 * includes functionality restricted to the contract owner.
 *
 * Runtime target: EVM
 */
contract BondManager is IBondManager, Lib_AddressResolver {
    // State variable to store the contract owner
    address public owner;

    /**
     * @param _libAddressManager Address of the Address Manager.
     */
    constructor(address _libAddressManager) Lib_AddressResolver(_libAddressManager) {
        owner = msg.sender; // Set the deployer as the initial owner
    }

    // Modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "BondManager: caller is not the owner");
        _;
    }

    // Function to transfer ownership to a new address (only callable by the owner)
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "BondManager: new owner is the zero address");
        owner = newOwner;
    }

    /**
     * Checks whether a given address is properly collateralized and can perform actions within
     * the system.
     * @param _who Address to check.
     * @return true if the address is properly collateralized, false otherwise.
     */
    function isCollateralized(address _who) public view returns (bool) {
        // Only authenticate sequencer to submit state root batches.
        return _who == resolve("OVM_Proposer");
    }

    /**
     * Checks whether an address is collateralized by chain ID.
     * Restricted to onlyOwner to prevent unauthorized access.
     * @param _chainId Chain ID to check.
     * @param _who Address to check.
     * @param _prop Proposer's address.
     * @return true if the address is collateralized.
     */
    function isCollateralizedByChainId(
        uint256 _chainId,
        address _who,
        address _prop
    ) override public view onlyOwner returns (bool) {
        require(_who == _prop, "BondManager: sender must be the proposer");
        return true;
    }

    /**
     * Registers a sequencer by chain ID.
     * Restricted to onlyOwner to prevent unauthorized access.
     * @param _chainId Chain ID to register.
     * @param _sequencer Sequencer's address.
     * @param _proposer Proposer's address.
     */
    function registerSequencerByChainId(
        uint256 _chainId,
        address _sequencer,
        address _proposer
    ) public onlyOwner {
        
    }
}
