#!/bin/sh 

set -u

# マイクラサーバーのプロセスを取得
mc_proc="$(pgrep -f "java.*server.jar")"

# ログイン中のプレイヤー
player="$(rcon-cli "list" | awk -F ': ' '{print $2}')"

set -e

# マイクラサーバーが停止していれば真
if [ -z "${mc_proc}" ]; then

	echo "マインクラフトサーバーは既に停止しています" 1>&2
	exit 1

# ログインしているプレイヤーがいない場合
elif [ -n "${player}" ]; then

	# エラーメッセージとプレイヤーを出力
	{ echo "サーバーにログイン中のプレイヤーがいます" ; rcon-cli "list" ; } 1>&2
	exit 1

else

	# マインクラフトサーバーに"stop"コマンドを送る
    rcon-cli "stop"

fi

