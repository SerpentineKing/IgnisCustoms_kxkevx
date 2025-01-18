-- Rebellion Falcon King
local s,id,o=GetID()
-- c220000023
function s.initial_effect(c)
	-- 3 Level 8 monsters
	Xyz.AddProcedure(c,aux.TRUE,8,3)
	c:EnableReviveLimit()
	-- Unaffected by other cards’ effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.e1con)
	e1:SetValue(s.e1val)
	c:RegisterEffect(e1)
	-- Cannot be used as material for a Fusion, Synchro, Xyz, or Link Summon.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	c:RegisterEffect(e2)
	-- This face-up card on the field cannot be Tributed.
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_SINGLE)
	e3a:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetValue(1)
	c:RegisterEffect(e3a)

	local e3b=e3a:Clone()
	e3b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3b)
	-- Cannot be destroyed by battle.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	-- Your opponent takes any battle damage you would have taken from battles involving this card.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	-- Your opponent takes any effect damage you would have taken.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_REFLECT_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	e6:SetValue(s.e6val)
	c:RegisterEffect(e6)
end
-- Helpers
function s.e1con(e)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.e1val(e,re)
	return re:GetOwner()~=e:GetOwner()
end
function s.e6val(e,re,val,r,rp)
	if (r&REASON_EFFECT)>0 then
		Duel.Hint(HINT_CARD,rp,id)
		return true
	end
	return false
end
