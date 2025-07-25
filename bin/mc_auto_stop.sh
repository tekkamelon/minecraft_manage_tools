#!/bin/sh

# ===== 変数の設定 =====
set -u

# 自作コマンドのPATHを通す
export PATH="${PATH}":/home/tekkamelon/.local/bin/

# 環境変数"DISCORD_WEBHOOK_URL"を読み取る
discord_webhook_url="DISCORD_WEBHOOK_URL"

# Discord Botの名前
bot_name="minecraft_manager"

# プレイヤーがいない状態の開始時間を記録するタイムスタンプファイルのパス
timestamp_file="/tmp/minecraft_empty_since"

# サーバーが落ちていればタイムスタンプを削除
if ! pgrep -f "java.*server.jar" > /dev/null; then

    rm -f "${timestamp_file}"
    exit 0

else

	# 現在ログイン中のプレイヤー数を取得
	player_count="$(rcon-cli "list" | grep -F "There are" | cut -d ' ' -f3)"

fi
# ===== 変数の設定ここまで =====


# プレイヤー数が0以下であれば真
if [ "${player_count}" -le 0 ]; then

    # タイムスタンプファイルが存在しない場合は作成
    if [ ! -f "${timestamp_file}" ]; then

        echo "プレイヤーが0人になったため自動停止の監視を開始"
        date +%s > "${timestamp_file}"

	# タイムスタンプファイルが存在する場合
    else

        # タイムスタンプファイルから開始時間を読み込む
        start_time="$(cat "${timestamp_file}")"
		
		# 現在の時刻を取得
        current_time="$(date +%s)"

        # 経過時間を計算
        elapsed_time="$((current_time - start_time))"

        # 経過時間が3600秒 (60分) を超えているか確認
        if [ "${elapsed_time}" -gt 3600 ]; then

            # Discordへ通知するメッセージ
            message="1時間以上プレイヤー不在のため自動停止"

			# サーバー停止(予めmc_stop.shをパスの通ったディレクトリに配置)
            mc_stop.sh

            # Discord WebhookでメッセージをPOST
			curl -X POST  "${discord_webhook_url}" -H "Content-Type: application/json" -d @- <<-EOS
				{

					"username": "${bot_name}",
					"content": "${message}"

				}
			EOS

            # タイムスタンプファイルを削除
            rm -f "${timestamp_file}"

            # メッセージを出力
            echo "${message}"

       fi

    fi

# プレイヤーがいる場合はタイムスタンプファイルが存在すれば削除
elif [ -f "${timestamp_file}" ] ; then

    echo "プレイヤーがログインしたため自動停止の監視を停止"

	# タイムスタンプファイルを削除
    rm -f "${timestamp_file}"

fi

