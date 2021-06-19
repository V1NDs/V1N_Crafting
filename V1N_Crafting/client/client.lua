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

--==Variables==--
local menuStatus = false
local crafting = false
local delay = 500
local inRange = false
--===================================--

--==Functions==--
guide = function(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

notify = function(text)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandThefeedPostTicker(false, false)
end

craftItem = function(data)
    for k,v in pairs(cfg.craftables[data.bench]) do
        if data.item == v.item then
            TriggerServerEvent("V1N_Crafting:checkInventory", v.item, v.itemName, v.recipe, v.amount, data.amount, v.craftingTime, data.bench)
        end
    end

    setDisplay(false)
end
--===================================--

--==Events==--
RegisterNetEvent("V1N_Crafting:reciveItemInformation", function(itemInfo)

    if itemInfo.item == itemInfo.name then
        cfg.craftables[itemInfo.bench][itemInfo.table]["notValid"] = true
    end

    cfg.craftables[itemInfo.bench][itemInfo.table]["itemName"] = itemInfo.name
    cfg.craftables[itemInfo.bench][itemInfo.table]["description"] = itemInfo.description
    cfg.craftables[itemInfo.bench][itemInfo.table]["vRPrecipe"] = itemInfo.recipe
    cfg.craftables[itemInfo.bench][itemInfo.table]["bench"] = itemInfo.bench
end)

RegisterNetEvent("V1N_Crafting:reciveInventory", function(missing, item, itemName, itemAmount, amount, craftingTime, recipe, bench, enoughSpace)
    if next(missing) == nil then
        if enoughSpace then
            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', 0, true)
            exports['progressBars']:startUI(craftingTime * amount * 1000, "Crafter "..itemAmount * amount.." "..itemName)
            crafting = true
            Citizen.Wait(craftingTime * amount * 1000)
            crafting = false
            ClearPedTasksImmediately(GetPlayerPed(-1))
            TriggerServerEvent("V1N_Crafting:craftItem", item, itemAmount, recipe, amount, bench)
        else
            if cfg.notification == "pNotify" then
                exports["pNotify"]:SendNotification({text = cfg.lang.notEnoughSpace, type = "error", queue = "global", timeout = 4000, layout = "bottomRight", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            elseif cfg.notification == "mythic_notify" then
                exports["mythic_notify"]:DoCustomHudText("error", cfg.lang.notEnoughSpace, 4000)
            end
        end
    else
        for k,v in pairs(missing) do
            if cfg.notification == "pNotify" then
                exports["pNotify"]:SendNotification({text = cfg.lang.missingItem:gsub("{AMOUNT}", v.amount):gsub("{ITEM}", v.item), type = "error", queue = "global", timeout = 4000, layout = "bottomRight", animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            elseif cfg.notification == "mythic_notify" then
                exports["mythic_notify"]:DoCustomHudText("error", cfg.lang.missingItem:gsub("{AMOUNT}", v.amount):gsub("{ITEM}", v.item), 4000)
            end

            missing[k] = nil
        end
    end
end)
--===================================--

--==Define item informations==--
for bench,v in pairs(cfg.craftables) do
    for k,v in pairs(v) do
        TriggerServerEvent("V1N_Crafting:getItemInformation", v, k, bench)
    end
end
--===================================--

--==UI==--
setDisplay = function(bool, bench)
    menuStatus = bool
    SetNuiFocus(bool, bool)

    if bool then
        if bench ~= nil then
            SendNUIMessage({
                status = bool,
                resource = GetCurrentResourceName(),
                items = cfg.craftables[bench]
            })
        end
    else
        SendNUIMessage({
            status = bool
        })
    end
end

RegisterNUICallback("close", function()
    setDisplay(false)
end)

RegisterNUICallback("craft", craftItem)
--===================================--

--==Threads==--
Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        local r,g,b,a = table.unpack(cfg.marker.rgba)

        for k,v in pairs(cfg.workbenches) do
            local sx,sy,sz = table.unpack(cfg.workbenches[k].coordinates)
            local bench = cfg.workbenches[k].bench

            if GetDistanceBetweenCoords(sx, sy, sz, x, y, z) < 10.0 then
                DrawMarker(cfg.marker.markerId, sx, sy, sz-0.97,  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, cfg.marker.scale, cfg.marker.scale, cfg.marker.scale, r, g, b, a, 0, 1, 0, 50)
                if GetDistanceBetweenCoords(sx, sy, sz, x, y, z) < cfg.marker.scale then
                    if not crafting then
                        guide(cfg.lang.openMenu:gsub("{KEY}", cfg.key):gsub("{BENCH}", v.bench))
                        if IsControlJustReleased(1, cfg.keys[cfg.key]) then
                            setDisplay(true, v.bench)
                        end
                    else
                        guide(cfg.lang.alreadyCrafting)
                    end
                end

                delay = 1
                break
            end
            delay = 500
        end

        Citizen.Wait(delay)
    end
end)

Citizen.CreateThread(function()
    while menuStatus do
        Citizen.Wait(0)
        DisableControlAction(0, 1, menuStatus)
        DisableControlAction(0, 2, menuStatus)
        DisableControlAction(0, 142, menuStatus)
        DisableControlAction(0, 18, menuStatus)
        DisableControlAction(0, 322, menuStatus)
        DisableControlAction(0, 106, menuStatus)
    end
end)
--===================================--
