local QBCore = exports['qb-core']:GetCoreObject()

function checkStash(stashType, name, index, box)
  local table = Config[stashType]
  if table[name] then
    if table[name][index] then
      if table[name][index].boxes >= box then
        local weight = table[name][index].weight
        local slots = table[name][index].slots
        return true, weight, slots
      end
    end
  end
  return false
end

QBCore.Functions.CreateCallback('sg-stashbox:server:checkPerms', function(source, cb, args)
  cb(QBCore.Functions.HasPermission(source, Config.PermLevel))
end)

if Config.UseCommand then
  QBCore.Commands.Add(Config.CommandName, '(Admin Only) Open gang/job stash', {
    {name = 'stashType', help = 'job or gang'},
    {name = 'name', help = 'Job/Gang Name [ex: mechanic]'},
    {name = 'index', help = 'Stash Index [ex: 1, 2, 3]'},
    {name = 'box', help = 'Box Number [ex: 1, 2, 3]'},
    }, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local stashType = string.lower(args[1])
    local name = string.lower(args[2])
    local index = tostring(args[3])
    local box = tonumber(args[4])
    stashType = stashType == 'job' and 'JobStash' or 'GangStash'
    local stashName = name..stashType..index..'Box'..box

    if not Player then return end

    local canOpen, weight, slots = checkStash(stashType, name, index, box)
    local pName = PlayerData.charinfo.firstname..' '..PlayerData.charinfo.lastname

    if canOpen then
      data = {stash = name, stashType = stashType, index = index, box = box, weight= weight, slots = slots}
      TriggerClientEvent('sg-stashbox:client:openStash', src, data)
      TriggerServerEvent('qb-log:server:CreateLog', Config.AdminWebhook.name, Config.AdminWebhook.label, Config.AdminWebhook.color, string.format(Lang:t('webhook.adminRaid'), pName, stashName))
    else
      TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.invalidStash'), 'error', 10000)
    end
  end, Config.PermLevel)
end

-- Command Help:
--[[
Config.JobStash = { -- This is the stashType. It will translate job into JobStash or gang into GangStash
  ['police'] = {    -- This is the name. Either the job or gang name, same as shared jobs.lua or gangs.lua
    ['1'] = {       -- This is the index. Which stash location to open.
      boxes = 1,    -- This is the box. Locations may have more than 1, so you can open any of them
----------------
]]--

