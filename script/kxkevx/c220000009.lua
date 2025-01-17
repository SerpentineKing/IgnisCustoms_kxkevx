-- You Lift Me Up
local s,id,o=GetID()
-- c220000009
function s.initial_effect(c)
	-- [Activation]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Once per turn, during your Standby Phase, pay 40 LP or destroy this card.
	-- Neither player can activate cards or effects in response to this card’s activation.
	-- This face-up card on the field cannot be Tributed.
	-- Cards cannot be sent from your Deck to the GY.
	-- Cards in your possession cannot be banished.
end
-- Helpers
