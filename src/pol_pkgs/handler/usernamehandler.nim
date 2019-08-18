import telebot
import asyncdispatch 
import logging 
import options 
import sam
import net
import re
import ../helper_func/[auth,utils,log]
import ../sql/[enforce_sql,time_sql]
from strutils import strip


# Grant User Permissions
let perm = ChatPermissions(canSendMessages: some(true),
canSendMediaMessages: some(true),
canSendPolls: some(true),
canSendOtherMessages: some(true),
canAddWebPagePreviews: some(true))

# Restrict User Permissions
let notperm = ChatPermissions(canSendMessages: some(false),
canSendMediaMessages: some(false),
canSendPolls: some(false),
canSendOtherMessages: some(false),
canAddWebPagePreviews: some(false))


# Function(s)
proc updateHandler*(b: Telebot, u: Update) {.async.} =
    # Message listener. (Mute someone when he/she does not have username)
    if not u.message.isSome:
        return
    if not (await canBotRestrict(b, $u.message.get.chat.id, u.message.get.chat)):
        return
    if (await isUserAdmin(b, u.message.get.chat.id.int, u.message.get.fromUser.get.id)) == true:
        return

    var 
        message = u.message.get
        user = message.fromUser.get
        chat = message.chat
        time : int
        timestr : string
    timestr = getTime($chat.id)

    if chat.kind == "supergroup":
        if getSet($chat.id) == "true":
            if not (timestr == ""):
                time = getTimeVal(getTime($chat.id))
            else:
                upsertTime($chat.id, "5m")
                time = getTimeVal("5m")    
            if not user.username.isSome and not (user.id == 777000):
                var 
                    text = "<a href=\"tg://user?id=" & $user.id & "\">" & user.firstName & "</a> telah <b>dibisukan</b> karena belum memasang <b>username</b>. [<code>" & $user.id & "</code>]"
                    msg = newMessage(u.message.get.chat.id, text)
                    unmute = initInlineKeyboardButton("✅ Sdh Pasang Username")
                    howto = initInlineKeyboardButton("⚙️ Cara Pasang Username")
                howto.url = some("https://www.wikihow.com/Change-Your-Name-on-Telegram-on-Android")
                unmute.callbackData = some("unmute_" & $user.id)
                msg.parse_mode = "html"
                msg.replyMarkup = newInlineKeyboardMarkup(@[howto, unmute])    
                
                try:
                    discard await b.restrictChatMember($chat.id, user.id, notperm, untilDate = time)
                    discard await b.deleteMessage($chat.id, message.messageId)
                    discard await b.send(msg)
                except IOError:
                    discard await b.restrictChatMember($chat.id, user.id, notperm, untilDate = time)
                    discard await b.send(msg)
                except:
                    discard
                discard sendLogUsername(b, u)
                
        elif getSet($chat.id) == "false":
            discard
        else:
            upsertSet($chat.id, "true")       


proc queryHandler*(b: Telebot, u: Update) {.async.} =
    # Query Listener. (Un-restrict users when they have username)
    if not u.callbackQuery.isSome:
        return
    if not (await canBotRestrict(b, $u.callbackQuery.get.message.get.chat.id, u.callbackQuery.get.message.get.chat)):
        return
    if (await isUserAdmin(b, u.callbackQuery.get.message.get.chat.id.int, u.callbackQuery.get.fromUser.id)):
        return

    var 
        query = u.callbackQuery.get
        user = query.fromUser
        message = query.message.get
        chat = message.chat
        data = query.data.get

    if chat.kind == "supergroup":
        if match(data, re"unmute_\d+"):
            var anu = data.split(re"unmute_")
            if $user.id == $anu[1]:
                if user.username.isSome:
                    try:
                        discard await b.restrictChatMember($chat.id, user.id, perm, untilDate = 0)
                        discard await b.answerCallbackQuery(query.id, "Terimakasih Sudah Pasang Username")
                        discard await b.deleteMessage($chat.id, message.messageId)
                    except IOError:
                        discard await b.restrictChatMember($chat.id, user.id, perm, untilDate = 0)
                        discard await b.answerCallbackQuery(query.id, "Terimakasih Sudah Pasang Username")
                    except:
                        discard
                else:
                    discard await b.answerCallbackQuery(query.id, "Anda Belum Pasang Username", 
                    showAlert = true, cacheTime = 5)
            else:
                discard await b.answerCallbackQuery(query.id, "Anda Bukanlah Pengguna Yang Dimaksud",
                showAlert = true, cacheTime = 10)
    