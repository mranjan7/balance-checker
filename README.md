# Solana Balance Checker

A lightweight Bash script to check Solana wallet balances directly from the terminal.  
It supports SOL balance, popular SPL token balances, USD price conversion, and auto-refresh.

---

## Features

- Display SOL balance
- Display SOL value in USD (via CoinGecko)
- Display popular SPL token balances:
  - USDC
  - JUP
  - BONK
  - WIF
- Auto-refresh wallet balance at a fixed interval
- Clean terminal output with color formatting

---

## Requirements

The following tools must be installed:

- `curl`
- `jq`
- `bc`

### Install on Debian / Ubuntu

```bash
sudo apt update
sudo apt install curl jq bc
