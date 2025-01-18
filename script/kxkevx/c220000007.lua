-- Nowhere to Stand
local s,id,o=GetID()
-- c220000007
function s.initial_effect(c)
	-- [Activation]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.e1tgt)
	c:RegisterEffect(e1)
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	Select 2 Monster Zones on the field.
	Neither player can use the selected zones (even if this card leaves the field).
	]]--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetOperation(s.e2evt)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
-- Helpers
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local z1=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
		local z2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
		return (z1+z2)>1
	end

	local z=Duel.SelectDisableField(tp,2,LOCATION_MZONE,LOCATION_MZONE,0)
	
	Duel.Hint(HINT_ZONE,tp,z)
	e:SetLabel(z)

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e2evt(e,tp)
	return e:GetLabelObject():GetLabel()
end
