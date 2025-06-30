#!/bin/sh 

set -u

# マイクラサーバーのプロセスを取得
mc_proc=$(pgrep -f "java.*server.jar")

set -e

# マイクラサーバーが起動していれば真
if [ -n "${mc_proc}" ]; then

	# ログイン中のプレイヤー
	player=$(rcon-cli "list")

	# ログからバージョンを取得
	version=$(grep < "${HOME}/Minecraft/logs/latest.log" -F "version" | cut -d ' ' -f7-)
	# シード値
	seed=$(rcon-cli "seed")


	# 出力
	cat <<- EOF
	# === Minecraft Server Status ===

	### Version 
	${version}

	### Players 
	${player}

	### Seed
	${seed}
	EOF

else

	# エラーメッセージを出力
	echo "Server is Down!" 1>&2
	exit 1

fi
