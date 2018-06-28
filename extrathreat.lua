--if UnitFramesImprovedConfig.extraThreat == 1 then return end

--DoSomething = klhtm.onupdate()
--DoSomething();
-- find frame

local _mod = klhtm
local _me = { }
_mod.guiraid = me

local TEXTURE       = [[Interface\AddOns\UnitFramesImproved_Vanilla\Textures\sb.tga]]
local BACKDROP      = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}

------------------------
--[[
local _mod = klhtm
local _me = { }
_mod.guiraid = me

local _userThreat = _mod.table.raiddata[UnitName("player")]
local _threatPercent
local data, playerCount, threat100 = KLHTM_GetRaidData();

if(playerCount) then
	ufi_chattext(playerCount)
end

if(_userThreat and threat100) then
	_threatPercent = math.floor(_userThreat / threat100 * 100);
end

if(_threatPercent) then
	ufi_chattext(_threatPercent)
end
--]]
-----------------------


local f = CreateFrame'Frame'

TargetFrame.ExtraThreatBar = CreateFrame('StatusBar', 'ExtraManaBar', PlayerFrame)
TargetFrame.ExtraThreatBar:SetWidth(100)
TargetFrame.ExtraThreatBar:SetHeight(10)
TargetFrame.ExtraThreatBar:SetPoint('TOP', TargetFrame, 'BOTTOM', -50, 37)
TargetFrame.ExtraThreatBar:SetStatusBarTexture(TEXTURE)
TargetFrame.ExtraThreatBar:SetStatusBarColor(1,0,0)
TargetFrame.ExtraThreatBar:SetBackdrop(BACKDROP)
TargetFrame.ExtraThreatBar:SetBackdropColor(0, 0, 0)

TargetFrame.ExtraThreatBar.Text = TargetFrame.ExtraThreatBar:CreateFontString('ExtraManaBarText', 'OVERLAY', 'TextStatusBarText')
--TargetFrame.ExtraThreatBar.Text:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
TargetFrame.ExtraThreatBar.Text:SetPoint('TOP', TargetFrame.ExtraThreatBar, 'BOTTOM', 0, 8)
TargetFrame.ExtraThreatBar.Text:SetTextColor(1, 1, 1)

TargetFrame.ExtraThreatBar:SetMinMaxValues(0, 100)
TargetFrame.ExtraThreatBar:SetValue(0)

local data, playerCount, threat100;
--local oldData, oldPlayerCount, oldThreat100;
local oldUserThreat, _userThreat

local OnUpdate = function()
	
	_userThreat = _mod.table.raiddata[UnitName("player")];

	if(oldUserThreat ~= _userThreat) then
		oldUserThreat = _userThreat;
		ExtraThreat_Update();
	end
end

function ExtraThreat_Update()
	--local _userThreat = _mod.table.raiddata[UnitName("player")];
	local _threatPercent = nil;

	data, playerCount, threat100 = KLHTM_GetRaidData();

	--if(_userThreat ~= 0 and threat100 ~= 0) then
	if(_userThreat and threat100) then
		_threatPercent = math.floor(_userThreat / threat100 * 100);
	end

	if(_threatPercent ~= nil) then
		DEFAULT_CHAT_FRAME:AddMessage( fontLightBlue.."<extraThreat> " .. _threatPercent)
		
		TargetFrame.ExtraThreatBar:SetMinMaxValues(0, 100)
		TargetFrame.ExtraThreatBar:SetValue(_threatPercent)
	end
end

local OnEvent = function()
    if event == 'VARIABLES_LOADED' then
        DEFAULT_CHAT_FRAME:AddMessage( fontLightBlue.."<Debug msg: >" .. "Variables Loaded")

    end
end

f:RegisterEvent'VARIABLES_LOADED'

f:SetScript('OnUpdate', OnUpdate)
f:SetScript('OnEvent', OnEvent)

--]]