-- Divine Gift
local s,id,o=GetID()
-- c220000003
function s.initial_effect(c)
	-- Cannot be destroyed by battle.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	-- This face-up card on the field cannot be Tributed, except by its own effect.
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE)
	e2a:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetValue(s.e2val)
	c:RegisterEffect(e2a)

	local e2b=e2a:Clone()
	e2b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e2b:SetValue(1)
	c:RegisterEffect(e2b)
	-- You take no battle damage from battles involving your Defense Position monsters.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.e3tgt)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--[[
	Each time a monster(s) is Summoned:
	Gain 1000 LP for each.
	]]--
	local e4a=Effect.CreateEffect(c)
	e4a:SetDescription(aux.Stringid(id,0))
	e4a:SetCategory(CATEGORY_RECOVER)
	e4a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4a:SetCode(EVENT_SUMMON_SUCCESS)
	e4a:SetProperty(EFFECT_FLAG_DELAY)
	e4a:SetRange(LOCATION_MZONE)
	e4a:SetTarget(s.e4tgt)
	e4a:SetOperation(s.e4evt)
	c:RegisterEffect(e4a)

	local e4b=e4a:Clone()
	e4b:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4b)
	
	local e4c=e4a:Clone()
	e4c:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4c)
	--[[
	You can Tribute this card;
	Special Summon 1 “King of Kings, Lord of Lords” from your hand, GY, or banishment.
	]]--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(s.e5cst)
	e5:SetTarget(s.e5tgt)
	e5:SetOperation(s.e5evt)
	c:RegisterEffect(e5)
end
-- Helpers
function s.e2val(e,c)
	return not c:IsCode(id)
end
function s.e3tgt(e,c)
	return c:IsDefensePos()
end
function s.e4tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsRelateToEffect(e)
	end

	local ct=eg:GetCount()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ct*1000)
end
function s.e4evt(e,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
function s.e5cst(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end

	Duel.Release(c,REASON_COST)
end
function s.e5fil(c,e,tp)
	return c:IsCode(220000001)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.e5tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end

	if chk==0 then
		return ft>0
		and Duel.IsExistingMatchingCard(s.e5fil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.e5evt(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)

	local g=Duel.SelectMatchingCard(tp,s.e5fil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
