import db_postgres
import ../config


# Create Tables
conn.exec(sql("CREATE TABLE IF NOT EXISTS setting (chat_id varchar(256) NOT NULL, option varchar(256), PRIMARY KEY (chat_id));"))


# Function(s)
proc upsertSet*(chat_id: string, opt: string) =
    # Upsert Process
    conn.exec(sql"INSERT INTO setting (chat_id, option) VALUES (?, ?) ON CONFLICT (chat_id) DO UPDATE SET option = EXCLUDED.option", chat_id, opt)


proc getSet*(chat_id: string): string =
    # Get Value of Selected Chat Id
    conn.getValue(sql("SELECT option FROM setting WHERE chat_id =?"), chat_id)