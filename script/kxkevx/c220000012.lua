-- Be Still
local s,id,o=GetID()
-- c220000012
function s.initial_effect(c)
	-- Neither player can activate cards or effects in response to this card’s activation.
	--[[
	Pay 1000 LP;
	Skip a number of your opponent’s next Battle Phases,
	equal to the number of Summons they performed this turn before this effect was activated.
	]]--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.e1cst)
	e1:SetTarget(s.e1tgt)
	e1:SetOperation(s.e1evt)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	-- During your opponent’s turn, if your opponent Summoned 4 or monsters this turn, you can activate this card from your hand.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.e2con)
	c:RegisterEffect(e2)

	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.ge2evt)
		Duel.RegisterEffect(ge1,0)

		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end)
end
-- Helpers
function s.e1cst(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=1000

	if chk==0 then
		return Duel.CheckLPCost(tp,ct)
	end

	Duel.PayLPCost(tp,ct)
end
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e1evt(e,tp)
	local c=e:GetHandler()

	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD)
	e1b:SetCode(EFFECT_SKIP_BP)
	e1b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1b:SetTargetRange(0,1)

	local ct=Duel.GetFlagEffect(1-tp,id)
	if Duel.GetTurnPlayer()~=tp and Duel.IsBattlePhase() then
		e1b:SetLabel(Duel.GetTurnCount())
		e1b:SetCondition(s.e1bcon)
		e1b:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,ct+1)
	else
		e1b:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,ct)
	end

	Duel.RegisterEffect(e1b,tp)
end
function s.e1bcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.ge2evt(e,tp,eg)
	local tc=eg:GetFirst()
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.e2con(e)
	local tp=e:GetHandlerPlayer()
	
	return Duel.GetTurnPlayer()==1-tp
	and Duel.GetFlagEffect(1-tp,id)>=4
end
