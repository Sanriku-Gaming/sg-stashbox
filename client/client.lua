local QBCore = exports['qb-core']:GetCoreObject()

--local variables
local PlayerData = QBCore.Functions.GetPlayerData()
local PlayerJob = QBCore.Functions.GetPlayerData().job
local PlayerGang = QBCore.Functions.GetPlayerData().gang
local isAdmin = false
local Targets = {}
local Props = {}

--------------------------
--      Functions       --
--------------------------
--Used for debugging tables
local function printTable(tbl)
  for key, value in pairs(tbl) do
      if type(value) == "table" then
          print(key .. " (table):")
          printTable(value)
      else
          print(key .. ":", value)
      end
  end
end

--Prop Spawning
local time = 1000
local function loadModel(model) if not HasModelLoaded(model) then
	if Config.Debug then print(string.format(Lang:t('debug.loadModel'), model)) end
	while not HasModelLoaded(model) do
		if time > 0 then time = time - 1 RequestModel(model)
		else loadTime = 1000 print(string.format(Lang:t('debug.modelTO'), model)) break
		end
		Wait(10)
	end
end end

local function createProp(data, freeze, synced)
  loadModel(data.prop)
  local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z, synced or 0, synced or 0, 0)
  SetEntityHeading(prop, data.coords.w)
  FreezeEntityPosition(prop, freeze or 0)
  if Config.Debug then print(string.format(Lang:t('debug.propCreated'), prop)) end
  return prop
end

--------------------------
--        Events        --
--------------------------
RegisterNetEvent('sg-stashbox:client:openMenu', function(data)
  if Config.Debug then printTable(data) end
  local headerLabel = data.stashType == 'JobStash' and 'Job Stash - '..QBCore.Shared.Jobs[data.stash].label or 'Gang Stash - '..QBCore.Shared.Gangs[data.stash].label

  local stashMenu = {}
  stashMenu[#stashMenu+1] = {
    header = headerLabel.." #"..data.index,
    isMenuHeader = true,
  }
  for i = 1, data.boxes do
    stashMenu[#stashMenu+1] = {
      header = "🗄️ Stash Boxes",
      txt = "Open Box #"..i,
      params = {
        event = "sg-stashbox:client:openStash",
        args = {
          index = data.index,
          stashType = data.stashType,
          stash = data.stash,
          box = i,
          weight = data.weight,
          slots = data.slots,
          policeRaid = data.policeRaid,
          adminRaid = data.adminRaid,
        },
      }
    }
  end
  stashMenu[#stashMenu+1] = {
    header = "Exit",
    params = {
      event = "qb-menu:closeMenu",
    }
  }
  exports['qb-menu']:openMenu(stashMenu)
end)

RegisterNetEvent('sg-stashbox:client:openStash', function(data)
  if Config.Debug then printTable(data) end
  local stashName = data.stash..data.stashType..data.index..'Box'..data.box
  TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
    maxweight = data.weight,
    slots = data.slots,
  })
  TriggerEvent("inventory:client:SetCurrentStash", stashName)
  local pName = PlayerData.charinfo.firstname..' '..PlayerData.charinfo.lastname
  if data.policeRaid and Config.RaidWebhook.enable then
    TriggerServerEvent('qb-log:server:CreateLog', Config.RaidWebhook.name, Config.RaidWebhook.label, Config.RaidWebhook.color, string.format(Lang:t('webhook.policeRaid'), pName, stashName))
  elseif data.adminRaid and Config.AdminWebhook.enable then
    TriggerServerEvent('qb-log:server:CreateLog', Config.AdminWebhook.name, Config.AdminWebhook.label, Config.AdminWebhook.color, string.format(Lang:t('webhook.adminRaid'), pName, stashName))
  end
end)

