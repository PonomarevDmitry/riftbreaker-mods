-- require("lua/utils/LogReflectionHelper.lua") Add at the top of mod files

function LogReflectionHelper( self )
    local ptr = rawget(self, "__ptr");

    local value = ptr:GetTypeName()
    value = value .. "\n{\n"

    for field_name in Iter( ptr:GetFieldNames() ) do
        value = value .. "\t" .. field_name .. " = "

        local field = ptr:GetField(field_name)
        if field ~= nil then
            local field_value = GetPodValue(field)
            if field_value ~= nil then
                value = value .. tostring(field_value)
            else
                value = value .. "[" .. field:GetTypeName() .. "]"
            end
        else
            value = value .. "nil"
        end

        value = value .. "\n"
    end

    value = value .. "}\n"
    return value
end