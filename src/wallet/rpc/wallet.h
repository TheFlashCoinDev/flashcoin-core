// Copyright (c) 2016-present The FlashCoin developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef FlashCoin_WALLET_RPC_WALLET_H
#define FlashCoin_WALLET_RPC_WALLET_H

#include <span.h>

class CRPCCommand;

namespace wallet {
std::span<const CRPCCommand> GetWalletRPCCommands();
} // namespace wallet

#endif // FlashCoin_WALLET_RPC_WALLET_H
