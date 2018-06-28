--UnitFramesImproved_Vanilla by Ko0zi. Based on UnitFramesImproved from Legion but with improvements for Vanilla 
--Cred to the dev of ModUI, darkmode in this addon is heavily inspired from his/hers addon.

_G = getfenv(0)

UNITFRAMESIMPROVED_UI_COLOR = {r = .3, g = .3, b = .3}
local UnitFramesImproved = CreateFrame('Button', 'UnitFramesImproved');
local ADDON_NAME = "UnitFramesImproved_Vanilla";

ufi_modui = false;
ufi_KTM = false;

FLAT_TEXTURE   = [[Interface\AddOns\UnitFramesImproved_Vanilla\Textures\name.tga]]
ORIG_TEXTURE   = [[Interface\TargetingFrame\UI-StatusBar.blp]]

function UnitFramesImproved_Default_Options()
	
	RegisterCVar('ufiClassPortrait',	1, true)
    RegisterCVar('ufiDarkMode',			1, true)
    RegisterCVar('ufiNameOutline',		1, true)
    RegisterCVar('ufiNPCClassColor',	0, false)
    RegisterCVar('ufiPlayerClassColor', 1, true)
    RegisterCVar('ufiPercentage',		0, false)
    RegisterCVar('ufiTrueFormat',		0, false)
    RegisterCVar('ufiHidePetText',		1, true)
	RegisterCVar('ufiHealthTexture',    0, false)
    RegisterCVar('ufiStatusGlow',		0, false)
    RegisterCVar('ufiColoredSbText',	1, true)
	RegisterCVar('ufiImprovedPet',		1, true)
	RegisterCVar('ufiCompactMode',		1, true)
	
	if not UnitFramesImprovedConfig then
		UnitFramesImprovedConfig = { }
	end

	if not UnitFramesImprovedConfig.NameTextX			then	UnitFramesImprovedConfig.NameTextX			= 0		end
	if not UnitFramesImprovedConfig.NameTextY			then	UnitFramesImprovedConfig.NameTextY			= 5		end
	if not UnitFramesImprovedConfig.NameTextFontSize	then	UnitFramesImprovedConfig.NameTextFontSize	= 11	end
	if not UnitFramesImprovedConfig.HPFontSize			then	UnitFramesImprovedConfig.HPFontSize			= 10	end
end

function UnitFramesImproved_Reset_Options()
	SetCVar('ufiClassPortrait',		1, true)
    SetCVar('ufiDarkMode',			1, true)
    SetCVar('ufiNameOutline',		1, true)
    SetCVar('ufiNPCClassColor',		0, false)
    SetCVar('ufiPlayerClassColor',	1, true)
    SetCVar('ufiPercentage',		0, false)
    SetCVar('ufiTrueFormat',		0, false)
    SetCVar('ufiHidePetText',		1, true)
	SetCVar('ufiHealthTexture',		0, false)
    SetCVar('ufiStatusGlow',		0, false)
    SetCVar('ufiColoredSbText',		1, true)
	SetCVar('ufiImprovedPet',		1, true)
	SetCVar('ufiCompactMode',		1, true)

	UnitFramesImprovedConfig.NameTextX			= 0		
	UnitFramesImprovedConfig.NameTextY			= 5		
	UnitFramesImprovedConfig.NameTextFontSize	= 11	
	UnitFramesImprovedConfig.HPFontSize			= 10
end

