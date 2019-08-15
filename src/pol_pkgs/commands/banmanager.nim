import telebot
import asyncdispatch 
import logging 
import options 
import sam 
import net
import strutils
import ../sql/ban_sql
import ../helper_func/[auth, log]


proc fban*(b: Telebot, c: Command) {.async.} = 
    var
        msg = c.message
        user = msg.fromUser.get
        notArgs = "Argumen tidak cukup. Berikan argumen seperti /fban 123456789 alasan."
        failEds = newMessage(c.message.chat.id, notArgs)

    if grantOwner(user.id) == true :
        if len(c.message.text.get) == 15:
            var
                cId : string
            try :
                cId = msg.text.get.split(" ", 1)[1]
            except IndexError:
                cId = ""
            if len(cId) == 9:
                var 
                    text = "<b>Berhasil Ditambahkan!</b>\nID: <code>" & cId & "</code>"
                    success = newMessage(c.message.chat.id, text)
                success.parseMode = "html"
                insertFban(parseInt(cId), "Tidak Ada Alasan.")
                discard await b.send(success)
                discard sendLogSpammerChn(b, cId, "None")
        elif len(c.message.text.get) > 15:
            var
                cId : string
                rSon : string
            try :
                cId = msg.text.get.split(" ", 2)[1]
                rSon = msg.text.get.split(" ", 2)[2]
            except IndexError:
                cId = ""
                rSon = ""
            if len(cId) == 9:
                var
                    text = "<b>Berhasil Ditambahkan!</b>\nID: <code>" & cId & "</code>\nAlasan: " & rSon
                    success = newMessage(c.message.chat.id, text)
                success.parseMode = "html"
                insertFban(parseInt(cId), rSon)
                discard await b.send(success)
                discard sendLogSpammerChn(b, cId, rSon)
        else:
            discard await b.send(failEds)


proc unfban*(b: Telebot, c: Command) {.async.} = 
    var
        msg = c.message
        user = msg.fromUser.get
    if grantOwner(user.id) == true :
        if len(c.message.text.get) == 17:
            var
                cId : string
            try :
                cId = msg.text.get.split(" ", 1)[1]
            except IndexError:
                cId = ""
            if len(cId) == 9:
                var
                    text = "<b>Berhasil Dihapus!</b>\nID: <code>" & cId & "</code>"
                    success = newMessage(c.message.chat.id, text)
                success.parseMode = "html"
                deleteFban(parseInt(cId))
                discard await b.send(success)
                discard sendLogunSpammerChn(b, cId)
        else:
            var
                textf = "<b>Gagal Dihapus!</b>\nAlasan: Tidak Ditemukan"
                fail = newMessage(c.message.chat.id, textf)
            fail.parseMode = "html"
            discard await b.send(fail)