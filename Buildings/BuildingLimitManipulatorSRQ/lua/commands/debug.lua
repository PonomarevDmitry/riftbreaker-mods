ConsoleService:RegisterCommand( "debug_crash_game", function( args )
    self:CrashGame() -- non existing func
end)

ConsoleService:RegisterCommand( "debug_unlock_mission", function( args )
    if not Assert( #args == 2, "Command requires two argument! [resource] [amonut]" ) then return end   
    CampaignService:UnlockMission( args[1], args[2])
end)

ConsoleService:RegisterCommand( "debug_send_lua_event", function( args )
    if not Assert( #args == 1, "Command requires one argument!" ) then return end	
	LogService:Log("Sending event: " .. args[1] )
	QueueEvent( "LuaGlobalEvent", event_sink, args[1], {} )
end)

g_debug_resource_harvester = false

ConsoleService:RegisterCommand( "debug_resource_harvester", function( args )
    if not Assert( #args == 1, "Command requires one argument! [bool]" ) then return end

    g_debug_resource_harvester = args[1] == "1"
end)

g_debug_dom_manager = false

ConsoleService:RegisterCommand( "debug_dom_manager", function( args )
    if not Assert( #args == 1, "Command requires one argument! [bool]" ) then return end

    g_debug_dom_manager = args[1] == "1"
end)

ConsoleService:RegisterCommand( "debug_spawn_resource_loot", function( args )
    if not Assert( #args == 2, "Command requires one argument! [resource] [count]" ) then return end

    local pawn = PlayerService:GetPlayerControlledEnt(0)

    for i=1,tonumber( args[2] ) do
        ItemService:SpawnLoot(pawn,"items/loot/resources/shard_" .. tostring( args[1] ) .. "_item", 5)
    end
end)

ConsoleService:RegisterCommand( "limit_up", function( args )
    if not Assert( #args == 1, "Command requires one argument! Write 'limit_up [number]', number = 1 for armory, 2 for communications hub, 3 for laboratory" ) then return end

    if args[ 1 ] == "1" then
        BuildingService:IncreaseBuildingLimits( "armory", 1)
    elseif args[ 1 ] == "2" then
        BuildingService:IncreaseBuildingLimits( "communications_hub", 1)
    elseif args[ 1 ] == "3" then
        BuildingService:IncreaseBuildingLimits( "laboratory", 1)
    end
end)

ConsoleService:RegisterCommand( "limit_down", function( args )
    if not Assert( #args == 1, "Command requires one argument! Write 'limit_down [number]', number = 1 for armory, 2 for communications hub, 3 for laboratory" ) then return end

    if args[ 1 ] == "1" then
        BuildingService:DecreaseBuildingLimits( "armory", 1)
    elseif args[ 1 ] == "2" then
        BuildingService:DecreaseBuildingLimits( "communications_hub", 1)
    elseif args[ 1 ] == "3" then
        BuildingService:DecreaseBuildingLimits( "laboratory", 1)
    end
end)