function UnitFramesImproved_Vanilla_OnLoad()
	
	UnitFramesImproved_Default_Options();
	-- Generic status text hook
	
	HealthBar_OnValueChanged = UnitFramesImproved_ColorUpdate;
	--PlayerFrame_Update = UnitFramesImproved_PlayerFrame_Update;
	TargetFrame_OnUpdate = UnitFramesImproved_TargetFrame_Update;
	TargetFrame_CheckClassification = UnitFramesImproved_TargetFrame_CheckClassification;
	PetFrame_OnUpdate = UnitFramesImproved_PetFrame_OnUpdate;
	
	ufi_chattext( fontLightGreen..'UnitFramesImproved_Vanilla Loaded. ' .. fontLightRed .. 'Type ' ..fontOrange.. '/ufi ' ..fontLightRed.. 'for options.' );

	-------------------------------------------------------------------------------------
	-- FOR MODUI COMPATIBILITY
	if (ufi_modui == false or ufi_modui == nil) then
		TextStatusBar_UpdateTextString = UnitFramesImproved_TextStatusBar_UpdateTextString;
	else
		ufi_chattext( fontOrange.. 'modUI ' ..fontLightGreen.. 'detected.' );
		PlayerFrameBackground.bg:Hide();
		SetCVar('ufiDarkMode', 0, false)
		SetCVar('ufiPlayerClassColor', 1, true)
		SetCVar('ufiPercentage', 0, false)
		SetCVar('ufiHealthTexture', 1, true)
		SetCVar('ufiColoredSbText', 0, false)
		SetCVar('ufiImprovedPet', 0, false)
	end
			-- Set up some stylings
	UnitFramesImproved_Style_PlayerFrame();
	UnitFramesImproved_TargetFrame_CheckClassification();
	UnitFramesImproved_Style_TargetFrame(TargetFrame);
	--UnitFramesImproved_Style_TargetFrame(FocusFrame);
	UnitFramesImproved_Style_TargetOfTargetFrame();
	UnitFramesImproved_Style_PetFrame();

	--Flat Healthbar texture if set in config
	if GetCVar"ufiHealthTexture" == "1" then
		UnitFramesImproved_HealthBarTexture(FLAT_TEXTURE);
	end
	if GetCVar'ufiClassPortrait' == '1' then
		UnitFramesImproved_ClassPortraits();
	end
	if GetCVar'ufiDarkMode' == '1' then
		UnitFramesImproved_DarkMode();
	end
	--[[
	if GetCVar'ufiCompactMode' == '1' then
		htext:SetPoint("TOP", TargetFrameHealthBar, "BOTTOM", MH3BlizzConfig.healthX-2, MH3BlizzConfig.healthY+13)
		ptext:SetPoint("TOP", TargetFrameManaBar, "BOTTOM", MH3BlizzConfig.powerX-2, MH3BlizzConfig.powerY+12)
	else
		htext:SetPoint("TOP", TargetFrameHealthBar, "BOTTOM", MH3BlizzConfig.healthX, MH3BlizzConfig.healthY+11)
		ptext:SetPoint("TOP", TargetFrameManaBar, "BOTTOM", MH3BlizzConfig.powerX, MH3BlizzConfig.powerY+10)
	end
	-- Skin TargetFrame buffs and debuffs
	--
	
	--]]
	-- Update some values
	TextStatusBar_UpdateTextString(PlayerFrame.healthbar);
	TextStatusBar_UpdateTextString(PlayerFrame.manabar);
	TextStatusBar_UpdateTextString(PetFrame.healthbar);
	TextStatusBar_UpdateTextString(PetFrame.manabar);
end

--Sets the texture for the StatusBars
function UnitFramesImproved_HealthBarTexture(NAME_TEXTURE)
	PlayerFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	PlayerFrameManaBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetFrameManaBar:SetStatusBarTexture(NAME_TEXTURE)
	PetFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	PetFrameManaBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetofTargetHealthBar:SetStatusBarTexture(NAME_TEXTURE)
	TargetofTargetManaBar:SetStatusBarTexture(NAME_TEXTURE)

	--PartyMemberFrame1HealthBar:SetStatusBarTexture(NAME_TEXTURE);
	--PartyMemberFrame1ManaBar:SetStatusBarTexture(NAME_TEXTURE);
	--Add party frames
end

function UnitFramesImproved_Style_TargetOfTargetFrame()
	-- May use this at some point
	TargetofTargetPortrait:ClearAllPoints()
	TargetofTargetPortrait:SetPoint("BOTTOMRIGHT", TargetofTargetFrame, "BOTTOMRIGHT", -53, 5)

	--MainMenuBarTexture3:Hide()
	--MainMenuBarTexture2:Hide()
	--MainMenuBarTexture1:Hide()
	--MainMenuMaxLevelBar0:Hide()
	--ActionBarUpButton:Hide()
	--ActionBarDownButton:Hide()
	--MainMenuBarPerformanceBarFrame:Hide()
	--KeyRingButton:Hide();

	--ShowBonusActionBar();
