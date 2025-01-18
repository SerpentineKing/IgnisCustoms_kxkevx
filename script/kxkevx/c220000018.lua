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
	e0:SetCost(s.e0cst)
	e0:SetTarget(s.e0tgt)
	c:RegisterEffect(e0)
	-- This face-up card on the field cannot be Tributed.
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE)
	e1a:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetValue(1)
	c:RegisterEffect(e1a)

	local e1b=e1a:Clone()
	e1b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e1b)
	-- Cards in your possession are unaffected by your opponent’s card effects.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(3110)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ALL,0)
	e2:SetValue(s.e2val)
	e2:SetOwnerPlayer(tp)
	c:RegisterEffect(e2)
	--[[
	If this card is sent to the GY or banished:
	Shuffle it into the Deck.
	]]--
	local e3a=Effect.CreateEffect(c)
	e3a:SetCategory(CATEGORY_TODECK)
	e3a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3a:SetCode(EVENT_TO_GRAVE)
	e3a:SetProperty(EFFECT_FLAG_DELAY)
	e3a:SetTarget(s.e3tgt)
	e3a:SetOperation(s.e3evt)
	c:RegisterEffect(e3a)

	local e3b=e3a:Clone()
	e3b:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3b)
end
-- Helpers
function s.e0cst(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=1000

	if chk==0 then
		return Duel.CheckLPCost(tp,ct)
	end
	
	Duel.PayLPCost(tp,ct)
end
function s.e0tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e2val(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.e3tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)

	if e:IsHasType(EFFECT_TYPE_SINGLE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e3evt(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
