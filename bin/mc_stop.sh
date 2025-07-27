#!/bin/sh 

set -eu

# マイクラサーバーのプロセスを取得
mc_pid="$(pgrep -f "java.*server.jar" || true)"

# マイクラサーバーが停止していれば真
if [ -z "${mc_pid}" ]; then

	echo "マインクラフトサーバーは既に停止しています" 1>&2
	exit 1

fi

# ログイン中のプレイヤー
logged_in_players="$(rcon-cli "list" | awk -F ': ' '{print $2}' || true)"

# ログインしているプレイヤーがいない場合
if [ -n "${logged_in_players}" ]; then

	# エラーメッセージとプレイヤーを出力
	{ echo "サーバーにログイン中のプレイヤーがいます" ; rcon-cli "list" ; } 1>&2
	exit 1

else

	# マインクラフトサーバーに"stop"コマンドを送る
	rcon-cli "stop"

fi

