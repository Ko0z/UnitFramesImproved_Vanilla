-- Thanks to Obble/modui

local _, class = UnitClass'player'
if class ~= 'DRUID' then return end

local TEXTURE       = [[Interface\AddOns\UnitFramesImproved_Vanilla\Textures\sb.tga]]
local BACKDROP      = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
local DruidManaLib  = AceLibrary'DruidManaLib-1.0'
--local DruidManaLib  = AceLibrary'LibDruidMana-1.0'

local f = CreateFrame'Frame'

PlayerFrame.ExtraManaBar = CreateFrame('StatusBar', 'ExtraManaBar', PlayerFrame)
PlayerFrame.ExtraManaBar:SetWidth(100)
PlayerFrame.ExtraManaBar:SetHeight(10)
if (GetCVar("ufiCompactMode") == "1") then
	PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 47)
else 
	PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 37)
end
PlayerFrame.ExtraManaBar:SetStatusBarTexture(TEXTURE)
PlayerFrame.ExtraManaBar:SetStatusBarColor(ManaBarColor[0].r, ManaBarColor[0].g, ManaBarColor[0].b)
PlayerFrame.ExtraManaBar:SetBackdrop(BACKDROP)
PlayerFrame.ExtraManaBar:SetBackdropColor(0, 0, 0)

PlayerFrame.ExtraManaBar.Text = PlayerFrame.ExtraManaBar:CreateFontString('ExtraManaBarText', 'OVERLAY', 'TextStatusBarText')
--PlayerFrame.ExtraManaBar.Text:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
PlayerFrame.ExtraManaBar.Text:SetPoint('TOP', PlayerFrame.ExtraManaBar, 'BOTTOM', 0, 8)
PlayerFrame.ExtraManaBar.Text:SetTextColor(.6, .65, 1)

PlayerFrame.ExtraManaBar:SetScript('OnMouseUp', function(bu)
    PlayerFrame:Click(bu)
end)

modSkin(PlayerFrame.ExtraManaBar, 1)
--modSkinColor(PlayerFrame.ExtraManaBar, .3, .3, .3)

local OnUpdate = function()
    DruidManaLib:MaxManaScript()
    local v, max = DruidManaLib:GetMana()
	local percent = math.floor(v/max*100)

	--DruidManaLib:GetMaximumMana()
    --local v, max = DruidManaLib:GetMana()
		

    PlayerFrame.ExtraManaBar:SetMinMaxValues(0, max)
    PlayerFrame.ExtraManaBar:SetValue(v)
    --PlayerFrame.ExtraManaBar.Text:SetText(true_format(v))
	--PlayerFrame.ExtraManaBar.Text:SetText(v)

	if GetCVar'ufiPercentage' == '1' then
		PlayerFrame.ExtraManaBar.Text:SetText(true_format(v)..'/'..true_format(max).. ' \226\128\148 ' ..percent..'%')
	else
		PlayerFrame.ExtraManaBar.Text:SetText(true_format(v)..'/'..true_format(max))
	end
end

local OnEvent = function()
    if event == 'PLAYER_AURAS_CHANGED' then
        if not PlayerFrame.ExtraManaBar:IsShown() then return end
    end
    if  f.loaded and UnitPowerType'player' ~= 0 then
        PlayerFrame.ExtraManaBar:Show()

		if (GetCVar("ufiDarkMode") == "1") then
			modSkinColor(PlayerFrame.ExtraManaBar, .3, .3, .3)
		else 
			modSkinColor(PlayerFrame.ExtraManaBar, 1, 1, 1)
		end
		if (GetCVar("ufiNameOutline") == "1") then
			PlayerFrame.ExtraManaBar.Text:SetFont(STANDARD_TEXT_FONT, UnitFramesImprovedConfig.HPFontSize, 'OUTLINE')
		else 
			PlayerFrame.ExtraManaBar.Text:SetFont(STANDARD_TEXT_FONT, UnitFramesImprovedConfig.HPFontSize)
		end

		if (GetCVar("ufiCompactMode") == "1") then
			PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 47)
		else 
			PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 37)
		end
    else
        PlayerFrame.ExtraManaBar:Hide()
        f.loaded = true
    end
end

f:RegisterEvent'UNIT_DISPLAYPOWER'
f:RegisterEvent'PLAYER_AURAS_CHANGED'

f:SetScript('OnUpdate', OnUpdate)
f:SetScript('OnEvent', OnEvent)

--
