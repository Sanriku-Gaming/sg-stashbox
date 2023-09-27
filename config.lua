print('^5Stashbox^7 - Job and Gang Stashes Script by Nicky of ^4The EliteRP^7')
------------------------
--       CONFIG       --
------------------------
Config = Config or {}

Config.Debug = false                                            -- Show prints to help debug
Config.DebugPoly = false                                        -- Show poly zone for stashes

--Police Raid Options
Config.EnableRaid = true                                        -- Allow Police to open any stash
Config.RaidJobType = 'leo'                                      -- Police job type to raid (false if you don't use jobType)
Config.RaidJobName = 'police'                                   -- Police Job Name
Config.RaidJobGrade = 2                                         -- Minimum grade allowed (applies to type as well)
Config.RaidWebhook = {
  enable = false,
  name = '',
  label = 'Police Raid',
  color = 'blue',
}

Config.AllowAdmin = true                                        -- Allow Admins to access any stash
Config.PermLevel = 'admin'                                      -- Ace perm level (mod, admin, god)
Config.UseCommand = true                                        -- Enable comand for admin to open stashes anywhere
Config.CommandName = 'openStash'                                -- Command name (ex: /openStash)
Config.AdminWebhook = {
  enable = false,
  name = '',
  label = 'Admin Raid',
  color = 'yellow',
}

Config.JobStash = {                                             -- Configureable number of stashes and weight per location
  ['police'] = {                                                -- Job name to access (same as shared > jobs.lua)
    ['1'] = {
      coords = vector4(-130.51, -643.14, 167.5, 5.99),          -- Location of the stash
      radius = 0.65,                                            -- Radius of the Circle Zone
      boxes = 1,                                                -- How many boxes in this stash location
      weight = 100000,                                          -- Stash weight (per box)
      slots = 300,                                              -- Stash slots (per box)
      rank = 0,                                                 -- Minimum rank to open stash
      useProp = true,                                           -- Set true to spawn a prop, false to use existing
      prop = 'prop_mil_crate_02',                               -- Prop to spawn if useProp is true
    },
  },
}

Config.GangStash = {                                            -- Configureable number of stashes and weight per location
  ['thefamily'] = {
    ['1'] = {
      coords = vector4(-132.25, -643.46, 167.5, 357.9),
      radius = 0.65,
      boxes = 2,
      weight = 200000,
      slots = 300,
      rank = 0,
      useProp = true,
      prop = 'prop_mil_crate_01',
    },
    ['2'] = {
      coords = vector4(-133.66, -643.08, 167.5, 306.97),
      radius = 0.65,
      boxes = 6,
      weight = 100000,
      slots = 100,
      rank = 0,
      useProp = true,
      prop = 'p_cs_locker_01_s',
    },
  },
}

--[[
Example Props:

p_cs_locker_01_s - Single Locker
ch_prop_ch_service_locker_02b - Single Locker
bkr_prop_gunlocker_01a - Gun Locker (open)
v_ind_cfcovercrate - Wood Crate
prop_mil_crate_01 - Military Crate (medium)
prop_mil_crate_02 - Military Crate (small)

More can be found at: https://forge.plebmasters.de/objects
]]--