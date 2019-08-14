import db_postgres
import ../config


# Create Tables
conn.exec(sql("CREATE TABLE IF NOT EXISTS timeset (chat_id varchar(256) NOT NULL, time varchar(256), PRIMARY KEY (chat_id));"))


# Function(s)
proc upsertTime*(chat_id: string, time: string) =
    # Upsert Process
    conn.exec(sql"INSERT INTO timeset (chat_id, time) VALUES (?, ?) ON CONFLICT (chat_id) DO UPDATE SET time = EXCLUDED.time", chat_id, time)


proc getTime*(chat_id: string): string =
    # Get Value of Selected Chat Id
    conn.getValue(sql("SELECT time FROM timeset WHERE chat_id =?"), chat_id)