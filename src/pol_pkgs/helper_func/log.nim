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
        text = "#NO_USERNAME\n\nUser ID : <code>" & $user.id & "</code>\nFirst Name : " & user.firstName & "\nChat : <code>" & chat.title.get & "</code>\nChat ID : " & $chat.id & "\nTime : " & format(local(getTime()), "d MMMM yyyy HH:mm") & "\nTrigger :\n\n" & message.text.get
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
        text = "#SPAMMER\n\nUser ID : <code>" & $user.id & "</code>\nFirst Name : " & user.firstName & "\nChat : <code>" & chat.title.get & "</code>\nChat ID : " & $chat.id & "\nTime : " & format(local(getTime()), "d MMMM yyyy HH:mm") & "\nTrigger :\n\n" & message.text.get
        success = newMessage(-1001254086972, text)
    success.parseMode = "html"
    success.disableWebPagePreview = true
    discard await b.send(success)