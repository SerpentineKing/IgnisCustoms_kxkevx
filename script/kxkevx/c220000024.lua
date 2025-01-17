-- Depart from Me
local s,id,o=GetID()
-- c220000024
function s.initial_effect(c)
	-- Cannot be Xyz Summoned.
	-- Neither player can activate cards or effects in response to this effect’s activation.
	--[[
	If your opponent would win the Duel,
	except if your LP becomes 0 or you are unable to draw a card,
	you can banish this card from your face-down Extra Deck, instead.
	]]--
	--[[
	While this card is in your banishment, you cannot lose the Duel,
	except if your LP becomes 0 or you are unable to draw a card.
	]]--
end
-- Helpers
