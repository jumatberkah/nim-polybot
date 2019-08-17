import dotenv
import os
import telebot
import db_postgres
import logging
from strutils import parseInt, replace, split

# Logging
var L = newConsoleLogger(fmtStr="$levelname, [$time] ")
addHandler(L)

# Load .env file
let env = initDotEnv()
env.load()

# Load Evironment Vars
var apiKey* = os.getEnv("API_KEY", "")
var owner* = os.getEnv("OWNER_ID", "")
var sudos*: seq[int]
if ',' in os.getEnv("SUDOS", ""):
    for sudo in os.getEnv("SUDOS", "").split(","):
        if ' ' in sudo:
            sudos.add(parseInt(sudo.replace(" ", "")))
        else:
            sudos.add(parseInt(sudo))
else:
    sudos.add(parseInt(os.getEnv("SUDOS", "")))
var logid* = os.getEnv("LOG_ID", "")
var pghost* = os.getEnv("PGHOST", "")
var pguser* = os.getEnv("PGUSER", "")
var pgdb* = os.getEnv("PGDB", "")
var pgpasswd* = os.getEnv("PGPASS", "")

# DB Connection
let conn* = open(pghost, pguser, pgpasswd, pgdb)
