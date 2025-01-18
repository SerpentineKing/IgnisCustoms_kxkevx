-- Steps of Faith
local s,id,o=GetID()
-- c220000015
function s.initial_effect(c)
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	Draw 4 cards,
	and if you do, your opponent gains 4000 LP,
	then if none of those cards were Monster Cards, discard them.
	]]--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,{id,0},EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.e1tgt)
	e1:SetOperation(s.e1evt)
	c:RegisterEffect(e1)
end
-- Helpers
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=4

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
		local g=Duel.GetOperatedGroup()
		if Duel.Recover(1-tp,4000,REASON_EFFECT)>0 then
			Duel.BreakEffect()

			local m=false
			local tc=g:GetFirst()
			for tc in aux.Next(g) do
				if tc:IsMonster() then
					m=true
				end
			end

			if not m then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
