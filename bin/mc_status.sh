#!/bin/sh 

set -eu

# マイクラサーバーのプロセスIDを取得
mc_pid="$(pgrep -f "java.*server.jar" || true)"

# 取得したプロセスIDから起動してからの経過時間を取得,不要な空白を削除
if [ -n "${mc_pid}" ]; then

    uptime="$(ps -p "${mc_pid}" -o etime= | xargs || true)"

else

    uptime=""

fi

# マイクラサーバーが起動していれば真
if [ -n "${mc_pid}" ]; then

	# ログからバージョンを取得
	version="$(grep < "${HOME}/Minecraft/logs/latest.log" -F "version" | cut -d ' ' -f7-)"

	# ログイン中のプレイヤー
	logged_in_players="$(rcon-cli "list")"

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
	${logged_in_players}
	### シード値
	${seed}
	EOF

else

	# エラーメッセージを出力
	echo "マインクラフトサーバーは起動していません" 1>&2
	exit 1

fi