end

function UnitFramesImproved_Style_PetFrame()
	-- May use this at some point
	--PetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetofTargetFrame");
	
	if (GetCVar("ufiImprovedPet") == "1") then
		PetFrameTexture:SetTexCoord(1, 0, 0, 1)
		PetFrameTexture:ClearAllPoints()
		PetFrameTexture:SetPoint("BOTTOMRIGHT", PlayerFrame, "BOTTOMRIGHT", -104, -28)--HERE -102, -29 -- -2, +1

		--PetFrame:SetPoint("BOTTOMRIGHT",0,0);

		PetPortrait:ClearAllPoints() 
		PetPortrait:SetPoint("BOTTOMRIGHT", PetFrame, "BOTTOMRIGHT", -86, 8)

		PetAttackModeTexture:ClearAllPoints() 
		PetAttackModeTexture:SetPoint("BOTTOMRIGHT", PetFrame, "BOTTOMRIGHT", -46, -22)

		PetFrameHealthBar:ClearAllPoints()
		PetFrameHealthBar:SetWidth(45)
		PetFrameHealthBar:SetPoint("BOTTOMRIGHT", PetFrame, "BOTTOMRIGHT", -125, 27)

		PetFrameHealthBarText:ClearAllPoints()
		PetFrameHealthBarText:SetPoint("BOTTOMRIGHT", PetFrame, "BOTTOMRIGHT", -125, 27)

		PetFrameManaBar:ClearAllPoints()
		PetFrameManaBar:SetWidth(45)
		PetFrameManaBar:SetPoint("BOTTOMRIGHT", PetFrame, "BOTTOMRIGHT", -125, 18)

		PetFrameManaBarText:ClearAllPoints()
		PetFrameManaBarText:SetPoint("BOTTOMRIGHT", PetFrame, "BOTTOMRIGHT", -125, 17)

		PetName:ClearAllPoints()
		PetName:SetPoint("BOTTOMRIGHT", PetFrame, "BOTTOMRIGHT", -125, 6)
	end
end

function UnitFramesImproved_Style_PlayerFrame()
	PlayerFrameHealthBar.lockColor = true;
	PlayerFrameHealthBar.capNumericDisplay = true;
	

	--PlayerFrame:SetScale(1.3);
	--TargetFrame:SetScale(1.3);

	--PlayerFrameManaBarText:SetTextColor(.6, .65, 1)

	if (GetCVar("ufiCompactMode") == "0") then
		if (GetCVar("ufiDarkMode") == "0") then
			PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame");
		else
			PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\darkUI-TargetingFrame");
		end

		PlayerFrameHealthBar:SetWidth(119);
		PlayerFrameHealthBar:SetHeight(29);
		PlayerFrameHealthBar:SetPoint("TOPLEFT",106,-22);
		PlayerFrameHealthBarText:SetPoint("CENTER",50,5);

		PlayerFrameManaBar:SetPoint("TOPLEFT",106,-51);
		PlayerFrameManaBarText:SetPoint("CENTER",50,-8);
	else
		--PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame");
		--PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-NoMana");
		--PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame-NoMana");
		if (GetCVar("ufiDarkMode") == "0") then
			PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\compactUI-TargetingFrame");
		else
			PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\DarkCompactUI-TargetingFrame");
		end
		--PlayerFrameTexture:SetTexture("");
		--PlayerFrameTexture:SetTexCoord(1, 0, 0, 1)
		--PlayerFrameTexture:ClearAllPoints()
		--PlayerFrameTexture:SetPoint("CENTER", PlayerFrame, "CENTER", 49, -22)

		PlayerFrameBackground:SetPoint("TOPLEFT",106,-24);
		PlayerFrameBackground:SetHeight(30);

		PlayerFrameHealthBar:SetHeight(20);
		PlayerFrameHealthBar:SetPoint("TOPLEFT",106,-22);
		PlayerFrameHealthBarText:SetPoint("CENTER",50,16);

		PlayerFrameManaBar:SetPoint("TOPLEFT",106,-42);
		PlayerFrameManaBarText:SetPoint("CENTER",50,3);

		--[[
		if (GetCVar("ufiDarkMode") == "1") then
			PlayerFrameTexture:SetVertexColor(.3,.3,.3)
			TargetofTargetTexture:SetVertexColor(.3,.3,.3)
			PetFrameTexture:SetVertexColor(.3,.3,.3)
		end --]]

	end

	--if UnitFramesImprovedConfig.StatusGlow == 1 then
	if (GetCVar("ufiStatusGlow") == "1") then
		PlayerStatusTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-Player-Status");	
	else
		PlayerStatusTexture:SetTexture(nil);
	end	
