# minecraft_manage_tools
マインクラフトサーバーの管理用ツール集

## スクリプト一覧

### `mc_auto_stop.sh`

- `/usr/local/bin`に配置
- `cron`で一定時間おきに実行
- マインクラフトサーバーの自動停止処理を実行

### `mc_backup.sh`

- マインクラフトサーバーのバックアップを実行

### `mc_discord_bot.py`

- Discord Bot

- Discordからマインクラフトサーバーを操作するスクリプトを実行

    - `!startmc`
        - Discordから`mc_start.sh`を呼び出す
    - `!stopmc`
        - Discordから`mc_stop.sh`を呼び出す

### `mc_start.sh`

- `tmux`セッション内でマインクラフトサーバーを起動

### `mc_status.sh`

- マインクラフトサーバーのステータスを確認

    - 起動からの経過時間
    - サーバーのバージョン
    - ログインプレイヤー数及びプレイヤー名
    - シード値

### `mc_stop.sh`

- 起動中のマインクラフトサーバーを停止

### `start-tmux.sh`

- マシンの起動時に`systemd`から実行

- 以下の`tmux`セッションを起動

    - minecraft
        - マインクラフトサーバーを自動するためのセッション

    - bot
        - `mc_discord_bot.py`を実行するためのセッション

    - edit
        - 作業用

