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

--==vRP connection==--
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

local vRP = Proxy.getInterface("vRP")
local vRPclient = Tunnel.getInterface("vRP", GetCurrentResourceName())
--===================================--

--==Configs==--
local cfg = module(GetCurrentResourceName(), "cfg/config")
local lang = module(GetCurrentResourceName(), "cfg/language")
--===================================--

--==Functions==--
craftItem = function(player, item, amount)
    local user_id = vRP.getUserId({player})

    for l,b in pairs(cfg.craftables) do
        if b.item:lower() == item then
            local item = b
            local missingItems = {}

            for k,v in pairs(item.requirements) do
                local reqItem = v.item
                local reqAmount = v.amount * amount
                local iAmount = vRP.getInventoryItemAmount({user_id, v.item})

                if iAmount < reqAmount then
                    table.insert(missingItems, {
                        item = reqItem,
                        amount = reqAmount - iAmount
                    })
                end
            end

            if not missingItems[1] then
                for k,v in pairs(item.requirements) do
                    vRP.tryGetInventoryItem({user_id, v.item, v.amount * amount, true})
                end

                vRP.giveInventoryItem({user_id, item.item, item.amount * amount, true})
            else
                for k,v in pairs(missingItems) do
                    if cfg.notification == "pNotify" then
                        TriggerClientEvent("pNotify:SendNotification", player, {text = lang.crafting.missingItem:gsub("{AMOUNT}", v.amount):gsub("{ITEM}", vRP.getItemName({v.item})), type = "error", queue = "global", timeout = 4000, layout = "bottomRight", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    elseif cfg.notification == "mythic_notify" then
                        TriggerClientEvent("mythic_notify:client:SendAlert", player, { type = "error", text = lang.crafting.missingItem:gsub("{AMOUNT}", v.amount):gsub("{ITEM}", vRP.getItemName({v.item})), duration = 4000})
                    end
                    
                    missingItems[k] = nil
                end
            end
        end
    end
end
--===================================--

--==Menu==--
local items = {}

local crafting_choice = function(player, choice)
    local user_id = vRP.getUserId({player})
    local item = items[choice]

    vRP.prompt({player, "Mængden at crafte", "", function(player, amount)
        local amount = parseInt(amount)

        if amount > 0 then
            vRP.request({player, "Er du sikker på du vil crafte "..item.amount * amount.." stk. "..vRP.getItemName({item.item}), 30, function(source, craft)
                if craft then
                    local new_weight = vRP.getInventoryWeight({user_id}) + vRP.getItemWeight({item.item}) * amount
                    if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
                        craftItem(player, tostring(item.item):lower(), amount)
                    else
                        if cfg.notification == "pNotify" then
                            TriggerClientEvent("pNotify:SendNotification", player, {text = lang.crafting.noSpace, type = "error", queue = "global", timeout = 4000, layout = "bottomRight", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        elseif cfg.notification == "mythic_notify" then
                            TriggerClientEvent("mythic_notify:client:SendAlert", player, { type = "error", text = lang.crafting.noSpace, duration = 4000})
                        end
                    end
                end
            end})
        else
            if cfg.notification == "pNotify" then
                TriggerClientEvent("pNotify:SendNotification", player, {text = lang.crafting.invalidAmount, type = "error", queue = "global", timeout = 4000, layout = "bottomRight", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            elseif cfg.notification == "mythic_notify" then
                TriggerClientEvent("mythic_notify:client:SendAlert", player, { type = "error", text = lang.crafting.invalidAmount, duration = 4000})
            end
        end
    end})
end

local crafting_menu = {function(player, choice)
    local user_id = vRP.getUserId({player})

    local menu = {}
    menu.name = cfg.menu.title
    menu.css = {top = "75px", header_color = "rgb("..cfg.menu.color..")"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end

    for k,v in pairs(cfg.craftables) do
        local reqItems = {}

        for j,c in pairs(v.requirements) do 
            table.insert(reqItems, c.amount.." stk. "..vRP.getItemName({c.item})..".<br/>")
            reqText = table.concat(reqItems, " ")
        end

        items[v.amount.." stk. "..vRP.getItemName({v.item})] = v
        menu[v.amount.." stk. "..vRP.getItemName({v.item})] = {crafting_choice, "<b>Du modtager "..v.amount.." stk. "..vRP.getItemName({v.item})..".</b><br/><br/><b>Kræver:</b><br/>"..reqText}
    end

    vRP.openMenu({player, menu})
end, cfg.menu.description}

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})

    if user_id ~= nil then
        local choices = {}
        choices[cfg.menu.title] = crafting_menu

        add(choices)
    end
end})
--===================================--
