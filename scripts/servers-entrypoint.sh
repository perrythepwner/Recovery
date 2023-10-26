#!/bin/bash

set -e
set -o errexit

echo "\n[*] Preparing..."
export PATH="/bitcoin-core/bin:$PATH"
mkdir -p /var/log/chall
mkdir -p /wallets 
mkdir -p /seeds

echo "\n[*] Starting bitcoin daemon..."
bitcoind -printtoconsole

echo "\n[*] Starting electrs server..."
electrs --conf=electrs.conf >> /var/log/chall/electrs.log &
export ELECTRS_PID=$!

echo "\n[*] Starting electrum daemon..."
electrum --regtest daemon -d --oneserver --server 127.0.0.1:$ELECTRS_PORT:t

echo "\n[*] Creating bank wallet & save seed..."
electrum --regtest create -w /wallets/bank | jq -r '.["seed"]' > /seeds/bank

echo "\n[*] Generating 101 blocks..."
electrum --regtest load_wallet -w /wallets/bank
export BANK_ADDR="$(electrum --regtest listaddresses -w /wallets/bank | jq -r '.[0]')"
bitcoin-cli generatetoaddress 101 $BANK_ADDR

echo "\n[*] Creating hacker wallet & save seed..."
electrum --regtest create -w /wallets/hacker | jq -r '.["seed"]' > /seeds/hacker
cp /seeds/hacker /shared/electrum-wallet-seed.txt

echo "\n[*] Sending 1 BTC to hacker wallet..."
electrum --regtest load_wallet -w /wallets/hacker
export HACKER_ADDR="$(electrum --regtest listaddresses -w /wallets/hacker | jq -r '.[0]')"
sleep 0.5
echo "[DEBUG] Bank balance: $(electrum --regtest getbalance -w /wallets/bank)"
echo "[DEBUG] Hacker address: $HACKER_ADDR"
SIGNED_TX=$(electrum --regtest payto $HACKER_ADDR 1 -w /wallets/bank)
electrum --regtest broadcast $SIGNED_TX

echo "\n[*] Mining 1 block to confirm transaction..."
bitcoin-cli generatetoaddress 1 $BANK_ADDR

echo "\n[*] Starting controller server..."
python3 /server.py >> /var/log/chall/server.log &
export SERVER_PID=$!

echo "\n[*] Finished setting up. Now mining block every 60 seconds."
/bin/sh /generate_blocks.sh