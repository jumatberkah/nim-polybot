import pol_pkgs/commands/[banmanager, usermanager]
import pol_pkgs/handler/[banhandler, logger, usernamehandler]
import pol_pkgs/config
import telebot, asyncdispatch, logging, options
from strutils import strip


proc main() = 
    # Initiatiation
    let bot = newTeleBot(apiKey) 

    # Message Update
    bot.onUpdate(userChecker)
    bot.onUpdate(updateHandler)
    bot.onUpdate(logAll)
    bot.onUpdate(queryHandler)

    # Commands Update
    bot.onCommand("start", startpm)
    bot.onCommand("fban", fban)
    bot.onCommand("unfban", unfban)
    bot.onCommand("enforce", enforceSet)
    bot.onCommand("time", timeSet)

    # Start polling
    try:
        bot.poll(timeout=300)
    except:
        discard
        
when isMainModule:
    main()