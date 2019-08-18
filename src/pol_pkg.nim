import pol_pkgs/commands/[banmanager, usermanager, pmmenu]
import pol_pkgs/handler/[banhandler, logger, usernamehandler]
import pol_pkgs/config
import telebot, asyncdispatch, logging, options


proc main() {.async.} = 
    # Initiation
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
    bot.onCommand("help", pmHandler)

    # Start polling
    bot.poll(timeout=15, clean=true)

when isMainModule:
    echo("Bot Initializing...")
    waitFor main()
    echo("Bot Running In a Loop.")