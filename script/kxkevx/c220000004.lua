-- Gabriel the Archangel
local s,id,o=GetID()
-- c220000004
function s.initial_effect(c)
	-- This card cannot be Special Summoned by your opponent’s card effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(s.e1lim)
	c:RegisterEffect(e1)
	--[[
	If this card is Normal or Special Summoned:
	You can add 1 “Michael the Archangel” from your Deck to your hand.
	]]--
	local e2a=Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id,0))
	e2a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2a:SetCode(EVENT_SUMMON_SUCCESS)
	e2a:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2a:SetTarget(s.e2tgt)
	e2a:SetOperation(s.e2evt)
	c:RegisterEffect(e2a)

	local e2b=e2a:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)
	--[[
	At the start of the Damage Step, if this card is attacked:
	You take no battle damage from that battle, also your opponent gains 7000 LP at the end of the Damage Step.
	This effect cannot be negated.
	]]--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.e3con)
	e3:SetOperation(s.e3evt)
	c:RegisterEffect(e3)
end
-- Helpers
function s.e1lim(e,se)
	return e:GetHandlerPlayer()==se:GetHandlerPlayer()
end
function s.e2fil(c)
	return c:IsCode(220000002)
	and c:IsAbleToHand()
end
function s.e2tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.e2fil,tp,LOCATION_DECK,0,1,nil)
	end
	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.e2evt(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

	local tc=Duel.SelectMatchingCard(tp,s.e2fil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.e3con(e,tp)
	return Duel.GetAttackTarget()==e:GetHandler()
end
function s.e3evt(e,tp)
	local c=e:GetHandler()

	local e3b1=Effect.CreateEffect(c)
	e3b1:SetType(EFFECT_TYPE_FIELD)
	e3b1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3b1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3b1:SetTargetRange(1,0)
	e3b1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	Duel.RegisterEffect(e3b1,tp)

	local e3b2=Effect.CreateEffect(c)
	e3b2:SetCategory(CATEGORY_RECOVER)
	e3b2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3b2:SetCode(EVENT_DAMAGE_STEP_END)
	e3b2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e3b2:SetCondition(s.e3con)
	e3b2:SetTarget(s.e3b2tgt)
	e3b2:SetOperation(s.e3b2evt)
	e3b2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e3b2)
end
function s.e3b2tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	local lp=7000
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(lp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,lp)
end
function s.e3b2evt(e,tp)
	local p,lp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,lp,REASON_EFFECT)
end
