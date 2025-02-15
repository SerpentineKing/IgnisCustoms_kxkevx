-- Michael the Archangel
local s,id,o=GetID()
-- c220000002
function s.initial_effect(c)
	-- This card cannot be Special Summoned by your opponent’s card effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(s.e1lim)
	c:RegisterEffect(e1)
	--[[
	If your opponent controls 5 monsters in their Main Monster Zones:
	You can Special Summon this card from your hand,
	and if you do, add 1 “Raphael the Archangel” from your Deck to your hand.
	]]--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tgt)
	e2:SetOperation(s.e2evt)
	c:RegisterEffect(e2)
	--[[
	At the start of the Damage Step, if this card is attacked:
	You take no battle damage from that battle, also your opponent gains 4000 LP at the end of the Damage Step.
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
function s.e2con(e,tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MMZONE)>4
end
function s.e2fil(c)
	return c:IsCode(220000005)
	and c:IsAbleToHand()
end
function s.e2tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.IsExistingMatchingCard(s.e2fil,tp,LOCATION_DECK,0,1,nil)
	end

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.e2evt(e,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

			local g=Duel.SelectMatchingCard(tp,s.e2fil,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
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
	e3b2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3b2:SetCode(EVENT_DAMAGE_STEP_END)
	e3b2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3b2:SetTarget(s.e3b2tgt)
	e3b2:SetOperation(s.e3b2evt)
	e3b2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3b2,tp)
end
function s.e3b2tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	local lp=4000
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(lp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,lp)
end
function s.e3b2evt(e,tp)
	local p,lp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,lp,REASON_EFFECT)
end
