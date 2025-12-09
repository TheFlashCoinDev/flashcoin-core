# FlashCoin Core

**FlashCoin Core** is a non-profit, educational fork of Bitcoin Core designed to learn how a full cryptocurrency node and wallet work: consensus, networking, mining, wallet, RPC, and more.  
It is **not** intended as an investment product.

---

## 🧾 FlashCoin Specifications

> Current protocol parameters, as configured in the code.

| Parameter                    | Value                              |
|-----------------------------|------------------------------------|
| Ticker                      | `FLASH`                            |
| Consensus                   | Proof-of-Work (PoW)                |
| PoW Algorithm               | SHA-256d                           |
| Target block time           | **3 seconds**                      |
| Block reward (initial)      | **5 FLASH**                        |
| Halving interval            | **5,000,000 blocks**               |
| Approx. halving period      | ~173 days (~5.7 months)           |
| Maximum theoretical supply  | ~**50,000,000 FLASH**              |
| Decimals                    | 8 (1 FLASH = 100,000,000 units)   |
| MainNet P2P port            | `17554`                            |
| TestNet P2P port            | `27554`                            |
| TestNet4 P2P port           | `37554`                            |
| Signet P2P port             | `47554`                            |

**Supply note:** with 5 FLASH per block and halvings every 5,000,000 blocks, the total theoretical supply approaches ~50 million FLASH over infinite time (geometric halving series).

FlashCoin inherits modern Bitcoin Core features (depending on upstream version), such as:

- SegWit and Taproot
- Descriptor wallets and PSBT
- Advanced RPC interface
- Optional indexes, ZMQ notifications, and more

> ⚠️ FlashCoin is experimental. Parameters and behavior may change as part of learning and development.

---

## 🎯 Project Purpose

FlashCoin Core is essentially **Bitcoin Core with different branding and parameters**, used as a lab to:

- Rename binaries and resources (`FlashCoind`, `FlashCoin-qt`, icons, strings, etc.).
- Adjust consensus parameters (block time, reward, halving, ports, etc.).
- Understand how a real node validates blocks, handles mempool, and exposes RPC.
- Experiment safely on regtest/test networks without touching real money.

**Primary goal:** education and experimentation.  
**No financial promises.**

---

## 🧱 Main Components

After building, the main binaries are:

- `FlashCoind` – full node daemon (no GUI).
- `FlashCoin-qt` – GUI wallet + node using Qt.
- `FlashCoin-cli` – command line interface for RPC.
- `FlashCoin-tx` – low-level transaction tool.
- Wallet utilities and tools (depending on build configuration).

File names, resources, and icons have been rebranded from Bitcoin Core to FlashCoin where applicable.

---

## 🔧 Building FlashCoin Core (Linux example)

Build steps are mostly identical to Bitcoin Core, just using this repository and the FlashCoin binary names.

### Clone the repository

```bash
git clone https://github.com/TheFlashCoinDev/flashcoin-core.git
cd flashcoin-core
