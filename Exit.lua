script_name("Exit")
script_version_number(1)
script_version("1.0")
script_author("Diplo")
require 'lib.moonloader'
local sampev = require 'lib.samp.events'

function main()
    act = false
    while not isSampAvailable() do wait(200) end
    sampRegisterChatCommand("ex", function()
    if act then
        sampAddChatMessage("{51A0FA}[Exit]: {FF0700}Деактивирован", 0xffffff)
        act = not act
    else
        sampAddChatMessage("{51A0FA}[Exit]: {32CD32}Активирован", 0xffffff)
        act = not act
    end
     end)
end

function sampev.onPlayerJoin(playerid, color, isNPC, nickname)
    nickname = string.lower(nickname)
    if act and (nickname == "REVO." or nickname == "moonundermood") then
        sampProcessChatInput("/q")
    end
end