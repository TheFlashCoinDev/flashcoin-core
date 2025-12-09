# Copyright (c) 2023-present The FlashCoin developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or https://opensource.org/license/mit/.

function(generate_setup_nsi)
  set(abs_top_srcdir ${PROJECT_SOURCE_DIR})
  set(abs_top_builddir ${PROJECT_BINARY_DIR})
  set(CLIENT_URL ${PROJECT_HOMEPAGE_URL})
  set(CLIENT_TARNAME "FlashCoin")
  set(FlashCoin_WRAPPER_NAME "FlashCoin")
  set(FlashCoin_GUI_NAME "FlashCoin-qt")
  set(FlashCoin_DAEMON_NAME "FlashCoind")
  set(FlashCoin_CLI_NAME "FlashCoin-cli")
  set(FlashCoin_TX_NAME "FlashCoin-tx")
  set(FlashCoin_WALLET_TOOL_NAME "FlashCoin-wallet")
  set(FlashCoin_TEST_NAME "test_FlashCoin")
  set(EXEEXT ${CMAKE_EXECUTABLE_SUFFIX})
  configure_file(${PROJECT_SOURCE_DIR}/share/setup.nsi.in ${PROJECT_BINARY_DIR}/FlashCoin-win64-setup.nsi USE_SOURCE_PERMISSIONS @ONLY)
endfunction()
