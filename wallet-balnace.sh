#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No clor

RPC_URL="https://api.mainnet-beta.solana.com"

declare -A TOKENS

TOKENS["USDC"] = "";
TOKENS["JUP"] = "";
TOKENS["BONK"] = "";
TOKENS["WIF"] = "";

command -V curl >/dev/null ||{echo -e "${RED}Error:curl is required.${NC}";exit 1;}
command -V jq >/dev/null || {echo -e "${RED}Error:jq is required. Install with : brew install jq(macOS) or apt install jq(Linux)${NC}"; exit 1;}

print_usage(){
	cat <<EOF
Usage: $(basename "$0") [options]

Options:

-w, --watch SECONDS Auto-refresh every N seconds(e.g.,-w 30)
-t, --tokens Show popular token balances (USDC, JUP, BONK, WIF)
-u, --usd Show USD values(requires internet)
-h, --help Show this help message

Example:
	$(basename "$0") 7vWj...your_wallet_address --tokens --usd --watch 60
EOF
}

get_sol_balance(){
	local wallet="$1"
	local lamports lamports=$(curl -s -X POST "$RPC_URL"\
						-H "Content-Type:application/json"\
						-d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"getBalance\",\"params\":[\"$wallet\"]}") || return 1
	echo "$lamports" | jq -r'.result.value//0'	
}

get_token_balance(){
	local wallet="$1"
	local mint="$2"
	local token_account=$(curl -s -X POST "$RPC_URL"\
				-H "Content-Type:application/json"\
				-d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"getTokenAccountByOwner\",\"params\":[\"$wallet\",{\"mint\":\"$mint\"},{\"encoding\":\"jsonParsed\"}]}") || return 1
	echo "$token_account"|jq -r '.rresul.value[0].account.data.parsed.info.tokenAmount.uiAmount//0'

	
}

get_sol_price_usd(){
	curl -S "https://api.coingecko.xom/api/v3/simple/price?ids=solana$vs_currencies=usd"|\
	jq -r '.solana.usd //"N/A"'
}

