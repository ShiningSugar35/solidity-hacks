# Ethernaut Solutions: A Foundry-Based Exploration of Smart Contract Vulnerabilities

This repository serves as the official "sparring ground" for my 30-Day Protocol Battle Plan(https://github.com/ShiningSugar35/protocol-journey). The primary objective is to cultivate an attacker's mindset by systematically dissecting and exploiting common smart contract vulnerabilities found in the classic [Ethernaut](https://ethernaut.openzeppelin.com/) wargame.

All solutions are developed using a professional, Test-Driven Development (TDD) workflow with the [Foundry](https://book.getfoundry.sh/) framework.

## Our Approach: Test-Driven Exploitation

Instead of simply finding a solution, each challenge is solved by writing a Foundry test that programmatically executes the exploit. This methodology ensures a deeper, more rigorous understanding of the vulnerability by forcing a clear definition of the success condition (the assertion) and the precise steps required to achieve it.

## Setup & Configuration

### 1. Prerequisites
Ensure you have [Foundry](https://book.getfoundry.sh/getting-started/installation) installed.

### 2. Installation
Clone the repository and install the necessary libraries:
```bash
git clone [https://github.com/ShiningSugar35/ethernaut-solutions.git](https://github.com/ShiningSugar35/ethernaut-solutions.git)
cd ethernaut-solutions
forge install
```

### 3. Environment Configuration
This project requires a connection to the Sepolia testnet to fork the state of the Ethernaut contracts. You will need a Sepolia RPC URL from a node provider like [Alchemy](https://www.alchemy.com/) or [Chainstack](https://chainstack.com/).

1.  Create a `.env` file in the root of the project:
    ```bash
    touch .env
    ```
2.  Add your Sepolia RPC URL to the `.env` file:
    ```
    SEPOLIA_RPC_URL="YOUR_SEPOLIA_RPC_URL_HERE"
    ```
3.  The `foundry.toml` file is already configured to load this variable. No further changes are needed.

## Usage

To run the exploit for a specific level, use the `--match-path` flag with `forge test`. Use `-vv` or more `v`'s for detailed logging, including `console.log` statements.

**Example for Level 1 (Fallback):**
```bash
forge test --match-path test/Fallback.t.sol -vv
```

