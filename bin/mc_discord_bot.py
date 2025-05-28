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
            ['bash', '/home/tekkamelon/Documents/script/mc_start.sh'],
            check=True
        )
        await ctx.send('マインクラフトサーバーを起動しました！')
    except subprocess.CalledProcessError as bash_error:
        await ctx.send(f'起動時にエラーが発生しました: {str(bash_error)}')


# !stopmc コマンドでサーバーを停止するシェルスクリプトを起動
@bot.command(name='stopmc')
@commands.has_role('@everyone')
# !stopmcコマンドを定義
async def stop_mc(ctx):
    try:
        subprocess.run(
            # サーバー停止用のシェルスクリプト
            ['bash', '/home/tekkamelon/Documents/script/mc_stop.sh'],
            check=True
        )
        await ctx.send('マインクラフトサーバーを停止しました！')
    except subprocess.CalledProcessError as bash_error:
        await ctx.send(f'停止時にエラーが発生しました: {str(bash_error)}')

bot.run(
    'YOUR_DISCORD_BOT_TOKEN'
)
