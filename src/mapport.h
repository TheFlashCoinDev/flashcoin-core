// Copyright (c) 2011-2020 The FlashCoin developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef FlashCoin_MAPPORT_H
#define FlashCoin_MAPPORT_H

static constexpr bool DEFAULT_NATPMP = true;

void StartMapPort(bool enable);
void InterruptMapPort();
void StopMapPort();

#endif // FlashCoin_MAPPORT_H
