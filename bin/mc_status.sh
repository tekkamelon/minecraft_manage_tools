#!/bin/sh 

set -eu

# === 変数の定義 ===
# ログイン中のプレイヤー
player=$(rcon-cli "list")
# ログからバージョンを取得
version=$(grep < "${HOME}/Minecraft/logs/latest.log" - F "version" | cut -d ' ' -f7-)
# シード値
seed=$(rcon "seed")
# === 変数の定義ここまで ===


# 出力
cat <<EOF
# === Minecraft Server Status ===

### Version 
${version}

### Players 
${player}

### Seed
${seed}
EOF

