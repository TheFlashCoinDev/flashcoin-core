// Copyright (c) 2023-present The FlashCoin developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef FlashCoin_TEST_UTIL_JSON_H
#define FlashCoin_TEST_UTIL_JSON_H

#include <univalue.h>

#include <string_view>

UniValue read_json(std::string_view jsondata);

#endif // FlashCoin_TEST_UTIL_JSON_H
