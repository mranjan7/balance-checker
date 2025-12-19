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
macOS (Homebrew):
brew install curl jq bc
Usage
./sol-balance.sh  [options]
Options
	•	-t, --tokens Show popular token balances
	•	-u, --usd Show USD values
	•	-w, --watch N Auto-refresh every N seconds
	•	-h, --help Show help
Examples
# Basic SOL balance
./sol-balance.sh 7vWj...yourAddress

# With tokens + USD
./sol-balance.sh 7vWj...yourAddress --tokens --usd

# Auto-refresh every 60s
./sol-balance.sh 7vWj...yourAddress --tokens --usd --watch 60
Press Ctrl+C to stop watch mode.
Notes
	•	Uses public Solana RPC (api.mainnet-beta.solana.com). Rate limits apply.
	•	For higher limits, edit RPC_URL to use a dedicated provider (e.g., Triton One, Helius).
License
This project is licensed under the MIT License - see the LICENSE file for details.
MIT License

Copyright (c) 2025 [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
Feature Requests
Email: solana.tools.contact@gmail.com
Donations
If this tool is useful to you, consider supporting development:
SOL Donation Address: ReplaceWithYourActualDonationAddress
Thank you! 🚀
**Tip:** Replace `[Your Name]` in the license section with your actual name or pseudonym, and update the donation address before saving.

Your `README.md` file is now ready! Just save it in the same folder as your script.
