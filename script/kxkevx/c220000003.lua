-- Divine Gift
local s,id,o=GetID()
-- c220000003
function s.initial_effect(c)
	-- Cannot be destroyed by battle.
	-- This face-up card on the field cannot be Tributed, except by its own effect.
	--[[
	Each time a monster(s) is Summoned:
	Gain 1000 LP for each.
	]]--
	-- You take no battle damage from battles involving your Defense Position monsters.
	--[[
	You can Tribute this card;
	Special Summon 1 “King of Kings, Lord of Lords” from your hand, GY, or banishment.
	]]--
end
-- Helpers
