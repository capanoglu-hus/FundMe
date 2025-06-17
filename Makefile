-include .env 
build:; forge build

test-sepolia:; forge test --fork-url $(SEPOLIA_RPC_URL)

test-anvil:; forge test --fork-url $(ANVIL_RPC_URL)

deploy-sepolia:; forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --broadcast --verify

storege:; forge inspect FundMe storageLayout


