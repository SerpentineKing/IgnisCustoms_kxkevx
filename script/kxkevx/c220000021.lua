-- Divine Resurrection
local s,id,o=GetID()
-- c220000021
function s.initial_effect(c)
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	If “Every Knee Will Bow” is on the field, “Ultimate Sacrifice” is on the field or in the GY(s),
	and “Lord of Lords, King of Kings” is in your GY:
	Special Summon 1 “King of Kings, Lord of Lords” from your GY during the 3rd Standby Phase after this card’s activation.
	]]--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tgt)
	e1:SetOperation(s.e1evt)
	c:RegisterEffect(e1)
end
-- Helpers
function s.e1con(e,tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,220000006)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,220000014)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,220000001)
end
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1evt(e,tp)
	local c=e:GetHandler()
	local ct=0
	if Duel.GetCurrentPhase()==PHASE_STANDBY then ct=-1 end

	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1b:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1b:SetCountLimit(1)
	e1b:SetLabel(ct)
	e1b:SetCondition(s.e1bcon)
	e1b:SetOperation(s.e1bevt)
	e1b:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,3)
	Duel.RegisterEffect(e1b,tp)
end
function s.e1bcon(e)
	e:SetLabel(e:GetLabel()+1)

	if e:GetLabel()==3 then
		return true
	end
	return false
end
function s.e1bfil(c,e,tp)
	return c:IsCode(220000001)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.e1bevt(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)

	local g=Duel.SelectMatchingCard(tp,s.e1bfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
