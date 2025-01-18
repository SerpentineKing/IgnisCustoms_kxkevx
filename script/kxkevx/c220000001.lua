-- King of Kings, Lord of Lords
local s,id,o=GetID()
-- c220000001
function s.initial_effect(c)
	-- Unaffected by other card’s effects, except “Trinity Power”.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.e1con)
	e1:SetValue(s.e1val)
	c:RegisterEffect(e1)
	-- Cannot be destroyed by battle.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	-- You take no battle damage from battles involving this card.
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
	-- Cannot be Special Summoned by your opponent’s card effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(s.e3lim)
	c:RegisterEffect(e3)
	-- Your opponent cannot use this card as material for a Fusion, Synchro, Xyz, or Link Summon.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	c:RegisterEffect(e4)
	-- This face-up card on the field cannot be Tributed.
	local e5a=Effect.CreateEffect(c)
	e5a:SetType(EFFECT_TYPE_SINGLE)
	e5a:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5a:SetRange(LOCATION_MZONE)
	e5a:SetValue(1)
	c:RegisterEffect(e5a)

	local e5b=e5a:Clone()
	e5b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5b)
	-- If this card is Special Summoned by the effect of “Divine Resurrection”, you win the Duel.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(s.e6con)
	e6:SetOperation(s.e6evt)
	c:RegisterEffect(e6)
	--[[
	[SOPT]
	If your opponent controls 4 or more monsters (Quick Effect):
	You can Special Summon this card from your hand.
	]]--
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_HAND)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e7:SetCondition(function(_,tp) return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>3 end)
	e7:SetTarget(s.e7tgt)
	e7:SetOperation(s.e7evt)
	c:RegisterEffect(e7)
end
-- Helpers
function s.e1con(e)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.e1val(e,re)
	local rc=re:GetHandler()

	return re:GetOwner()~=e:GetOwner()
	and not rc:IsCode(220000011)
end
function s.e3lim(e,se)
	return e:GetHandlerPlayer()==se:GetHandlerPlayer()
end
function s.e6con(e,tp,eg,ep,ev,re)
	return re
	and re:GetHandler():IsCode(220000021)
end
function s.e6evt(e,tp)
	Duel.Win(tp,WIN_REASON_FINAL_COUNTDOWN)
end
function s.e7tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.e7evt(e,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
