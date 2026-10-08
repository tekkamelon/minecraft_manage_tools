#!/bin/sh

set -eu
set -xv

# リモートサーバーの10日前のバックアップを削除
ssh -i /home/tekkamelon/.ssh/id_ed25519 tekkamelon@100.71.150.10 'find /home/tekkamelon/minecraft_backups/ -mtime +10 -type f | xargs -r rm'
