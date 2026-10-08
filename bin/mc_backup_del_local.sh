#!/bin/sh

set -eu
set -xv

# ローカルの30日前のバックアップを削除
find /srv/dev-disk-by-uuid-d94137ca-68ab-4cab-8621-085596ec7d58/my_vault/archives/minecraft/ -mtime +30 -type f | xargs -r rm
