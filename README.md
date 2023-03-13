# Metamorphic Contract

A metamorphic contract is a type of smart contract that can change or evolve over time while retaining its original functionality and properties. They are more flexible and adaptable than traditional smart contracts and can be useful in situations where contract requirements are likely to change over time. However, they also present some unique challenges and risks, particularly around security and transparency, and should be carefully evaluated before deployment.

# How to use metemorphic contract template

Make sure to have the runtime code to pass to the `implementation` variable.

### Inherit MorphFactory Contract

Create a contract that inherits `MorphFactory` contract and in the constructor assign a runtime code to `implementation` variable.

Note: The runtime code should also have a function called `kill(address)` that selfdestruct the morph contract. SELFDESTRUCTing a contract and then redeploying different bytecode to the same address is called a metamorphic contract

```solidity
  contract DeployMorph is MorphFactory {
        constructor() {
        // function kill(address toAddr) external { selfdestruct(payable(toAddr)); }
        implementation = hex"6080604052348015600f57600080fd5b506004361060285760003560e01c8063cbf0b0c014602d575b600080fd5b603c6038366004604a565b603e565b005b806001600160a01b0316ff5b600060208284031215605b57600080fd5b81356001600160a01b0381168114607157600080fd5b939250505056fea2646970667358221220fa74903010d5696d23a03f1d53caf4b0d16c7b46c51cefce36cb93d1cb60182364736f6c63430008050033";
        }
   }
```

### Deploy Metamorphic contract

Create the Metamorphic contract by calling the function `deploy(uint256)` and passing any 32-bytes value as argument.

```solidity
  function deploy(uint256 _salt) external returns (address addr) {
        // deploy statements
  }
```

### Get morph address

Call the function `getAddressOfMorph(_salt)` passing the same `salt` used when deploy the morph contract returns the address of the morph contract, you can also predict the address of the morph contract before deploying, just make sure to use the same salt.

```solidity
  function getAddressOfMorph(uint256 _salt) public view returns (address addy) {
        // get address statements
  }
```

### Check runtime code

`getRuntimeCode(address)` function returns the runtime code of the address passed as argument, this can also be used to check if the runtime code returned is equal to the one stored in `implementation` variable.

```solidity
  function getRuntimeCode(address x) external view returns (bytes memory) {
        // get runtime code statements
  }
```

## Now let's change the runtime code of a deployed morph contract

Remember in our runtime code with have a function `kill(address)` that selfdestruct the morph contract, we will be using that because before a different runtime code can be redeployed to the morph contract created earlier, the contract has to be destroyed.

### Selfdestruct morph Contract

Call `destroy(address)` function passing the morph contract address as argument.

```solidity
  function destroy(address morphContractAddr) external {
        // selfdestruct statements
  }
```

### Change runtime code and deploy to same address

We have a new runtime code we want to assign to our previous morph address. Firstly, we update `impletation` variable by calling function `changeImpl(bytes memory)` passing the new runtime code as argument, then we call `deploy(uint256)` function passing the same `_salt` that was used to create the previous morph contract.

```solidity
   function changeImpl(bytes memory impl) external {
        // change implementation statements
   }
```