--------------------------
--       Threads        --
--------------------------
-- MAIN THREAD
CreateThread(function()
  -- tables
  local Tables = {
    JobStash = Config.JobStash,
    GangStash = Config.GangStash
  }

  -- Shared locals
  local x, y, z, w

  -- Get the proper Config Table
  for stashType, stashes in pairs(Tables) do
    if Config.Debug then print(stashType, stashes) end
    -- Iterate through config table for stashes
    for name, stashData in pairs(stashes) do
      if Config.Debug then print(name, stashData) end
      -- Iterate through stash table to build targets and options
      for index, data in pairs(stashData) do
        if Config.Debug then print(index) printTable(data) end
        local optionsList = {}
        x, y, z, w = table.unpack(data.coords)
        -- Create prop if needed
        if data.useProp then
          -- Prop logic
          propModel = data.prop
          Props[#Props+1] = createProp({prop = propModel, coords = vector4(x, y, z, w)}, true, true)
          if Config.Debug then print(string.format(Lang:t('debug.propCreated2'), propModel, k, data.coords)) end
        end

        -- Job/gang based options
        if stashType == "JobStash" then
          -- Job access option
          optionsList[#optionsList+1] = {
            type = "client",
            event = "sg-stashbox:client:openMenu",
            icon = "fas fa-sign-in-alt",
            label = Lang:t('label.jobStash'),
            job = {[name] = data.rank},
            stashType = stashType,
            index = index,
            stash = name,
            boxes = data.boxes,
            weight = data.weight,
            slots = data.slots,
          }
        elseif stashType == "GangStash" then
          -- Gang access option
          optionsList[#optionsList+1] = {
            type = "client",
            event = "sg-stashbox:client:openMenu",
            icon = "fas fa-sign-in-alt",
            label = Lang:t('label.gangStash'),
            gang = {[name] = data.rank},
            stashType = stashType,
            index = index,
            stash = name,
            boxes = data.boxes,
            weight = data.weight,
            slots = data.slots,
          }
        end

        if Config.EnableRaid then
          optionsList[#optionsList+1] = {
            type = "client",
            event = "sg-stashbox:client:openMenu",
            icon = "fas fa-sign-in-alt",
            label = Lang:t('label.raidStash'),
            stashType = stashType,
            index = index,
            stash = name,
            boxes = data.boxes,
            weight = data.weight,
            slots = data.slots,
            policeRaid = true,
            canInteract = function()
              if (PlayerJob.name == Config.RaidJobName or PlayerJob.type == Config.RaidJobType) and PlayerJob.grade.level >= Config.RaidJobGrade then
                return true
              end
            end,
          }
        end

        if Config.AllowAdmin then
          optionsList[#optionsList+1] = {
            type = "client",
            event = "sg-stashbox:client:openMenu",
            icon = "fas fa-sign-in-alt",
            label = Lang:t('label.raidStash2'),
            stashType = stashType,
            index = index,
            stash = name,
            boxes = data.boxes,
            weight = data.weight,
            slots = data.slots,
            adminRaid = true,
            canInteract = function()
              return isAdmin
            end,
          }
        end
        -- Add target
        local zoneId = name.."-"..stashType.."-"..index
        Targets[#Targets+1] = exports['qb-target']:AddCircleZone(zoneId, vector3(x, y, z), data.radius, {
            name = zoneId,
            debugPoly = Config.DebugPoly,
            useZ = false,
          }, {
            options = optionsList,
            distance = 2.5
          }
        )
      end
    end
  end
end)

--------------------------
--     Core Events      --
--     DO NOT TOUCH     --
--------------------------
AddEventHandler('onResourceStart', function(resource)
  if resource == GetCurrentResourceName() then
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    QBCore.Functions.TriggerCallback('sg-stashbox:server:checkPerms', function(bool)
      isAdmin = bool
    end)
  end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
    for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
    for i = 1, #Props do if DoesEntityExist(Props[i]) then DeleteEntity(Props[i]) end end
	end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
  PlayerData = QBCore.Functions.GetPlayerData()
  PlayerJob = QBCore.Functions.GetPlayerData().job
  PlayerGang = QBCore.Functions.GetPlayerData().gang
  QBCore.Functions.TriggerCallback('sg-stashbox:server:checkPerms', function(bool)
    isAdmin = bool
  end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
  PlayerJob = JobInfo
end)