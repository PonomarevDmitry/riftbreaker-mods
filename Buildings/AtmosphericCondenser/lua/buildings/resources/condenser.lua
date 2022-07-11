local building = require("lua/buildings/building.lua")
require("lua/utils/string_utils.lua")
class 'condenser' ( building )

function condenser:__init()
	building.__init(self,self)
end

function condenser:OnInit()
    self.fsm = self:CreateStateMachine()
	self.fsm:AddState( "working", { execute="OnWorking" } )

	self.srq = self:CreateStateMachine()
	self.srq:AddState( "waiting", { execute="OnWaiting" } )
	self.srq:ChangeState( "waiting" ) 
end

function condenser:OnBuildingEnd()
	self.fsm:ChangeState( "working" ) 	
end

function condenser:OnWorking(state)
	local timeofday1 = EnvironmentService:GetTimeOfDay()
	if timeofday1 ~= "day" then
		self.srq:ChangeState( "waiting" ) 
		BuildingService:DisableBuilding( self.entity )
	end
end

function condenser:OnWaiting(state)
	local timeofday2 = EnvironmentService:GetTimeOfDay()
	if timeofday2 == "day" then
		self.fsm:ChangeState( "working" )
		BuildingService:EnableBuilding( self.entity )
	end
end

function condenser:OnActivate()
	self.fsm:ChangeState("working")
end

function condenser:OnDeactivate()
	local state = self.fsm:GetState("working")
	if ( state ~= nil ) then
		state:Exit()
	end	 
end

return condenser