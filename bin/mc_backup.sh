#!/bin/sh

set -eu

# 保持世代数 (reiからのssh実行でもここで上限を保証する)
keep=2
backup_dir="$HOME/minecraft_backups"
mkdir -p "$backup_dir"

tar -czf "$backup_dir/minecraft_backup-$(date "+%Y_%m_%d_%H_%M_%S").tar.gz" -C "$HOME" Minecraft

# ローテーション: 新しい順にkeep世代だけ残し、古いものを削除
ls -1t "$backup_dir" | grep -E "^minecraft_backup-.*\.tar\.gz$" | tail -n +$((keep + 1)) | while IFS= read -r f; do
  rm -f -- "$backup_dir/$f"
done
