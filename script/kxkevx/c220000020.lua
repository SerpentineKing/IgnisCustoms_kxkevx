-- Thou Shalt Not...
local s,id,o=GetID()
-- c220000021
function s.initial_effect(c)
	-- [Activation]
	-- Neither player can activate cards or effects in response to this card’s activation or effect activations.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
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
	-- Your opponent cannot take control of, or attach as material, or Special Summon cards in your possession.
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetTargetRange(LOCATION_ALL,0)
	c:RegisterEffect(e2a)

	local e2b=Effect.CreateEffect(c)
	e2b:SetType(EFFECT_TYPE_FIELD)
	e2b:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2b:SetRange(LOCATION_SZONE)
	e2b:SetTargetRange(LOCATION_ALL,0)
	e2b:SetValue(s.e2blim)
	c:RegisterEffect(e2b)

	local e2c=Effect.CreateEffect(c)
	e2c:SetType(EFFECT_TYPE_FIELD)
	e2c:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2c:SetRange(LOCATION_SZONE)
	e2c:SetTargetRange(LOCATION_ALL,0)
	e2c:SetValue(s.e2clim)
	c:RegisterEffect(e2c)
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
function s.e2blim(e,c)
	if not c then return false end

	return not c:IsOwner()==e:GetOwner()
end
function s.e2clim(e,se)
	return e:GetHandlerPlayer()==se:GetHandlerPlayer()
end
function s.e3con(e,tp)
	local c=e:GetHandler()
	
	return c:IsReason(REASON_EFFECT)
	and c:GetReasonPlayer()==1-tp
end
function s.e3tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	local ct=2000

	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct)

	if e:IsHasType(EFFECT_TYPE_SINGLE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e3evt(e,tp)
	local p,lp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,lp,REASON_EFFECT)
end
