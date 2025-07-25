#!/bin/sh 

set -u

# セッション名
session_name="minecraft"
# 起動時RAMサイズ
ram_size="12G"

# マイクラサーバーのプロセスをチェックする関数
is_minecraft_running() {

	pgrep -f "java.*server.jar" > /dev/null 2>&1

}

set -e

# セッションが存在しなければ作成
if ! tmux has-session -t "${session_name}" 2>/dev/null ; then

	tmux new-session -d -s "${session_name}"

fi

# マイクラサーバーがすでに起動していれば真
if [ -n "${mc_proc}" ]; then

	echo "マインクラフトサーバーは既に起動しています" 1>&2
	exit 1

else

	# セッション内でコマンドを実行
	tmux send-keys -t "${session_name}" "java -Xmx${ram_size} -Xms${ram_size} -jar server.jar nogui" C-m
	
	sleep 5

	set +e
	
	# マイクラサーバーが起動していれば真
	if is_minecraft_running ; then

		echo "マインクラフトサーバーを起動しました"
		
	else

		echo "マインクラフトサーバーの起動に失敗しました" 1>&2
		exit 1

	fi

fi

