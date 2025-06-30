#!/usr/bin/env python3

from discord.ext import commands
import discord
import subprocess


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


# コマンドの定義
# !startmc コマンドでサーバーを起動するシェルスクリプトを起動
@bot.command(name='startmc')
# サーバーの全員に許可
@commands.has_role('@everyone')
# !startmcコマンドを定義
async def start_mc(ctx):
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
        await ctx.send('マインクラフトサーバーを起動しました！')
    except subprocess.CalledProcessError as bash_error:
        # エラーメッセージにコードブロックを使用
        error_message = f'起動時にエラーが発生しました:\n```{bash_error.stderr}```'
        await ctx.send(error_message)


# !stopmc コマンドでサーバーを停止するシェルスクリプトを起動
@bot.command(name='stopmc')
@commands.has_role('@everyone')
# !stopmcコマンドを定義
async def stop_mc(ctx):
    try:
        subprocess.run(
            # サーバー停止用のシェルスクリプト
            ['bash', 'mc_stop.sh'],
            check=True,
            capture_output=True,
            text=True
        )
        await ctx.send('マインクラフトサーバーを停止しました！')
    except subprocess.CalledProcessError as bash_error:
        error_message = f'停止時にエラーが発生しました:\n```{bash_error.stderr}```'
        await ctx.send(error_message)


# !status コマンドでサーバーの状態を取得するシェルスクリプトを起動
@bot.command(name='status')
@commands.has_role('@everyone')
# !statusコマンドを定義
async def status_mc(ctx):
    try:
        # シェルスクリプトの実行結果を取得
        result = subprocess.run(
            # サーバー状態取得用のシェルスクリプト
            ['bash', 'mc_status.sh'],
            check=True,
            capture_output=True,
            text=True
        )
        # 出力にコードブロックを使用
        await ctx.send(f'```{result.stdout}```')
    except subprocess.CalledProcessError as bash_error:
        error_message = f'状態取得時にエラーが発生しました:\n```{bash_error.stderr}```'
        await ctx.send(error_message)

# Botの起動
# 'YOUR_DISCORD_BOT_TOKEN'にDiscord Botのトークンを入れる
bot.run(
    'YOUR_DISCORD_BOT_TOKEN'
)