end

function UnitFramesImproved_ColorUpdate(value, smooth) --> HealthBar_OnValueChanged
	if this == PlayerFrameHealthBar then
		--if UnitFramesImprovedConfig.PlayerClassColor == 1 then
		--cv = tonumber(GetCVar'ufiPlayerClassColor')
		--if cv == 1 then
		if GetCVar'ufiPlayerClassColor' == '1' then
			PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
		else
			PlayerFrameHealthBar:SetStatusBarColor(0,1,0);
		end
	else
		if ( not value ) then
			return;
		end
		local r, g, b;
		local min, max = this:GetMinMaxValues();
		if ( (value < min) or (value > max) ) then
			return;
		end
		if ( (max - min) > 0 ) then
			value = (value - min) / (max - min);
		else
			value = 0;
		end
		if(smooth) then
			if(value > 0.5) then
				r = (1.0 - value) * 2;
				g = 1.0;
			else
				r = 1.0;
				g = value * 2;
			end
		else
			r = 0.0;
			g = 1.0;
		end
		b = 0.0;
		this:SetStatusBarColor(r, g, b);
	end
end

function UnitFramesImproved_Style_TargetFrame(unit)
		local classification = UnitClassification("target");
		if (GetCVar("ufiCompactMode") == "1") then
			TargetFrameBackground:SetHeight(30);
			TargetFrameHealthBar:SetHeight(20);
			TargetFrameHealthBar:SetPoint("TOPLEFT",6,-22);
			TargetFrameManaBar:ClearAllPoints()
			TargetFrameManaBar:SetPoint("TOPRIGHT",-106,-42);
			TargetFrameNameBackground:Hide();
		else
			if (classification == "minus") then
				TargetFrameHealthBar:SetHeight(12);
				TargetFrameHealthBar:SetPoint("TOPLEFT",6,-41);
				TargetFrameManaBar:SetPoint("TOPLEFT",6,-51);
				TargetDeadText:SetPoint("CENTER",-50,4);
				TargetFrameNameBackground:Hide()
			else
				TargetFrameHealthBar:SetHeight(29);
				TargetFrameHealthBar:SetPoint("TOPLEFT",6,-22);
				TargetFrameManaBar:SetPoint("TOPLEFT",6,-51);
				TargetDeadText:SetPoint("CENTER",-50,6);
				TargetFrameNameBackground:Hide();
			end
			TargetFrameHealthBar:SetWidth(119);
			TargetFrameHealthBar.lockColor = true;
		end
end

function true_format(v)            -- STATUS TEXT FORMATTING ie 1.5k, 2.3m
         if v > 1E7 then return (math.floor(v/1E6))..'m'
         elseif v > 1E6 then return (math.floor((v/1E6)*10)/10)..'m'
         elseif v > 1E4 then return (math.floor(v/1E3))..'k'
         --elseif v > 1E3 and UnitFramesImprovedConfig.TrueFormat == 1 then return (math.floor((v/1E3)*10)/10)..'k'
		 elseif ( v > 1E3 and GetCVar("ufiTrueFormat") == "1" ) then return (math.floor((v/1E3)*10)/10)..'k'
         else return v 
	end
end

