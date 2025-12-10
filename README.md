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

Clone the repository:

    git clone https://github.com/TheFlashCoinDev/flashcoin-core.git
    cd flashcoin-core
    # (build instructions similar to Bitcoin Core: depends, cmake/configure, make, etc.)

---

## ⛏️ Mining FlashCoin

FlashCoin uses Proof-of-Work (**SHA256d**, same algorithm as Bitcoin) with a **target block time of ~3 seconds** and an initial block reward of **5 FLASH**.

You can mine FlashCoin by running a full node and either:

- **Solo mining** against your own node (for testing / small setups).
- Or connecting external miners / a pool (recommended for serious mining).

> ⚠️ Mining on mainnet is at your own risk. Always test first on testnet or regtest and make sure your node is fully synced before mining.

---

### 1. Basic node setup

1. **Install / build FlashCoin Core**  
   Use the binaries from the releases page or build from source as explained above in this README.

2. **Start the node once** so it creates the data directory, then close it:
   - On Windows (Qt):
     - Run `FlashCoin-qt.exe` once, wait until it starts, then close it.
   - On Linux/macOS (daemon):
     - Run `FlashCoind` once, then stop it.

3. Locate your **FlashCoin data directory**:

   - **Windows:**  
     `%APPDATA%\FlashCoin\`
   - **Linux:**  
     `~/.flashcoin/`
   - **macOS:**  
     `~/Library/Application Support/FlashCoin/`

4. Create (or edit) the file: **`flashcoin.conf`** in that folder.  
   You can use the example at the bottom of this section.

---

### 2. Solo mining (CPU example)

> Note: Solo mining only makes sense for testing, development, or very early stages of the network.

1. Make sure your `flashcoin.conf` has **RPC enabled**:

    server=1
    rpcuser=flashrpc
    rpcpassword=change_this_password
    rpcallowip=127.0.0.1
    rpcbind=127.0.0.1
    # Example RPC port (set this explicitly if you want to use a miner):
    rpcport=17555

2. Start your node:

   - **Qt wallet (with RPC):**

        FlashCoin-qt -server

   - **Daemon (Linux/macOS):**

        FlashCoind -daemon

3. Wait until the node is **fully synced** with the FlashCoin network.

4. Use a miner that supports **SHA256d** and JSON-RPC (for example, a cpuminer fork).  
   Point it to your local node, using the RPC credentials from `flashcoin.conf`:

    cpuminer -a sha256d -o http://127.0.0.1:17555 -u flashrpc -p change_this_password

   - `-a sha256d` → mining algorithm  
   - `-o` → your node’s RPC URL  
   - `-u` / `-p` → must match `rpcuser` / `rpcpassword` in `flashcoin.conf`  

If blocks are being found, you should see new rewards in your wallet after they mature (same maturity rules as Bitcoin, unless modified in consensus).

---

### 3. Adding peers / nodes

There are two main ways to add peers:

#### A) Through `flashcoin.conf`

Add one or more `addnode=` lines:

    # P2P listening port for FlashCoin mainnet
    port=17554

    # Example: add specific peers (replace with real IPs / hostnames)
    addnode=123.45.67.89:17554
    addnode=flash-node.example.com:17554

Restart the node after editing the config.

#### B) From the debug console (Qt)

1. Open **FlashCoin-qt**
2. Go to **Help → Debug window → Console**
3. Use:

    addnode "123.45.67.89:17554" "add"

You can remove a node later with:

    addnode "123.45.67.89:17554" "remove"

---

### 📄 Example `flashcoin.conf`

Below is a simple, generic configuration file you can use as a starting point.

> ⚠️ Change the RPC password and any placeholder values before running this in production.

    ############################
    # FlashCoin Core config
    ############################

    # Enable JSON-RPC
    server=1

    # On Linux/macOS, run as daemon (ignored on Windows Qt)
    daemon=1

    # Keep a full transaction index (optional, but useful for explorers/tools)
    txindex=1

    ############################
    # RPC configuration
    ############################

    rpcuser=flash
