import telebot
import asyncdispatch 
import logging 
import options 
import sam
import net
import re
import times
import ../config
from strutils import strip


# Function(s)
proc sendLogUsername*(b: Telebot, u: Update) {.async}=
    if not u.message.isSome:
        return
    var
        message = u.message.get
        user = message.fromUser.get
        chat = message.chat
        text = "#NO_USERNAME\n\n<b>User ID :</b> <code>" & $user.id & "</code>\n<b>First Name :</b> " & user.firstName & "\n<b>Chat :</b> <code>" & chat.title.get & "</code>\n<b>Chat ID :</b> " & $chat.id & "\n<b>Time :</b> " & format(local(getTime()), "d MMMM yyyy HH:mm") & "\n<b>Trigger :</b>\n\n" & message.text.get
        success = newMessage(-1001254086972, text)
    success.parseMode = "html"
    success.disableWebPagePreview = true
    discard await b.send(success)


proc sendLogSpammer*(b: Telebot, u: Update) {.async} =
    if not u.message.isSome:
        return
    var
        message = u.message.get
        user = message.fromUser.get
        chat = message.chat
        text = "#SPAMMER\n\n<b>User ID :</b> <code>" & $user.id & "</code>\n<b>First Name :</b> " & user.firstName & "\n<b>Chat :</b> <code>" & chat.title.get & "</code>\nChat ID : " & $chat.id & "\nTime : " & format(local(getTime()), "d MMMM yyyy HH:mm") & "\n<b>Trigger :</b>\n\n" & message.text.get
        success = newMessage(-1001254086972, text)
    success.parseMode = "html"
    success.disableWebPagePreview = true
    discard await b.send(success)


proc sendLogSpammerChn*(b: Telebot, id: string, rson: string) {.async} =
    var
        text = "#FBAN\n\n<b>User ID :</b> <code>" & id & "</code>\n<b>Reason :</b> <code>" & rson & "</code>\n<b>Time :</b> " & format(local(getTime()), "d MMMM yyyy HH:mm")
        success = newMessage(-1001381264934, text)
    success.parseMode = "html"
    success.disableWebPagePreview = true
    discard await b.send(success)


proc sendLogunSpammerChn*(b: Telebot, id: string) {.async} =
    var
        text = "#UNFBAN\n\n<b>User ID :</b> <code>" & id & "</code>\n<b>Time :</b> " & format(local(getTime()), "d MMMM yyyy HH:mm")
        success = newMessage(-1001381264934, text)
    success.parseMode = "html"
    success.disableWebPagePreview = true
    discard await b.send(success)