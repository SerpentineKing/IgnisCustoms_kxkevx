-- Wonderful Counselor
local s,id,o=GetID()
-- c220000008
function s.initial_effect(c)
	-- [Activation]
	-- Neither player can activate cards or effects in response to this card’s activation.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.e0tgt)
	c:RegisterEffect(e0)
	-- Other Spells/Traps you control cannot leave the field because of your opponent’s card effects.
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1a:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1a:SetTargetRange(LOCATION_SZONE,0)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetTarget(s.e1tgt)
	e1a:SetValue(aux.indoval)
	c:RegisterEffect(e1a)

	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD)
	e1b:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e1b:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1b:SetTargetRange(LOCATION_SZONE,0)
	e1b:SetRange(LOCATION_SZONE)
	e1b:SetCondition(s.e1con)
	e1b:SetTarget(s.e1tgt)
	c:RegisterEffect(e1b)

	local e1c=e1b:Clone()
	e1c:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e1c)

	local e1d=e1b:Clone()
	e1d:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e1d)

	local e1e=e1b:Clone()
	e1e:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e1e)
	-- You take no battle damage.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--[[
	If this card is sent to the GY, or banished, by an opponent’s card effect:
	Inflict 2000 damage to your opponent.
	]]--
	local e3a=Effect.CreateEffect(c)
	e3a:SetCategory(CATEGORY_DAMAGE)
	e3a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3a:SetCode(EVENT_TO_GRAVE)
	e3a:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3a:SetCountLimit(1)
	e3a:SetCondition(s.e3con)
	e3a:SetTarget(s.e3tgt)
	e3a:SetOperation(s.e3evt)
	c:RegisterEffect(e3a)

	local e3b=e3a:Clone()
	e3b:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3b)
end
-- Helpers
function s.e0tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1con(e,tp)
	return e:GetHandler():GetReasonPlayer()==1-tp
end
function s.e1tgt(e,c)
	return c~=e:GetHandler()
end
function s.e3con(e,tp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=1-tp
end
function s.e3tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	local ct=2000

	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct)
end
function s.e3evt(e,tp)
	local p,lp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,lp,REASON_EFFECT)
end
