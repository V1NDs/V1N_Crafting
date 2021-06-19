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

--==vRP connection==--
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

local vRP = Proxy.getInterface("vRP")
--===================================--

--==Config==--
local secure = module(GetCurrentResourceName(), "config/secure")
--===================================--

--==Functions==--
sendWebhook = function(webhook, name, message)
    if message == nil or message == "" or message:sub(1, 1) == "/" then return FALSE end
    local embed = {{ ["color"] = 2899536, ["title"] = "**"..name.."**\n", ["description"] = message, ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S')}}
    PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = name, embeds = embed}), { ["Content-Type"] = "application/json" })
end
--===================================--

--==Events==--
RegisterServerEvent("V1N_Crafting:getItemInformation", function(item, table, bench)
    local source = source
    local user_id = vRP.getUserId({source})
    local itemName = vRP.getItemName({item.item})
    local itemDescription = vRP.getItemDescription({item.item})

    local itemRecipe = {}
    for k,v in pairs(item.recipe) do
        itemRecipe[k] = {
            item = vRP.getItemName({v.item}),
            amount = v.amount
        }
    end

    TriggerClientEvent("V1N_Crafting:reciveItemInformation", source, {item = item.item, table = table, bench = bench, name = itemName, description = itemDescription, recipe = itemRecipe})
end)

RegisterServerEvent("V1N_Crafting:checkInventory", function(item, itemName, recipe, itemAmount, amount, craftingTime, bench)
    local source = source
    local user_id = vRP.getUserId({source})

    local missingItems = {}
    local enoughSpace = nil
    local new_weight = vRP.getInventoryWeight({user_id}) + vRP.getItemWeight({item}) * itemAmount * amount

    if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
        enoughSpace = true
    else
        enoughSpace = false
    end

    for k,v in pairs(recipe) do
        local reqItem = v.item
        local reqAmount = v.amount * amount
        local iAmount = vRP.getInventoryItemAmount({user_id, v.item})

        if iAmount < reqAmount then
            table.insert(missingItems, {
                item = vRP.getItemName({reqItem}),
                amount = reqAmount - iAmount
            })
        end
    end

    TriggerClientEvent("V1N_Crafting:reciveInventory", source, missingItems, item, itemName, itemAmount, amount, craftingTime, recipe, bench, enoughSpace)
end)

RegisterServerEvent("V1N_Crafting:craftItem", function(item, itemAmount, recipe, amount, bench)
    local source = source
    local user_id = vRP.getUserId({source})

    local missingItems = {}

    for k,v in pairs(recipe) do
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

    if next(missingItems) == nil then
        for k,v in pairs(recipe) do
            vRP.tryGetInventoryItem({user_id, v.item, v.amount * amount, true})
        end

        vRP.giveInventoryItem({user_id, item, itemAmount * amount, true})

        sendWebhook(secure.webhooks.craft, "Crafting - "..bench, "**ID:** "..user_id.."\n**Mængde:** "..itemAmount * amount.."\n**Item navn:** "..vRP.getItemName({item}).."\n**Item kode:** "..item)
    end
end)
--===================================--
