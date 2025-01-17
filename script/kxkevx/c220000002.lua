-- Michael the Archangel
local s,id,o=GetID()
-- c220000002
function s.initial_effect(c)
	-- This card cannot be Special Summoned by your opponent’s card effects.
	--[[
	[SOPT]
	If your opponent controls 5 monsters in their Main Monster Zones:
	You can Special Summon this card from your hand,
	and if you do, add 1 “Raphael the Archangel” from your Deck to your hand.
	]]--
	--[[
	At the start of the Damage Step, if this card is attacked:
	You take no battle damage from that battle, also your opponent gains 4000 LP at the end of the Damage Step.
	This effect cannot be negated.
	]]--
end
-- Helpers
