# minecraft_manage_tools
マインクラフトサーバーの管理用ツール集

## mc_backup.sh

- マイクラサーバーのバックアップを実行

## mc_diacord_bot.py

- Discord Bot

- Discordからマイクラサーバーを操作するスクリプトを実行

    - `!startmc`

        - Discordから`mc_start.sh`を呼び出す

    - `!stopmc`

        - Discordから`mc_stop.sh`を呼び出す

## mc_start.sh

- `tmux`セッション内でマイクラサーバーを起動

## mc_stop.sh

- 上記スクリプトで実行したマイクラサーバーを停止

## start-tmux.sh

- マシンの起動時に`systemd`から実行

- 実行するセッション

    - マイクラサーバー

    - Discord Bot

    - 作業用
