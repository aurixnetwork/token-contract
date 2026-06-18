# AURIX Network Smart Contract

**AURIX Network (AURX)** is the native utility token of the AURIX ecosystem, implemented on BNB Smart Chain (BEP-20 standard).

This repository contains the smart contract source code, deployment scripts, verification configuration, and documentation required to deploy and manage the AURIX Network token.

---

# Token Information

| Item               | Value               |
| ------------------ | ------------------- |
| Token Name         | AURIX Network       |
| Symbol             | AURX                |
| Decimals           | 18                  |
| Total Supply       | 10,000,000,000 AURX |
| Standard           | BEP-20              |
| Owner              | Deployment Wallet   |
| Mint               | Not Supported       |
| Burn               | Owner Only          |
| Lock Address       | Supported           |
| Ownership Transfer | Supported           |

---

# Smart Contract Features

## BEP-20 Compliance

The contract supports standard BEP-20 functionality:

* transfer()
* approve()
* transferFrom()
* allowance()
* increaseApproval()
* decreaseApproval()

---

## Owner Address Lock

The owner can temporarily lock specific addresses.

### Function

```solidity
lockAddress(address account, bool locked)
```

### Behavior

* Locked address cannot send tokens.
* Locked address can still receive tokens.
* Owner address cannot be locked.

### Use Cases

* Stolen funds
* Security incidents
* Compliance requests
* Fraud investigation

---

## Owner Burn

The owner may permanently burn tokens.

### Function

```solidity
burn(uint256 amount)
```

### Effects

* Owner balance decreases.
* Total Supply decreases.
* Burn event emitted.
* Transfer event emitted to zero address.

### Example

Before:

```text
Total Supply = 10,000,000,000
```

Burn:

```text
1,000,000
```

After:

```text
Total Supply = 9,999,000,000
```

---

## Ownership Transfer

Ownership can be transferred to another wallet or a MultiSig wallet.

### Function

```solidity
transferOwnership(address newOwner)
```

### Recommended Future Setup

```text
Deployment Wallet
        ↓
Safe MultiSig Wallet
```

---

# Project Structure

```text
contracts/
 └ AURIXNetwork.sol

scripts/
 ├ deploy.ts
 └ check.ts

.env.example
hardhat.config.ts
package.json
README.md
```

---

# Requirements

* Ubuntu 22+
* Node.js 22+
* Hardhat 3
* Ethers v6

---

# Installation

Install dependencies:

```bash
npm install
```

---

# Environment Configuration

Create `.env` file:

```env
PRIVATE_KEY_TESTNET=
PRIVATE_KEY_MAINNET=
ETHERSCAN_API_KEY=

TOKEN_ADDRESS_TESTNET=
TOKEN_ADDRESS_MAINNET=
```

Never upload `.env` to GitHub.

---

# Compile Contract

```bash
npm run compile
```

---

# Deploy to BSC Testnet

Ensure the deployer wallet contains tBNB.

```bash
npm run deploy:testnet
```

---

# Verify on BscScan Testnet

```bash
npm run verify:testnet -- CONTRACT_ADDRESS
```

---

# Deploy to BSC Mainnet

Ensure the deployer wallet contains BNB.

```bash
npm run deploy:mainnet
```

---

# Verify on BscScan Mainnet

```bash
npm run verify:mainnet -- CONTRACT_ADDRESS
```

---

# Check Token Information

Testnet:

```bash
npm run check:testnet
```

Mainnet:

```bash
npm run check:mainnet
```

---

# Security Notes

* No Mint function exists.
* Total supply is fixed at deployment.
* Burn permanently reduces total supply.
* Address lock only affects outgoing transfers.
* Ownership can be transferred to a MultiSig wallet.
* Contract-wide lock functionality is intentionally excluded.

---

# License

MIT License
