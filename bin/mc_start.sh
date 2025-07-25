#!/bin/sh

set -u

# セッション名
session_name="minecraft"
# 起動時RAMサイズ
ram_size="12G"

set -e

# マイクラサーバーのプロセスをチェックする関数
is_minecraft_running() {

	pgrep -f "java.*server.jar" > /dev/null 2>&1

}

# セッションが存在しなければ作成
if ! tmux has-session -t "${session_name}" 2>/dev/null; then

	tmux new-session -d -s "${session_name}"
fi

# マイクラサーバーが既に起動していればエラー終了
if is_minecraft_running; then

	echo "マインクラフトサーバーは既に起動しています" 1>&2
	exit 1

fi

# サーバー起動
echo "マインクラフトサーバーを起動中..."
tmux send-keys -t "${session_name}" "java -Xmx${ram_size} -Xms${ram_size} -jar server.jar nogui" C-m

# 起動待機(最大30秒)
timeout=30
# 経過時間
elapsed_time=0

# 30秒間マイクラサーバーが起動するか確認
while [ "${elapsed_time}" -lt "${timeout}" ]; do

	if is_minecraft_running; then

		echo "マインクラフトサーバーを起動しました"
		exit 0

	fi

	sleep 1

	# 経過時間を加算
	elapsed_time="$((elapsed_time + 1))"

done

echo "マインクラフトサーバーの起動に失敗しました（タイムアウト）" 1>&2
exit 1

