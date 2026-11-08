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

	# ワールドの昼夜(daytime tick)
	# 26.1以降はtime query minecraft:day,26.1未満はtime query daytime
	daytime_response="$(rcon-cli "time query minecraft:day" || true)"
	daytime="$(printf '%s\n' "${daytime_response}" | awk 'END {print $NF}')"

	# 26.1以降の構文で数値が取れなければ26.1未満の構文で再取得
	case "${daytime}" in
		''|*[!0-9]*)

			daytime_response="$(rcon-cli "time query daytime" || true)"
			daytime="$(printf '%s\n' "${daytime_response}" | awk 'END {print $NF}')"

			;;
	esac

	# 応答末尾が数値でなければ取得失敗
	case "${daytime}" in
		''|*[!0-9]*) daytime="" ;;
	esac

	# daytime tickから昼夜とゲーム内時刻を算出
	if [ -z "${daytime}" ]; then

		world_time="取得できませんでした"

	else

		# 1日は24000tick,0が夜明け(06:00),12000が日没(18:00)
		mc_hour="$(( (daytime / 1000 + 6) % 24 ))"
		mc_minute="$(( (daytime % 1000) * 6 / 100 ))"

		if [ "${daytime}" -lt 12000 ]; then

			day_night="昼"

		else

			day_night="夜"

		fi

		world_time="$(printf '%s (ゲーム内時刻 %02d:%02d / daytime %s)' \
			"${day_night}" "${mc_hour}" "${mc_minute}" "${daytime}")"

	fi

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
	### ワールドの昼夜
	${world_time}
	EOF

else

	# エラーメッセージを出力
	echo "マインクラフトサーバーは起動していません" 1>&2
	exit 1

fi

