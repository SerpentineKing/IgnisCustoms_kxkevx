-- My Grace is Enough
local s,id,o=GetID()
-- c220000013
function s.initial_effect(c)
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	[HOPT]
	Draw 7 cards, then your opponent gains 7000 LP and you take 1400 damage.
	]]--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,{id,0},EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.e1tgt)
	e1:SetOperation(s.e1evt)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
-- Helpers
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=7

	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,ct)
	end

	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1evt(e,tp)
	local p,ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,ct,REASON_EFFECT)>0 then
		Duel.BreakEffect()

		Duel.Recover(1-tp,7000,REASON_EFFECT)
		Duel.Damage(tp,1400,REASON_EFFECT)
	end
end
