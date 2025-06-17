# **FUND ME FOUNDRY  -  CYFRİN UPDRAFT**



https://updraft.cyfrin.io/courses/foundry




#### ➤ *forge script* "..." *--rpc-url* "SEPOLIA_RPC_URL" *--private-key* "0x..." *--broadcast*


used to deploy the contract


#### ➤ *forge test --fork-url "SEPOLIA_RPC_URL"*


used for test contracts


#### ➤ *forge test --match-test "..." -vvv*


used to test specific test functions and view their details


#### ➤ *forge coverage*


used to find out what percentage of all contracts have been tested


#### ➤  *forge snapshot*


used to learn about gas usage in the contract


#### ➤  *forge inspect* "..." *storageLayout*  


used to find out how much space certain functions take up in storage
        
       




## **CheatCodes** 




#### ➥ vm.exceptRevert()


When testing, it deliberately returns an error as if it had found a bug in the contract.


#### ➥ vm.prank()


creating a fake address and deploying it with that address


#### ➥ makeAddr()


creates a fake user-dependent address


#### ➥ vm.deal(user, amount)


assigning fake money to the user address


#### ➥ hoax(address, amount) 


sending fake money to an address


#### ➥ chisel 


You write the Solidity code in the terminal


#### ➥ vm.txGasPrice()


transaction determines gas price


#### ➥ gasLeft()


measuring the remaining gas







## TEST RESULT



