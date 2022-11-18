KEY="l1"
CHAINID="loyal-t1"
MONIKER="localloyal"
KEYALGO="secp256k1"
KEYRING="test"
LOGLEVEL="info"
TRACE="" # "--trace"
BINARY="loyald"
CHAIN_HOME=".loyal" # DO NOT LEAVE THIS BLANK

$BINARY config keyring-backend $KEYRING
$BINARY config chain-id $CHAINID
$BINARY config output "json"

command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }

# if CHAIN_HOME is empty, exit
if [ -z "$CHAIN_HOME" ]; then
  echo "CHAIN_HOME is empty. Please set it to the location of your chain's home directory."
  exit 1
fi

from_scratch () {

    make install

    # remove existing daemon
    rm -rf ~/$CHAIN_HOME/* 

    echo "decorate bright ozone fork gallery riot bus exhaust worth way bone indoor calm squirrel merry zero scheme cotton until shop any excess stage laundry" | $BINARY keys add $KEY --keyring-backend $KEYRING --algo $KEYALGO --recover

    $BINARY init $MONIKER --chain-id $CHAINID 

    # Function updates the config based on a jq argument as a string
    update_test_genesis () {
    # update_test_genesis '.consensus_params["block"]["max_gas"]="100000000"'
        cat $HOME/$CHAIN_HOME/config/genesis.json | jq "$1" > $HOME/$CHAIN_HOME/config/tmp_genesis.json && mv $HOME/$CHAIN_HOME/config/tmp_genesis.json $HOME/$CHAIN_HOME/config/genesis.json
    }

    update_test_genesis '.consensus_params["block"]["max_gas"]="100000000"'
    update_test_genesis '.app_state["gov"]["voting_params"]["voting_period"]="15s"'

    update_test_genesis '.app_state["staking"]["params"]["bond_denom"]="ulyl"'
    # update_test_genesis '.app_state["bank"]["params"]["send_enabled"]=[{"denom": "ulyl","enabled": false}]'
    # update_test_genesis '.app_state["staking"]["params"]["min_commission_rate"]="0.05000000000000000"'    

    update_test_genesis '.app_state["mint"]["params"]["mint_denom"]="ulyl"'  
    update_test_genesis '.app_state["gov"]["deposit_params"]["min_deposit"]=[{"denom": "ulyl","amount": "1000000"}]' # 1 eve right now
    update_test_genesis '.app_state["crisis"]["constant_fee"]={"denom": "ulyl","amount": "1000"}'  

    $BINARY add-genesis-account $KEY 10000000ulyl --keyring-backend $KEYRING
    $BINARY gentx $KEY 1000000ulyl --keyring-backend $KEYRING --chain-id $CHAINID

    $BINARY collect-gentxs
    
    $BINARY validate-genesis
}

from_scratch

# Opens the RPC endpoint to outside connections
sed -i '/laddr = "tcp:\/\/127.0.0.1:26657"/c\laddr = "tcp:\/\/0.0.0.0:26657"' ~/.$BINARY/config/config.toml
sed -i 's/cors_allowed_origins = \[\]/cors_allowed_origins = \["\*"\]/g' ~/.$BINARY/config/config.toml

$BINARY start --pruning=nothing  --minimum-gas-prices=0ulyl