#!/bin/sh 

set -eu
# set -xv

# ログイン中のプレイヤー
player=$(rcon-cli "list" | awk -F ': ' '{print $2}')

# マイクラサーバーが停止していれば真
if ! pgrep -f "java.*server.jar" > /dev/null; then

	echo "マインクラフトサーバーは既に停止しています" 1>&2

# ログインしているプレイヤーがいない場合
elif [ -n "${player}" ]; then

	# エラーメッセージとプレイヤーを出力
	{ echo "サーバーにログイン中のプレイヤーがいます" ; rcon-cli "list" ; } 1>&2
	exit 1

else

	# マインクラフトサーバーに"stop"コマンドを送る
    rcon-cli "stop"

fi

