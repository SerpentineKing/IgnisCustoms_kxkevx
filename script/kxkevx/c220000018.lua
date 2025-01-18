-- My True Strength..
local s,id,o=GetID()
-- c220000018
function s.initial_effect(c)
	-- [Activation]
	-- Activate this card by paying 1000 LP.
	-- Neither player can activate cards or effects in response to this card’s activation or effect activations.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.e0tgt)
	c:RegisterEffect(e0)
	-- This face-up card on the field cannot be Tributed.
	-- Cards in your possession are unaffected by your opponent’s card effects.
	--[[
	If this card is sent to the GY or banished:
	Shuffle it into the Deck.
	]]--
end
-- Helpers
function s.e0tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
