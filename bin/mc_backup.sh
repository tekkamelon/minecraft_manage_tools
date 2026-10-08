#!/bin/sh

set -eu

# ====== 変数の宣言 ======

keep=2
backup_dir="${HOME}/minecraft_backups"

# ====== 変数の宣言ここまで ======

# バックアップ格納先の作成
mkdir -p "${backup_dir}"

# バックアップの取得
tar -czf "${backup_dir}/minecraft_backup-$(date "+%Y_%m_%d_%H_%M_%S").tar.gz" -C "${HOME}" Minecraft

# 古い世代の削除 (ファイル名降順でのローテーション)
for candidate in "${backup_dir}"/minecraft_backup-*.tar.gz; do
    [ -e "${candidate}" ] || continue

    case "${candidate}" in
        "${backup_dir}"/minecraft_backup-*.tar.gz)
            printf '%s\n' "${candidate}"
            ;;
    esac
done | sort -r | tail -n +$((keep + 1)) | while IFS= read -r target; do
    rm -f -- "${target}"
done
