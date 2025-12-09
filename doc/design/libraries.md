# Libraries

| Name                     | Description |
|--------------------------|-------------|
| *libFlashCoin_cli*         | RPC client functionality used by *FlashCoin-cli* executable |
| *libFlashCoin_common*      | Home for common functionality shared by different executables and libraries. Similar to *libFlashCoin_util*, but higher-level (see [Dependencies](#dependencies)). |
| *libFlashCoin_consensus*   | Consensus functionality used by *libFlashCoin_node* and *libFlashCoin_wallet*. |
| *libFlashCoin_crypto*      | Hardware-optimized functions for data encryption, hashing, message authentication, and key derivation. |
| *libFlashCoin_kernel*      | Consensus engine and support library used for validation by *libFlashCoin_node*. |
| *libFlashCoinqt*           | GUI functionality used by *FlashCoin-qt* and *FlashCoin-gui* executables. |
| *libFlashCoin_ipc*         | IPC functionality used by *FlashCoin-node* and *FlashCoin-gui* executables to communicate when [`-DENABLE_IPC=ON`](multiprocess.md) is used. |
| *libFlashCoin_node*        | P2P and RPC server functionality used by *FlashCoind* and *FlashCoin-qt* executables. |
| *libFlashCoin_util*        | Home for common functionality shared by different executables and libraries. Similar to *libFlashCoin_common*, but lower-level (see [Dependencies](#dependencies)). |
| *libFlashCoin_wallet*      | Wallet functionality used by *FlashCoind* and *FlashCoin-wallet* executables. |
| *libFlashCoin_wallet_tool* | Lower-level wallet functionality used by *FlashCoin-wallet* executable. |
| *libFlashCoin_zmq*         | [ZeroMQ](../zmq.md) functionality used by *FlashCoind* and *FlashCoin-qt* executables. |

## Conventions

- Most libraries are internal libraries and have APIs which are completely unstable! There are few or no restrictions on backwards compatibility or rules about external dependencies. An exception is *libFlashCoin_kernel*, which, at some future point, will have a documented external interface.

- Generally each library should have a corresponding source directory and namespace. Source code organization is a work in progress, so it is true that some namespaces are applied inconsistently, and if you look at [`add_library(FlashCoin_* ...)`](../../src/CMakeLists.txt) lists you can see that many libraries pull in files from outside their source directory. But when working with libraries, it is good to follow a consistent pattern like:

  - *libFlashCoin_node* code lives in `src/node/` in the `node::` namespace
  - *libFlashCoin_wallet* code lives in `src/wallet/` in the `wallet::` namespace
  - *libFlashCoin_ipc* code lives in `src/ipc/` in the `ipc::` namespace
  - *libFlashCoin_util* code lives in `src/util/` in the `util::` namespace
  - *libFlashCoin_consensus* code lives in `src/consensus/` in the `Consensus::` namespace

## Dependencies

- Libraries should minimize what other libraries they depend on, and only reference symbols following the arrows shown in the dependency graph below:

<table><tr><td>

```mermaid

%%{ init : { "flowchart" : { "curve" : "basis" }}}%%

graph TD;

FlashCoin-cli[FlashCoin-cli]-->libFlashCoin_cli;

FlashCoind[FlashCoind]-->libFlashCoin_node;
FlashCoind[FlashCoind]-->libFlashCoin_wallet;

FlashCoin-qt[FlashCoin-qt]-->libFlashCoin_node;
FlashCoin-qt[FlashCoin-qt]-->libFlashCoinqt;
FlashCoin-qt[FlashCoin-qt]-->libFlashCoin_wallet;

FlashCoin-wallet[FlashCoin-wallet]-->libFlashCoin_wallet;
FlashCoin-wallet[FlashCoin-wallet]-->libFlashCoin_wallet_tool;

libFlashCoin_cli-->libFlashCoin_util;
libFlashCoin_cli-->libFlashCoin_common;

libFlashCoin_consensus-->libFlashCoin_crypto;

libFlashCoin_common-->libFlashCoin_consensus;
libFlashCoin_common-->libFlashCoin_crypto;
libFlashCoin_common-->libFlashCoin_util;

libFlashCoin_kernel-->libFlashCoin_consensus;
libFlashCoin_kernel-->libFlashCoin_crypto;
libFlashCoin_kernel-->libFlashCoin_util;

libFlashCoin_node-->libFlashCoin_consensus;
libFlashCoin_node-->libFlashCoin_crypto;
libFlashCoin_node-->libFlashCoin_kernel;
libFlashCoin_node-->libFlashCoin_common;
libFlashCoin_node-->libFlashCoin_util;

libFlashCoinqt-->libFlashCoin_common;
libFlashCoinqt-->libFlashCoin_util;

libFlashCoin_util-->libFlashCoin_crypto;

libFlashCoin_wallet-->libFlashCoin_common;
libFlashCoin_wallet-->libFlashCoin_crypto;
libFlashCoin_wallet-->libFlashCoin_util;

libFlashCoin_wallet_tool-->libFlashCoin_wallet;
libFlashCoin_wallet_tool-->libFlashCoin_util;

classDef bold stroke-width:2px, font-weight:bold, font-size: smaller;
class FlashCoin-qt,FlashCoind,FlashCoin-cli,FlashCoin-wallet bold
```
</td></tr><tr><td>

**Dependency graph**. Arrows show linker symbol dependencies. *Crypto* lib depends on nothing. *Util* lib is depended on by everything. *Kernel* lib depends only on consensus, crypto, and util.

</td></tr></table>

- The graph shows what _linker symbols_ (functions and variables) from each library other libraries can call and reference directly, but it is not a call graph. For example, there is no arrow connecting *libFlashCoin_wallet* and *libFlashCoin_node* libraries, because these libraries are intended to be modular and not depend on each other's internal implementation details. But wallet code is still able to call node code indirectly through the `interfaces::Chain` abstract class in [`interfaces/chain.h`](../../src/interfaces/chain.h) and node code calls wallet code through the `interfaces::ChainClient` and `interfaces::Chain::Notifications` abstract classes in the same file. In general, defining abstract classes in [`src/interfaces/`](../../src/interfaces/) can be a convenient way of avoiding unwanted direct dependencies or circular dependencies between libraries.

- *libFlashCoin_crypto* should be a standalone dependency that any library can depend on, and it should not depend on any other libraries itself.

- *libFlashCoin_consensus* should only depend on *libFlashCoin_crypto*, and all other libraries besides *libFlashCoin_crypto* should be allowed to depend on it.

- *libFlashCoin_util* should be a standalone dependency that any library can depend on, and it should not depend on other libraries except *libFlashCoin_crypto*. It provides basic utilities that fill in gaps in the C++ standard library and provide lightweight abstractions over platform-specific features. Since the util library is distributed with the kernel and is usable by kernel applications, it shouldn't contain functions that external code shouldn't call, like higher level code targeted at the node or wallet. (*libFlashCoin_common* is a better place for higher level code, or code that is meant to be used by internal applications only.)

- *libFlashCoin_common* is a home for miscellaneous shared code used by different FlashCoin applications. It should not depend on anything other than *libFlashCoin_util*, *libFlashCoin_consensus*, and *libFlashCoin_crypto*.

- *libFlashCoin_kernel* should only depend on *libFlashCoin_util*, *libFlashCoin_consensus*, and *libFlashCoin_crypto*.

- The only thing that should depend on *libFlashCoin_kernel* internally should be *libFlashCoin_node*. GUI and wallet libraries *libFlashCoinqt* and *libFlashCoin_wallet* in particular should not depend on *libFlashCoin_kernel* and the unneeded functionality it would pull in, like block validation. To the extent that GUI and wallet code need scripting and signing functionality, they should be able to get it from *libFlashCoin_consensus*, *libFlashCoin_common*, *libFlashCoin_crypto*, and *libFlashCoin_util*, instead of *libFlashCoin_kernel*.

- GUI, node, and wallet code internal implementations should all be independent of each other, and the *libFlashCoinqt*, *libFlashCoin_node*, *libFlashCoin_wallet* libraries should never reference each other's symbols. They should only call each other through [`src/interfaces/`](../../src/interfaces/) abstract interfaces.

## Work in progress

- Validation code is moving from *libFlashCoin_node* to *libFlashCoin_kernel* as part of [The libFlashCoinkernel Project #27587](https://github.com/FlashCoin/FlashCoin/issues/27587)
