class 'flashbang' ( LuaEntityObject )

function flashbang:__init()
	LuaEntityObject.__init(self,self)
end

function flashbang:init()
    GuiService:FadeOutToWhite( 0.01 )
    GuiService:FadeIn( 15 )
end


return flashbang
