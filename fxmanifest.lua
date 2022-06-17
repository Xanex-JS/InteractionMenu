--[[
──────────────────────────────────────────────────────────────────

	SEM_InteractionMenu (fxmanifest.lua) - Created by Scott M
	Current Version: v1.6.1 (Sep 2020)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

──────────────────────────────────────────────────────────────────
]]



-- Resource Metadata
fx_version 'adamant'
game 'common'

--DO NOT REMOVE THESE
title 'SEM_InteractionMenu'
description 'Multi Purpose Interaction Menu'
author 'Scott M [SEM Development]'
version 'v1.6.1' --This is required for the version checker, DO NOT change or remove

client_scripts {
    'dependencies/NativeUI.lua',
    'client.lua',
    'config.lua',
    'functions.lua',
    -- 'kb-c.lua',
    'menu.lua',
}

server_scripts {
    'config.lua',
    'server.lua',
    'functions.lua',
    'DoesHaveKeycard',
    'TogglePublicMenu',
    'ToggleFireMenu',
}

exports {
    'IsOndutyLEO',
    'IsOndutyFire',
    'DoesHaveKeycard',
    'TogglePublicMenu',
    'ToggleFireMenu',
}