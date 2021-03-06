--[[
────────────────────────────────────────────────────────────────────────────────
─██████──██████─████████───██████──────────██████─████████████───██████████████─
─██░░██──██░░██─██░░░░██───██░░██████████──██░░██─██░░░░░░░░████─██░░░░░░░░░░██─
─██░░██──██░░██─████░░██───██░░░░░░░░░░██──██░░██─██░░████░░░░██─██░░██████████─
─██░░██──██░░██───██░░██───██░░██████░░██──██░░██─██░░██──██░░██─██░░██─────────
─██░░██──██░░██───██░░██───██░░██──██░░██──██░░██─██░░██──██░░██─██░░██████████─
─██░░██──██░░██───██░░██───██░░██──██░░██──██░░██─██░░██──██░░██─██░░░░░░░░░░██─
─██░░██──██░░██───██░░██───██░░██──██░░██──██░░██─██░░██──██░░██─██████████░░██─
─██░░░░██░░░░██───██░░██───██░░██──██░░██████░░██─██░░██──██░░██─────────██░░██─
─████░░░░░░████─████░░████─██░░██──██░░░░░░░░░░██─██░░████░░░░██─██████████░░██─
───████░░████───██░░░░░░██─██░░██──██████████░░██─██░░░░░░░░████─██░░░░░░░░░░██─
─────██████─────██████████─██████──────────██████─████████████───██████████████─
────────────────────────────────────────────────────────────────────────────────
Discord: V1NDs#0977
Youtube: https://www.youtube.com/channel/UCxoJ3jF7onq1TRkOnAZAF8w
Github: https://github.com/V1NDs
Discord server: https://discord.gg/ECUxET82SD
]]--

--==Script data==--
fx_version "cerulean"
game "gta5"
--===================================--

--==Script information==--
author "V1NDs"
description "vRP Crafting system with UI"
version "2.0"
--===================================--

--==Script dependencies==--
dependencies {
    "vrp",
    "progressBars"
}
--===================================--

--==Script client files==--
client_scripts {
    "config/config.lua",
    "client/client.lua"
}

--==Script server files==--
server_scripts {
    "@vrp/lib/utils.lua",
    "server/server.lua"
}
--===================================--

--==Script HTML Files==--
ui_page "client/html/index.html"

files {
    "client/html/index.html",
    "client/html/index.css",
    "client/html/reset.css",
    "client/html/index.js"
}
--===================================--
