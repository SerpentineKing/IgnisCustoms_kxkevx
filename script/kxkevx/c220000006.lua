-- Every Knee Will Bow
local s,id,o=GetID()
-- c220000006
function s.initial_effect(c)
	-- [Activation]
	-- Neither player can activate cards or effects in response to this card’s activation or effect activations.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.e0tgt)
	c:RegisterEffect(e0)
	-- Unaffected by other cards’ effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(s.e1con)
	e1:SetValue(s.e1val)
	c:RegisterEffect(e1)
	-- This face-up card on the field cannot be Tributed.
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE)
	e2a:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2a:SetRange(LOCATION_FZONE)
	e2a:SetValue(1)
	c:RegisterEffect(e2a)

	local e2b=e2a:Clone()
	e2b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2b)
	-- This card’s owner takes no battle or effect damage.
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_FIELD)
	e3a:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3a:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3a:SetRange(LOCATION_FZONE)
	e3a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3a:SetTarget(s.e3tgt)
	e3a:SetValue(1)
	c:RegisterEffect(e3a)
	-- TODO : Owner, not controler
	local e3b1=Effect.CreateEffect(c)
	e3b1:SetType(EFFECT_TYPE_FIELD)
	e3b1:SetCode(EFFECT_CHANGE_DAMAGE)
	e3b1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3b1:SetRange(LOCATION_FZONE)
	e3b1:SetTargetRange(1,0)
	e3b1:SetValue(s.e3bval)
	c:RegisterEffect(e3b1)

	local e3b2=e3b1:Clone()
	e3b2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3b2)
	-- This card’s owner cannot lose the Duel, except if their LP becomes 0.
	-- TODO : Owner, not controler
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD)
	e4a:SetCode(EFFECT_CANNOT_LOSE_DECK)
	e4a:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4a:SetRange(LOCATION_FZONE)
	e4a:SetTargetRange(1,0)
	c:RegisterEffect(e4a)

	local e4b=e4a:Clone()
	e4b:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e4b)
	--[[
	Once per turn, during your Standby Phase, or your opponent’s End Phase, if this card is in your GY or banishment:
	You can add it to your hand.
	]]--
	local e5a=Effect.CreateEffect(c)
	e5a:SetCategory(CATEGORY_TOHAND)
	e5a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5a:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5a:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e5a:SetCountLimit(1)
	e5a:SetCondition(s.e5acon)
	e5a:SetTarget(s.e5tgt)
	e5a:SetOperation(s.e5evt)
	c:RegisterEffect(e5a)

	local e5b=e5a:Clone()
	e5b:SetCode(EVENT_PHASE+PHASE_END)
	e5b:SetCondition(s.e5bcon)
	c:RegisterEffect(e5b)
end
-- Helpers
function s.e0tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1con(e)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.e1val(e,re)
	return re:GetOwner()~=e:GetOwner()
end
function s.e3tgt(e,c)
	return e:GetHandler():GetOwner()==c:GetControler()
end
function s.e3bval(e,re,val,r)
	if (r&REASON_EFFECT)~=0 then
		return 0
	else
		return val
	end
end
function s.e5acon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function s.e5bcon(e,tp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.e5tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	if chk==0 then
		return c:IsAbleToHand()
	end

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,LOCATION_GRAVE+LOCATION_REMOVED)

	if e:IsHasType(EFFECT_TYPE_FIELD) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e5evt(e,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
