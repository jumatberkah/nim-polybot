import dotenv
import os
from strutils import parseInt, replace, split
import telebot
import db_postgres

let env = initDotEnv()
env.load()

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

var pghost* = os.getEnv("PGHOST", "")
var pguser* = os.getEnv("PGUSER", "")
var pgdb* = os.getEnv("PGDB", "")
var pgpasswd* = os.getEnv("PGPASS", "")

let conn* = open(pghost, pguser, pgpasswd, pgdb)