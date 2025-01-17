-- Thou Shalt Not...
local s,id,o=GetID()
-- c220000021
function s.initial_effect(c)
	-- [Activation]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Neither player can activate cards or effects in response to this card’s activation or effect activations.
	-- This face-up card on the field cannot be Tributed.
	-- Your opponent cannot take control of, or attach as material, or Special Summon cards in your possession.
	--[[
	If this card is sent to the GY, or banished, by an opponent’s card effect:
	Inflict 2000 damage to your opponent.
	]]--
end
-- Helpers
