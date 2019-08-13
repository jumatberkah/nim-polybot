import telebot
import asyncdispatch 
import logging 
import options 
import sam 
import net
import strutils
import ../sql/log_sql


proc logAll*(b: Telebot, u: Update) {.async} =
    if not u.message.isSome:
        return
    var 
        message = u.message.get
        user = message.fromUser.get
        chat = message.chat
    
    insertUserLog(user.id, $user.username, user.firstName, $user.lastName)
    insertChatLog($chat.id, $chat.title.get)    