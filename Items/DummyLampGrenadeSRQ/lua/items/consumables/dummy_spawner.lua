local item = require("lua/items/item.lua")

class 'dummy_spawner' ( item )

function dummy_spawner:__init()
	item.__init(self,self)
end

function dummy_spawner:OnInit()
	ConsoleService:Write("dummy_spawner:OnInit")
	self:OnPop()
end

function dummy_spawner:OnEquipped()
end

function dummy_spawner:OnPop()

	self.srq = self:CreateStateMachine()
	self.srq:AddState( "attract", { execute = "OnAttractEnemies" })

	local EntPosX = EntityService:GetPositionX(self.entity)
	local EntPosY = EntityService:GetPositionY(self.entity)
	local EntPosZ = EntityService:GetPositionZ(self.entity)
	
	if (EntPosY ~= 0) then
		EntPosY = 0
		entSRQ = EntityService:SpawnEntity("buildings/decorations/dummy_lamp", EntPosX, EntPosY, EntPosZ, "player" )
		EntityService:DissolveEntity( entSRQ, 1.0, 20.0 )
	else
		entSRQ = EntityService:SpawnEntity("buildings/decorations/dummy_lamp", self.entity, "player" )
		EntityService:DissolveEntity( entSRQ, 1.0, 20.0 )
	end

	EffectService:SpawnEffect(self.entity, "effects/SRQ/marker")
	self.srq:ChangeState("attract")
end

function dummy_spawner:OnAttractEnemies( state )
	local objects = FindService:FindEntitiesByTypeInRadius( self.entity, "ground_unit", 100 )

	for entObjSRQ in Iter(objects) do
		UnitService:SetCurrentTarget( entObjSRQ, "lamp", entSRQ );
	end

	if not EntityService:IsAlive(entSRQ) then
	--	ConsoleService:Write("NUMBER OF ENTITIES FOUND = " .. tostring(#objects))
	--else
		state:Exit()
	end
end

function dummy_spawner:OnDePop()
	ConsoleService:Write("dummy_spawner:OnDePop")
	return true
end

return dummy_spawner
