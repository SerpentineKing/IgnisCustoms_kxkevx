-- Nowhere to Stand
local s,id,o=GetID()
-- c220000007
function s.initial_effect(c)
	-- [Activation]
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	Select 2 Monster Zones on the field.
	Neither player can use the selected zones (even if this card leaves the field).
	]]--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.e1tgt)
	e1:SetOperation(s.e1evt)
	c:RegisterEffect(e1)
end
-- Helpers
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local z1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local z2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		return (z1+z2)>1
	end

	local z=Duel.SelectDisableField(tp,2,LOCATION_MZONE,LOCATION_MZONE,0,true)
	Duel.Hint(HINT_ZONE,tp,z)
	e:SetLabel(z)

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1evt(e,tp)
	local c=e:GetHandler()
	
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD)
	e1b:SetCode(EFFECT_DISABLE_FIELD)
	e1b:SetOperation(s.e1bevt)
	e1b:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1b,tp)
end
function s.e1bevt(e,tp)
	return e:GetLabel()
end
