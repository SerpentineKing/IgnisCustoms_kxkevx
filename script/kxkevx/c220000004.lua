-- Gabriel the Archangel
local s,id,o=GetID()
-- c220000004
function s.initial_effect(c)
	-- This card cannot be Special Summoned by your opponent’s card effects.
	--[[
	If this card is Normal or Special Summoned:
	You can add 1 “Michael the Archangel” from your Deck to your hand.
	]]--
	--[[
	At the start of the Damage Step, if this card is attacked:
	You take no battle damage from that battle, also your opponent gains 7000 LP at the end of the Damage Step.
	This effect cannot be negated.
	]]--
end
-- Helpers
