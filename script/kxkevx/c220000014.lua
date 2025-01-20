-- Ultimate Sacrifice
local s,id,o=GetID()
-- c220000014
function s.initial_effect(c)
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	If you take battle or effect damage, OR if “King of Kings, Lord of Lords” in your GY (Quick Effect):
	You can discard this card; this card gains the following effects while in the GY or banishment.
	•
	You take no battle or effect damage.
	•
	You cannot lose the Duel, except if your LP becomes 0.
	]]--
	local e1a=Effect.CreateEffect(c)
	e1a:SetDescription(aux.Stringid(id,0))
	e1a:SetType(EFFECT_TYPE_QUICK_O)
	e1a:SetCode(EVENT_FREE_CHAIN)
	e1a:SetRange(LOCATION_HAND)
	e1a:SetCost(s.e1cst)
	e1a:SetTarget(s.e1tgt)
	e1a:SetOperation(s.e1evt)
	c:RegisterEffect(e1a)
	
	local e1b=Effect.CreateEffect(c)
	e1b:SetDescription(aux.Stringid(id,0))
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1b:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1b:SetRange(LOCATION_HAND)
	e1b:SetCode(EVENT_DAMAGE)
	e1b:SetCost(s.e1cst)
	e1b:SetCondition(s.e1bcon)
	e1b:SetTarget(s.e1btgt)
	e1b:SetOperation(s.e1evt)
	c:RegisterEffect(e1b)
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
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.e1fil,tp,LOCATION_GRAVE,0,1,nil)
	end

	if e:IsHasType(EFFECT_TYPE_QUICK_O) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1evt(e,tp)
	local c=e:GetHandler()
	-- TODO : Add Reset
	local e1c1=Effect.CreateEffect(c)
	e1c1:SetType(EFFECT_TYPE_FIELD)
	e1c1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1c1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1c1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1c1:SetTargetRange(1,0)
	e1c1:SetValue(1)
	c:RegisterEffect(e1c1)

	local e1c2=Effect.CreateEffect(c)
	e1c2:SetType(EFFECT_TYPE_FIELD)
	e1c2:SetCode(EFFECT_CHANGE_DAMAGE)
	e1c2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1c2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1c2:SetTargetRange(1,0)
	e1c2:SetValue(s.e1cval)
	c:RegisterEffect(e1c2)

	local e1c3=e1c2:Clone()
	e1c3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e1c3)

	local e1d1=Effect.CreateEffect(c)
	e1d1:SetType(EFFECT_TYPE_FIELD)
	e1d1:SetCode(EFFECT_CANNOT_LOSE_DECK)
	e1d1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1d1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1d1:SetTargetRange(1,0)
	c:RegisterEffect(e1d1)

	local e1d2=e1d1:Clone()
	e1d2:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e1d2)
end
function s.e1bcon(e,tp,eg,ep,ev,re,r)
	return ep==tp
	and r&(REASON_BATTLE+REASON_EFFECT)~=0
end
function s.e1btgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	if e:IsHasType(EFFECT_TYPE_TRIGGER_O) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1cval(e,re,val,r)
	if (r&REASON_EFFECT)~=0 then
		return 0
	else
		return val
	end
end
