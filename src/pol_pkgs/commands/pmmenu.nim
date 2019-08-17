import telebot
import asyncdispatch 
import logging 
import options 
import sam 
import net
import strutils


# Function(s)
proc pmHandler*(b: Telebot, u: Command) {.async.} =
    var 
        message = u.message
        user = message.fromUser.get
        chat = message.chat
    if chat.kind == "private":  
        var 
            text = "<a href=\"tg://user?id=" & $user.id & "\">" & user.firstName & "</a> berikut adalah daftar bantuan:"
            msg = newMessage(u.message.chat.id, text)
            waktu = initInlineKeyboardButton("Waktu")
            opsi = initInlineKeyboardButton("Opsi")
            data = initInlineKeyboardButton("Kebijakan Privasi")
            contohper = initInlineKeyboardButton("Contoh")
            donasi = initInlineKeyboardButton("Donasi")
        waktu.callbackData = some("waktu")
        opsi.callbackData = some("opsi")
        data.callbackData = some("data")
        contohper.callbackData = some("cthprnth")
        donasi.callbackData = some("donasi")
        msg.parse_mode = "html"
        msg.replyMarkup = newInlineKeyboardMarkup(@[waktu, opsi], @[data, contohper], @[donasi])  
        discard await b.send(msg)  