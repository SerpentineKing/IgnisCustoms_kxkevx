-- King of Kings, Lord of Lords
local s,id,o=GetID()
-- c220000001
function s.initial_effect(c)
	-- Unaffected by other card’s effects, except “Divine Resurrection” and “Trinity Power”.
	-- Cannot be destroyed by battle.
	-- You take no battle damage from battles involving this card.
	-- This card cannot be Special Summoned by your opponent’s card effects.
	-- Your opponent cannot use this card as material for a Fusion, Synchro, Xyz, or Link Summon.
	-- This face-up card on the field cannot be Tributed.
	-- If this card is Special Summoned by the effect of “Divine Resurrection”, you win the Duel.
	--[[
	[SOPT]
	If your opponent controls 4 or more monsters (Quick Effect):
	You can Special Summon this card from your hand.
	]]--
end
-- Helpers
