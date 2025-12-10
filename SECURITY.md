# Security Policy

FlashCoin Core is an **experimental, non-profit, educational fork** of Bitcoin Core.  
It is intended for learning how a full node and wallet work (consensus, networking, mining, RPC, etc.), **not** as a production-grade financial product.

Because of this, security handling is **best-effort** and much simpler than Bitcoin Core’s process.

---

## Supported Versions

There is **no formal long-term support (LTS)** policy.

As a rule of thumb:

- The **latest tagged release** (e.g. `v0.1.1`) and
- The `main` branch

are the only versions that may receive security fixes, and even then **on a best-effort, educational basis only**.

Older releases are considered **unsupported**.

---

## Reporting a Vulnerability

If you discover a potential security issue in FlashCoin Core:

1. **Do not** post full exploit details publicly in GitHub Issues or social media.
2. Prefer one of the following options:

### Option A – GitHub (preferred)

- Open a **new GitHub Issue** in this repository.
- Use a neutral title such as:  
  `Potential security issue in XYZ component`
- In the description, **do not** include step-by-step exploit instructions.  
  Instead:
  - Describe the general impact (crash, DoS, fund loss risk, etc.).
  - Mention affected area (P2P, RPC, wallet, mining, etc.).
  - Ask the maintainer to contact you privately for more details.

Repository:  
<https://github.com/TheFlashCoinDev/flashcoin-core>

### Option B – Private contact (if needed)

If more privacy is required, you can:

- Contact the repository owner (`TheFlashCoinDev`) directly via GitHub, or
- Share a contact method (e.g. email or handle) in the issue and request a private channel.

> Note: There is currently **no dedicated security team or official security email** for FlashCoin.  
> Handling is done by the maintainer on a best-effort basis.

---

## Scope and Expectations

- FlashCoin is **experimental** and may contain bugs, consensus risks, or network vulnerabilities.
- There is **no guarantee** of response time, backports, or coordinated disclosure.
- However, good-faith reports are appreciated and help improve the project for learning and experimentation.

If you are looking for a hardened, production-ready implementation for real funds, you should consider using official Bitcoin Core instead.

