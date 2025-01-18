-- Ultimate Sacrifice
local s,id,o=GetID()
-- c220000014
function s.initial_effect(c)
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	If this card is in your hand:
	You can discard this card, then target 1 “King of Kings, Lord of Lords” in your GY;
	it gains the following effects.
	•
	While this card is in your GY, you take no battle or effect damage.
	•
	You cannot lose the Duel, except if your LP becomes 0.
	]]--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.e1cst)
	e1:SetTarget(s.e1tgt)
	e1:SetOperation(s.e1evt)
	c:RegisterEffect(e1)
	-- If you take battle or effect damage: You can activate this card from your hand.
	local e1d=Effect.CreateEffect(c)
	e1d:SetDescription(aux.Stringid(id,1))
	e1d:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1d:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1d:SetRange(LOCATION_HAND)
	e1d:SetCode(EVENT_DAMAGE)
	e1d:SetCost(s.e1cst)
	e1d:SetCondition(s.e1dcon)
	e1d:SetTarget(s.e1tgt)
	e1d:SetOperation(s.e1evt)
	c:RegisterEffect(e1d)
end
-- Helpers
function s.e1cst(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	if chk==0 then
		return c:IsDiscardable()
	end
	
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.e1fil(c)
	return c:IsCode(220000001)
end
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE)
		and s.e1fil(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.e1fil,tp,LOCATION_GRAVE,0,1,nil)
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectTarget(tp,s.e1fil,tp,LOCATION_GRAVE,0,1,1,nil)

	if e:IsHasType(EFFECT_TYPE_IGNITION) or e:IsHasType(EFFECT_TYPE_FIELD) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1evt(e,tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local c=e:GetHandler()

		local e1b1=Effect.CreateEffect(c)
		e1b1:SetType(EFFECT_TYPE_FIELD)
		e1b1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1b1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1b1:SetRange(LOCATION_GRAVE)
		e1b1:SetTargetRange(LOCATION_MZONE,0)
		e1b1:SetTarget(aux.TRUE)
		e1b1:SetValue(1)
		tc:RegisterEffect(e1b1)

		local e1b2=Effect.CreateEffect(c)
		e1b2:SetType(EFFECT_TYPE_FIELD)
		e1b2:SetCode(EFFECT_CHANGE_DAMAGE)
		e1b2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1b2:SetRange(LOCATION_GRAVE)
		e1b2:SetTargetRange(1,0)
		e1b2:SetValue(s.e1bval)
		tc:RegisterEffect(e1b2)

		local e1b3=e1b2:Clone()
		e1b3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		tc:RegisterEffect(e1b3)

		local e1c1=Effect.CreateEffect(c)
		e1c1:SetType(EFFECT_TYPE_FIELD)
		e1c1:SetCode(EFFECT_CANNOT_LOSE_DECK)
		e1c1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1c1:SetRange(LOCATION_GRAVE)
		e1c1:SetTargetRange(1,0)
		tc:RegisterEffect(e1c1)

		local e1c2=e1c1:Clone()
		e1c2:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
		tc:RegisterEffect(e1c2)
	end
end
function s.e1bval(e,re,val,r)
	if (r&REASON_EFFECT)~=0 then
		return 0
	else
		return val
	end
end
function s.e1dcon(e,tp,eg,ep,ev,re,r)
	return ep==tp
	and r&(REASON_BATTLE+REASON_EFFECT)~=0
end
