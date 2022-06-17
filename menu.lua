--[[
───────────────────────────────────────────────────────────────

	SEM_InteractionMenu (menu.lua) - Created by Scott M
	Current Version: v1.6.1 (Sep 2020)
	
	Support | https://semdevelopment.com/discord
	
        !!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

───────────────────────────────────────────────────────────────
]]



local MenuOri = 0
if Config.MenuOrientation == 0 then
    MenuOri = 0
elseif Config.MenuOrientation == 1 then
    MenuOri = 1320
else
    MenuOri = 0
end


_MenuPool = NativeUI.CreatePool()
MainMenu = NativeUI.CreateMenu()





function Menu()
    local MenuTitle = ''
    if Config.MenuTitle == 0 then
        MenuTitle = 'Interaction Menu'
    elseif Config.MenuTitle == 1 then
        MenuTitle = GetPlayerName(-1)
    elseif Config.MenuTitle == 2 then
        MenuTitle = Config.MenuTitleCustom
    else
        MenuTitle = 'Interaction Menu'
    end



	_MenuPool:Remove()
	_MenuPool = NativeUI.CreatePool()
	MainMenu = NativeUI.CreateMenu(MenuTitle, 'Aspire Gaming Networks', MenuOri)
	_MenuPool:Add(MainMenu)
	MainMenu:SetMenuWidthOffset(Config.MenuWidth)
	collectgarbage()
	
	MainMenu:SetMenuWidthOffset(Config.MenuWidth)	
	_MenuPool:ControlDisablingEnabled(false)
	_MenuPool:MouseControlsEnabled(false)

    -- Public Officer Menu
    if PUBRestrict() then 
        local PUBMenu = _MenuPool:AddSubMenu(MainMenu, '| Public Officer', 'Public Officer Interaction Menu', true)
        PUBMenu:SetMenuWidthOffset(Config.MenuWidth)
            local PubActions = _MenuPool:AddSubMenu(PUBMenu, '| Actions', '', true)
            PUBMenu:SetMenuWidthOffset(Config.MenuWidth)
        local Cuff = NativeUI.CreateItem('| Cuff', 'Cuff Closest Player')
        local Drag = NativeUI.CreateItem('| Drag', 'Drags Closest Player')
        local Seat = NativeUI.CreateItem('| Seat', 'Puts Player in Vehicle')
        local Unseat = NativeUI.CreateItem('| Unseat', 'Removes Player from Vehicle')
        local Radar = NativeUI.CreateItem('| Radar', 'Toggles Wraith Radar')
        local CCTV = NativeUI.CreateItem('| Cameras', 'View Multiple CCTV Cameras')
        local Shotgun = NativeUI.CreateItem('| Toggle Shotgun', 'Toggles Shotgun')
        PubActions:AddItem(Cuff)
        PubActions:AddItem(Drag)
        PubActions:AddItem(Seat)
        PubActions:AddItem(Unseat)
        PubActions:AddItem(CCTV)
        PubActions:AddItem(Shotgun)
        Shotgun.Activated = function(ParentMenu, SelectedItem)
            if (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18) then
                ShotgunEquipped = not ShotgunEquipped
                CarbineEquipped = false
            elseif (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 18) then
                Notify('~r~You Must be in a Police Vehicle to rack/unrack your Shotgun')
                return
            end
            
            if ShotgunEquipped then
                Notify('~g~Shotgun Equipped')
                GiveWeapon('weapon_pumpshotgun')
                AddWeaponComponent('weapon_pumpshotgun', 'component_at_ar_flsh')
            else
                Notify('~y~Shotgun Unequipped')
                RemoveWeaponFromPed(GetPlayerPed(-1), 'weapon_pumpshotgun')
            end
        end
        CCTV.Activated = function(ParentMenu, SelectedItem)
            ExecuteCommand("cctv")
            _MenuPool:CloseAllMenus()
        end
        Cuff.Activated = function(ParentMenu, SelectedItem)
        local player = GetClosestPlayer()
        if player ~= false then
            TriggerServerEvent('SEM_InteractionMenu:CuffNear', player)
        end
        end
        Drag.Activated = function(ParentMenu, SelectedItem)
        local player = GetClosestPlayer()
        if player ~= false then
            TriggerServerEvent('SEM_InteractionMenu:DragNear', player)
        end
        end
        Seat.Activated = function(ParentMenu, SelectedItem)
        local Veh = GetVehiclePedIsIn(Ped, true)

        local player = GetClosestPlayer()
        if player ~= false then
            TriggerServerEvent('SEM_InteractionMenu:SeatNear', player, Veh)
        end
        end
        Unseat.Activated = function(ParentMenu, SelectedItem)
        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            Notify('~o~You need to be outside of the vehicle')
            return
        end

        local player = GetClosestPlayer()
        if player ~= false then
            TriggerServerEvent('SEM_InteractionMenu:UnseatNear', player)
        end
        end
    end


        -- LEO Menu
    if LEORestrict() then
        local LEOMenu = _MenuPool:AddSubMenu(MainMenu, '| LEO Toolbox', 'Law Enforcement Related Menu', true)
        LEOMenu:SetMenuWidthOffset(Config.MenuWidth)
            local LEOActions = _MenuPool:AddSubMenu(LEOMenu, '| Actions', '', true)
            LEOActions:SetMenuWidthOffset(Config.MenuWidth)
                local Cuff = NativeUI.CreateItem('| Cuff', 'Cuff Closest Player')
                local Drag = NativeUI.CreateItem('| Drag', 'Drags Closest Player')
                local Seat = NativeUI.CreateItem('| Seat', 'Puts Player in Vehicle')
                local Unseat = NativeUI.CreateItem('| Unseat', 'Removes Player from Vehicle')
                local Radar = NativeUI.CreateItem('| Radar', 'Toggles Wraith Radar')
                local CCTV = NativeUI.CreateItem('| Cameras', 'View Multiple CCTV Cameras')
                local Inventory = NativeUI.CreateItem('| Inventory', 'Search Inventory')
                local BAC = NativeUI.CreateItem('| BAC', 'Tests BAC Level')
                local Jail = NativeUI.CreateItem('| Jail', 'Jail Player')
                local Unjail = NativeUI.CreateItem('| Unjail', 'Unjails Player')
                local Spikes = NativeUI.CreateItem('| Deploy Spikes', 'Places Spike Strips in Front of Player')
                local Shield = NativeUI.CreateItem('| Toggle Shield', 'Toggles Bulletproof Shield')
                local CarbineRifle = NativeUI.CreateItem('| Toggle Carbine', 'Toggles Carbine Rifle')
                local Shotgun = NativeUI.CreateItem('| Toggle Shotgun', 'Toggles Shotgun')
                PropsList = {}
                for _, Prop in pairs(Config.Props) do
                    table.insert(PropsList, Prop.name)
                end
                local Props = NativeUI.CreateListItem('| Spawn Props', PropsList, 1, 'Spawn Objects/Props')
                local RemoveProps = NativeUI.CreateItem('| Remove Props', 'Removes Spawned Props')
                LEOActions:AddItem(Cuff)
                LEOActions:AddItem(Drag)
                LEOActions:AddItem(Seat)
                LEOActions:AddItem(Unseat)
                LEOActions:AddItem(CCTV)
                if Config.Radar ~= 0 then
                    LEOActions:AddItem(Radar)
                end
                LEOActions:AddItem(Inventory)
                LEOActions:AddItem(BAC)
				if Config.LEOJail then
                    LEOActions:AddItem(Jail)
                    if UnjailAllowed then
                        LEOActions:AddItem(Unjail)
                    end
				end
                LEOActions:AddItem(Spikes)
                LEOActions:AddItem(Shield)
                if Config.UnrackWeapons == 1 or Config.UnrackWeapons == 2 then
                    LEOActions:AddItem(CarbineRifle)
                    LEOActions:AddItem(Shotgun)
                end
                if Config.DisplayProps then
                    LEOActions:AddItem(Props)
                    LEOActions:AddItem(RemoveProps)
                end
                CCTV.Activated = function(ParentMenu, SelectedItem)
                        ExecuteCommand("cctv")
                        _MenuPool:CloseAllMenus()
                end
                Cuff.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:CuffNear', player)
                    end
                end
                Drag.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:DragNear', player)
                    end
                end
                Seat.Activated = function(ParentMenu, SelectedItem)
                    local Veh = GetVehiclePedIsIn(Ped, true)

                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:SeatNear', player, Veh)
                    end
                end
                Unseat.Activated = function(ParentMenu, SelectedItem)
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        Notify('~o~You need to be outside of the vehicle')
                        return
                    end

                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:UnseatNear', player)
                    end
                end
                Radar.Activated = function(ParentMenu, SelectedItem)
                    if Config.Radar ~= 0 then
                        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                            if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18 then
                                if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)) == -1) then
                                    _MenuPool:CloseAllMenus()
                                    if Config.Radar == 1 then
                                        TriggerEvent('wk:openRemote')
                                    elseif Config.Radar == 2 then
                                        TriggerEvent('wk:radarRC')
                                    end
                                else
                                    Notify('~o~You need to be in the driver seat')
                                end
                            else
                                Notify('~o~You need to be in a police vehicle')
                            end
                        else
                            Notify('~o~You need to be in a vehicle')
                        end
                    end
                end
                Inventory.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        Notify('~b~Searching ...')
                        TriggerServerEvent('SEM_InteractionMenu:InventorySearch', player)
                    end
                end
                BAC.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        Notify('~b~Testing ...')
                        TriggerServerEvent('SEM_InteractionMenu:BACTest', player)
                    end
                end
                Jail.Activated = function(ParentMenu, SelectedItem)
                    local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
                    if PlayerID == nil then
                        Notify('~r~Please enter a player ID')
                        return
                    end

                    local JailTime = tonumber(KeyboardInput('Time: (Seconds) - Max Time: ' .. Config.MaxJailTime .. ' | Default Time: 30', string.len(Config.MaxJailTime)))
                    if JailTime == nil then
                        JailTime = 30
                    end
                    if JailTime > Config.MaxJailTime then
                        Notify('~y~Exceeded Max Time\nMax Time: ' .. Config.MaxJailTime .. ' seconds')
                        JailTime = Config.MaxJailTime
                    end

                    Notify('Player Jailed for ~b~' .. JailTime .. ' seconds')
                    TriggerServerEvent('SEM_InteractionMenu:Jail', PlayerID, JailTime)
                end
                Unjail.Activated = function(ParentMenu, SelectedItem)
                    local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
                    if PlayerID == nil then
                        Notify('~r~Please enter a player ID')
                        return
                    end

                    TriggerServerEvent('SEM_InteractionMenu:Unjail', PlayerID)
                end
                Spikes.Activated = function(ParentMenu, SelectedItem)
                    TriggerEvent('SEM_InteractionMenu:Spikes-SpawnSpikes')
                end
                Shield.Activated = function(ParentMenu, SelectedItem)
                    if ShieldActive then
                        DisableShield()
                    else
                        EnableShield()
                    end
                end
                CarbineRifle.Activated = function(ParentMenu, SelectedItem)
                    if (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18) then
                        CarbineEquipped = not CarbineEquipped
                        ShotgunEquipped = false
                    elseif (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 18) then
                        Notify('~r~You Must be in a Police Vehicle to rack/unrack your Carbine Rifle')
                        return
                    end
                
                    if CarbineEquipped then
                        Notify('~g~Carbine Rifle Equipped')
                        GiveWeapon('weapon_carbinerifle')
                        AddWeaponComponent('weapon_carbinerifle', 'component_at_ar_flsh')
                        AddWeaponComponent('weapon_carbinerifle', 'component_at_ar_afgrip')
                    else 
                        Notify('~y~Carbine Rifle Unequipped')
                        RemoveWeaponFromPed(GetPlayerPed(-1), 'weapon_carbinerifle')
                    end
                end
                Shotgun.Activated = function(ParentMenu, SelectedItem)
                    if (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) == 18) then
                        ShotgunEquipped = not ShotgunEquipped
                        CarbineEquipped = false
                    elseif (GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1))) ~= 18) then
                        Notify('~r~You Must be in a Police Vehicle to rack/unrack your Shotgun')
                        return
                    end
                    
                    if ShotgunEquipped then
                        Notify('~g~Shotgun Equipped')
                        GiveWeapon('weapon_pumpshotgun')
                        AddWeaponComponent('weapon_pumpshotgun', 'component_at_ar_flsh')
                    else
                        Notify('~y~Shotgun Unequipped')
                        RemoveWeaponFromPed(GetPlayerPed(-1), 'weapon_pumpshotgun')
                    end
                end
                LEOActions.OnListSelect = function(sender, item, index)
                    if item == Props then
                        for _, Prop in pairs(Config.Props) do
                            if Prop.name == item:IndexToItem(index) then
                                SpawnProp(Prop.spawncode, Prop.name)
                            end
                        end
                    end
                end
                RemoveProps.Activated = function(ParentMenu, SelectedItem)
                    for _, Prop in pairs(Config.Props) do
                        DeleteProp(Prop.spawncode)
                    end
                end

            if Config.DisplayBackup then
                local LEOBackup = _MenuPool:AddSubMenu(LEOMenu, 'Backup', '', true)
                LEOBackup:SetMenuWidthOffset(Config.MenuWidth)
                    --[[
                        Code 1 Backup  | No Lights or Siren
                        Code 2 Backup  | Only Lights
                        Code 3 Backup  | Lights and Siren
                        Code 99 Backup | All Available Unit Responde Code 3
                    ]]
                    local BK1 = NativeUI.CreateItem('Code 1', 'Call Code 1 Backup to your location')
                    local BK2 = NativeUI.CreateItem('Code 2', 'Call Code 2 Backup to your location')
                    local BK3 = NativeUI.CreateItem('Code 3', 'Call Code 3 Backup to your location')
                    local BK99 = NativeUI.CreateItem('Code 99', 'Call Code 99 Backup to your location')
                    local PanicBTN = NativeUI.CreateItem('~r~Panic Button', 'Officer Panic Button')
                    LEOBackup:AddItem(BK1)
                    LEOBackup:AddItem(BK2)
                    LEOBackup:AddItem(BK3)
                    LEOBackup:AddItem(BK99)
                    LEOBackup:AddItem(PanicBTN)
                    BK1.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('SEM_InteractionMenu:Backup', 1, StreetName, Coords)
                    end
                    BK2.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('SEM_InteractionMenu:Backup', 2, StreetName, Coords)
                    end
                    BK3.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('SEM_InteractionMenu:Backup', 3, StreetName, Coords)
                    end
                    BK99.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('SEM_InteractionMenu:Backup', 99, StreetName, Coords)
                    end
                    PanicBTN.Activated = function(ParentMenu, SelectedItem)
                        local Coords = GetEntityCoords(GetPlayerPed(-1))
                        local Street1, Street2 = GetStreetNameAtCoord(Coords.x, Coords.y, Coords.z)
                        local StreetName = GetStreetNameFromHashKey(Street1)

                        TriggerServerEvent('SEM_InteractionMenu:Backup', 'panic', StreetName, Coords)
                    end
            end

            if Config.ShowStations then
                local LEOStation = _MenuPool:AddSubMenu(LEOMenu, '| Stations', '', true)
                LEOStation:SetMenuWidthOffset(Config.MenuWidth)
                    for _, Station in pairs(Config.LEOStations) do
                        local StationCategory = _MenuPool:AddSubMenu(LEOStation, Station.name, '', true)
                        StationCategory:SetMenuWidthOffset(Config.MenuWidth)
                            local SetWaypoint = NativeUI.CreateItem('Set Waypoint', 'Sets Waypoint to Station')
                            local Teleport = NativeUI.CreateItem('Teleport', 'Teleport to Station')
                            StationCategory:AddItem(SetWaypoint)
                            if Config.AllowStationTeleport then
                                StationCategory:AddItem(Teleport)
                            end
                            SetWaypoint.Activated = function(ParentMenu, SelectedItem)
                                SetNewWaypoint(Station.coords.x, Station.coords.y)
                            end
                            Teleport.Activated = function(ParentMenu, SelectedItem)
                                SetEntityCoords(PlayerPedId(), Station.coords.x, Station.coords.y, Station.coords.z)
                                SetEntityHeading(PlayerPedId(), Station.coords.h)
                            end
                    end
            end

            if Config.DisplayLEOUniforms or Config.DisplayLEOLoadouts then
                local LEOLoadouts = _MenuPool:AddSubMenu(LEOMenu, 'Loadouts', '', true)
                LEOLoadouts:SetMenuWidthOffset(Config.MenuWidth)
                    UniformsList = {}
                    for _, Uniform in pairs(Config.LEOUniforms) do
                        table.insert(UniformsList, Uniform.name)
                    end
                    
                    LoadoutsList = {}
                    for Name, Loadout in pairs(Config.LEOLoadouts) do
                        table.insert(LoadoutsList, Name)
                    end

                    local Uniforms = NativeUI.CreateListItem('Uniforms', UniformsList, 1, 'Spawn Uniforms')
                    local Loadouts = NativeUI.CreateListItem('Loadouts', LoadoutsList, 1, 'Spawns LEO Loadouts')
                    if Config.DisplayLEOUniforms then
                        LEOLoadouts:AddItem(Uniforms)
                    end
                    if Config.DisplayLEOLoadouts then
                        LEOLoadouts:AddItem(Loadouts)
                    end
                    LEOLoadouts.OnListSelect = function(sender, item, index)
                        if item == Uniforms then
                            for _, Uniform in pairs(Config.LEOUniforms) do
                                if Uniform.name == item:IndexToItem(index) then
                                    LoadPed(Uniform.spawncode)
                                    Notify('~b~Uniform Spawned: ~g~' .. Uniform.name)
                                end
                            end
                        end



                        if item == Loadouts then
                            for Name, Loadout in pairs(Config.LEOLoadouts) do
                                if Name == item:IndexToItem(index) then
                                    SetEntityHealth(GetPlayerPed(-1), 200)
                                    RemoveAllPedWeapons(GetPlayerPed(-1), true)
                                    AddArmourToPed(GetPlayerPed(-1), 100)

                                    for _, Weapon in pairs(Loadout) do
                                        GiveWeapon(Weapon.weapon)
                                                                
                                        for _, Component in pairs(Weapon.components) do
                                            AddWeaponComponent(Weapon.weapon, Component)
                                        end
                                    end

                                    Notify('~b~Loadout Spawned: ~g~' .. Name)
                                end
                            end
                        end
                    end
            end

            if Config.ShowLEOVehicles then
                local LEOVehicles = _MenuPool:AddSubMenu(LEOMenu, '| Vehicles', '', true)
                LEOVehicles:SetMenuWidthOffset(Config.MenuWidth)
                
                for Name, Category in pairs(Config.LEOVehiclesCategories) do
                    local LEOCategory = _MenuPool:AddSubMenu(LEOVehicles, Name, '', true)
                    LEOCategory:SetMenuWidthOffset(Config.MenuWidth)
                    for _, Vehicle in pairs(Category) do
                        local LEOVehicle = NativeUI.CreateItem(Vehicle.name, '')
                        LEOCategory:AddItem(LEOVehicle)
                        if Config.ShowLEOSpawnCode then
                            LEOVehicle:RightLabel(Vehicle.spawncode)
                        end
                        LEOVehicle.Activated = function(ParentMenu, SelectedItem)
                            SpawnVehicle(Vehicle.spawncode, Vehicle.name, Vehicle.livery, Vehicle.extras)
                        end
                    end
                end
            end

            if Config.DisplayTrafficManager then
                local LEOTrafficManager = _MenuPool:AddSubMenu(LEOMenu, '| Traffic Section', '', true)
                local LEOControlTraffic = _MenuPool:AddSubMenu(LEOTrafficManager, '| Control Traffic', '', true)
                local LEOTowTraffic = _MenuPool:AddSubMenu(LEOTrafficManager, '| Tow Vehicles', '', true)
                LEOTrafficManager:SetMenuWidthOffset(Config.MenuWidth)
                LEOControlTraffic:SetMenuWidthOffset(Config.MenuWidth)
                LEOTowTraffic:SetMenuWidthOffset(Config.MenuWidth)
    
                    local TMSlow = NativeUI.CreateItem('| Slow Traffic', '')
                    local TMStop = NativeUI.CreateItem('| Stop Traffic', '')
                    local TMResume = NativeUI.CreateItem('| Resume Traffic', '')
                    local TMTow = NativeUI.CreateItem('| Tow Vehicle', '')
                    local TMTowC = NativeUI.CreateItem('| Cancel Tow', '')
                    LEOControlTraffic:AddItem(TMStop)
                    LEOControlTraffic:AddItem(TMSlow)
                    LEOControlTraffic:AddItem(TMResume)
                    LEOTowTraffic:AddItem(TMTow)
                    LEOTowTraffic:AddItem(TMTowC)
                    TMTowC.Activated = function(ParentMenu, SelectedItem)
                        TriggerEvent("pis:cancelTow")
                    end
                    TMTow.Activated = function(ParentMenu, SelectedItem)
                            TriggerEvent("pis:spawnTow")
                    end
                    TMStop.Activated = function(ParentMenu, SelectedItem)
                            TriggerEvent("stoptraffic")
                    end
                    TMSlow.Activated = function(ParentMenu, SelectedItem)
                        TriggerEvent("slowtraffic")
                    end
                    TMResume.Activated = function(ParentMenu, SelectedItem)
                        TriggerEvent("resumetraffic")
                    end
                end
    end

    function ShowNotification( text )
        SetNotificationTextEntry("STRING")
        AddTextComponentSubstringPlayerName(text)
        DrawNotification(false, false)
    end
    
    local sz = nil
    
    
    RegisterNetEvent('slowtraffic')
    AddEventHandler('slowtraffic', function()
    
    if sz ~= nil then 
    RemoveSpeedZone(sz)
    ShowNotification("Traffic ~g~Resumed")
    sz = nil
    RemoveBlip(tcblip)
    else
    ShowNotification("Traffic ~y~Slowed")
    tcblip = AddBlipForRadius(GetEntityCoords(GetPlayerPed(-1)),40.0)
    SetBlipAlpha(tcblip,80)
    SetBlipColour(tcblip,5)
    sz = AddSpeedZoneForCoord(GetEntityCoords(GetPlayerPed(-1)),40.0,5.0,false)
    
    end
    
    end)
    RegisterNetEvent('resumetraffic')
    AddEventHandler('resumetraffic', function()
    if sz ~= nil then 
    RemoveSpeedZone(sz)
    ShowNotification("Traffic ~g~Resumed")
    sz = nil
    RemoveBlip(tcblip)
    
    end
    end)
    RegisterNetEvent('stoptraffic')
    AddEventHandler('stoptraffic', function()
    
    if sz ~= nil then 
    RemoveSpeedZone(sz)
    ShowNotification("Traffic ~g~Resumed")
    sz = nil
    RemoveBlip(tcblip)
    else
    ShowNotification("Traffic ~r~Stopped")
    tcblip = AddBlipForRadius(GetEntityCoords(GetPlayerPed(-1)),50.0)
    sz = AddSpeedZoneForCoord(GetEntityCoords(GetPlayerPed(-1)),50.0,0.0,false)
    SetBlipAlpha(tcblip,80)
    SetBlipColour(tcblip,1)
    
    end
    
    end)
    AddSpeedZoneForCoord(236.2,6565.1,31.5,40.0,20.0,false)
    AddSpeedZoneForCoord(161.2,6544.5,31.8,40.0,10.0,false)

    if FireRestrict() then
        local FireMenu = _MenuPool:AddSubMenu(MainMenu, '| Medical', 'Medical Related Menu', true)
        FireMenu:SetMenuWidthOffset(Config.MenuWidth)
            local FireActions = _MenuPool:AddSubMenu(FireMenu, '| Actions', '', true)
            FireActions:SetMenuWidthOffset(Config.MenuWidth)
                local Drag = NativeUI.CreateItem('| Drag', 'Drags Closest Player')
                local Seat = NativeUI.CreateItem('| Seat', 'Puts Player in Vehicle')
                local Unseat = NativeUI.CreateItem('| Unseat', 'Removes Player from Vehicle')
                local Revive = NativeUI.CreateItem('| Revive', 'Revives the nearest player')
                FireActions:AddItem(Revive)
                FireActions:AddItem(Drag)
                FireActions:AddItem(Seat)
                FireActions:AddItem(Unseat)
                Revive.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:ReviveNear', player)
                    end
                end
                Drag.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:DragNear', player)
                    end
                end
                Seat.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:SeatNear', player, Veh)
                    end
                end
                Unseat.Activated = function(ParentMenu, SelectedItem)
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        Notify('~o~You need to be outside of the vehicle')
                        return
                    end

                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:UnseatNear', player)
                    end
                end
				if Config.FireHospital then
                    local HospitalLocations = _MenuPool:AddSubMenu(FireActions, '| Hospitalize', '', true)
                    HospitalLocations:SetMenuWidthOffset(Config.MenuWidth)
                        for HospitalName, HospitalInfo in pairs(Config.HospitalLocation) do
                            local Hospitalize = NativeUI.CreateItem(HospitalName, '| Hospitalize Player')
                            HospitalLocations:AddItem(Hospitalize)
                            Hospitalize.Activated = function(ParentMenu, SelectedItem)
                                local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
                                if PlayerID == nil then
                                    Notify('~r~Please enter a player ID')
                                    return
                                end

                                local HospitalTime = tonumber(KeyboardInput('Time: (Seconds) - Max Time: ' .. Config.MaxHospitalTime .. ' | Default Time: 30', 3))
                                if HospitalTime == nil then
                                    HospitalTime = 30
                                end
                                if HospitalTime > Config.MaxHospitalTime then
                                    Notify('~y~Exceeded Max Time\nMax Time: ' .. Config.MaxHospitalTime .. ' seconds')
                                    HospitalTime = Config.MaxHospitalTime
                                end

                                Notify('Player Hospitalized for ~b~' .. HospitalTime .. ' seconds')
                                TriggerServerEvent('SEM_InteractionMenu:Hospitalize', PlayerID, HospitalTime, HospitalInfo)
                            end
                        end
                    local Unhospitalize = NativeUI.CreateItem('Unhospitalize', 'Unhospitalize Player')
                    if UnhospitalAllowed then
                        FireActions:AddItem(Unhospitalize)
                    end
                    Unhospitalize.Activated = function(ParentMenu, SelectedItem)
                        local PlayerID = tonumber(KeyboardInput('Player ID:', 10))
                        if PlayerID == nil then
                            Notify('~r~Please enter a player ID')
                            return
                        end

                        TriggerServerEvent('SEM_InteractionMenu:Unhospitalize', PlayerID)
                    end
                end
                PropsList = {}
                for _, Prop in pairs(Config.Props) do
                    table.insert(PropsList, Prop.name)
                end
                local Props = NativeUI.CreateListItem('| Spawn Props', PropsList, 1, 'Spawn Objects/Props')
                local RemoveProps = NativeUI.CreateItem('| Remove Props', 'Removes Spawned Props')
                FireActions.OnListSelect = function(sender, item, index)
                    if item == Props then
                        for _, Prop in pairs(Config.Props) do
                            if Prop.name == item:IndexToItem(index) then
                                SpawnProp(Prop.spawncode, Prop.name)
                            end
                        end
                    end
                end
                RemoveProps.Activated = function(ParentMenu, SelectedItem)
                    for _, Prop in pairs(Config.Props) do
                        DeleteProp(Prop.spawncode)
                    end
                end

            if Config.ShowStations then
                local FireEMSStation = _MenuPool:AddSubMenu(FireMenu, '| Stations', '', true)
                FireEMSStation:SetMenuWidthOffset(Config.MenuWidth)
                    local FireStation = _MenuPool:AddSubMenu(FireEMSStation, '| Fire Stations', '', true)
                    FireStation:SetMenuWidthOffset(Config.MenuWidth)
                        for _, Station in pairs(Config.FireStations) do
                            local StationCategory = _MenuPool:AddSubMenu(FireStation, Station.name, '', true)
                            StationCategory:SetMenuWidthOffset(Config.MenuWidth)
                                local SetWaypoint = NativeUI.CreateItem('| Set Waypoint', 'Sets Waypoint to Station')
                                local Teleport = NativeUI.CreateItem('| Teleport', 'Teleport to Station')
                                StationCategory:AddItem(SetWaypoint)
                                if Config.AllowStationTeleport then
                                    StationCategory:AddItem(Teleport)
                                end
                                SetWaypoint.Activated = function(ParentMenu, SelectedItem)
                                    SetNewWaypoint(Station.coords.x, Station.coords.y)
                                end
                                Teleport.Activated = function(ParentMenu, SelectedItem)
                                    SetEntityCoords(PlayerPedId(), Station.coords.x, Station.coords.y, Station.coords.z)
                                    SetEntityHeading(PlayerPedId(), Station.coords.h)
                                end
                        end

                    local EMSStation = _MenuPool:AddSubMenu(FireEMSStation, '| Hospitals', '', true)
                    EMSStation:SetMenuWidthOffset(Config.MenuWidth)
                        for _, Station in pairs(Config.HospitalStations) do
                            local StationCategory = _MenuPool:AddSubMenu(EMSStation, Station.name, '', true)
                            StationCategory:SetMenuWidthOffset(Config.MenuWidth)
                                local SetWaypoint = NativeUI.CreateItem('| Set Waypoint', 'Sets Waypoint to Station')
                                local Teleport = NativeUI.CreateItem('| Teleport', 'Teleport to Station')
                                StationCategory:AddItem(SetWaypoint)
                                if Config.AllowStationTeleport then
                                    StationCategory:AddItem(Teleport)
                                end
                                SetWaypoint.Activated = function(ParentMenu, SelectedItem)
                                    SetNewWaypoint(Station.coords.x, Station.coords.y)
                                end
                                Teleport.Activated = function(ParentMenu, SelectedItem)
                                    SetEntityCoords(PlayerPedId(), Station.coords.x, Station.coords.y, Station.coords.z)
                                    SetEntityHeading(PlayerPedId(), Station.coords.h)
                                end
                        end
            end

            if Config.DisplayFireUniforms or Config.DisplayFireLoadouts then
                local FireLoadouts = _MenuPool:AddSubMenu(FireMenu, '| Loadouts', '', true)
                FireLoadouts:SetMenuWidthOffset(Config.MenuWidth)
                    UniformsList = {}
                    for _, Uniform in pairs(Config.FireUniforms) do
                        table.insert(UniformsList, Uniform.name)
                    end
                        
                    LoadoutsList = {
                        'Clear',
                        'Standard',
                    }
                    local Uniforms = NativeUI.CreateListItem('| Uniforms', UniformsList, 1, 'Spawn Uniforms')
                    local Loadouts = NativeUI.CreateListItem('| Loadouts', LoadoutsList, 1, 'Spawns Fire Loadouts')
                    if Config.DisplayFireUniforms then
                        FireLoadouts:AddItem(Uniforms)
                    end
                    if Config.DisplayFireLoadouts then
                        FireLoadouts:AddItem(Loadouts)
                    end
                    FireLoadouts.OnListSelect = function(sender, item, index)
                        if item == Uniforms then
                            for _, Uniform in pairs(Config.FireUniforms) do
                                if Uniform.name == item:IndexToItem(index) then
                                    LoadPed(Uniform.spawncode)
                                    Notify('~b~Uniform Spawned: ~g~' .. Uniform.name)
                                end
                            end
                        end
            
            
            
                        if item == Loadouts then
                            local SelectedLoadout = item:IndexToItem(index)
                            if SelectedLoadout == 'Clear' then
                                SetEntityHealth(GetPlayerPed(-1), 200)
                                RemoveAllPedWeapons(GetPlayerPed(-1), true)
                                Notify('~r~All Weapons Cleared!')
                            elseif SelectedLoadout == 'Standard' then
                                SetEntityHealth(GetPlayerPed(-1), 200)
                                RemoveAllPedWeapons(GetPlayerPed(-1), true)
                                AddArmourToPed(GetPlayerPed(-1), 100)
                                GiveWeapon('weapon_flashlight')
                                GiveWeapon('weapon_fireextinguisher')
                                GiveWeapon('weapon_flare')
                                GiveWeapon('weapon_stungun')
                                Notify('~b~Loadout Spawned: ~g~' .. SelectedLoadout)
                            end
                        end
                    end
            end
            
            if Config.ShowFireVehicles then
                local FireVehicles = _MenuPool:AddSubMenu(FireMenu, '| Vehicles', '', true)
                FireVehicles:SetMenuWidthOffset(Config.MenuWidth)
                
                for _, Vehicle in pairs(Config.FireVehicles) do
                    local FireVehicle = NativeUI.CreateItem(Vehicle.name, '')
                    FireVehicles:AddItem(FireVehicle)
                    if Config.ShowFireSpawnCode then
                        FireVehicle:RightLabel(Vehicle.spawncode)
                    end
                    FireVehicle.Activated = function(ParentMenu, SelectedItem)
                        SpawnVehicle(Vehicle.spawncode, Vehicle.name, Vehicle.livery, Vehicle.extras)
                    end
                end
            end
    end




    if CivRestrict() then
        local CivMenu = _MenuPool:AddSubMenu(MainMenu, '| Civ Toolbox', 'Civilian Related Menu', true)
        local CivSetName = _MenuPool:AddSubMenu(CivMenu, '| CAD Related', 'Civilian Related Menu', true)
        CivMenu:SetMenuWidthOffset(Config.MenuWidth)
        CivSetName:SetMenuWidthOffset(Config.MenuWidth)
            local CivActions = _MenuPool:AddSubMenu(CivMenu, '| Actions', '', true)
            CivActions:SetMenuWidthOffset(Config.MenuWidth)
            CivSetName:SetMenuWidthOffset(Config.MenuWidth)
                local HU = NativeUI.CreateItem('| HU', 'Hands Up')
                local HUK = NativeUI.CreateItem('| HUK', 'Hands Up and Kneel')
                local Inventory = NativeUI.CreateItem('| Inventory', 'Set Inventory')
                local BAC = NativeUI.CreateItem('| BAC', 'Set BAC Level')
                local DropWeapon = NativeUI.CreateItem('| Drop Weapon', 'Drops Weapon on the floor')
                local Drag = NativeUI.CreateItem('| Drag', 'Drags Closest Player')
                local SetName = NativeUI.CreateItem('| Set Showid', 'Set Your Civilians Name. ~r~This needs to be the same as CAD.')
                local ShowID = NativeUI.CreateItem('| Show ID', 'Shows your ID to the nearest player.')
                CivSetName:AddItem(ShowID)
                CivSetName:AddItem(SetName)
                CivActions:AddItem(HU)
                CivActions:AddItem(HUK)
                CivActions:AddItem(Inventory)
                CivActions:AddItem(BAC)
                CivActions:AddItem(DropWeapon)
                CivActions:AddItem(Drag)
                SetName.Activated = function(ParentMenu, SelectedItem)
                    local CivName = KeyboardInput('Civilian Name:', 45)
                    local CivDOB = KeyboardInput('Civilian DOB:', 15)
                    local Name = GetPlayerName(NetworkGetEntityOwner(GetPlayerPed(-1)))
                    if CivName == nil or CivName == '' then
                        exports['mythic_notify']:SendAlert('error', 'Civilian Name not Provided')
                        return
                    end
                    if CivDOB == nil or CivDOB == '' then
                        exports['mythic_notify']:SendAlert('error', 'No DOB Provided')
                        return
                    end
                    TriggerEvent("StoreID", CivName, CivDOB)
                    exports['mythic_notify']:SendAlert('inform', 'Set ID: ' .. CivName .. ' With DOB: ' .. CivDOB)
                end
                ShowID.Activated = function(ParentMenu, SelectedItem)
                    local Name = GetPlayerName(NetworkGetEntityOwner(GetPlayerPed(-1)))
                    if CivName then
                        ExecuteCommand("me ^1 Shows ID: " .. CivName .. ' DOB: ' .. CivDOB)
                            -- sendMsg(Name .. '^2 Shows ID: ' .. CivName .. ' With DOB: ' .. CivDOB)
                    else
                        exports['mythic_notify']:SendAlert('error', 'You Don\'t have a Civilian Name Set')
                    end
                end
                HU.Activated = function(ParentMenu, SelectedItem)
                    local Ped = PlayerPedId()
                    if DoesEntityExist(Ped) and not HandCuffed then
                        Citizen.CreateThread(function()
                            LoadAnimation('random@mugging3')
                            if IsEntityPlayingAnim(Ped, 'random@mugging3', 'handsup_standing_base', 3) or HandCuffed then
                                ClearPedSecondaryTask(Ped)
                                SetEnableHandcuffs(Ped, false)
                            elseif not IsEntityPlayingAnim(Ped, 'random@mugging3', 'handsup_standing_base', 3) or not HandCuffed then
                                TaskPlayAnim(Ped, 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0, 0, 0, 0)
                                SetEnableHandcuffs(Ped, true)
                            end
                        end)
                    end
                end
                HUK.Activated = function(ParentMenu, SelectedItem)
                    local Ped = PlayerPedId()
                    if (DoesEntityExist(Ped) and not IsEntityDead(Ped)) and not HandCuffed then
                        Citizen.CreateThread(function()
                            LoadAnimation('random@arrests')
                            if (IsEntityPlayingAnim(Ped, 'random@arrests', 'kneeling_arrest_idle', 3)) then
                                TaskPlayAnim(Ped, 'random@arrests', 'kneeling_arrest_get_up', 8.0, 1.0, -1, 128, 0, 0, 0, 0)
                            else
                                TaskPlayAnim(Ped, 'random@arrests', 'idle_2_hands_up', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                                Wait (4000)
                                TaskPlayAnim(Ped, 'random@arrests', 'kneeling_arrest_idle', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                            end
                        end)
                    end
                end
                Drag.Activated = function(ParentMenu, SelectedItem)
                    local player = GetClosestPlayer()
                    if player ~= false then
                        TriggerServerEvent('SEM_InteractionMenu:DragNear', player)
                    end
                end
                Inventory.Activated = function(ParentMenu, SelectedItem)
                    local Items = KeyboardInput('Items:', 75)
                    if Items == nil or Items == '' then
                        Notify('~r~No Items Provided!')
                        return
                    end

                    TriggerServerEvent('SEM_InteractionMenu:InventorySet', Items)
                    Notify('~g~Inventory Set!')
                end
                BAC.Activated = function(ParentMenu, SelectedItem)
                    local BACLevel = KeyboardInput('BAC Level - Legal Limit: 0.08', 5)
                    if BACLevel == nil or BACLevel == '' then
                        Notify('~r~No BAC Level Provided!')
                        return
                    end

                    TriggerServerEvent('SEM_InteractionMenu:BACSet', tonumber(BACLevel))
                    if tonumber(BACLevel) < 0.08 then
                        Notify('~b~BAC Level Set: ~g~' .. tostring(BACLevel))
                    else
                        Notify('~b~BAC Level Set: ~r~' .. tostring(BACLevel))
                    end
                end
                DropWeapon.Activated = function(ParentMenu, SelectedItem)
                    local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
                    SetCurrentPedWeapon(PlayerPedId(), 'weapon_unarmed', true)
                    SetPedDropsInventoryWeapon(GetPlayerPed(-1), CurrentWeapon, -2.0, 0.0, 0.5, 30)
                    Notify('~r~Weapon Dropped!')
                end
            if Config.ShowCivAdverts then
                local CivAdverts = _MenuPool:AddSubMenu(CivMenu, '| Adverts', 'Civilian Adverts', true)
                CivAdverts:SetMenuWidthOffset(Config.MenuWidth)
                    for _, Ad in pairs(Config.CivAdverts) do
                        local Advert  = NativeUI.CreateItem(Ad.name, '')
                        CivAdverts:AddItem(Advert)
                        Advert.Activated = function(ParentMenu, SelectedItem)
                            local Message = KeyboardInput('Message:', 128)
                            if Message == nil or Message == '' then
                                Notify('~r~No Advert Message Provided!')
                                return
                            end
                
                            TriggerServerEvent('SEM_InteractionMenu:Ads', Message, Ad.name, Ad.loc, Ad.file)
                        end
                    end
            end
            if Config.ShowCivVehicles then
                local CivVehicles = _MenuPool:AddSubMenu(CivMenu, '| Vehicles', '', true)
                CivVehicles:SetMenuWidthOffset(Config.MenuWidth)
                
                for _, Vehicle in pairs(Config.CivVehicles) do
                    local CivVehicle = NativeUI.CreateItem(Vehicle.name, '')
                    CivVehicles:AddItem(CivVehicle)
                    if Config.ShowCivSpawnCode then
                        CivVehicle:RightLabel(Vehicle.spawncode)
                    end
                    CivVehicle.Activated = function(ParentMenu, SelectedItem)
                        SpawnVehicle(Vehicle.spawncode, Vehicle.name)
                    end
                end
            end
    end





    if VehicleRestrict() then
        local VehicleMenu = _MenuPool:AddSubMenu(MainMenu, '| Vehicle', 'Vehicle Related Menu', true)
        VehicleMenu:SetMenuWidthOffset(Config.MenuWidth)
            local Seats = {-1, 0, 1, 2}
            local Windows = {'Front', 'Rear', 'All'}
            local Doors = {'Driver', 'Passenger', 'Rear Right', 'Rear Left', 'Hood', 'Trunk', 'All'}
            local Engine = NativeUI.CreateItem('| Toggle Engine', 'Toggles Vehicle\'s Engine')
            local ILights = NativeUI.CreateItem('| Toggle Interior Light', 'Toggles Vehicle\'s Interior Light')
            local Seat = NativeUI.CreateSliderItem('| Change Seats', Seats, 1, 'Change Seats in a Vehicle')
            local Window = NativeUI.CreateListItem('| Windows', Windows, 1, 'Open/Close Windows')
            local Door = NativeUI.CreateListItem('| Doors', Doors, 1, 'Open/Close Doors')
            VehicleMenu:AddItem(Engine)
            VehicleMenu:AddItem(ILights)
            VehicleMenu:AddItem(Seat)
            VehicleMenu:AddItem(Window)
            VehicleMenu:AddItem(Door)
            Engine.Activated = function(ParentMenu, SelectedItem)
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if Vehicle ~= nil and Vehicle ~= 0 and GetPedInVehicleSeat(Vehicle, 0) then
                    SetVehicleEngineOn(Vehicle, (not GetIsVehicleEngineRunning(Vehicle)), false, true)
                    Notify('~g~Engine Toggled!')
                else
                    Notify('~r~You\'re not in a Vehicle!')
                end
            end
            ILights.Activated = function(ParentMenu, SelectedItem)
                local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                if IsPedInVehicle(PlayerPedId(), Vehicle, false) then
                    if IsVehicleInteriorLightOn(Vehicle) then
                        SetVehicleInteriorlight(Vehicle, false)
                    else
                        SetVehicleInteriorlight(Vehicle, true)
                    end
                else
                    Notify('~r~You\'re not in a Vehicle!')
                end
            end
            VehicleMenu.OnSliderChange = function(sender, item, index)
                if item == Seat then
                    VehicleSeat = item:IndexToItem(index)
                    local Veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
                    SetPedIntoVehicle(PlayerPedId(), Veh, VehicleSeat)
                end
            end
            VehicleMenu.OnListSelect = function(sender, item, index)
                local Ped = GetPlayerPed(-1)
                local Veh = GetVehiclePedIsIn(Ped, false)

                if item == Window then
                    VehicleWindow = item:IndexToItem(index)
                    if VehicleWindow == 'Front' then
                        if IsPedInAnyVehicle(Ped, false) then
                            if (GetPedInVehicleSeat(Veh, -1) == Ped) then 
                                SetEntityAsMissionEntity(Veh, true, true)
                                if (WindowFrontRolled) then
                                    RollDownWindow(Veh, 0)
                                    RollDownWindow(Veh, 1)
                                    WindowFrontRolled = false
                                else
                                    RollUpWindow(Veh, 0)
                                    RollUpWindow(Veh, 1)
                                    WindowFrontRolled = true
                                end
                            end
                        end
                    elseif VehicleWindow == 'Rear' then
                        if IsPedInAnyVehicle(Ped, false) then
                            if (GetPedInVehicleSeat(Veh, -1) == Ped) then 
                                SetEntityAsMissionEntity(Veh, true, true)
                                if (WindowFrontRolled) then
                                    RollDownWindow(Veh, 2)
                                    RollDownWindow(Veh, 3)
                                    WindowFrontRolled = false
                                else
                                    RollUpWindow(Veh, 2)
                                    RollUpWindow(Veh, 3)
                                    WindowFrontRolled = true
                                end
                            end
                        end
                    elseif VehicleWindow == 'All' then
                        if IsPedInAnyVehicle(Ped, false) then
                            if (GetPedInVehicleSeat(Veh, -1) == Ped) then 
                                SetEntityAsMissionEntity(Veh, true, true)
                                if (WindowFrontRolled) then
                                    RollDownWindow(Veh, 0)
                                    RollDownWindow(Veh, 1)
                                    RollDownWindow(Veh, 2)
                                    RollDownWindow(Veh, 3)
                                    WindowFrontRolled = false
                                else
                                    RollUpWindow(Veh, 0)
                                    RollUpWindow(Veh, 1)
                                    RollUpWindow(Veh, 2)
                                    RollUpWindow(Veh, 3)
                                    WindowFrontRolled = true
                                end
                            end
                        end
                    end
                elseif item == Door then
                    local Doors = {'Driver', 'Passenger', 'Rear Left', 'Rear Right', 'Hood', 'Trunk', 'All'}
                    VehicleDoor = item:IndexToItem(index)
                    if VehicleDoor == 'Driver' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 0) > 0 then
                                SetVehicleDoorShut(Veh, 0, false)
                            else
                                SetVehicleDoorOpen(Veh, 0, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Passenger' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 1) > 0 then
                                SetVehicleDoorShut(Veh, 1, false)
                            else
                                SetVehicleDoorOpen(Veh, 1, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Rear Left' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 2) > 0 then
                                SetVehicleDoorShut(Veh, 2, false)
                            else
                                SetVehicleDoorOpen(Veh, 2, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Rear Right' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 3) > 0 then
                                SetVehicleDoorShut(Veh, 3, false)
                            else
                                SetVehicleDoorOpen(Veh, 3, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Hood' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 4) > 0 then
                                SetVehicleDoorShut(Veh, 4, false)
                            else
                                SetVehicleDoorOpen(Veh, 4, false, false)
                            end
                        end
                    elseif VehicleDoor == 'Trunk' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 5) > 0 then
                                SetVehicleDoorShut(Veh, 5, false)
                            else
                                SetVehicleDoorOpen(Veh, 5, false, false)
                            end
                        end
                    elseif VehicleDoor == 'All' then
                        if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
                            if GetVehicleDoorAngleRatio(Veh, 0) > 0 then
                                SetVehicleDoorShut(Veh, 0, false)
                                SetVehicleDoorShut(Veh, 1, false)
                                SetVehicleDoorShut(Veh, 2, false)
                                SetVehicleDoorShut(Veh, 3, false)
                                SetVehicleDoorShut(Veh, 4, false)
                                SetVehicleDoorShut(Veh, 5, false)
                            else
                                SetVehicleDoorOpen(Veh, 0, false, false)
                                SetVehicleDoorOpen(Veh, 1, false, false)
                                SetVehicleDoorOpen(Veh, 2, false, false)
                                SetVehicleDoorOpen(Veh, 3, false, false)
                                SetVehicleDoorOpen(Veh, 4, false, false)
                                SetVehicleDoorOpen(Veh, 5, false, false)
                            end
                        end
                    end
                end
            end

            if Config.VehicleOptions then
              --  local FixVeh = NativeUI.CreateItem('Repair Vehicle', 'Repairs Current Vehicle')
                local CleanVeh = NativeUI.CreateItem('| Clean Vehicle', 'Cleans Current Vehicle')
                local DelVeh = NativeUI.CreateItem('~r~| Delete Vehicle', 'Deletes Current Vehicle')
               -- VehicleMenu:AddItem(FixVeh)
                VehicleMenu:AddItem(CleanVeh)
                VehicleMenu:AddItem(DelVeh)
              --  FixVeh.Activated = function(ParentMenu, SelectedItem)
                --    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                 --   if Vehicle ~= nil and Vehicle ~= 0 then
                  --      SetVehicleEngineHealth(Vehicle, 100)
                  --      SetVehicleFixed(Vehicle)
                  --      Notify('~g~Vehicle Repaired!')
                  --  else
                       -- Notify('~r~You\'re not in a Vehicle!')
                  --  end

              --  end
                CleanVeh.Activated = function(ParentMenu, SelectedItem)
                    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    if Vehicle ~= nil and Vehicle ~= 0 then
                        SetVehicleDirtLevel(Vehicle, 0)
                        Notify('~g~Vehicle Cleaned!')
                    else
                        Notify('~r~You\'re not in a Vehicle!')
                    end
                end
                DelVeh.Activated = function(ParentMenu, SelectedItem)
                    if (IsPedSittingInAnyVehicle(PlayerPedId())) then 
                        local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                        if (GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId()) then 
                            SetEntityAsMissionEntity(Vehicle, true, true)
                            DeleteVehicle(Vehicle)

                            if (DoesEntityExist(Vehicle)) then 
                                Notify('~o~Unable to delete vehicle, try again.')
                            else 
                                Notify('~r~Vehicle Deleted!')
                            end 
                        else 
                            Notify('~r~You must be in the driver\'s seat!')
                        end 
                    else
                        Notify('~r~You\'re not in a Vehicle!')
                    end
                end
            end
    end



        

    if EmoteRestrict() then
        local EmotesList = {}
        for _, Emote in pairs(Config.EmotesList) do
            table.insert(EmotesList, Emote.name)
        end

        local EmotesMenu = NativeUI.CreateListItem('| Emotes', EmotesList, 1, 'General RP Emotes')
        MainMenu:AddItem(EmotesMenu)
            
            MainMenu.OnListSelect = function(sender, item, index)
                if item == EmotesMenu then
                    for _, Emote in pairs(Config.EmotesList) do
                        if Emote.name == item:IndexToItem(index) then
                            PlayEmote(Emote.emote, Emote.name)
                        end
                    end
                end
            end
    end
        


    _MenuPool:RefreshIndex()
end



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		_MenuPool:ProcessMenus()	
		_MenuPool:ControlDisablingEnabled(false)
		_MenuPool:MouseControlsEnabled(false)
		
		if IsControlJustPressed(1, Config.MenuButton) and GetLastInputMethod(2) then
			if not menuOpen then
				Menu()
                MainMenu:Visible(true)
            else
                _MenuPool:CloseAllMenus()
			end
		end
	end
end)

RegisterCommand("force", function(source)
    LEOAce = true
    PUBAce = true
    FireAce = true
    FireOnduty = true
end)

RegisterCommand(Config.Command, function(source, args, rawCommands)
    if Config.OpenMenu == 1 then
        Menu()
        MainMenu:Visible(true)
    end
end)

Citizen.CreateThread(function()
    if Config.OpenMenu == 1 then
        TriggerEvent('chat:addSuggestion', '/' .. Config.Command, 'Used to open SEM_InteractionMenu')
    end
end)

-- towing

-- C O N F I G --
local companyName = "Xanex's Towing"

local towOffset = -5.0

local deleteLastTruck = true --Deletes the last spawned truck.
local spawnDistance = 50 	--	Default 50
							---								---
local drivingStyle = 786603  	--	**786603  - "Normal" - Default**
								--	**1074528293 - "Rushed"**
								--	**2883621 - "Ignore Lights"**
								--	**5 - "Sometimes Overtake Traffic"**
								--	**Customize Driving Style: https://vespura.com/drivingstyle/

local towDriverQuoteOfTheDay = {
	"Xanex is a bad CEO, anyway, towing your vehicle.",
	"Do you even lift bro? Because I do.",
	"You called the right guy, because I got puns from head to tow.",
	"Tow'nt worry about it, I'll get it towed!",
	"I wont charge you a arm and a leg! I only want your tows.",
	"You want too hook up some time?",
	"I hate my job.",
	"Sorry I took so long!",
	"We have some of the best hookers in town!",
	"There ya go!",
	"Take care.",
	"That will look good in the impound!",
	"Fuck you.",
	"I got it!",
	"Thanks for using " .. companyName .. "!",
	"It will be at the compound."
}	
								
-- Register a network event 
RegisterNetEvent('pis:spawnTow')
RegisterNetEvent('pis:cancelTow')

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

-- The distance to check in front of the player for a vehicle
-- Distance is in GTA units, which are quite big  
local distanceToCheck = 5.0

enroute = false
onscene = false
cleartask = false

AddEventHandler( 'pis:spawnTow', function()
	--local spawnDistance = math.random(spawnDistance * -1, spawnDistance)
	local spawnDistance = math.random(spawnDistance, spawnDistance + 25)
	local player = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(player)
	local pmodels = {"mp_m_waremech_01"}
	local vehicles = {"flatbed"}
	local driver = GetHashKey(pmodels[math.random(#pmodels)])
	local vehiclehash = GetHashKey(vehicles[math.random(#vehicles)])
    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(player, 0.0, distanceToCheck, 0.0)
    local ped = GetPlayerPed(-1)
	RequestModel(vehiclehash)
	RequestModel(driver)
	
	while not HasModelLoaded(vehiclehash) and RequestModel(driver) do
		RequestModel(vehiclehash)
		RequestModel(driver)
		Citizen.Wait(0)
	end
    
    if enroute == true then 
        TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, multiline = true, args = {"Tow Script", "You've already got a tow enroute"}})        
	else
        if IsPedSittingInAnyVehicle(player) then
            targetVeh = GetVehiclePedIsIn(player, false)
	end
	
	if DoesEntityExist(vehicle) and deleteLastTruck == true then
		SetEntityAsMissionEntity(driver)
		SetEntityAsMissionEntity(vehicle)
		SetEntityAsMissionEntity(towedVeh)
		
		DeleteEntity(driver)
		DeleteEntity(vehicle)
		DeleteEntity(towedVeh)
		
		while DoesEntityExist(driver) do
			Wait(0)
			DeleteEntity(driver)
		end
	end
	
	if DoesEntityExist(targetVeh) then
	TriggerEvent('radio')
	
		Wait(math.random(2000, 6000))
			
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
		local heading, vector = GetNthClosestVehicleNode(x, y, z, spawnDistance, 0, 0, 0)
		local sX, sY, sZ = table.unpack(vector)	
		tow = CreateVehicle(vehiclehash, sX, sY, sZ, heading, true, true)
		
		local vehiclehash = GetHashKey(tow)
		
		driver = CreatePedInsideVehicle(tow, 26, driver, -1, true, false)
		local vehpos = GetEntityCoords(targetVeh)
		TaskVehicleDriveToCoord(driver, tow, vehpos.x, vehpos.y, vehpos.z, 17.0, 0, vehiclehash, drivingStyle, 1.0, true)
		SetVehicleFixed(tow)
		SetVehicleOnGroundProperly(tow)
		if DoesEntityExist(driver) and DoesEntityExist(tow) then
		SetEntityAsMissionEntity(driver, true, true)
		towblip = AddBlipForEntity(tow)
		SetBlipColour(towblip, 29)
		SetBlipFlashes(towblip, true)
		
		local distanceToTow = GetDistanceBetweenCoords(GetEntityCoords(tow), GetEntityCoords(targetVeh))
		
		if distanceToTow < 100 then
			eta = '~g~1 Minute'
		elseif distanceToTow < 300 then
			eta = '~g~2 Minutes'
		elseif distanceToTow < 500 then
			eta = '~o~3 Minutes'
		elseif distanceToTow > 500 then
			eta = '~r~5 Minutes'
		end
		
		ShowNotification("A tow truck has been dispatched to your location. Thanks for using ~y~" .. companyName .. "~w~\nETA: " .. eta)
		enroute = true
		while (enroute) do
			Citizen.Wait(300)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(tow), GetEntityCoords(targetVeh), 1)
			SetEntityInvincible(tow, true)
			SetEntityInvincible(driver, true)
				if distanceToVeh <= 15 then
					SetVehicleIndicatorLights(tow, 1, true)
					SetVehicleIndicatorLights(tow, 2, true)
					TaskVehicleTempAction(driver, tow, 27, 10000)
					Wait(3000)
					AttachEntityToEntity(targetVeh, tow, 20, -0.5, towOffset, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					SetDriveTaskDrivingStyle(tow, 786603)
					TaskVehicleDriveWander(driver, tow, 17.0, drivingStyle)
					SetVehicleSiren(tow, true)
					ShowNotification("~o~Tow Driver:~w~ " .. towDriverQuoteOfTheDay[math.random(#towDriverQuoteOfTheDay)])
					SetEntityAsNoLongerNeeded(tow)
					enroute = false
					towblip = RemoveBlip(towblip)
					SetVehicleIndicatorLights(tow, 1, false)
					SetVehicleIndicatorLights(tow, 2, false)
					SetEntityInvincible(vehicle, false)
					SetEntityInvincible(driver, false)
					Wait(30000)
					dofade(tow)
					dofade(targetVeh)
					dofade(driver)
				end
			end
		end
	else
	ShowNotification("No vehicle found!")
	end
end
end)

AddEventHandler( 'pis:cancelTow', function()
	if enroute == true then
		ShowNotification("Tow Truck request has been canceled. Thank you for using ~y~" .. companyName)
		
		SetEntityAsMissionEntity(tow)
		SetEntityAsMissionEntity(driver)
		
		DeleteEntity(tow)
		DeleteEntity(driver)
		enroute = false
	end
end)

RegisterNetEvent('radio')
AddEventHandler('radio', function()
    Citizen.CreateThread(function()
        TaskPlayAnim(player, "random@arrests", "generic_radio_enter", 1.5, 2.0, -1, 50, 2.0, 0, 0, 0 )
		Citizen.Wait(6000)
		ClearPedTasks(player)
    end)
end)

-- F U N C T I O N S --

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

function dofade(vehicle)
    Citizen.CreateThread(function()
    local fadeouttim = 0
    local alpha = 255
    SetEntityAlpha(vehicle,alpha)

    while alpha > 5 and DoesEntityExist(vehicle) and fadeouttim < 3 do
        alpha = alpha - 25
        Citizen.Wait(30)
        SetEntityAlpha(vehicle,alpha)
        if alpha <= 5 then
            while alpha < 255 do
                alpha = alpha + 25
                Citizen.Wait(10)
                SetEntityAlpha(vehicle,alpha)
            end
            fadeouttim = fadeouttim + 1
        end
    end
    SetEntityAsMissionEntity(vehicle)
    DeleteEntity(vehicle)
end)
end