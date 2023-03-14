// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./MorphFactory.sol";

contract DeployMorph is MorphFactory {
    constructor() {
        // function kill(address toAddr) external { selfdestruct(payable(toAddr)); }
        implementation = hex"6080604052348015600f57600080fd5b506004361060285760003560e01c8063cbf0b0c014602d575b600080fd5b603c6038366004604a565b603e565b005b806001600160a01b0316ff5b600060208284031215605b57600080fd5b81356001600160a01b0381168114607157600080fd5b939250505056fea2646970667358221220fa74903010d5696d23a03f1d53caf4b0d16c7b46c51cefce36cb93d1cb60182364736f6c63430008050033";
    }
}
