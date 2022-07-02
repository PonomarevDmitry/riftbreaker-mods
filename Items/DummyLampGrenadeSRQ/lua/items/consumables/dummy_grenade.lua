local item = require("lua/items/item.lua")

class 'dummy_grenade' ( item )

function dummy_grenade:__init()
	item.__init(self,self)
end

function dummy_grenade:OnInit()
    self.bp = self.data:GetString( "bp" )
	self.att = self.data:GetString( "att" )
end

function dummy_grenade:OnEquipped()

end

function dummy_grenade:OnActivate()
	ConsoleService:Write("dummy_grenade:OnActivate")
	local entity = WeaponService:ThrowGrenade( self.bp , self.owner, self.att )
	ItemService:SetItemCreator( entity, self.entity_blueprint )

	
end

function dummy_grenade:OnDeactivate()
	return true
end


return dummy_grenade
