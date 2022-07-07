local building = require("lua/buildings/building.lua")
require("lua/utils/reflection.lua")
require("lua/utils/string_utils.lua")
class 'aoe_tower' ( building )

function aoe_tower:__init()
	building.__init(self,self)
end


function aoe_tower:OnInit()
    self.srq = self:CreateStateMachine()
	self.srq:AddState( "working", { execute="OnWorking"} )       -- Add a working state, if the state happens, execute the function >OnWorking<
    self.range = self.data:GetFloatOrDefault("range", 30)
end



function aoe_tower:OnBuildingEnd()
    self.srq:ChangeState( "working" )                                          -- Tell the game that the building is in >working< state
end



function aoe_tower:OnActivate()
	self.srq:ChangeState("working")                                            -- Tell the game that the building is in >working< state
end



function aoe_tower:OnDeactivate()
	local state = self.srq:GetState("working")
	if ( state ~= nil ) then
		state:Exit()
	end	 
end



function aoe_tower:OnWorking( state )
    local level = BuildingService:GetBuildingLevel( self.entity )

    --ConsoleService:Write("AOE tower building level :" .. tostring(level))
    if (level == 1) then
        local ModSlot1ID = self:GetEquippedMods(self.entity, "MOD_1")
        local ModSlot1BP = EntityService:GetBlueprintName( ModSlot1ID )
            --ConsoleService:Write("AOE tower modSlot1 ID: " .. tostring(ModSlot1ID))
            --ConsoleService:Write("AOE tower modSlot1 BP: " ..  tostring(ModSlot1BP))
    elseif (level == 2) then
        local ModSlot1ID = self:GetEquippedMods(self.entity, "MOD_1")
        local ModSlot1BP = EntityService:GetBlueprintName( ModSlot1ID )
            --ConsoleService:Write("AOE tower modSlot1 ID: " .. tostring(ModSlot1ID))
            --ConsoleService:Write("AOE tower modSlot1 BP: " ..  tostring(ModSlot1BP))
        local ModSlot2ID = self:GetEquippedMods(self.entity, "MOD_2")
        local ModSlot2BP = EntityService:GetBlueprintName( ModSlot2ID )
            --ConsoleService:Write("AOE tower modSlot2 ID: " .. tostring(ModSlot2ID))
            --ConsoleService:Write("AOE tower modSlot2 BP: " ..  tostring(ModSlot2BP))
    else
        local ModSlot1ID = self:GetEquippedMods(self.entity, "MOD_1")
        local ModSlot1BP = EntityService:GetBlueprintName( ModSlot1ID )
            --ConsoleService:Write("AOE tower modSlot1 ID: " .. tostring(ModSlot1ID))
            --ConsoleService:Write("AOE tower modSlot1 BP: " ..  tostring(ModSlot1BP))
        local ModSlot2ID = self:GetEquippedMods(self.entity, "MOD_2")
        local ModSlot2BP = EntityService:GetBlueprintName( ModSlot2ID )
            --ConsoleService:Write("AOE tower modSlot2 ID: " .. tostring(ModSlot2ID))
            --ConsoleService:Write("AOE tower modSlot2 BP: " ..  tostring(ModSlot2BP))
        local ModSlot3ID = self:GetEquippedMods(self.entity, "MOD_3")
        local ModSlot3BP = EntityService:GetBlueprintName( ModSlot3ID )
            --ConsoleService:Write("AOE tower modSlot3 ID: " .. tostring(ModSlot3ID))
            --ConsoleService:Write("AOE tower modSlot3 BP: " ..  tostring(ModSlot3BP))
    end

    local affected_towers = FindService:FindEntitiesByTypeInRadius( self.entity, "tower", self.range )
    for j=1, #affected_towers do
        if affected_towers[j] ~= self.entity and BuildingService:IsBuildingFinished( affected_towers[j] ) then
            affected_towers_level = BuildingService:GetBuildingLevel( affected_towers[j] )

            --ConsoleService:Write("Building Name: " .. BuildingService:GetBuildingName(affected_towers[j]))
            --ConsoleService:Write("Building Level: " .. tostring(affected_towers_level))
            --ConsoleService:Write("Building ID: " .. tostring(affected_towers[j]))
            
            if (affected_towers_level == 1) then
                affected_towers_mod1 = self:GetEquippedMods(affected_towers[j], "MOD_1")
                affected_towers_mod1_name = EntityService:GetBlueprintName(affected_towers_mod1)
                --ConsoleService:Write("Building_mod1 BP: " .. affected_towers_mod1_name)
            elseif (affected_towers_level == 2) then
                affected_towers_mod1 = self:GetEquippedMods(affected_towers[j], "MOD_1")
                affected_towers_mod2 = self:GetEquippedMods(affected_towers[j], "MOD_2")
                --ConsoleService:Write("Building_mod1 BP: " ..  EntityService:GetBlueprintName(affected_towers_mod1))
                --ConsoleService:Write("Building_mod2 BP: " ..  EntityService:GetBlueprintName(affected_towers_mod2))
            else
                affected_towers_mod1 = self:GetEquippedMods(affected_towers[j], "MOD_1")
                affected_towers_mod2 = self:GetEquippedMods(affected_towers[j], "MOD_2")
                affected_towers_mod3 = self:GetEquippedMods(affected_towers[j], "MOD_3")
                --ConsoleService:Write("Building_mod1 BP: " ..  EntityService:GetBlueprintName(affected_towers_mod1))
                --ConsoleService:Write("Building_mod2 BP: " ..  EntityService:GetBlueprintName(affected_towers_mod2))
                --ConsoleService:Write("Building_mod3 BP: " ..  EntityService:GetBlueprintName(affected_towers_mod3))
            end
        end
    end

end




    --for i=1,level do
        --local item_entity = self:GetEquippedMods(self.entity, "MOD_" .. tostring(i))
        --local item_blueprint = EntityService:GetBlueprintName(item_entity)
        --ConsoleService:Write("MOD_" .. tostring(i) .. " entity=" .. tostring(item_entity) .. ", blueprint='" .. item_blueprint .. "'")
    --end

    --local affected_towers = FindService:FindEntitiesByTypeInRadius( self.entity, "tower", self.range )
    --for j=1, affected_towers do

      --  EntityService:SpawnEntity( Entity::Id target );
      --  EntityService:SpawnAndAttachEntity( item_blueprint, affected_towers[j] )
      --  ItemService:EquipItemInSlot( Exor::Entity::Id owner, Exor::Entity::Id item, Exor::String slotId)



    --end
--end



function aoe_tower:GetEquippedMods( owner, slot_name )
    local equipment = reflection_helper( EntityService:GetComponent(owner, "EquipmentComponent") ).equipment[1]

    local slots = equipment.slots
        for i=1,slots.count do
            local slot = slots[i]
            if slot.name == slot_name then
                local entities = slot.subslots[slot.current_subslot + 1]
                local entity = entities[1]
                if entity ~= nil then
                    return entity.id
                end
            end
        end
    return INVALID_ID

end















return aoe_tower