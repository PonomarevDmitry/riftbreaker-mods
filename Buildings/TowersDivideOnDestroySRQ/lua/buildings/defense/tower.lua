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

	self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "divide", { enter="OnDivide" } )

	self.wreck_type = "wreck_small";
	self.wreckMinSpeed = 8
	self.allowDivideHealthInPercentage = 70
	self.divideScaleMul = 0.85
	
	self.canEat = EnvironmentService:GetTimeOfDay()
	self.wasDivided = false

end

function tower:OnDestroy()
	if ( self.wasDivided == false ) then

		local clonesNumber = self.data:GetIntOrDefault( "clones_number", 3 )

		if  clonesNumber > 0 then
				self.wasDivided = true
				EffectService:SpawnEffects( self.entity, "divide" )
				self.fsm:ChangeState( "divide" )
			
		end
	end
	return true
end


function tower:OnDamageEvent( evt )

end

function tower:OnDivide( state )
	
	local srqblueprints =
	{
		{ "buildings/defense/tower_plasma_clone_2" },
		{ "buildings/defense/tower_laser_clone_2" },
		{ "buildings/defense/tower_minigun_clone_2" },
		{ "buildings/defense/tower_rockets_clone_2" },
		{ "buildings/defense/tower_railgun_clone_2" }
	}

	local idx = RandInt(1, #srqblueprints)
	local currentBP = srqblueprints[idx]

	local entity = EntityService:SpawnEntity( currentBP[1], self.entity, "player" )
	--UnitService:SetInitialState( entity, UNIT_AGGRESSIVE);

	EntityService:RemoveEntity( self.entity )
end



function tower:_OnDayCycleDayStartedEvent( )
	self:OperateLight("day")
end

function tower:_OnDayCycleNightStartedEvent( )
	self:OperateLight("night")
end

function tower:_OnDayCycleSunriseStartedEvent( )
	self:OperateLight("sunrise")
end

function tower:_OnDayCycleSunsetStartedEvent( )
	self:OperateLight("sunset")
end

function tower:OnActivate()
	self:OperateLight(EnvironmentService:GetTimeOfDay())
end

function tower:OnDeactivate()
	self:OperateLight(EnvironmentService:GetTimeOfDay())
end

function tower:OnTurretEvent( evt )
end

function tower:OperateLight( time )
	if self.working == true and time ~= "day" and self.lightStatus == false then
		EffectService:AttachEffects(self.entity, "lamp")	
		self.lightStatus = true
	elseif self.working == false and self.lightStatus == true then 
		EffectService:DestroyEffectsByGroup(self.entity, "lamp")	
		self.lightStatus = false
	elseif time == "day" and self.lightStatus == true then
		EffectService:DestroyEffectsByGroup(self.entity, "lamp")	
		self.lightStatus = false
	end
end


function tower:OnResourceMissingEvent( evt )
	local resource = evt:GetResource()
	if ( resource ~= "energy" and resource ~= "ai" and ConsoleService:GetConfig("g_tower_ammo_missing_annoucements") == "1" ) then
		EntityService:ShowTimeoutSoundEvent( INVALID_ID, 30.0, "voice_over/announcement/not_enough_ammo_tower", false )
	end
end


return tower
