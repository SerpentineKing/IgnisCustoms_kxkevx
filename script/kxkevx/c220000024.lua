-- Depart from Me
local s,id,o=GetID()
-- c220000024
function s.initial_effect(c)
	-- Cannot be Xyz Summoned.
	c:EnableReviveLimit()
	--[[
	If your opponent would win the Duel,
	except if your LP becomes 0 or you are unable to draw a card,
	you can banish this card from your face-down Extra Deck, instead.
	]]--
	-- TODO
	--[[
	While this card is in your banishment, you cannot lose the Duel,
	except if your LP becomes 0 or you are unable to draw a card.
	]]--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
end
-- Helpers
