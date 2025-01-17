-- Every Knee Will Bow
local s,id,o=GetID()
-- c220000006
function s.initial_effect(c)
	-- [Activation]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Neither player can activate cards or effects in response to this card’s activation or effect activations.
	-- Unaffected by other cards’ effects.
	-- This face-up card on the field cannot be Tributed.
	-- This card’s owner takes no battle or effect damage.
	-- This card’s owner cannot lose the Duel, except if their LP becomes 0.
	--[[
	Once per turn, during your Standby Phase, or your opponent’s End Phase, if this card is in your GY or banishment:
	You can add it to your hand.
	]]--
end
-- Helpers
