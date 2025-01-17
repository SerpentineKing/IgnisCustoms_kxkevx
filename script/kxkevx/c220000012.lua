-- Be Still
local s,id,o=GetID()
-- c220000012
function s.initial_effect(c)
	-- Neither player can activate cards or effects in response to this card’s activation.
	-- During your opponent’s turn, if your opponent Summoned 4 or monsters this turn, you can activate this card from your hand.
	--[[
	Pay 1000 LP;
	Skip a number of your opponent’s next Battle Phases,
	equal to the number of Summons they performed this turn before this effect was activated.
	]]--
end
-- Helpers
