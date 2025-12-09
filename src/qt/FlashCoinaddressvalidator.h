// Copyright (c) 2011-2020 The FlashCoin developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef FlashCoin_QT_FlashCoinADDRESSVALIDATOR_H
#define FlashCoin_QT_FlashCoinADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class FlashCoinAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit FlashCoinAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

/** FlashCoin address widget validator, checks for a valid FlashCoin address.
 */
class FlashCoinAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit FlashCoinAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

#endif // FlashCoin_QT_FlashCoinADDRESSVALIDATOR_H
