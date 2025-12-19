# Solana Balance Checker

Lightweight Bash script to check SOL and popular token balances for a Solana wallet from the terminal.

## Features

- Native **SOL** balance
- Optional balances for: **USDC**, **JUP**, **BONK**, **WIF**
- Optional USD valuation (live SOL price via CoinGecko)
- Watch mode with auto-refresh
- Colorful output

## Requirements

- `curl`, `jq`, `bc`

**Debian/Ubuntu:**
```bash
sudo apt install curl jq bc
```
**macOS (Homebrew):**
```bash
brew install curl jq
```
## Usage
```bash
./sol-balance.sh  [options]
```
Options. 
	•	`-t, --tokens` Show popular token balances. 
	•	`-u, --usd` Show USD values. 
	•	`-w, --watch N` Auto-refresh every N seconds. 
	•	`-h, --help` Show help. 
## Examples
**Basic SOL balance**
```bash
./sol-balance.sh 7vWj...yourAddress
```
**With tokens + USD**
```bash
./sol-balance.sh 7vWj...yourAddress --tokens --usd
```

**Auto-refresh every 60s**
```bash
./sol-balance.sh 7vWj...yourAddress --tokens --usd --watch 60
```
Press Ctrl+C to stop watch mode.

## Notes

	- Uses public Solana RPC (api.mainnet-beta.solana.com). Rate limits apply.
	
	- For higher limits, edit RPC_URL to use a dedicated provider (e.g., Triton One, Helius).

## Additional Feature Requests
Email: ktools@tuta.com
