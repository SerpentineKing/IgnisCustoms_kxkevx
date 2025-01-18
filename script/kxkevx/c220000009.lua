-- You Lift Me Up
local s,id,o=GetID()
-- c220000009
function s.initial_effect(c)
	-- [Activation]
	-- Neither player can activate cards or effects in response to this card’s activation.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.e0tgt)
	c:RegisterEffect(e0)
	-- Once per turn, during your Standby Phase, pay 40 LP or destroy this card.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.e1con)
	e1:SetOperation(s.e1evt)
	c:RegisterEffect(e1)
	-- This face-up card on the field cannot be Tributed.
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE)
	e2a:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetValue(1)
	c:RegisterEffect(e2a)

	local e2b=e2a:Clone()
	e2b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2b)
	-- Cards cannot be sent from your Deck to the GY.
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD)
	e3a:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e3a:SetRange(LOCATION_SZONE)
	e3a:SetTargetRange(LOCATION_DECK,0)
	c:RegisterEffect(e3a)
	
	local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_FIELD)
	e3b:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e3b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3b:SetRange(LOCATION_SZONE)
	e3b:SetTargetRange(LOCATION_DECK,0)
	c:RegisterEffect(e3b)
	-- Cards in your possession cannot be banished.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA,0)
	c:RegisterEffect(e4)
end
-- Helpers
function s.e0tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1con(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function s.e1evt(e,tp)
	local c=e:GetHandler()
	local ct=40

	if Duel.CheckLPCost(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.PayLPCost(tp,ct)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