function UnitFramesImproved_TextStatusBar_UpdateTextString(textStatusBar)	
	if ( not textStatusBar ) then
		textStatusBar = this;
	end
	local string = textStatusBar.TextString;

	if(string) then
		local value = textStatusBar:GetValue();
		local valueMin, valueMax = textStatusBar:GetMinMaxValues();
		local pp = UnitPowerType'player'
    	local v  = math.floor(textStatusBar:GetValue())
    	local min, max = textStatusBar:GetMinMaxValues()
        local percent = math.floor(v/max*100)
		local _, class = UnitClass("player")
		if (GetCVar("ufiColoredSbText") == "1") then
			if  textStatusBar:GetName() == 'PlayerFrameManaBar' or textStatusBar:GetName() == 'TargetFrameManaBar' then
				if class == 'ROGUE' or (class == 'DRUID' and pp == 3) then
					string:SetTextColor(250/255, 240/255, 200/255)
				elseif class == 'WARRIOR' or (class == 'DRUID' and pp == 1) then
					string:SetTextColor(250/255, 108/255, 108/255)
				else
					string:SetTextColor(.6, .65, 1)
				end
			elseif textStatusBar:GetName() == 'PlayerFrameHealthBar' then
				gradient(v, string, min, max)
			end
		end
			
		if ( valueMax > 0 ) then
			textStatusBar:Show();

			if ( value == 0 and textStatusBar.zeroText ) then
				string:SetText(textStatusBar.zeroText);
				textStatusBar.isZero = 1;
				string:Show();
			else
				textStatusBar.isZero = nil;
					if GetCVar'ufiPercentage' == '1' then
						string:SetText(true_format(v)..'/'..true_format(max).. ' \226\128\148 ' ..percent..'%')
					else
						string:SetText(true_format(v)..'/'..true_format(max))
					end
				if ( GetCVar("statusBarText") == "1" and textStatusBar.textLockable ) then
					string:Show();
				elseif ( textStatusBar.lockShow > 0 ) then
					string:Show();
				else
					string:Hide();
				end
			end
		else
			textStatusBar:Hide();
		end
	end
end

function UnitFramesImproved_TargetFrame_Update()

	for i = 1, 5 do
        local bu = _G['TargetFrameBuff'..i]
        modSkin(bu, 1)
        modSkinColor(bu, .3, .3, .3)
		--bu:Show()
    end

    for i = 1, 16 do
        local bu = _G['TargetFrameDebuff'..i]
        --modSkin(bu, 1)
        --modSkinColor(bu, 1, 0, 0)
		--bu:Show()
    end

    for i = 1, 4 do
        local bu = _G['TargetofTargetFrameDebuff'..i]
        modSkin(bu, -1)
        modSkinColor(bu, 1, 0, 0)
		--bu:Show()
    end

	--ShowBonusActionBar();
	--BONUSACTIONBAR_XPOS = 512


	MH3Blizz:PowerUpdate();
	-- Set back color of health bar
	TargetofTarget_Update();
	if ( UnitIsTapped("target") and not UnitIsTappedByPlayer("target") ) then
		-- Gray if npc is tapped by other player
		this.healthbar:SetStatusBarColor(0.5, 0.5, 0.5);
	else
		-- Standard by class etc if not
		this.healthbar:SetStatusBarColor(UnitColor(this.healthbar.unit));	
	end
end

function UnitFramesImproved_PetFrame_OnUpdate(elapsed)
	if ( PetAttackModeTexture:IsVisible() ) then
		local alpha = 255;
		local counter = this.attackModeCounter + elapsed;
		local sign    = this.attackModeSign;
		

		if ( counter > 0.5 ) then
			sign = -sign;
			this.attackModeSign = sign;
		end
		counter = mod(counter, 0.5);
		this.attackModeCounter = counter;

		if ( sign == 1 ) then
			alpha = (55  + (counter * 400)) / 255;
		else
			alpha = (255 - (counter * 400)) / 255;
		end
		PetAttackModeTexture:SetVertexColor(1.0, 1.0, 1.0, alpha);
	end

	if (GetCVar("ufiImprovedPet") == "1") then
		PetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetofTargetFrame");
		PetFrameHappiness:Hide()

		local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
		local pp = UnitPowerType'pet'
		local _, class = UnitClass("player")

		if(pp == 2) then
			-- Better color for pet energy bar
			this.manabar:SetStatusBarColor(1,102/255,0)
		else
			this.manabar:SetStatusBarColor(0,0,1)
		end
		if class == 'HUNTER' then
			if (happiness == 3) then
				this.healthbar:SetStatusBarColor(0,1,0)
			elseif (happiness == 2) then
				this.healthbar:SetStatusBarColor(1,1,0)
			else 
				this.healthbar:SetStatusBarColor(1,0,0)
			end
		end
	end
	CombatFeedback_OnUpdate(elapsed);

	if (GetCVar("ufiHidePetText") == "1") then
		PetFrame.healthbar.TextString:Hide();
		PetFrame.manabar.TextString:Hide();
	end
