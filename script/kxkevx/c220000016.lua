-- Good Reaction to Simoochi
local s,id,o=GetID()
-- c220000016
function s.initial_effect(c)
	-- [Activation]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Any effect that would inflict damage to a player increases their LP by the same amount, instead.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.e1val)
	c:RegisterEffect(e1)
end
-- Helpers
function s.e1val(e,re,r)
	return (r&REASON_EFFECT)>0
end
