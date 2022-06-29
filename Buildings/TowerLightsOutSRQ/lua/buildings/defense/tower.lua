local building = require("lua/buildings/building.lua")

class 'tower' ( building )

function tower:__init()
	building.__init(self,self)
end

function tower:OnInit()
	self:RegisterHandler( event_sink , "DayStartedEvent", "_OnDayCycleDayStartedEvent")	
	self:RegisterHandler( event_sink , "NightStartedEvent", "_OnDayCycleNightStartedEvent")	
	self:RegisterHandler( event_sink , "SunriseStartedEvent", "_OnDayCycleSunriseStartedEvent")	
	self:RegisterHandler( event_sink , "SunsetStartedEvent", "_OnDayCycleSunsetStartedEvent")	
	self:RegisterHandler( self.entity, "ResourceMissingEvent", "OnResourceMissingEvent" ) 
	self:RegisterHandler( self.entity, "TurretEvent", "OnTurretEvent" )
	self.lightStatus = false
	
	self.data:SetFloat( "shooting", 0 )
	local timeOfDay = EnvironmentService:GetTimeOfDay()
end

function tower:OnDestroy()
	return true
end

function tower:_OnDayCycleDayStartedEvent( )
end

function tower:_OnDayCycleNightStartedEvent( )
end

function tower:_OnDayCycleSunriseStartedEvent( )
end

function tower:_OnDayCycleSunsetStartedEvent( )
end

function tower:OnActivate()
end

function tower:OnDeactivate()
end

function tower:OnTurretEvent( evt )
end

function tower:OperateLight( time )
end


function tower:OnResourceMissingEvent( evt )
	local resource = evt:GetResource()
	if ( resource ~= "energy" and resource ~= "ai" and ConsoleService:GetConfig("g_tower_ammo_missing_annoucements") == "1" ) then
		EntityService:ShowTimeoutSoundEvent( INVALID_ID, 30.0, "voice_over/announcement/not_enough_ammo_tower", false )
	end
end


return tower