end

function UnitFramesImproved_TargetFrame_CheckClassification()
	local classification = UnitClassification("target");

	if (GetCVar("ufiDarkMode") == "1") then

		if (GetCVar("ufiCompactMode") == "1") then
			-- DARK COMPACT FRAMES
			UnitFramesImproved_SetTexture(TargetFrameTexture, "DarkCompactUI");

		else
			-- DARK EXTENDED FRAMES
			UnitFramesImproved_SetTexture(TargetFrameTexture, "darkUI");
		end
	else
		if (GetCVar("ufiCompactMode") == "1") then
			-- LIGHT COMPACT FRAMES
			UnitFramesImproved_SetTexture(TargetFrameTexture, "compactUI");
		else
			-- LIGHT EXTENDED FRAMES
			UnitFramesImproved_SetTexture(TargetFrameTexture, "UI");
		end
	end
end

function UnitFramesImproved_SetTexture(frame, type)
	local classification = UnitClassification("target");

	if ( classification == "worldboss" ) then
		frame:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\" .. type .. "-TargetingFrame-Elite");
	elseif ( classification == "rareelite"  ) then
		frame:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\" .. type .. "-TargetingFrame-Rare-Elite");
	elseif ( classification == "elite"  ) then
		frame:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\" .. type .. "-TargetingFrame-Elite");
	elseif ( classification == "rare"  ) then
		frame:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\" .. type .. "-TargetingFrame-Rare");
	else
		frame:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\" .. type .. "-TargetingFrame");
	end
end

function UnitFramesImproved_Settings_Compact()
	--TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame-NoMana");
	
	TargetFrameBackground:SetHeight(30);
	TargetFrameHealthBar:SetHeight(20);
	TargetFrameManaBar:ClearAllPoints()
	TargetFrameManaBar:SetPoint("TOPRIGHT",-106,-42);

end

function UnitFramesImproved_TargetFrame_CheckFaction()
	local factionGroup = UnitFactionGroup("target");
	if ( UnitIsPVPFreeForAll("target") ) then
		TargetPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		TargetPVPIcon:Show();
	elseif ( factionGroup and UnitIsPVP("target") ) then
		TargetPVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup);
		TargetPVPIcon:Show();
	else
		TargetPVPIcon:Hide();
	end
	UnitFramesImproved_Style_TargetFrame(this.unit);
end

-- Utility functions
function UnitColor(unit)
	local r, g, b;
	local sr, sg, sb = TargetFrameNameBackground:GetVertexColor();
	local localizedClass, englishClass = UnitClass(unit);
	local classColor = RAID_CLASS_COLORS[englishClass];
	--local cv;

	if ( ( not UnitIsPlayer(unit) ) and ( ( not UnitIsConnected(unit) ) or ( UnitIsDeadOrGhost(unit) ) ) ) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
	elseif ( UnitIsPlayer(unit) ) then
		--Try to color it by class.
		--if UnitFramesImprovedConfig.PlayerClassColor == 1 then
		--cv = tonumber(GetCVar'ufiPlayerClassColor')
		--if cv == 1 then
		if GetCVar'ufiPlayerClassColor' == '1' then
			if ( classColor ) then
				if ( UnitClass(unit) == "Shaman" ) then
					r, g, b = 0, 0.44, 0.87;
				else
				r, g, b = classColor.r, classColor.g, classColor.b;
				end
			else
				if ( UnitIsFriend("player", unit) ) then
					r, g, b = 0.0, 1.0, 0.0;
				else
					r, g, b = 1.0, 0.0, 0.0;
				end
			end
		else
			r, g, b = sr, sg, sb;
		end

	else
		--cv = tonumber(GetCVar'ufiNPCClassColor')
		--if UnitFramesImprovedConfig.NPCClassColor == 1 and classColor then
		--if cv == 1 and classColor then
		if (GetCVar'ufiNPCClassColor' == '1' and classColor) then
			r, g, b = classColor.r, classColor.g, classColor.b;
		else
			r, g, b = sr, sg, sb;
		end
	end
	
	return r, g, b;
