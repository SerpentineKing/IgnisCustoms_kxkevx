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
end
-- Helpers
