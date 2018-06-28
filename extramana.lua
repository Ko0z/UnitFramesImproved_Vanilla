-- Thanks to Obble/modui


--TODO: SWAP POSITION OF RAGE/MANA BAR.
--FIX OPTIONS TO UPDATE AND WORK CORRECTLY

local _, class = UnitClass'player'
if class ~= 'DRUID' then return end

local TEXTURE       = [[Interface\AddOns\UnitFramesImproved_Vanilla\Textures\sb.tga]]
local BACKDROP      = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
local DruidManaLib  = AceLibrary'DruidManaLib-1.0'
--local DruidManaLib  = AceLibrary'LibDruidMana-1.0'

local f = CreateFrame'Frame'
--local emtext

PlayerFrame.ExtraManaBar = CreateFrame('StatusBar', 'ExtraManaBar', PlayerFrame)
PlayerFrame.ExtraManaBar:SetHeight(10)

--local frame = CreateFrame("frame", "UfiExtraMana", PlayerFrame) --added
UfiExtraManaText = CreateFrame("frame", "UfiExtraMana", PlayerFrame) --added
emtext = UfiExtraManaText:CreateFontString("ExtraManaBarText", "ARTWORK") --added

UfiExtraManaText:SetFrameLevel(2);
--PlayerFrame.ExtraManaBar.Text = PlayerFrame.ExtraManaBar:CreateFontString('ExtraManaBarText', 'ARTWORK', 'TextStatusBarText') -- OVERLAY
--PlayerFrame.ExtraManaBar.Text = PlayerFrame.ExtraManaBar:CreateFontString('ExtraManaBarText', 'ARTWORK') -- OVERLAY

--PlayerFrame.ExtraManaBar.Text:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
--PlayerFrame.ExtraManaBar.Text:SetPoint('TOP', PlayerFrame.ExtraManaBar, 'BOTTOM', 0, 8)

--PlayerFrame.ExtraManaBar.Text:SetTextColor(.6, .65, 1)
emtext:SetTextColor(.6, .65, 1) -- added

--PlayerFrame.ExtraManaBar.Text:SetFrameLevel(5);
--PlayerFrame.ExtraManaBar:SetFrameLevel(1);
--ExtraManaBarText:SetFrameLevel(5);

--PlayerFrame.ExtraManaBar:SetStatusBarTexture(TEXTURE)
PlayerFrame.ExtraManaBar:SetStatusBarTexture(ORIG_TEXTURE)
PlayerFrame.ExtraManaBar:SetStatusBarColor(ManaBarColor[0].r, ManaBarColor[0].g, ManaBarColor[0].b)
PlayerFrame.ExtraManaBar:SetBackdrop(BACKDROP)
PlayerFrame.ExtraManaBar:SetBackdropColor(0, 0, 0)

PlayerFrame.ExtraManaBar:SetScript('OnMouseUp', function(bu)
    PlayerFrame:Click(bu)
end)

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
		--PlayerFrame.ExtraManaBar.Text:SetText(true_format(v)..'/'..true_format(max).. ' \226\128\148 ' ..percent..'%')
		emtext:SetText(true_format(v)..'/'..true_format(max).. ' \226\128\148 ' ..percent..'%') --added
	else
		--PlayerFrame.ExtraManaBar.Text:SetText(true_format(v)..'/'..true_format(max))
		emtext:SetText(true_format(v)..'/'..true_format(max)) --added
	end
end

function ExtraManaStyle()
	 if  f.loaded and UnitPowerType'player' ~= 0 then
        PlayerFrame.ExtraManaBar:Show()
		UfiExtraManaText:Show()

		if (GetCVar("ufiDarkMode") == "1") then
			modSkinColor(PlayerFrame.ExtraManaBar, .3, .3, .3)
		else 
			modSkinColor(PlayerFrame.ExtraManaBar, 1, 1, 1)
		end
		if (GetCVar("ufiNameOutline") == "1") then
			--PlayerFrame.ExtraManaBar.Text:SetFont(STANDARD_TEXT_FONT, UnitFramesImprovedConfig.HPFontSize, 'OUTLINE')
			emtext:SetFont(STANDARD_TEXT_FONT, UnitFramesImprovedConfig.HPFontSize, 'OUTLINE') --added
		else 
			--PlayerFrame.ExtraManaBar.Text:SetFont(STANDARD_TEXT_FONT, UnitFramesImprovedConfig.HPFontSize)
			emtext:SetFont(STANDARD_TEXT_FONT, UnitFramesImprovedConfig.HPFontSize) --added
		end

		if (GetCVar("ufiCompactMode") == "1") then
			PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
			--PlayerFrameTexture:SetTexture("");
			PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 47)
		else 
			PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 37)
		end
    else
        PlayerFrame.ExtraManaBar:Hide()
		UfiExtraManaText:Hide()
        f.loaded = true
		if (GetCVar("ufiCompactMode") == "1") then
			if (GetCVar("ufiDarkMode") == "1") then
				UnitFramesImproved_SetTexture(PlayerFrameTexture, "DarkCompactUI");
			else
				UnitFramesImproved_SetTexture(PlayerFrameTexture, "compactUI");
			end
		else
			if (GetCVar("ufiDarkMode") == "1") then
				UnitFramesImproved_SetTexture(PlayerFrameTexture, "darkUI");
			else
				UnitFramesImproved_SetTexture(PlayerFrameTexture, "UI");
			end
		end
    end
end

function ExtraManaInitialize()
	if (GetCVar("ufiCompactMode") == "1") then
		--PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 47)
		-- CHANGE
		--PlayerFrameManaBar:SetPoint("TOPLEFT",106,-42);
		PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame");
		PlayerFrame.ExtraManaBar:SetPoint('TOPLEFT', PlayerFrame, 'BOTTOM', -11, 46)
		PlayerFrame.ExtraManaBar:SetWidth(120)
		--PlayerFrame.ExtraManaBar.Text:SetPoint('TOP', PlayerFrame.ExtraManaBar, 'BOTTOM', 0, 11)
		emtext:SetPoint('TOP', PlayerFrame.ExtraManaBar, 'BOTTOM', 0, 11) --added 11
		modSkinHide(PlayerFrame.ExtraManaBar);
	else 
		PlayerFrame.ExtraManaBar:SetPoint('TOP', PlayerFrame, 'BOTTOM', 50, 37)
		PlayerFrame.ExtraManaBar:SetWidth(100)
		--PlayerFrame.ExtraManaBar.Text:SetPoint('TOP', PlayerFrame.ExtraManaBar, 'BOTTOM', 0, 8)
		emtext:SetPoint('TOP', PlayerFrame.ExtraManaBar, 'BOTTOM', 0, 8) --added
		modSkin(PlayerFrame.ExtraManaBar, 1)
		modSkinShow(PlayerFrame.ExtraManaBar);
	end
end

local OnEvent = function()
	
	if event == 'ADDON_LOADED' then 
		ExtraManaInitialize();
	end

    if event == 'PLAYER_AURAS_CHANGED' then
        if not PlayerFrame.ExtraManaBar:IsShown() then return end
    end
   
   ExtraManaStyle();
end

f:RegisterEvent'UNIT_DISPLAYPOWER'
f:RegisterEvent'PLAYER_AURAS_CHANGED'
f:RegisterEvent'ADDON_LOADED'

f:SetScript('OnUpdate', OnUpdate)
f:SetScript('OnEvent', OnEvent)
--
