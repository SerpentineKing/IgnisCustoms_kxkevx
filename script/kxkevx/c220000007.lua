-- Nowhere to Stand
local s,id,o=GetID()
-- c220000007
function s.initial_effect(c)
	-- [Activation]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	Select 2 Monster Zones on the field.
	Neither player can use the selected zones (even if this card leaves the field).
	]]--
end
-- Helpers
