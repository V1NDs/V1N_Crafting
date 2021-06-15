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
]]--

cfg = {}

--==Script indstillinger==--
cfg.notification = "pNotify" --"pNotify" eller "mythic_notify".

cfg.menu = {
    title = "Crafting", --Titlen på menuen + knappen i F9 menuen.
    color = "52, 73, 94", --Farven på menuen i rgb format.
    description = "Her kan du crafte ting.", --Beskrivelsen af menuen.
}

cfg.craftables = {
    ["Pistol"] = {
        item = "wbody|WEAPON_PISTOL", --Koden på det item de modtager.
        amount = 1, --Mængden af itemet de modtager ved at crafte det.

        requirements = {
            {
                item = "pistolframe", --Koden på det item de skal bruge.
                amount = 1 --Mængden af itemet de skal bruge for at crafte.
            },

            {
                item = "pistolbarrel", --Koden på det item de skal bruge.
                amount = 1 --Mængden af itemet de skal bruge for at crafte.
            },

            {
                item = "pistoltrigger", --Koden på det item de skal bruge.
                amount = 1 --Mængden af itemet de skal bruge for at crafte.
            },

            {
                item = "aluminiumbar", --Koden på det item de skal bruge.
                amount = 5 --Mængden af itemet de skal bruge for at crafte.
            }
        }
    },

    ["Pistol ammunition"] = {
        item = "wammo|WEAPON_PISTOL", --Koden på det item de modtager.
        amount = 10, --Mængden af itemet de modtager ved at crafte det.

        requirements = {
            {
                item = "gunpowder", --Koden på det item de skal bruge.
                amount = 5 --Mængden af itemet de skal bruge for at crafte.
            },

            {
                item = "sulfur", --Koden på det item de skal bruge.
                amount = 3 --Mængden af itemet de skal bruge for at crafte.
            },

            {
                item = "steel", --Koden på det item de skal bruge.
                amount = 1 --Mængden af itemet de skal bruge for at crafte.
            }
        }
    }
}
--===================================--

return cfg
