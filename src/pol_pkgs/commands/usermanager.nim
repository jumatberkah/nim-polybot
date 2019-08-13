import telebot
import asyncdispatch 
import logging 
import options 
import sam 
import net
import strutils
import re
import ../sql/[enforce_sql,time_sql]
import ../helper_func/auth


# Function(s)
proc enforceSet*(b: TeleBot, c: Command) {.async} =
    var 
        response = c.message
        textNotargs = "Tidak Cukup Argumen. Masukkan true/false. Contoh: <code>/enforce true</code>" 
        textSucc = "Berhasil! Pengaturan obrolan diperbarui."
        msgNotargs = newMessage(response.chat.id, textNotargs)
        msgSucc = newMessage(response.chat.id, textSucc)
    msgNotargs.parseMode = "html"
    
    if (await isUserAdmin(b, response.chat.id.int, response.fromUser.get.id)):
        if len($response.text) == 16:
            discard await b.send(msgNotargs)
        elif len($response.text) > 16 :
            var opt = response.text.get.split(" ", 1)[1].toLowerAscii()
            if opt == "true":
                upsertSet($response.chat.id, "true")
                discard await b.send(msgSucc)
            elif opt == "false":
                upsertSet($response.chat.id, "false")
                discard await b.send(msgSucc)
            else:
                discard await b.send(msgNotargs)


proc timeSet*(b: TeleBot, c: Command) {.async} =
    var 
        response = c.message
        textNotargs = "Tidak Cukup Argumen. Masukkan waktu. Contoh: <code>/time 5m</code>" 
        textSucc = "Berhasil! Pengaturan obrolan diperbarui."
        msgNotargs = newMessage(response.chat.id, textNotargs)
        msgSucc = newMessage(response.chat.id, textSucc)
    msgNotargs.parseMode = "html"
    
    if (await isUserAdmin(b, response.chat.id.int, response.fromUser.get.id)):
        if len($response.text) == 13:
            discard await b.send(msgNotargs)
        elif len($response.text) > 13 :
            var tim = response.text.get.split(" ", 1)[1].toLowerAscii()
            if tim.endsWith(re"\d+[mhd]{1}"):
                upsertTime($response.chat.id, tim)
                discard await b.send(msgSucc)
            else:
                discard await b.send(msgNotargs)


proc startpm*(b: Telebot, u: Command) {.async} =
    var 
        response = u.message
        chat = response.chat
        text = "Halo disana! Aku adalah bot untuk membantu kamu membisukan pengguna yang belum memasang username, aku juga bisa mengeban para spammer. Tekan /help untuk mengetahui aku lebih lanjut.\n\nTambahkan aku ke obrolan mu! <a href=\"https://t.me/Polyesterbot?startgroup=new\">Tekan ini</a> "
        msg = newMessage(response.chat.id, text)
    msg.parseMode = "html"
    if (chat.kind == "private"):
        discard await b.send(msg)