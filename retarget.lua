--This addition is SHIRSIG's retarget addon merged with UFI.

local function feigning()
	local i, buff = 1, nil
	repeat
		buff = UnitBuff('target', i)
		if buff == [[Interface\Icons\Ability_Rogue_FeignDeath]] then
			return true
		end
		i = i + 1
	until not buff
	return UnitCanAttack('player', 'target')
end
local unit, lost
local pass = function() end
CreateFrame'Frame':SetScript('OnUpdate', function()
	local target = UnitName'target'
	--if target then
	if target and UnitIsPlayer("target") then
		unit, dead, lost = target, UnitIsDead'target', false
	elseif unit then
		local _PlaySound, _UIErrorsFrame_OnEvent = PlaySound, UIErrorsFrame_OnEvent
		PlaySound, UIErrorsFrame_OnEvent = lost and PlaySound or pass, pass
		TargetByName(unit, true)
		PlaySound, UIErrorsFrame_OnEvent = _PlaySound, _UIErrorsFrame_OnEvent
		if UnitExists'target' then
			if not (lost or (not dead and UnitIsDead'target' and feigning())) then
				ClearTarget()
				unit, lost = nil, false
			end
		else
			lost = true
		end
	end
end)