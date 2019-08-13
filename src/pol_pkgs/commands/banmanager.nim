import telebot
import asyncdispatch 
import logging 
import options 
import sam 
import net
import strutils
import ../sql/ban_sql
import ../helper_func/auth


proc fban*(b: Telebot, c: Command) {.async.} = 
    var
        msg = c.message
        user = msg.fromUser.get
        notArgs = "Argumen tidak cukup. Berikan argumen seperti /fban 123456789 alasan."
        failEds = newMessage(c.message.chat.id, notArgs)

    if grantOwner(user.id) == true :
        if len(c.message.text.get) == 15:
            var
                cId = msg.text.get.split(" ", 1)[1]
                text = "<b>Berhasil Ditambahkan!</b>\nID: <code>" & cId & "</code>"
                success = newMessage(c.message.chat.id, text)
            success.parseMode = "html"
            if len(cId) == 9:
                insertFban(parseInt(cId), "Tidak Ada Alasan.")
                discard await b.send(success)
        elif len(c.message.text.get) > 15:
            var
                cId = msg.text.get.split(" ", 2)[1]
                rSon = msg.text.get.split(" ", 2)[2]
                text = "<b>Berhasil Ditambahkan!</b>\nID: <code>" & cId & "</code>\nAlasan: " & rSon
                success = newMessage(c.message.chat.id, text)
            success.parseMode = "html"
            if len(cId) == 9:
                insertFban(parseInt(cId), rSon)
                discard await b.send(success)
        else:
            discard await b.send(failEds)


proc unfban*(b: Telebot, c: Command) {.async.} = 
    var
        msg = c.message
        user = msg.fromUser.get
        cId = msg.text.get.split(" ")[1]
        textf = "<b>Gagal Dihapus!</b>\nID: <code>" & cId & "</code>\nAlasan: Tidak Ditemukan"
        fail = newMessage(c.message.chat.id, textf)
    fail.parseMode = "html"
    
    if grantOwner(user.id) == true :
        if len(c.message.text.get) == 17:
            var
                cId = msg.text.get.split(" ", 1)[1]
                text = "<b>Berhasil Dihapus!</b>\nID: <code>" & cId & "</code>"
                success = newMessage(c.message.chat.id, text)
            success.parseMode = "html"
            if len(cId) == 9:
                deleteFban(parseInt(cId))
                discard await b.send(success)
        else:
            discard await b.send(fail)