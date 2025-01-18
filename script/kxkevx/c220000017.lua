-- I Trust in You.
local s,id,o=GetID()
-- c220000017
function s.initial_effect(c)
	-- [Activation]
	-- Neither player can activate cards or effects in response to this card’s activation or effect activations.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.e0tgt)
	c:RegisterEffect(e0)
	-- This face-up card on the field cannot be Tributed.
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_SINGLE)
	e1a:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1a:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetValue(1)
	c:RegisterEffect(e1a)

	local e1b=e1a:Clone()
	e1b:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e1b)
	--[[
	[SOPT]
	Once per turn:
	You can shuffle any number of cards from either player’s GY(s) and/or banishment(s) into the Deck/Extra Deck.
	]]--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.e2tgt)
	e2:SetOperation(s.e2evt)
	c:RegisterEffect(e2)
	--[[
	If this card is sent to the GY or banished:
	Shuffle it into the Deck.
	]]--
	local e3a=Effect.CreateEffect(c)
	e3a:SetCategory(CATEGORY_TODECK)
	e3a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3a:SetCode(EVENT_TO_GRAVE)
	e3a:SetProperty(EFFECT_FLAG_DELAY)
	e3a:SetTarget(s.e3tgt)
	e3a:SetOperation(s.e3evt)
	c:RegisterEffect(e3a)

	local e3b=e3a:Clone()
	e3b:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3b)
	--[[
	During your Draw Phase, if this card is in your GY, instead of conducting your normal draw:
	You can Set this card to your field.
	]]--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.e4con)
	e4:SetTarget(s.e4tgt)
	e4:SetOperation(s.e4evt)
	c:RegisterEffect(e4)
end
-- Helpers
function s.e0tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e2fil(c)
	return c:IsAbleToDeck()
end
function s.e2tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	if chk==0 then
		return Duel.IsExistingMatchingCard(s.e2fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
	end

	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)

	if e:IsHasType(EFFECT_TYPE_QUICK_O) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e2evt(e,tp)
	local ct=Duel.GetMatchingGroup(s.e2fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil):GetCount()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.e2fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
		end
	end
end
function s.e3tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end

	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)

	if e:IsHasType(EFFECT_TYPE_SINGLE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e3evt(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.e4con(e,tp)
	return tp==Duel.GetTurnPlayer()
	and Duel.GetDrawCount(tp)>0
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function s.e4tgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()

	if chk==0 then
		return c:IsSSetable()
	end

	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt

		local e4b=Effect.CreateEffect(c)
		e4b:SetType(EFFECT_TYPE_FIELD)
		e4b:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4b:SetCode(EFFECT_DRAW_COUNT)
		e4b:SetTargetRange(1,0)
		e4b:SetReset(RESET_PHASE+PHASE_DRAW)
		e4b:SetValue(0)
		Duel.RegisterEffect(e4b,tp)
	end

	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)

	if e:IsHasType(EFFECT_TYPE_FIELD) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.e4evt(e,tp)
	local c=e:GetHandler()
	
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end
