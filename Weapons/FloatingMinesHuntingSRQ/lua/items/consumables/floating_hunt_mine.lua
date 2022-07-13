require("lua/utils/table_utils.lua")
require("lua/utils/reflection.lua")
require("lua/utils/find_utils.lua")

class 'floating_hunt_mine' ( LuaEntityObject )

function floating_hunt_mine:__init()
	LuaEntityObject.__init(self,self)
end

function floating_hunt_mine:init()

	self:RegisterHandler( self.entity, "DestroyRequest", "OnDestroyRequest" )
	self:RegisterHandler( self.entity, "EnteredTriggerEvent", 	 "OnEnteredTriggerEvent" )
	self:RegisterHandler( self.entity, "LeftTriggerEvent", 	 "OnLeftTriggerEvent" )
	self.bp = self.data:GetString( "bp" )
	self.item_blueprint = self.data:GetStringOrDefault( "item_blueprint", "" )
	self.delay = self.data:GetFloatOrDefault( "delay", 0 )
	self.delayBeforeArmoed = self.data:GetFloatOrDefault( "delay_before_armed", 1 )
	self.explode_height = self.data:GetFloatOrDefault( "explode_height", 1.2 )
	self.sm = self:CreateStateMachine()
	self.sm:AddState( "explode", { enter="OnExplodeStart", execute="OnExplodeExecute", exit="OnExplodeEnd" } )
	self.sm:AddState( "armed", { enter="OnArmedStart", exit="OnArmedEnd" } )
	self.exploded = false
	self.armed = false
	EntityService:SetGraphicsUniform( self.entity, "cGlowFactor", 0.0 )
	self.sm:ChangeState("armed")

	self.entered = 0

	self.srq = self:CreateStateMachine()
	self.srq:AddState( "hunt", { execute="OnHuntExecute" } )
	self.huntrange = 30
	self.srq:ChangeState("hunt")

end


function floating_hunt_mine:OnHuntExecute( state )
	local allenemies = self:FindEntitiesByTeamInRadius( self.entity, self.huntrange, "enemy" )
	local hunttarget = FindClosestEntity( self.entity, allenemies )

	MoveService:MoveToTarget( self.entity, hunttarget, 20.0)
end



function floating_hunt_mine:FindEntitiesByTeamInRadius( origin, radius, team )
local predicate = 
	{

		filter = function(entity)
			return EntityService:IsInTeamRelation(origin, entity, "hostility")
		end
	}

return FindService:FindEntitiesByPredicateInRadius( origin, radius, predicate )

end




function floating_hunt_mine:OnEnteredTriggerEvent( evt )
	if ( self.armed == false ) then
		self.entered = self.entered + 1
		return
	end

	if self.exploded == true then 
		return
	end
	EntityService:RemoveLifeTime( self.entity ) 
	self.sm:ChangeState("explode")
	EffectService:DestroyEffectsByGroup( self.entity, "mine_unarmed" )
	self.exploded = true
end

function floating_hunt_mine:OnLeftTriggerEvent( evt )
	if self.exploded == true  then 
		return
	end
	if ( self.armed == false ) then
		self.entered = self.entered - 1
	end
end

function floating_hunt_mine:OnArmedStart( state )
	if string.find(self.bp, "mine_nuclear") and EntityService:CompareTeam( self.entity, "player") then
		CampaignService:UnlockAchievement(ACHIEVEMENT_KABOOM)
	end

	state:SetDurationLimit( self.delayBeforeArmoed )
end

function floating_hunt_mine:OnArmedEnd( state )
	self.armed = true
	EntityService:SetGraphicsUniform( self.entity, "cGlowFactor", 1.0 )
	EntityService:ChangeType(self.entity, "prop|not_move_to_target")
	if ( self.entered > 0 ) then
		EntityService:RemoveLifeTime( self.entity ) 
		self.sm:ChangeState("explode")
		EffectService:DestroyEffectsByGroup( self.entity, "mine_unarmed" )
		self.exploded = true
	end
end

function floating_hunt_mine:OnExplodeStart( state )
	EffectService:AttachEffects( self.entity, "mine_armed" )
	state:SetDurationLimit( self.delay )
	self.position = EntityService:GetPosition( self.entity )
	EntityService:RemoveComponent( self.entity, "HealthComponent")
end

function floating_hunt_mine:OnExplodeExecute( state )
	local progres = 0
	if ( state:GetDurationLimit() ~= 0 ) then
		progres = state:GetDuration() / state:GetDurationLimit()
	end
	EntityService:SetGraphicsUniform( self.entity, "cGlowFactor", progres * 10 )
	EntityService:SetPosition( self.entity, self.position.x, self.position.y  + self.explode_height * (progres * progres) , self.position.z )
	EntityService:Rotate( self.entity, 0.0, 1.0, 0.0, 25.0 * (progres * progres) )
end

function floating_hunt_mine:OnExplodeEnd(  )
	local entity = EntityService:SpawnEntity( self.bp, self.entity, EntityService:GetTeam( self.entity ))
	local itemCreator = ItemService:GetItemCreator(self.entity)
	if itemCreator ~= "" then
		ItemService:SetItemCreator( entity, itemCreator );
	end
	EntityService:DissolveEntity( self.entity, 0.2 ) 
end

function floating_hunt_mine:OnDestroyRequest( evt)
	if (evt:GetDamageType() == "quicksand") then
		EffectService:DestroyEffectsByGroup( self.entity, "mine_unarmed" )
		self.exploded = true
		EntityService:CreateQuickSandSinkMovement( self.entity, 2)
		EntityService:RequestDestroyPattern(self.entity, evt:GetDamageType(), false )
	elseif ( self.armed == false)  then
		self.exploded = true
		EntityService:RequestDestroyPattern(self.entity, evt:GetDamageType() )
	end

end

return floating_hunt_mine
 