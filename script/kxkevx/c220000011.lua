-- Trinity Power
local s,id,o=GetID()
-- c220000011
function s.initial_effect(c)
	-- [Activation]
	-- Equip only to “King of Kings, Lord of Lords”.
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,220000001))
	--[[
	At the start of the Damage Step, if the equipped monster battles a monster:
	Destroy that monster,
	and if you do, send the equipped monster to the GY at the end of the Battle Phase.
	This effect and its activation cannot be negated.
	]]--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tgt)
	e1:SetOperation(s.e1evt)
	c:RegisterEffect(e1)
	--[[
	Once per turn, during your End Phase, if this card is in your GY or banishment:
	Add it to your hand.
	]]--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1)
	e2:SetTarget(s.e2tgt)
	e2:SetOperation(s.e2evt)
	c:RegisterEffect(e2)
end
-- Helpers
function s.e1con(e,tp)
	local ec=e:GetHandler():GetEquipTarget()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()

	if not d then return false end

	return (a==ec) or (d==ec)
end
function s.e1tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget():GetBattleTarget()

	if chk==0 then
		return tc and tc:IsControler(1-tp)
	end

	local g=Group.FromCards(tc,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.e1evt(e,tp)
	local c=e:GetHandler()
	
	if not c:IsRelateToEffect(e) then return end

	local ec=c:GetEquipTarget()
	local tc=ec:GetBattleTarget()
	if tc:IsRelateToBattle() and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local e1b=Effect.CreateEffect(c)
		e1b:SetCategory(CATEGORY_TOGRAVE)
		e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1b:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1b:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1b:SetCountLimit(1)
		e1b:SetLabelObject(ec)
		e1b:SetOperation(s.e1bevt)
		e1b:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1b,tp)
	end
end
function s.e1bevt(e,tp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function s.e2tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	if chk==0 then
		return c:IsAbleToHand()
	end

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.e2evt(e,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
