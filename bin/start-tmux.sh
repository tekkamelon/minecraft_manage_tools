#!/bin/sh

set -eu
set -xv

# 環境変数を設定
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/tekkamelon/.local/bin
export TERM=xterm-256color
export HOME=/home/tekkamelon

# tmuxを起動
/usr/bin/tmux start-server

# セッションを作成,エラー出力のみをログに出力
{ 

	/usr/bin/tmux new-session -d -s minecraft 
	/usr/bin/tmux new-session -d -s bot
	/usr/bin/tmux new-session -d -s edit

} 2>> /tmp/tmux-mysession-error.log

# マインクラフトサーバーのセッションでの作業ディレクトリを設定
tmux send-keys -t minecraft "cd /home/tekkamelon/Minecraft" C-m
# discord botを起動
tmux send-keys -t bot "mc_discord_bot.py" C-m

exit 0

