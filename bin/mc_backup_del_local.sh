#!/bin/sh

set -eu

# ====== 変数の宣言 ======

target_dir="/srv/dev-disk-by-uuid-d94137ca-68ab-4cab-8621-085596ec7d58/my_vault/archives/minecraft/"

# ====== 変数の宣言ここまで ======

# 30日前バックアップの削除
find "${target_dir}" -type f -mtime +30 -exec rm -f -- {} +
