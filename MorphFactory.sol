// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

interface INTERFACE {
    function kill(address) external;
}

contract MorphFactory {
    // Morph Initialization code breakdown
    /** Opcodes                                     Stack state
     *
     * comment: 0x0000000e - function sig of `callback19F236F3()`
     *   63 0000000e (PUSH4 0x0000000e)              [0x0000000e]
     *   60 00       (PUSH1 0x00)                    [0x00, 0x0000000e]
     *   52          (MSTORE)                        []
     *
     * comment: staticcall(gas, address, in, insize, out, outsize)
     *   60 00       (PUSH1 0x00)                    [0x00]
     *   60 00       (PUSH1 0x00)                    [0x00, 0x00]
     *   60 04       (PUSH1 0x04)                    [0x04, 0x00, 0x00]
     *   60 1c       (PUSH1 0x1c)                    [0x1c, 0x04, 0x00, 0x00]
     *   33          (CALLER)                        [msg.sender, 0x1c, 0x04, 0x00, 0x00]
     *   5a          (GAS)                           [gasleft, msg.sender, 0x1c, 0x04, 0x00, 0x00]
     *   fa          (STATICCALL)                    []
     *
     * comment: copies the return data to memory
     *   3d          (RETURNDATASIZE)                [returndatasize]
     *   60 00       (PUSH1 0x00)                    [0x00, returndatasize]
     *   60 00       (PUSH1 0x00)                    [0x00, 0x00, returndatasize]
     *   3e          (RETURNDATACOPY)                []
     *
     * comment: length of runtime code alone
     *   60 20       (PUSH1 0x20)                    [0x20]
     *   51          (MLOAD)                         [returndata_length]
     *   60 40       (PUSH1 0x40)                    [0x40, returndata_length]
     *   f3          (RETURN)                        []
     */

    bytes private constant morphInitCode =
        hex"630000000e600052600060006004601c335afa3d600060003e6020516040f3";

    // stores the runtime code
    bytes implementation;

    // Creates a Morph contract passing a random salt as argument
    function deploy(uint256 _salt) external returns (address addr) {
        bytes memory _morphInitCode = morphInitCode;
        assembly {
            // `0x00` - value in wei to send to the newly created morph contract
            // `0xa0-0x1f` - reads the content (Morph Initialization Code) from memory `0xa0` to 0x1f
            // `_salt` - 32-bytes value used to create the new account at a deterministic address
            addr := create2(0x00, 0xa0, 0x1f, _salt)

            // reverts if addr == address(0)
            if iszero(addr) {
                revert(0x00, 0x00)
            }
        }
    }

    // returns the runtime code that is stored in `implementation` variable
    // it is called in the morph Initialization Code
    function callback19F236F3() external view returns (bytes memory) {
        return implementation;
    }

    // stores a new runtime code in `implementation` variable
    function changeImpl(bytes memory impl) external {
        implementation = impl;
    }

    // predicts the address of the morph contract to be deployed
    function getAddressOfMorph(
        uint256 _salt
    ) public view returns (address addy) {
        addy = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            _salt,
                            keccak256(morphInitCode)
                        )
                    )
                )
            )
        );
    }

    // calls the function `kill(address)` in the morph contract address that is passed as argument
    function destroy(address morphContractAddr) external {
        // self-destruct morph contract
        INTERFACE(morphContractAddr).kill(msg.sender);
    }

    // returns the runtime code of the contract passed as argument
    function getRuntimeCode(address x) external view returns (bytes memory) {
        return x.code;
    }
}
