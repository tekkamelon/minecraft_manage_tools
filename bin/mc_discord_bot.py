#!/usr/bin/env python3

from discord.ext import commands
import discord
from discord import app_commands
import subprocess
import os


# intentの設定
# BotがDiscordから受け取る情報を明示
intents = discord.Intents.default()
# メッセージの内容を読み取るために必要
intents.message_content = True

# Botの初期化時にintentsを指定
bot = commands.Bot(command_prefix='!', intents=intents)


@bot.event
async def on_ready():
    print(f'{bot.user} has connected to Discord!')
    # グローバル同期（時間がかかる場合あり）
    try:
        synced = await bot.tree.sync()
        print(f'Synced {len(synced)} command(s) globally')
    except Exception as e:
        print(f'Global sync error: {e}')

    # スラッシュコマンドを即座に表示させるため、ギルド限定同期を有効化してください。
        # 以下のYOUR_GUILD_IDを実際のDiscordサーバー（ギルド）のIDに置き換えてください。
        # ギルドIDの取得方法: Discordでサーバー名を右クリック → 'サーバー設定をコピー' → IDを確認
        # 開発中はギルド限定同期を使用するとコマンドがすぐに表示されます。
        # guild = discord.Object(id=YOUR_GUILD_ID)  # ← ここを実際のIDに変更
        # synced = await bot.tree.sync(guild=guild)
        # print(f'Synced {len(synced)} command(s) to guild')
    
        # テスト手順:
        # 1. discord.pyがインストールされているか確認: pip install -U discord.py (バージョン2.0以上推奨)
        # 2. ボットを起動し、コンソールで同期メッセージを確認
        # 3. Discordサーバーで/start, /stop, /statusが表示されるか確認
        # 4. コマンドを実行し、シェルスクリプトが正しく動作するかテスト
        # 5. 問題がある場合、グローバル同期の代わりにギルド同期を有効化


# コマンドの定義
# !startmc コマンドでサーバーを起動するシェルスクリプトを起動
@app_commands.command(name="start", description="マインクラフトサーバーを起動します")
async def start(interaction: discord.Interaction):
    try:
        subprocess.run(
            # サーバー起動用のシェルスクリプト
            ['bash', 'mc_start.sh'],
            check=True,
            # 標準出力,標準エラー出力をキャプチャ
            capture_output=True,
            # 出力を文字列として扱う
            text=True
        )
        await interaction.response.send_message('マインクラフトサーバーを起動しました！')
    except subprocess.CalledProcessError as bash_error:
        # エラーメッセージにコードブロックを使用
        error_message = f'起動時にエラーが発生しました:\n```{bash_error.stderr}```'
        await interaction.response.send_message(error_message)


# !stopmc コマンドでサーバーを停止するシェルスクリプトを起動
@app_commands.command(name="stop", description="マインクラフトサーバーを停止します")
async def stop(interaction: discord.Interaction):
    try:
        subprocess.run(
            # サーバー停止用のシェルスクリプト
            ['bash', 'mc_stop.sh'],
            check=True,
            capture_output=True,
            text=True
        )
        await interaction.response.send_message('マインクラフトサーバーを停止しました！')
    except subprocess.CalledProcessError as bash_error:
        error_message = f'停止時にエラーが発生しました:\n```{bash_error.stderr}```'
        await interaction.response.send_message(error_message)


# !status コマンドでサーバーの状態を取得するシェルスクリプトを起動
@app_commands.command(name="status", description="マインクラフトサーバーの状態を取得します")
async def status(interaction: discord.Interaction):
    try:
        # シェルスクリプトの実行結果を取得
        result = subprocess.run(
            # サーバー状態取得用のシェルスクリプト
            ['bash', 'mc_status.sh'],
            check=True,
            capture_output=True,
            text=True
        )
        await interaction.response.send_message(f'{result.stdout}')
    except subprocess.CalledProcessError as bash_error:
        error_message = f'状態取得時にエラーが発生しました:\n```{bash_error.stderr}```'
        await interaction.response.send_message(error_message)

# スラッシュコマンドをbot.treeに追加
bot.tree.add_command(start)
bot.tree.add_command(stop)
bot.tree.add_command(status)

# Botの起動

# 環境変数"DISCORD_BOT_TOKEN"を読み取る
token = os.getenv('DISCORD_BOT_TOKEN')

# 環境変数が設定されていなければ真
if token is None:
    # エラーメッセージを表示
    print('環境変数"DISCORD_BOT_TOKEN"が設定されていません')
    exit(1)
else:
    # botを起動
    bot.run(token)
