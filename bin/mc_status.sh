#!/bin/sh 

set -u

# マイクラサーバーのプロセスIDを取得
mc_proc="$(pgrep -f "java.*server.jar")"
# 取得したプロセスIDから起動してからの経過時間を取得,不要な空白を削除
uptime="$(ps -p "${mc_proc}" -o etime= | tr -d ' ')"

set -e

# マイクラサーバーが起動していれば真
if [ -n "${mc_proc}" ]; then

	# ログからバージョンを取得
	version="$(grep < "${HOME}/Minecraft/logs/latest.log" -F "version" | cut -d ' ' -f7-)"

	# ログイン中のプレイヤー
	player="$(rcon-cli "list")"

	# シード値
	seed="$(rcon-cli "seed")"

	# 出力
	cat <<- EOF
	## === Minecraft Server Status ===

	### 起動からの経過時間
	${uptime}
	### バージョン
	${version}
	### ログイン中のプレイヤー
	${player}
	### シード値
	${seed}
	EOF

else

	# エラーメッセージを出力
	echo "Server is Down!" 1>&2
	exit 1

fi

