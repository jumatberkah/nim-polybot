import db_postgres
import ../config


# Create Tables
conn.exec(sql("CREATE TABLE IF NOT EXISTS spamuser (user_id int NOT NULL, reason varchar(256), PRIMARY KEY (user_id));"))
conn.exec(sql("CREATE TABLE IF NOT EXISTS spamchat (chat_id varchar(256) NOT NULL, reason varchar(256), PRIMARY KEY (chat_id));"))


# Functions=(s)
proc insertFban*(user_id: int, reason: string) =
    # Upsert Data
    conn.exec(sql"INSERT INTO spamuser (user_id, reason) VALUES (?, ?) ON CONFLICT (user_id) DO UPDATE SET reason = EXCLUDED.reason", user_id, reason)


proc insertFbanChat*(chat_id: string, reason: string) =
    # Upsert Data
    conn.exec(sql"INSERT INTO spamchat (chat_id, reason) VALUES (?, ?) ON CONFLICT (chat_id) DO UPDATE SET reason = EXCLUDED.reason", chat_id, reason)  


proc deleteFban*(user_id: int) =
    # Delete Data
    conn.exec(sql"DELETE FROM spamuser WHERE user_id=?;", user_id)


proc deleteFbanChat*(chat_id: string) =
    # Delete Data
    conn.exec(sql"DELETE FROM spamchat WHERE chat_id=?;", chat_id)


proc isSpammer*(user_id: int) : string =
    # Get Data
    var isSpam = conn.getValue(sql("SELECT user_id FROM spamuser WHERE user_id =?"), user_id)
    return isSpam