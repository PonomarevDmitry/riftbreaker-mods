local building = require("lua/buildings/building_base.lua")
require("lua/utils/reflection.lua")
require("lua/utils/string_utils.lua")
class 'intel_station' ( building )

function intel_station:__init()
	building.__init(self,self)
end

-- Łukas start
function intel_station:SpawnFogRevealer( position, radius, duration )
    local entity = EntityService:SpawnEntity("logic/position_marker", position.x, position.y, position.z, "") -- Spawn empty entity
    EntityService:CreateLifeTime(entity, duration, "normal")                                                  -- Make it disappear after >duration<

    local component = reflection_helper(EntityService:CreateComponent(entity, "FogOfWarRevealerComponent"))   -- Create fog of war revealer component 
    component.radius = radius                                                                                 -- Set its radius to >radius<
-- Łukas end
    
    guiTimer2 = BuildingService:AttachGuiTimer( self.entity, 120, true )                                      -- Add a timer which shows the time left until next fog reveal

end


function intel_station:OnInit()
    self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "working", { execute="OnWorking", interval=120} )       -- Add a working state, if the state happens, execute the function >OnWorking< each 120 seconds
    guiTimer1 = nil
    guiTimer2 = nil

    playable_min = MissionService:GetPlayableRegionMin() 	                   -- Get the min playable area on the map
    playable_max = MissionService:GetPlayableRegionMax()                       -- Get the min playable area on the map

end

function intel_station:OnBuildingEnd()
    local randomX = RandInt(playable_min.x,playable_max.x)                     -- Find random spot between the playable map borders left <-> right
    local randomZ = RandInt(playable_min.z,playable_max.z)                     -- Find random spot between the playable map borders top <-> bottom (z = y)
    self:SpawnFogRevealer( { x = randomX, y = 0.0, z = randomZ }, 65.0, 30 )   -- Reveal fog at the random coordinates, radius of 65, duration of 30 seconds
    guiTimer1 = BuildingService:AttachGuiTimer( self.entity, 120, true )       -- Add a timer which shows the time left until next fog reveal
    self.fsm:ChangeState( "working" )                                          -- Tell the game that the building is in >working< state, switches to the state (Line 39) now
end

function intel_station:OnWorking(state)
    local randomX = RandInt(playable_min.x,playable_max.x)                     -- Find random spot between the playable map borders left <-> right
    local randomZ = RandInt(playable_min.z,playable_max.z)                     -- Find random spot between the playable map borders top <-> bottom (z = y)
    self:SpawnFogRevealer( { x = randomX, y = 0.0, z = randomZ }, 60.0, 30 )   -- Reveal fog at the random coordinates, radius of 60, duration of 30 seconds
end

function intel_station:OnActivate()
    if (guiTimer1 ~= nil) then                                                 -- If the timer is existing, resume it
        BuildingService:ResumeGuiTimer( guiTimer1 )
    end
    if (guiTimer2 ~= nil) then                                                 -- If the timer is existing, resume it
        BuildingService:ResumeGuiTimer( guiTimer2 )
    end
	self.fsm:ChangeState("working")                                            -- Tell the game that the building is in >working< state
end

function intel_station:OnDeactivate()
    if (guiTimer1 ~= nil) then                                                 -- If the timer is existing, pause it
        BuildingService:PauseGuiTimer( guiTimer1 )
    end
    if (guiTimer2 ~= nil) then                                                 -- If the timer is existing, pause it
        BuildingService:PauseGuiTimer( guiTimer2 )
    end
	local state = self.fsm:GetState("working")
	if ( state ~= nil ) then
		state:Exit()
	end	 
end

return intel_station