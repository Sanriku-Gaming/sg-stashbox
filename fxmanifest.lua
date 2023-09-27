fx_version "cerulean"
game "gta5"

name "Stashbox"
author "Nicky"
description "Job and Gang Stashes Script by Nicky"
version "1.0.0"

shared_scripts {
  '@qb-core/shared/locale.lua',
  'config.lua',
  'locales/en.lua',
}

client_scripts {
  'client/client.lua',
}

server_script {
  'server/server.lua'
}

--[[ escrow_ignore {
  'config.lua',
  'client/*.lua',
  'locales/*.lua',
  'assets/*.*',
} ]]

lua54 'yes'