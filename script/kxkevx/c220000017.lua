-- I Trust in You.
local s,id,o=GetID()
-- c220000017
function s.initial_effect(c)
	-- [Activation]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Neither player can activate cards or effects in response to this card’s activation or effect activations.
	-- This face-up card on the field cannot be Tributed.
	--[[
	[SOPT]
	Once per turn:
	You can shuffle any number of cards from either player’s GY(s) and/or banishment(s) into the Deck/Extra Deck.
	]]--
	--[[
	If this card is sent to the GY or banished:
	Shuffle it into the Deck.
	]]--
	--[[
	During your Draw Phase, if this card is in your GY, instead of conducting your normal draw:
	You can Set this card to your field.
	]]--
end
-- Helpers
