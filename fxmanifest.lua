fx_version 'cerulean'
game 'gta5'

description 'Carry Script for Qbox Framework with ox_target made by Ltc-Bullet '
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_target',
    'qbx_core'
}

lua54 'yes'