end


function UnitFramesImproved_ClassPortraits ()
	
	if GetCVar'ufiClassPortrait' == '0' then
		return;
	
	else 
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
	end
end

function UnitFramesImproved_DarkMode()
	-- Dark borders UI, code from modUI
	for _, v in pairs({
			-- MINIMAP CLUSTER
		MinimapBorder,
		MiniMapMailBorder,
		MiniMapTrackingBorder,
		MiniMapMeetingStoneBorder,
		MiniMapMailBorder,
		MiniMapBattlefieldBorder,
			-- UNIT & CASTBAR
		--PlayerFrameTexture,
		--TargetFrameTexture,
		PetFrameTexture,
		PartyMemberFrame1Texture,
		PartyMemberFrame2Texture,
		PartyMemberFrame3Texture,
		PartyMemberFrame4Texture,
		PartyMemberFrame1PetFrameTexture,
		PartyMemberFrame2PetFrameTexture,
		PartyMemberFrame3PetFrameTexture,
		PartyMemberFrame4PetFrameTexture,
		TargetofTargetTexture,
		CastingBarBorder,
			-- MAIN MENU BAR
		MainMenuBarTexture0,
		MainMenuBarTexture1,
		MainMenuBarTexture2,
		MainMenuBarTexture3,
		MainMenuMaxLevelBar0,
		MainMenuMaxLevelBar1,
		MainMenuMaxLevelBar2,
		MainMenuMaxLevelBar3,
		MainMenuXPBarTextureLeftCap,
		MainMenuXPBarTextureRightCap,
		MainMenuXPBarTextureMid,
		BonusActionBarTexture0,
		BonusActionBarTexture1,
		ReputationWatchBarTexture0,
		ReputationWatchBarTexture1,
		ReputationWatchBarTexture2,
		ReputationWatchBarTexture3,
		ReputationXPBarTexture0,
		ReputationXPBarTexture1,
		ReputationXPBarTexture2,
		ReputationXPBarTexture3,
		SlidingActionBarTexture0,
		SlidingActionBarTexture1,
		MainMenuBarLeftEndCap,
		MainMenuBarRightEndCap,
		ExhaustionTick:GetNormalTexture(),
	})	do 
		v:SetVertexColor(UNITFRAMESIMPROVED_UI_COLOR.r, UNITFRAMESIMPROVED_UI_COLOR.g, UNITFRAMESIMPROVED_UI_COLOR.b)
	end
end

gradient = function(v, f, min, max)
        
    if v < min or v > max then return end
    if (max - min) > 0 then
        v = (v - min)/(max - min)
    else
        v = 0
    end
    if v > .5 then
        r = (1 - v)*2
        g = 1
    else
        r = 1
        g = v*2
    end
    b = 0
    f:SetTextColor(r*1.5, g*1.5, b*1.5)
end

function ufi_chattext(txt)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( fontLightBlue.."<UFI> "..txt)
	end
end 

function UnitFramesImproved_OnLoad() 
	UnitFramesImproved:SetScript("OnEvent", UnitFramesImproved_OnEvent)
	UnitFramesImproved:RegisterEvent('ADDON_LOADED');
	UnitFramesImproved:RegisterEvent('PLAYER_ENTERING_WORLD');
	--UnitFramesImproved:RegisterEvent('VARIABLES_LOADED');
end

function UnitFramesImproved_OnEvent() 	
	if IsAddOnLoaded'modui' then                   -- modUI
    	ufi_modui = true;
    end

	if IsAddOnLoaded'KLHThreatMeter' then                   -- modUI
    	ufi_KTM = true;
    end

	if (event == "ADDON_LOADED") then	--makes sure it doesnt fire more than once.
		if (arg1 == ADDON_NAME) then 
			--if (event == "PLAYER_ENTERING_WORLD") then
				UnitFramesImproved_Vanilla_OnLoad(); 
			--end
		end
    end 
end

UnitFramesImproved_OnLoad();
