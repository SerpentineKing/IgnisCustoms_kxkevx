-- Divine Assistance
local s,id,o=GetID()
-- c220000010
function s.initial_effect(c)
	-- [Activation]
	aux.AddEquipProcedure(c)
	-- Once per turn, during the Standby Phase, pay 7 LP or destroy this card.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.e1evt)
	c:RegisterEffect(e1)
	-- The equipped monster cannot be targeted, or destroyed, by card effects.
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_EQUIP)
	e2a:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2a:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2a:SetValue(1)
	c:RegisterEffect(e2a)

	local e2b=e2a:Clone()
	e2b:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2b:SetValue(1)
	c:RegisterEffect(e2b)
	--[[
	When the equipped monster declares an attack:
	Your opponent sends the top 10 cards of their Deck to the GY (or their entire Deck, if less than 10).
	]]--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tgt)
	e3:SetOperation(s.e3evt)
	c:RegisterEffect(e3)
end
-- Helpers
function s.e1evt(e,tp)
	local c=e:GetHandler()
	local ct=7

	if Duel.CheckLPCost(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.PayLPCost(tp,ct)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
function s.e3con(e,tp)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function s.e3tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,10)
end
function s.e3evt(e,tp)
	Duel.DiscardDeck(1-tp,10,REASON_EFFECT)
end
