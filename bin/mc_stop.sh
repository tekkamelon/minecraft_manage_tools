#!/bin/sh 

set -eu
set -xv

# セッション名
session_name="minecraft"

# "minecraft"セッションの有無を確認
if tmux has-session -t "${session_name}" 2>/dev/null; then

    # セッションが存在する場合の処理
	# マインクラフトサーバーに"stop"コマンドを送る
    tmux send-keys -t "${session_name}" "stop" C-m

else

    # セッションが存在しない場合はエラーメッセージを出力
    echo "セッション '${session_name}' が見つかりません。" 1>&2

    exit 1

fi

