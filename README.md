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

Installation
Clone or download the script:
git clone https://github.com/yourusername/solana-balance-checker.git
cd solana-balance-checker
Make the script executable:
chmod +x solana_balance_checker.sh
Usage
./solana_balance_checker.sh <WALLET_ADDRESS> [options]
Options
Option	Description
-h, --help	Show help message
-w, --watch SECONDS	Auto-refresh every N seconds
-t, --tokens	Show popular SPL token balances
-u, --usd	Show SOL value in USD
Examples
Basic SOL balance
./solana_balance_checker.sh 7vWj...YourWalletAddress
SOL + Token balances
./solana_balance_checker.sh 7vWj...YourWalletAddress --tokens
SOL + USD value
./solana_balance_checker.sh 7vWj...YourWalletAddress --usd
Auto-refresh every 60 seconds
./solana_balance_checker.sh 7vWj...YourWalletAddress --tokens --usd --watch 60
How It Works
Uses Solana JSON RPC (https://api.mainnet-beta.solana.com)
Fetches SOL balance via getBalance
Fetches SPL tokens via getTokenAccountsByOwner
Converts SOL → USD using CoinGecko API
Donations
If this tool helps you, consider supporting development ❤️
Solana
3osdGZH4jPhABzU32vbZ7DLrhdq39E2D2nXqzqnt1Yy5
Ethereum
0x123456789abcdef123456789abcdef1234567890
Bitcoin
bc1qlp4e54rcjjdjd8d7lqfwk4c7a59l5jtwd4l8ts
Feature Requests & Support
Have ideas, feature requests, or found a bug?
📧 Email: your.email@example.com

License
MIT License
Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files, to deal in the Software
without restriction.


---

If you want, I can also:
- Replace placeholder donation addresses
- Add badges (license, bash, solana)
- Optimize for GitHub / GitLab
- Add screenshots section

Just tell me 👍

Get smarter responses, upload files and images, and more.

Log in

Sign up for free


