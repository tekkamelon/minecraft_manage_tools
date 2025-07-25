#!/bin/sh 

set -u

# セッション名
session_name="minecraft"
# 起動時RAMサイズ
ram_size="12G"
# マイクラサーバーのプロセスを取得
mc_proc="$(pgrep -f "java.*server.jar")"

set -e

# セッションをデタッチ状態で起動,既にセッションがあれば何もしない
if ! tmux has-session -t "${session_name}" 2>/dev/null ; then

	:
else

	tmux new-session -d -s "${session_name}"

fi

# マイクラサーバーが起動していれば真
if [ -n "${mc_proc}" ]; then

	# マイクラサーバーが起動していればエラーメッセージを出力
    echo "マインクラフトサーバーは既に起動しています" 1>&2
	exit 1

else

	# セッション内でコマンドを実行
	tmux send-keys -t "${session_name}" "java -Xmx${ram_size} -Xms${ram_size} -jar server.jar nogui" C-m

fi

