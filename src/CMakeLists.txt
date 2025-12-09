# Copyright (c) 2023-present The FlashCoin developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or https://opensource.org/license/mit/.

include(AddWindowsResources)

configure_file(${PROJECT_SOURCE_DIR}/cmake/FlashCoin-build-config.h.in FlashCoin-build-config.h USE_SOURCE_PERMISSIONS @ONLY)
include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

#=============================
# Subprojects
#=============================
# Subprojects include subdirectories that do or could have tests
# and/or benchmark binaries, such as all subtrees and univalue.
# These need to be included before CMAKE_*_OUTPUT_DIRECTORY variables
# are set, so output locations of subproject tests and libraries are
# not overridden.
include(../cmake/crc32c.cmake)
include(../cmake/leveldb.cmake)
include(../cmake/minisketch.cmake)
add_subdirectory(univalue)
if (ENABLE_IPC AND NOT WITH_EXTERNAL_LIBMULTIPROCESS)
  include(../cmake/libmultiprocess.cmake)
  add_libmultiprocess(ipc/libmultiprocess)
endif()
include(../cmake/secp256k1.cmake)
add_secp256k1(secp256k1)

# Set top-level target output locations.
if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
endif()
if(NOT CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
endif()
if(NOT CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
endif()

add_custom_target(generate_build_info
  BYPRODUCTS ${PROJECT_BINARY_DIR}/src/FlashCoin-build-info.h
  COMMAND ${CMAKE_COMMAND} -DBUILD_INFO_HEADER_PATH=${PROJECT_BINARY_DIR}/src/FlashCoin-build-info.h -DSOURCE_DIR=${PROJECT_SOURCE_DIR} -P ${PROJECT_SOURCE_DIR}/cmake/script/GenerateBuildInfo.cmake
  COMMENT "Generating FlashCoin-build-info.h"
  VERBATIM
)
add_library(FlashCoin_clientversion STATIC EXCLUDE_FROM_ALL
  clientversion.cpp
)
target_link_libraries(FlashCoin_clientversion
  PRIVATE
    core_interface
)
add_dependencies(FlashCoin_clientversion generate_build_info)

add_subdirectory(crypto)
add_subdirectory(util)
if(ENABLE_IPC)
  add_subdirectory(ipc)
endif()

add_library(FlashCoin_consensus STATIC EXCLUDE_FROM_ALL
  arith_uint256.cpp
  consensus/merkle.cpp
  consensus/tx_check.cpp
  hash.cpp
  primitives/block.cpp
  primitives/transaction.cpp
  pubkey.cpp
  script/interpreter.cpp
  script/script.cpp
  script/script_error.cpp
  uint256.cpp
)
target_link_libraries(FlashCoin_consensus
  PRIVATE
    core_interface
    FlashCoin_crypto
    secp256k1
)

if(WITH_ZMQ)
  add_subdirectory(zmq)
endif()

# Home for common functionality shared by different executables and libraries.
# Similar to `FlashCoin_util` library, but higher-level.
add_library(FlashCoin_common STATIC EXCLUDE_FROM_ALL
  addresstype.cpp
  base58.cpp
  bech32.cpp
  chain.cpp
  chainparams.cpp
  chainparamsbase.cpp
  coins.cpp
  common/args.cpp
  common/bloom.cpp
  common/config.cpp
  common/init.cpp
  common/interfaces.cpp
  common/messages.cpp
  common/netif.cpp
  common/pcp.cpp
  common/run_command.cpp
  common/settings.cpp
  common/signmessage.cpp
  common/system.cpp
  common/url.cpp
  compressor.cpp
  core_read.cpp
  core_write.cpp
  deploymentinfo.cpp
  external_signer.cpp
  init/common.cpp
  kernel/chainparams.cpp
  key.cpp
  key_io.cpp
  merkleblock.cpp
  musig.cpp
  net_permissions.cpp
  net_types.cpp
  netaddress.cpp
  netbase.cpp
  outputtype.cpp
  policy/feerate.cpp
  policy/policy.cpp
  pow.cpp
  protocol.cpp
  psbt.cpp
  rpc/rawtransaction_util.cpp
  rpc/request.cpp
  rpc/util.cpp
  scheduler.cpp
  script/descriptor.cpp
  script/miniscript.cpp
  script/parsing.cpp
  script/sign.cpp
  script/signingprovider.cpp
  script/solver.cpp
)
target_link_libraries(FlashCoin_common
  PRIVATE
    core_interface
    FlashCoin_consensus
    FlashCoin_util
    univalue
    secp256k1
    Boost::headers
    $<TARGET_NAME_IF_EXISTS:USDT::headers>
    $<$<PLATFORM_ID:Windows>:ws2_32>
)

include(InstallBinaryComponent)

if(ENABLE_WALLET)
  add_subdirectory(wallet)

  if(BUILD_WALLET_TOOL)
    add_executable(FlashCoin-wallet
      FlashCoin-wallet.cpp
      init/FlashCoin-wallet.cpp
      wallet/wallettool.cpp
    )
    add_windows_resources(FlashCoin-wallet FlashCoin-wallet-res.rc)
    add_windows_application_manifest(FlashCoin-wallet)
    target_link_libraries(FlashCoin-wallet
      core_interface
      FlashCoin_wallet
      FlashCoin_common
      FlashCoin_util
      Boost::headers
    )
    install_binary_component(FlashCoin-wallet HAS_MANPAGE)
  endif()
endif()


# P2P and RPC server functionality used by `FlashCoind` and `FlashCoin-qt` executables.
add_library(FlashCoin_node STATIC EXCLUDE_FROM_ALL
  addrdb.cpp
  addrman.cpp
  banman.cpp
  bip324.cpp
  blockencodings.cpp
  blockfilter.cpp
  consensus/tx_verify.cpp
  dbwrapper.cpp
  deploymentstatus.cpp
  flatfile.cpp
  headerssync.cpp
  httprpc.cpp
  httpserver.cpp
  i2p.cpp
  index/base.cpp
  index/blockfilterindex.cpp
  index/coinstatsindex.cpp
  index/txindex.cpp
  init.cpp
  kernel/chain.cpp
  kernel/checks.cpp
  kernel/coinstats.cpp
  kernel/context.cpp
  kernel/cs_main.cpp
  kernel/disconnected_transactions.cpp
  kernel/mempool_removal_reason.cpp
  mapport.cpp
  net.cpp
  net_processing.cpp
  netgroup.cpp
  node/abort.cpp
  node/blockmanager_args.cpp
  node/blockstorage.cpp
  node/caches.cpp
  node/chainstate.cpp
  node/chainstatemanager_args.cpp
  node/coin.cpp
  node/coins_view_args.cpp
  node/connection_types.cpp
  node/context.cpp
  node/database_args.cpp
  node/eviction.cpp
  node/interface_ui.cpp
  node/interfaces.cpp
  node/kernel_notifications.cpp
  node/mempool_args.cpp
  node/mempool_persist.cpp
  node/mempool_persist_args.cpp
  node/miner.cpp
  node/mini_miner.cpp
  node/minisketchwrapper.cpp
  node/peerman_args.cpp
  node/psbt.cpp
  node/timeoffsets.cpp
  node/transaction.cpp
  node/txdownloadman_impl.cpp
  node/txorphanage.cpp
  node/txreconciliation.cpp
  node/utxo_snapshot.cpp
  node/warnings.cpp
  noui.cpp
  policy/ephemeral_policy.cpp
  policy/fees.cpp
  policy/fees_args.cpp
  policy/packages.cpp
  policy/rbf.cpp
  policy/settings.cpp
  policy/truc_policy.cpp
  rest.cpp
  rpc/blockchain.cpp
  rpc/external_signer.cpp
  rpc/fees.cpp
  rpc/mempool.cpp
  rpc/mining.cpp
  rpc/net.cpp
  rpc/node.cpp
  rpc/output_script.cpp
  rpc/rawtransaction.cpp
  rpc/server.cpp
  rpc/server_util.cpp
  rpc/signmessage.cpp
  rpc/txoutproof.cpp
  script/sigcache.cpp
  signet.cpp
  torcontrol.cpp
  txdb.cpp
  txgraph.cpp
  txmempool.cpp
  txrequest.cpp
  validation.cpp
  validationinterface.cpp
  versionbits.cpp
  $<$<TARGET_EXISTS:FlashCoin_wallet>:wallet/init.cpp>
  $<$<NOT:$<TARGET_EXISTS:FlashCoin_wallet>>:dummywallet.cpp>
)
target_link_libraries(FlashCoin_node
  PRIVATE
    core_interface
    FlashCoin_common
    FlashCoin_util
    $<TARGET_NAME_IF_EXISTS:FlashCoin_zmq>
    leveldb
    minisketch
    univalue
    Boost::headers
    $<TARGET_NAME_IF_EXISTS:libevent::core>
    $<TARGET_NAME_IF_EXISTS:libevent::extra>
    $<TARGET_NAME_IF_EXISTS:libevent::pthreads>
    $<TARGET_NAME_IF_EXISTS:USDT::headers>
)

if(BUILD_FlashCoin_BIN)
  # FlashCoin: por ahora no construimos el wrapper FlashCoin.exe
  # add_executable(FlashCoin FlashCoin.cpp)
  # add_windows_resources(FlashCoin FlashCoin-res.rc)
  # add_windows_application_manifest(FlashCoin)
  # target_link_libraries(FlashCoin core_interface FlashCoin_util)
  # install_binary_component(FlashCoin HAS_MANPAGE)
endif()

# FlashCoin FlashCoind.
if(BUILD_DAEMON)
  add_executable(FlashCoind
    FlashCoind.cpp
    init/FlashCoind.cpp
  )
  add_windows_resources(FlashCoind FlashCoind-res.rc)
  add_windows_application_manifest(FlashCoind)
  target_link_libraries(FlashCoind
    core_interface
    FlashCoin_node
    $<TARGET_NAME_IF_EXISTS:FlashCoin_wallet>
  )
  install_binary_component(FlashCoind HAS_MANPAGE)
endif()
if(ENABLE_IPC AND BUILD_DAEMON)
  add_executable(FlashCoin-node
    FlashCoind.cpp
    init/FlashCoin-node.cpp
  )
  target_link_libraries(FlashCoin-node
    core_interface
    FlashCoin_node
    FlashCoin_ipc
    $<TARGET_NAME_IF_EXISTS:FlashCoin_wallet>
  )
  install_binary_component(FlashCoin-node INTERNAL)
endif()

if(ENABLE_IPC AND BUILD_TESTS)
    # FlashCoin_ipc_test library target is defined here in src/CMakeLists.txt
    # instead of src/test/CMakeLists.txt so capnp files in src/test/ are able to
    # reference capnp files in src/ipc/capnp/ by relative path. The Cap'n Proto
    # compiler only allows importing by relative path when the importing and
    # imported files are underneath the same compilation source prefix, so the
    # source prefix must be src/, not src/test/
    add_library(FlashCoin_ipc_test STATIC EXCLUDE_FROM_ALL
      test/ipc_test.cpp
    )
    target_capnp_sources(FlashCoin_ipc_test ${PROJECT_SOURCE_DIR}
      test/ipc_test.capnp
    )
    add_dependencies(FlashCoin_ipc_test FlashCoin_ipc_headers)
endif()


add_library(FlashCoin_cli STATIC EXCLUDE_FROM_ALL
  compat/stdin.cpp
  rpc/client.cpp
)
target_link_libraries(FlashCoin_cli
  PUBLIC
    core_interface
    univalue
)


# FlashCoin RPC client
if(BUILD_CLI)
  add_executable(FlashCoin-cli FlashCoin-cli.cpp)
  add_windows_resources(FlashCoin-cli FlashCoin-cli-res.rc)
  add_windows_application_manifest(FlashCoin-cli)
  target_link_libraries(FlashCoin-cli
    core_interface
    FlashCoin_cli
    FlashCoin_common
    FlashCoin_util
    libevent::core
    libevent::extra
  )
  install_binary_component(FlashCoin-cli HAS_MANPAGE)
endif()


if(BUILD_TX)
  add_executable(FlashCoin-tx FlashCoin-tx.cpp)
  add_windows_resources(FlashCoin-tx FlashCoin-tx-res.rc)
  add_windows_application_manifest(FlashCoin-tx)
  target_link_libraries(FlashCoin-tx
    core_interface
    FlashCoin_common
    FlashCoin_util
    univalue
  )
  install_binary_component(FlashCoin-tx HAS_MANPAGE)
endif()


if(BUILD_UTIL)
  add_executable(FlashCoin-util FlashCoin-util.cpp)
  add_windows_resources(FlashCoin-util FlashCoin-util-res.rc)
  add_windows_application_manifest(FlashCoin-util)
  target_link_libraries(FlashCoin-util
    core_interface
    FlashCoin_common
    FlashCoin_util
  )
  install_binary_component(FlashCoin-util HAS_MANPAGE)
endif()


if(BUILD_GUI)
  add_subdirectory(qt)
endif()


if(BUILD_KERNEL_LIB)
  add_subdirectory(kernel)
endif()

if(BUILD_UTIL_CHAINSTATE)
  add_executable(FlashCoin-chainstate
    FlashCoin-chainstate.cpp
  )
  # TODO: The `SKIP_BUILD_RPATH` property setting can be deleted
  #       in the future after reordering Guix script commands to
  #       perform binary checks after the installation step.
  # Relevant discussions:
  # - https://github.com/hebasto/FlashCoin/pull/236#issuecomment-2183120953
  # - https://github.com/FlashCoin/FlashCoin/pull/30312#issuecomment-2191235833
  set_target_properties(FlashCoin-chainstate PROPERTIES
    SKIP_BUILD_RPATH OFF
  )
  target_link_libraries(FlashCoin-chainstate
    PRIVATE
      core_interface
      FlashCoinkernel
  )
  install_binary_component(FlashCoin-chainstate INTERNAL)
endif()


add_subdirectory(test/util)
if(BUILD_BENCH)
  add_subdirectory(bench)
endif()

if(BUILD_TESTS)
  add_subdirectory(test)
endif()

if(BUILD_FUZZ_BINARY)
  add_subdirectory(test/fuzz)
endif()
