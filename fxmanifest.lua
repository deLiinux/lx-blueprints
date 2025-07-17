fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'Liinux'
description 'Vehicle Blueprints'
version '1.0.0'

client_scripts {
    'client.lua',
    '@ox_lib/init.lua',
}

server_scripts {
    'server.lua',
    '@ox_lib/init.lua',
    "@oxmysql/lib/MySQL.lua",
}

dependencies {
    'qbx-core',
    'ox_inventory',
    'ox_lib'
}