import telebot, asyncdispatch, logging, options, sam, net
import re
import strutils
import ../config


# Function(s)
proc grantOwner*(user_id : int): bool =
    if (user_id in sudos):
        return true


proc canBotRestrict*(b: TeleBot, chatid: string, c: Chat): Future[bool] {.async.} =
    let bot = await b.getMe()
    let botChat = await getChatMember(b, chatid, bot.id)
    if botChat.canRestrictMembers.isSome:
        return botChat.canRestrictMembers.get


proc canBotDelMsgs*(b: TeleBot, chatid: string, c: Chat): Future[bool] {.async.} =
    let bot = await b.getMe()
    let botChat = await getChatMember(b, chatid, bot.id)
    if botChat.canDeleteMessages.isSome:
        return botChat.canDeleteMessages.get  


proc isUserAdmin*(b: TeleBot, chat_id: int, user_id: int): Future[bool] {.async.} =
    let user = await getChatMember(b, $chat_id, user_id)
    return (user.status in ["creator", "administrator"]) or (user_id in sudos) or (user_id == parseInt(config.owner))

