-- Crooked Cook Mastered
local s,id,o=GetID()
-- c220000025
function s.initial_effect(c)
	-- 2 Level 4 monsters
	Xyz.AddProcedure(c,aux.TRUE,4,2)
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
	-- This face-up card on the field cannot be Tributed.
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE)
	e2a:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetValue(1)
	c:RegisterEffect(e2a)

	local e2b=e2a:Clone()
	e2b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2b)
	-- This card’s controller takes no damage from battles involving their Defense Position monsters.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.e3tgt)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	-- This card’s controller takes no effect damage.
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD)
	e4a:SetCode(EFFECT_CHANGE_DAMAGE)
	e4a:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4a:SetRange(LOCATION_MZONE)
	e4a:SetTargetRange(1,0)
	e4a:SetValue(s.e4val)
	c:RegisterEffect(e4a)

	local e4b=e4a:Clone()
	e4b:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4b)
end
-- Helpers
function s.e1con(e)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.e1val(e,re)
	return re:GetOwner()~=e:GetOwner()
end
function s.e3tgt(e,c)
	return c:IsDefensePos()
end
function s.e4val(e,re,val,r)
	if (r&REASON_EFFECT)~=0 then
		return 0
	else
		return val
	end
end
