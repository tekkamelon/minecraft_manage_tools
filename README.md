# minecraft_manage_tools
マインクラフトサーバーの管理用ツール集

`bin`以下に各スクリプトを配置しています。

## スクリプト一覧

### `mc_auto_stop.sh`

- `cron`で一定時間おきに実行する事を想定
- プレイヤー不在が1時間(3600秒)継続した場合に自動停止を実行
- 動作概要
    - `pgrep -f "java.*server.jar"`でサーバー起動有無を確認,停止中であれば`/tmp/minecraft_empty_since`を削除して終了
    - `rcon-cli "list"`でログイン中のプレイヤー数を取得
    - プレイヤー数0で`/tmp/minecraft_empty_since`が無ければ現在時刻を記録して監視開始
    - プレイヤー数0が継続し,経過時間が3600秒を超えたら`mc_stop.sh`で停止
    - `${HOME}/.discord_webhook`から`DISCORD_WEBHOOK_URL`を読み込み,Discord Webhookへ通知(Bot名`minecraft_manager`)
    - プレイヤーがログインしたら`/tmp/minecraft_empty_since`を削除して監視停止

### `mc_backup.sh`

- マインクラフトサーバーのバックアップを実行
- `~/minecraft_backups`を`mkdir -p`で作成後、`~/Minecraft`を`~/minecraft_backups/minecraft_backup-YYYY_MM_DD_HH_MM_SS.tar.gz`として`tar -czf`で圧縮保存
- 保存後に最新2世代のみ残して古いバックアップを削除(ローテーション)
- ローテーションはglob列挙 + ファイル名降順(`sort -r`) + `tail`による選別で実施(`ls`不使用)
- スクリプト内部で上限管理するため、`ssh`経由の実行でも世代上限を保証する

### `mc_backup_del_remote.sh`

- リモートサーバー(mutsumi)の10日前より古いバックアップを削除
- `rei`の`cron`から実行する事を想定
- 対象ゼロでも誤動作しないよう`xargs -r`を使用

### `mc_backup_del_local.sh`

- ローカル(`rei`の共有ストレージ)の30日前より古いバックアップを削除
- `rei`の`cron`から実行する事を想定
- `find -type f -mtime +30 -exec rm -f -- {} +`で削除(`xargs`不使用、特殊文字名対応、対象ゼロでも正常終了)

### `mc_discord_bot.py`

- Discord Bot本体(`discord.py`,スラッシュコマンド方式)
- 必要な環境変数
    - `DISCORD_BOT_TOKEN`: Botのトークン(未設定時はエラー終了)
    - `MINECRAFT_ROLE`: 実行を許可するロール名(既定値`crafter`)
    - `DEV_GUILD_ID`: 設定時は開発用ギルドへ即時同期,未設定時はグローバル同期
- コマンドはいずれも`crafter`ロール(または`MINECRAFT_ROLE`指定ロール)必須
    - `/start`
        - `mc_start.sh`を呼び出してサーバーを起動
    - `/stop`
        - `mc_stop.sh`を呼び出してサーバーを停止
    - `/status`
        - `mc_status.sh`を呼び出して結果をそのままDiscordへ返信
- 実行ログをコンソールへ出力(実行日時,実行ユーザー,標準出力)

### `mc_start.sh`

- `tmux`セッション`minecraft`内でマインクラフトサーバーを起動
- 動作概要
    - セッション`minecraft`が無ければ作成し,作業ディレクトリを`${HOME}/Minecraft`に移動
    - `pgrep -f "java.*server.jar"`で二重起動を防止(起動済みならエラー終了)
    - `java -Xmx12G -Xms3G -jar server.jar nogui`を`tmux send-keys`で実行
    - 最大30秒間起動を待機,成功で`マインクラフトサーバーを起動しました`,タイムアウトでエラー終了

### `mc_status.sh`

- マインクラフトサーバーのステータスを確認
- 停止中であれば`マインクラフトサーバーは起動していません`を標準エラー出力してエラー終了
- 起動中の場合,以下の内容を出力
    - 起動からの経過時間(`ps -p <PID> -o etime=`,PIDは`pgrep -f "java.*server.jar"`で取得)
    - サーバーのバージョン(`${HOME}/Minecraft/logs/latest.log`から取得)
    - ログイン中プレイヤー(`rcon-cli "list"`の結果)
    - シード値(`rcon-cli "seed"`の結果)

### `mc_stop.sh`

- 起動中のマインクラフトサーバーを停止
- 動作概要
    - `pgrep -f "java.*server.jar"`で起動確認,停止済みならエラー終了
    - `rcon-cli "list"`でログイン中プレイヤーを確認,1人でもいれば一覧を表示して停止を拒否
    - プレイヤー不在時のみ`rcon-cli "stop"`を送信して停止

### `start-tmux.sh`

- マシンの起動時に`systemd`から実行する事を想定
- 以下の`tmux`セッションを起動
    - minecraft
        - マインクラフトサーバーを起動するためのセッション,作業ディレクトリを`/home/tekkamelon/Minecraft`に移動
    - bot
        - `mc_discord_bot.py`を実行するためのセッション
    - edit
        - 作業用
- 補足
    - `PATH`,`TERM`,`HOME`を明示的に設定
    - `tmux start-server`後に3セッションを作成,失敗時の標準エラー出力は`/tmp/tmux-mysession-error.log`へ追記
