#!/bin/bash

set -euo pipefail


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BLINK='\033[0;35m'
NC='\033[0m' # No color

RPC_URL="https://api.mainnet-beta.solana.com"

declare -A TOKENS

TOKENS["USDC"]="EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v"
TOKENS["JUP"]="JUPyiwrYJFskUPiHa7hkeR8VUtAeFoSYbKedZNsDvCN"
TOKENS["BONK"]="DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263"
TOKENS["WIF"]="EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm"

if ! command -v curl >/dev/null 2>&1; then
	echo "${RED}Error: curl is required.${NC}"
	exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
	echo "{RED}Error: jq is required.${NC}"
	exit 1
fi
	



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
	echo "$lamports" | jq -r '.result.value//0'	
}

get_token_balance(){
	local wallet="$1"
	local mint="$2"
	local token_account=$(curl -s -X POST "$RPC_URL"\
				-H "Content-Type:application/json"\
				-d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"getTokenAccountsByOwner\",\"params\":[\"$wallet\",{\"mint\":\"$mint\"},{\"encoding\":\"jsonParsed\"}]}") || return 1
	echo "$token_account"|jq -r '.result.value[0].account.data.parsed.info.tokenAmount.uiAmount//0'

	
}

get_sol_price_usd(){
	curl -s "https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd"|\
	jq -r '.solana.usd //"N/A"'
}

SOL_PRICE=0

set +e +o pipefail

SOL_PRICE=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd" | jq -r '.solana.usd')


status=$?

set -euo pipefail



fetch_transaction_details(){
	local signature=$1
	local n=5
	local short_sig="" 
	short_sig=$(echo "${signature:0:n}...${signature: -n}")
	printf "Transaction : %s\n" $short_sig
	tx_details=$(curl -s -X POST $RPC_URL \
	-H "Content-Type: application/json" \
	-d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"getTransaction\",\"params\":[\"$signature\",{\"encoding\": \"jsonParsed\",\"maxSupportedTransactionVersion\":0}]}")

	local slot=$(echo "$tx_details" | jq '.result.slot')
	local block_time=$(echo "$tx_details" | jq '.result.blockTime')
	local status=$(echo "$tx_details" | jq '.result.meta.err')
	local priority_fee=$(echo "$tx_details" | jq '.result.meta.fee')

	printf "Block Time : %s Slot : %s Status : %s Priority Fee : %s" $block_time
	
}
get_transactions(){
	local wallet_address="$1"
	if [[ -z "$wallet_address" ]]; then
		echo "ERROR: Wallet address is required"
		return 1
	fi
	echo "Fetching recent transactions for: $wallet_address"
	echo

	local signatures=$(curl -s -X POST "$RPC_URL" \
		-H "Content-Type:application/json" \
		-d "{\"jsonrpc\":\"2.0\",\"id\": 1,\"method\":\"getSignaturesForAddress\",\"params\":[\"$wallet_address\",{\"limit\":3}]}" | jq -r '.result[].signature')


	for signature in $signatures; do
		local tx_details
		tx_details=$(fetch_transaction_details "$signature")
		echo "$tx_details"
	done
}
		



display_balance(){
	local wallet="$1"
	local show_tokens="$2"
	local show_usd="$3"
	local lamports=$(get_sol_balance "$wallet")
	local sol=$(echo "scale=4; $lamports/1000000000"|bc -l 2>/dev/null || echo "0")

	echo -e "${BLUE}Wallet:${NC} $wallet"
	echo -e "${GREEN}SOL balance:${NC} $sol SOL"

	if [[ "$show_usd" == true ]]; then
		local price=$(get_sol_price_usd)
		if [[ "$price" != "N/A" ]]; then
			local usd_value=$(echo "$sol * $price" | bc -l 2>/dev/null || echo "0")
			echo -e "${YELLOW} = ${usd_value} USD${NC} (at ~\$$price/SOL)"
		fi
	fi

	if [[ "$show_tokens" == true ]]; then
		echo -e "\n${BLUE}Popular Tokens:${NC}"
		for symbol in "${!TOKENS[@]}"; do
			local balance=$(get_token_balance "$wallet" "${TOKENS[$symbol]}")
			printf " %-6s %s\n" "$symbol:" "$balance"
		done
	fi

	get_transactions "$wallet"

	echo -e "${BLINK}TOP TRENDING"
	local coin=$(echo curl -s -X GET "https://api.coingecko.com/api/v3/search/trending" \
		-H "accept: application/json" | jq -r '.coins[0].item.name')
	local nft=$(echo curl -s -X GET "https://api.coingecko.com/api/v3/search/trending" \
		-H "accept: application/json" | jq -r '.nfts[0].item.name')
	printf "COIN : %s   NFT : %s" "$coin" "$nft"
	echo ""
}

WALLET=""
WATCH_INTERVAL=0
SHOW_TOKENS=false
SHOW_USD=false

while [[ $# -gt 0 ]]; do
	case $1 in
		-h|--help)
			print_usage
			exit 0
			;;
		-w|--watch)
			WATCH_INTERVAL="$2"
			shift
			;;
		-t|--tokens)
			SHOW_TOKENS=true
			;;
		-u|--usd)
			SHOW_USD=true
			;;
		-*)
			echo "Unknown option: $1"
			print_usage
			exit 1
			;;
		*)
			if [[ -z "$WALLET" ]]; then
				WALLET="$1"
			else
				echo "Multiple wallets not supported yet."
				exit 1
			fi
			;;
	esac			
	shift
done

if [[ -z "$WALLET" ]]; then
	echo -e "${RED}Error: Wallet address required. ${NC}"
	print_usage
	exit 1
fi	

if [[ ${#WALLET} -lt 32 || ${#WALLET} -gt 44 ]]; then
	echo -e "${RED}Error: Invalid Solana Wallet address length.${NC}"
	exit 1
fi

if [[ $WATCH_INTERVAL -gt 0 ]]; then
	while true; do
		clear
		echo -e "${YELLOW}Solana Balance Checker (refresh ecery ${WATCH_INTERVAL}s) - Ctrl+C to stop${NC}\n"
		display_balance "$WALLET" "$SHOW_TOKENS" "$SHOW_USD"
		sleep "$WATCH_INTERVAL"
	done
else
	display_balance "$WALLET" "$SHOW_TOKENS" "$SHOW_USD"	
fi
