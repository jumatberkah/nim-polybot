import ../config
import db_postgres


# Create Tables
conn.exec(sql("CREATE TABLE IF NOT EXISTS loguser (user_id int NOT NULL, username varchar(256), firstname varchar(256), lastname varchar(256), PRIMARY KEY (user_id));"))
conn.exec(sql("CREATE TABLE IF NOT EXISTS logchat (chat_id varchar(256) NOT NULL, title varchar(256), PRIMARY KEY (chat_id));"))


# Function(s)
proc insertUserLog*(user_id: int, username: string, firstname:string, lastname: string) =
    # Upsert Data
    conn.exec(sql"INSERT INTO loguser (user_id, username, firstname, lastname) VALUES (?, ?, ?, ?) ON CONFLICT (user_id) DO UPDATE SET (username, firstname, lastname) = (EXCLUDED.username, EXCLUDED.firstname, EXCLUDED.lastname)", user_id, username, firstname, lastname)


proc insertChatLog*(chat_id: string, title: string) =
    # Upsert Data
    conn.exec(sql"INSERT INTO logchat (chat_id, title) VALUES (?, ?) ON CONFLICT (chat_id) DO UPDATE SET title = EXCLUDED.title", chat_id, title)  


proc deleteUserLog*(user_id: int) =
    # Delete Data
    conn.exec(sql"DELETE FROM loguser WHERE user_id=?;", user_id)


proc deleteChatLog*(chat_id: string) =
    # Delete Data
    conn.exec(sql"DELETE FROM spamchat WHERE chat_id=?;", chat_id)