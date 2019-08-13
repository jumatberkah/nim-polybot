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
        cId = msg.text.get.split(" ")[1]
        rSon = msg.text.get.split(" ")[2]
        text = "<b>Berhasil Ditambahkan!</b>\nID: <code>" & cId & "</code>"
        success = newMessage(c.message.chat.id, text)
    success.parseMode = "html"

    if grantOwner(user.id) == true :
        if len(cId) == 9:
            insertFban(parseInt(cId), rSon)
            b.send(success)
        elif len(cId) >= 14:
            insertFbanChat(cId, rSon)
            discard await b.send(success)
    
    
proc unfban*(b: Telebot, c: Command) {.async.} = 
    var
        msg = c.message
        user = msg.fromUser.get
        cId = msg.text.get.split(" ")[1]
        text = "<b>Berhasil Dihapus!</b>\nID: <code>" & cId & "</code>"
        textf = "<b>Gagal Dihapus!</b>\nID: <code>" & cId & "</code>\nAlasan: Tidak Ditemukan"
        success = newMessage(c.message.chat.id, text)
        fail = newMessage(c.message.chat.id, textf)
    success.parseMode = "html"
    fail.parseMode = "html"
    
    if grantOwner(user.id) == true :
        if len(cId) == 9:
            deleteFban(parseInt(cId))
            discard await b.send(success)
        elif len(cId) >= 14:
            deleteFbanChat(cId)
            discard await b.send(success)