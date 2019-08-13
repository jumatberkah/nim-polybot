import telebot, asyncdispatch, logging, options, sam, net
import times
import re
import strutils
import ../config


# Function(s)
proc getTimeVal*(t: string): int =
    # Extract Time
    var toRepl: string
    var timeConst: int
    var extratime: int

    if 'd' in t:
        toRepl = "d"
        timeConst = 86400
    elif 'h' in t:
        toRepl = "h"
        timeConst = 3600
    elif 'm' in t:
        toRepl = "m"
        timeConst = 60
    else:
        extratime = 0
    try:
        extratime = parseInt(t.replace(toRepl, ""))
    except:
        extratime = 0

    if extratime <= 0:
        result = 0
    else:
        result = (toUnix(getTime()).int + extratime*timeConst)
    return result