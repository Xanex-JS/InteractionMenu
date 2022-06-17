--[[
──────────────────────────────────────────────────────────────────

	SEM_InteractionMenu (fxmanifest.lua) - Created by Scott M
	Current Version: v1.6.1 (Sep 2020)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

──────────────────────────────────────────────────────────────────
]]



resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

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
    'menu.lua',
}

server_scripts {
    'config.lua',
    'server.lua',
    'functions.lua',
}

server_export 'ToggleDuty'
export 'ToggleDuty'

server_export 'CuffNear'
export 'CuffNear'

server_export 'ForceNearCar'
export 'ForceNearCar'

server_export 'ForceOutOfCar'
export 'ForceOutOfCar'

server_export 'DragNearestPlayer'
export 'DragNearestPlayer'