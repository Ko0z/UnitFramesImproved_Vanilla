local function log(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end -- alias for convenience
local ClassPortraits = CreateFrame("Frame", nil, UIParent);
local iconPath="Interface\\Addons\\UnitFramesImproved_Vanilla\\UI-CLASSES-CIRCLES"
-- copied from TBC Client 2.4.3
local CLASS_BUTTONS = {
	["HUNTER"] = {
		0, -- [1]
		0.25, -- [2]
		0.25, -- [3]
		0.5, -- [4]
	},
	["WARRIOR"] = {
		0, -- [1]
		0.25, -- [2]
		0, -- [3]
		0.25, -- [4]
	},
	["ROGUE"] = {
		0.49609375, -- [1]
		0.7421875, -- [2]
		0, -- [3]
		0.25, -- [4]
	},
	["MAGE"] = {
		0.25, -- [1]
		0.49609375, -- [2]
		0, -- [3]
		0.25, -- [4]
	},
	["PRIEST"] = {
		0.49609375, -- [1]
		0.7421875, -- [2]
		0.25, -- [3]
		0.5, -- [4]
	},
	["WARLOCK"] = {
		0.7421875, -- [1]
		0.98828125, -- [2]
		0.25, -- [3]
		0.5, -- [4]
	},
	["DRUID"] = {
		0.7421875, -- [1]
		0.98828125, -- [2]
		0, -- [3]
		0.25, -- [4]
	},
	["SHAMAN"] = {
		0.25, -- [1]
		0.49609375, -- [2]
		0.25, -- [3]
		0.5, -- [4]
	},
	["PALADIN"] = {
		0, -- [1]
		0.25, -- [2]
		0.5, -- [3]
		0.75, -- [4]
	},
}

-- event: UNIT_PORTRAIT_UPDATE
-- found this: 16.11.2013; can probably be used

local partyFrames = {
	[1] = PartyMemberFrame1,
	[2] = PartyMemberFrame2,
	[3] = PartyMemberFrame3,
	[4] = PartyMemberFrame4,
}

ClassPortraits:SetScript("OnUpdate",  function()
	if PlayerFrame.portrait~=nil then
		local _, class = UnitClass("player")
		local iconCoords = CLASS_BUTTONS[class]
		PlayerFrame.portrait:SetTexture(iconPath, true)
		PlayerFrame.portrait:SetTexCoord(unpack(iconCoords))
	end
	for i=1, GetNumPartyMembers() do
		if partyFrames[i].portrait~=nil then
			local _, class = UnitClass("party"..i)
			if not CLASS_BUTTONS[class] then return end
			partyFrames[i].portrait:SetTexture(iconPath, true)
			partyFrames[i].portrait:SetTexCoord(unpack(CLASS_BUTTONS[class]))
		end
	end
		if(UnitName("target")~=nil and UnitIsPlayer("target") ~= nil and TargetFrame.portrait~=nil) then
			local _, class = UnitClass("target")
			TargetFrame.portrait:SetTexture(iconPath, true)
			TargetFrame.portrait:SetTexCoord(unpack(CLASS_BUTTONS[class]))
		elseif(UnitName("target")~=nil) then
			TargetFrame.portrait:SetTexCoord(0,1,0,1)
		end
		
		if(UnitName("targettarget")~=nil and UnitIsPlayer("targettarget") ~= nil and TargetofTargetFrame.portrait~=nil) then
		local _, class = UnitClass("targettarget")
		TargetofTargetFrame.portrait:SetTexture(iconPath, true)
		TargetofTargetFrame.portrait:SetTexCoord(unpack(CLASS_BUTTONS[class]))
		elseif(UnitName("targettarget")~=nil) then
			TargetofTargetFrame.portrait:SetTexCoord(0,1,0,1)
		end
end
)