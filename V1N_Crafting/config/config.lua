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
Youtube: https://www.youtube.com/channel/UCaBZGvYryg09IS-uaSHyfPw
Github: https://github.com/V1NDs
Discord server: https://discord.gg/ECUxET82SD
]]--

--[[
INFORMATION:
> Scriptet er inspireret fra rust, hvilket er tydeligst at se ved at det er lavet med grid.

> Hvis et item ikke kommer frem i ui'en er det fordi itemet ikke findes, dette sker for at sikre at folk ikke giver noget og ikke får noget retur. 
  (Virker ikke hvis de skal modtage våben, så vises itemet stadig i ui'en).

> Der kan kun være en marker indenfor 10.0 gta units, ellers vil den ene marker ikke loade ind.

> Hvis du finder nogle problemer eller ideer, så skriv eller lav en ticket på discorden: https://discord.gg/ECUxET82SD.

> Brug hjernen og lad være med at tage credit eller sælge scriptet.
]]--

cfg = {
    keys = {
        ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
        ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
        ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
        ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
        ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
        ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
        ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
        ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173
    }
}

--==Script indstillinger==--
cfg.key = "E" --Knappen der trykkes ved markeren.

cfg.notification = "pNotify" --"pNotify" eller "mythic_notify".

cfg.marker = {
    markerId = 25, --Marker id kan findes her: https://docs.fivem.net/docs/game-references/markers/.
    scale = 1.0, --Størrelsen på markeren, skal være en float value altså der skal være .x bag på.
    rgba = {52, 73, 94, 200} --Farveren på markeren i rgba format. Så fx er rød (255, 0, 0, 0-255).
}
--===================================--

--==Script sporg==--
cfg.lang = {
    openMenu = "Tryk [~b~{KEY}~w~] for at åbne {BENCH} menuen.",
    alreadyCrafting = "~r~Du er i gang med at crafte.",
    missingItem = "Du mangler {AMOUNT} stk. {ITEM}.",
    notEnoughSpace = "Du har ikke nok plads i rygsækken!"
}
--===================================--

--==Workbench locations==--
cfg.workbenches = {
    --[[Eksempel på lokation:
    {
        coordinates = {706.17858886719, -963.81481933594, 30.408285140991}, --Kordinater på markeren og menuen.
        bench = "Våben" --Våben er identificatoren på menuen som vist længere ned på linje 75.
    },
    ]]--

    {
        coordinates = {707.13818359375, -966.90710449219, 30.41284942627},
        bench = "Tier 1"
    },

    {
        coordinates = {1542.9193115234, 2178.7268066406, 78.809371948242},
        bench = "Tier 2"
    },

    {
        coordinates = {1367.8885498047, 3615.1982421875, 35.018093109131},
        bench = "Tier 3"
    }
}
--===================================--

--==Craftable items==--
cfg.craftables = {
    --[[Eksempel på crafting type og item:
    ["Våben"] = { --["Våben"] er titlen på menuen + det der bliver brugt til at identificere menuen.
        {
            item = "wbody|WEAPON_PISTOL_MK2", --Item koden på det item der bliver modtager ved at crafte.
            amount = 1, --Mængden af det item de crafter som de modtager.
            craftingTime = 20, --Tid i sekunder det tager at crafte itemet.

            recipe = {
                {item = "aluminiumbar", amount = 30}, --Item det kræver at crafte og hvor meget af itemet.
                {item = "stainless", amount = 10}, --Item det kræver at crafte og hvor meget af itemet.
                {item = "steel", amount = 5} --Item det kræver at crafte og hvor meget af itemet.
            }
        }
    },
    ]]--

    ["Tier 1"] = {
        {
            item = "wbody|WEAPON_KNIFE",
            amount = 1,
            craftingTime = 15,

            recipe = {
                {item = "aluminiumbar", amount = 5},
                {item = "stainless", amount = 3}
            }
        },

        {
            item = "wbody|WEAPON_HAMMER",
            amount = 1,
            craftingTime = 10,

            recipe = {
                {item = "aluminiumbar", amount = 3},
                {item = "stainless", amount = 1}
            }
        },

        {
            item = "wbody|WEAPON_KNUCKLE",
            amount = 1,
            craftingTime = 10,

            recipe = {
                {item = "aluminiumbar", amount = 3}
            }
        }
    },

    ["Tier 2"] = {
        {
            item = "wbody|WEAPON_PISTOL50",
            amount = 1,
            craftingTime = 35,

            recipe = {
                {item = "pistol50frame", amount = 1},
                {item = "pistol50barrel", amount = 1},
                {item = "pistol50trigger", amount = 1},
                {item = "aluminiumbar", amount = 7}
            }
        },

        {
            item = "wammo|WEAPON_PISTOL50",
            amount = 10,
            craftingTime = 5,
    
            recipe = {
                {item = "gunpowder", amount = 3},
                {item = "sulfur", amount = 3},
                {item = "steel", amount = 1}
            }
        },

        {
            item = "wbody|WEAPON_PISTOL",
            amount = 1,
            craftingTime = 30,

            recipe = {
                {item = "pistolframe", amount = 1},
                {item = "pistolbarrel", amount = 1},
                {item = "pistoltrigger", amount = 1},
                {item = "aluminiumbar", amount = 5}
            }
        },

        {
            item = "wammo|WEAPON_PISTOL",
            amount = 10,
            craftingTime = 5,
    
            recipe = {
                {item = "gunpowder", amount = 3},
                {item = "sulfur", amount = 3},
                {item = "steel", amount = 1}
            }
        },

        {
            item = "wbody|WEAPON_SNSPISTOL",
            amount = 1,
            craftingTime = 30,

            recipe = {
                {item = "snsframe", amount = 1},
                {item = "snsbarrel", amount = 1},
                {item = "snstrigger", amount = 1},
                {item = "aluminiumbar", amount = 3}
            }
        },

        {
            item = "wammo|WEAPON_SNSPISTOL",
            amount = 15,
            craftingTime = 5,
    
            recipe = {
                {item = "gunpowder", amount = 3},
                {item = "sulfur", amount = 3},
                {item = "steel", amount = 1}
            }
        }
    },

    ["Tier 3"] = {
        {
            item = "wbody|WEAPON_MACHINEPISTOL",
            amount = 1,
            craftingTime = 60,

            recipe = {
                {item = "aluminiumbar", amount = 50},
                {item = "stainless", amount = 30},
                {item = "steel", amount = 15}
            }
        },

        {
            item = "wammo|WEAPON_MACHINEPISTOL",
            amount = 15,
            craftingTime = 10,
    
            recipe = {
                {item = "gunpowder", amount = 5},
                {item = "sulfur", amount = 5},
                {item = "steel", amount = 3}
            }
        },

        {
            item = "wbody|WEAPON_GUSENBERG",
            amount = 1,
            craftingTime = 90,

            recipe = {
                {item = "aluminiumbar", amount = 70},
                {item = "stainless", amount = 50},
                {item = "steel", amount = 30}
            }
        },

        {
            item = "wammo|WEAPON_GUSENBERG",
            amount = 10,
            craftingTime = 10,
    
            recipe = {
                {item = "gunpowder", amount = 7},
                {item = "sulfur", amount = 7},
                {item = "steel", amount = 5}
            }
        },

        {
            item = "wbody|WEAPON_MICROSMG",
            amount = 1,
            craftingTime = 75,

            recipe = {
                {item = "aluminiumbar", amount = 60},
                {item = "stainless", amount = 40},
                {item = "steel", amount = 20}
            }
        },

        {
            item = "wammo|WEAPON_MICROSMG",
            amount = 10,
            craftingTime = 7,
    
            recipe = {
                {item = "gunpowder", amount = 4},
                {item = "sulfur", amount = 4},
                {item = "steel", amount = 2}
            }
        }
    }
}
--===================================--
