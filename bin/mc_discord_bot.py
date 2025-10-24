#!/usr/bin/env python3

from discord.ext import commands
import discord
# from discord import app_commands
import subprocess
import os


# intentの設定
# BotがDiscordから受け取る情報を明示
intents = discord.Intents.default()
# メッセージの内容を読み取るために必要
intents.message_content = True

# Botの初期化時にintentsを指定
client = commands.Bot(command_prefix='!', intents=intents)


# Botのイベントハンドラー
@client.event
async def on_ready():
    print(f'{client.user} has connected to Discord!')
    # すべてのコマンドをクリア
    client.tree.clear_commands(guild=None)
    # スラッシュコマンドを同期
    await client.tree.sync()
    print('スラッシュコマンドを同期しました')


# コマンドの定義
# /start コマンドでサーバーを起動するシェルスクリプトを起動
@client.tree.command(name="start", description="マインクラフトサーバーを起動します")
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


# /stop コマンドでサーバーを停止するシェルスクリプトを起動
@client.tree.command(name="stop", description="マインクラフトサーバーを停止します")
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


# /status コマンドでサーバーの状態を取得するシェルスクリプトを起動
@client.tree.command(name="status", description="マインクラフトサーバーの状態を取得します")
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
    client.run(token)
