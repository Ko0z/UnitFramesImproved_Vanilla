_G = getfenv(0)

UNITFRAMESIMPROVED_UI_COLOR = {r = .4, g = .4, b = .4}


function UnitFramesImproved_Default_Options()
	if not UnitFramesImprovedConfig then
		UnitFramesImprovedConfig = { }
	end

	if not UnitFramesImprovedConfig.StatusBarText		then	UnitFramesImprovedConfig.StatusBarText = false end
	if not UnitFramesImprovedConfig.ClassPortrait		then	UnitFramesImprovedConfig.ClassPortrait = false end
	if not UnitFramesImprovedConfig.DarkMode			then	UnitFramesImprovedConfig.DarkMode = false end
end


function UnitFramesImproved_Vanilla_OnLoad()
	-- Generic status text hook
	HealthBar_OnValueChanged = UnitFramesImproved_ColorUpdate;

	TextStatusBar_UpdateTextString = UnitFramesImproved_TextStatusBar_UpdateTextString;

	TargetFrame_OnUpdate = UnitFramesImproved_TargetFrame_Update;
	TargetFrame_CheckFaction = UnitFramesImproved_TargetFrame_CheckFaction;
	TargetFrame_CheckClassification = UnitFramesImproved_TargetFrame_CheckClassification;

	ufi_chattext( fontLightGreen..'UnitFramesImproved_Vanilla Loaded.' .. fontLightRed .. 'Type ' ..fontLightGreen.. '/ufi ' ..fontLightRed.. 'for commands' );
	
	class_active = false;
	dark_active = false;
	-------------------------------------------------------------------------------------
	
	UnitFramesImproved_Default_Options();

			-- Set up some stylings
	UnitFramesImproved_Style_PlayerFrame();
	UnitFramesImproved_TargetFrame_CheckClassification();
	UnitFramesImproved_Style_TargetFrame(TargetFrame);
	UnitFramesImproved_Style_TargetFrame(FocusFrame);

	-- Update some values
	TextStatusBar_UpdateTextString(PlayerFrame.healthbar);
	TextStatusBar_UpdateTextString(PlayerFrame.manabar);
end

function UnitFramesImproved_Style_TargetOfTargetFrame()
	-- May use this at some point
end

function UnitFramesImproved_Style_PlayerFrame()
	PlayerFrameHealthBar.lockColor = true;
	PlayerFrameHealthBar.capNumericDisplay = true;
	PlayerFrameHealthBar:SetWidth(119);
	PlayerFrameHealthBar:SetHeight(29);
	PlayerFrameHealthBar:SetPoint("TOPLEFT",106,-22);
	PlayerFrameHealthBarText:SetPoint("CENTER",50,6);
	
	PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame");
	PlayerStatusTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-Player-Status");
	
	PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
	
	PlayerFrame:SetScale(1.0);
	TargetFrame:SetScale(1.0);

end

function UnitFramesImproved_ColorUpdate()
	PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
end

function UnitFramesImproved_Style_TargetFrame(unit)
		local classification = UnitClassification("target");
		if (classification == "minus") then
			TargetFrameHealthBar:SetHeight(12);
			TargetFrameHealthBar:SetPoint("TOPLEFT",7,-41);
			--textStatusBar.TextString:SetPoint("CENTER",-50,4);
			TargetDeadText:SetPoint("CENTER",-50,4);
			TargetFrameNameBackground:SetPoint("TOPLEFT",7,-41);
		else
			TargetFrameHealthBar:SetHeight(29);
			TargetFrameHealthBar:SetPoint("TOPLEFT",7,-22);
			--textStatusBar.TextString:SetPoint("CENTER",-50,6);
			TargetDeadText:SetPoint("CENTER",-50,6);
			TargetFrameNameBackground:Hide();
			TargetFrameNameBackground:SetPoint("TOPLEFT",7,-22);
		end
		TargetFrameHealthBar:SetWidth(119);
		TargetFrameHealthBar.lockColor = true;
end


function UnitFramesImproved_TextStatusBar_UpdateTextString(textStatusBar)
	if class_active == false then			--just to make sure it doesnt load it more than once
		UnitFramesImproved_ClassPortraits();
	end

	if dark_active == false then			--just to make sure it doesnt load it more than once
		UnitFramesImproved_DarkMode();
	end

	if ( not textStatusBar ) then
		textStatusBar = this;
	end
	local string = textStatusBar.TextString;
	if(string) then
		local value = textStatusBar:GetValue();
		local valueMin, valueMax = textStatusBar:GetMinMaxValues();
		if ( valueMax > 0 ) then
			textStatusBar:Show();
			if ( value == 0 and textStatusBar.zeroText ) then
				string:SetText(textStatusBar.zeroText);
				textStatusBar.isZero = 1;
				string:Show();
			else
				textStatusBar.isZero = nil;
				if ( textStatusBar.prefix ) then
					if UnitFramesImprovedConfig.StatusBarText then
						string:SetText(textStatusBar.prefix.." "..value.." / "..valueMax);
					else
						string:SetText(value.." / "..valueMax);
					end
				else
					string:SetText(value.." / "..valueMax);
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
	-- Set back color of health bar
	TargetofTarget_Update();
	
	if ( UnitIsTapped("target") and not UnitIsTappedByPlayer("target") ) then
		-- Gray if npc is tapped by other player
		this.healthbar:SetStatusBarColor(0.5, 0.5, 0.5);
		--TargetFrameNameBackground:SetVertexColor(0.5, 0.5, 0.5);
		--TargetPortrait:SetVertexColor(0.5, 0.5, 0.5);
	else
		-- Standard by class etc if not
		this.healthbar:SetStatusBarColor(UnitColor(this.healthbar.unit));	
	end
end

function UnitFramesImproved_TargetFrame_CheckClassification()

	local classification = UnitClassification("target");
	
	if ( classification == "worldboss" ) then
		TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame-Elite");
	elseif ( classification == "rareelite"  ) then
		TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame-Rare-Elite");
	elseif ( classification == "elite"  ) then
		TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame-Elite");
	elseif ( classification == "rare"  ) then
		TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame-Rare");
	else
		TargetFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame");
	end
	
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
	local localizedClass, englishClass = UnitClass(unit);
	local classColor = RAID_CLASS_COLORS[englishClass];
	if ( ( not UnitIsPlayer(unit) ) and ( ( not UnitIsConnected(unit) ) or ( UnitIsDeadOrGhost(unit) ) ) ) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
	elseif ( UnitIsPlayer(unit) ) then
		--Try to color it by class.
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
		r, g, b = classColor.r, classColor.g, classColor.b;
	end
	
	return r, g, b;
end


function UnitFramesImproved_ClassPortraits ()

	if (UnitFramesImprovedConfig.ClassPortrait == false or UnitFramesImprovedConfig.ClassPortrait == nil ) then
		return;
	else 
		class_active = true;
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
	-- Dark borders and UI, code from modUI
	if (UnitFramesImprovedConfig.DarkMode == false or UnitFramesImprovedConfig.DarkMode == nil ) then
		return;
	else 
		for _, v in pairs({
				-- MINIMAP CLUSTER
			MinimapBorder,
			MiniMapMailBorder,
			MiniMapTrackingBorder,
			MiniMapMeetingStoneBorder,
			MiniMapMailBorder,
			MiniMapBattlefieldBorder,
				-- UNIT & CASTBAR
			PlayerFrameTexture,
			TargetFrameTexture,
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
		dark_active = true;
	end
end
-- Add all Slash Commands
-----------------------------------------------------------------------------


SLASH_UNITFRAMESIMPROVED1 = "/ufi";
SLASH_UNITFRAMESIMPROVED2 = "/unitframesimproved"
  
local function UFI_Slash(msg, editbox)
	-- extract option name and option argument from message string
	-- handle show/hide of options dialog first of all
	-- handle all simple commands that dont require parsing right here
	if  msg == 'text'  then
		if UnitFramesImprovedConfig.StatusBarText == true then
			UnitFramesImprovedConfig.StatusBarText = false;
			TextStatusBar_UpdateTextString(PlayerFrame.healthbar);
			TextStatusBar_UpdateTextString(PlayerFrame.manabar);
			ufi_chattext( ' StatusBarText disabled ' );
		else
			UnitFramesImprovedConfig.StatusBarText = true;
			TextStatusBar_UpdateTextString(PlayerFrame.healthbar);
			TextStatusBar_UpdateTextString(PlayerFrame.manabar);
			ufi_chattext( fontLightGreen..' StatusBarText enabled ' );
		end
		return

	elseif  msg == 'class'  then
		if UnitFramesImprovedConfig.ClassPortrait == true then
			UnitFramesImprovedConfig.ClassPortrait = false;
			class_active = false;
			ufi_chattext( ' ClassPortraits disabled ' );
			ReloadUI();
		else
			UnitFramesImprovedConfig.ClassPortrait = true;
			ufi_chattext( fontLightGreen..' ClassPortraits enabled ' );	
			ReloadUI();		
		end
		return

	elseif ( msg == 'dark' or msg == 'darkmode' ) then
		if UnitFramesImprovedConfig.DarkMode == true then
			UnitFramesImprovedConfig.DarkMode = false;
			dark_active = false;
			ufi_chattext( ' DarkMode OFF ' );
			ReloadUI();
		else
			UnitFramesImprovedConfig.DarkMode = true;
			ufi_chattext( fontLightGreen..' DarkMode ON ' );
			ReloadUI();
		end
		return

	elseif  msg == 'status'  then
		if UnitFramesImprovedConfig.DarkMode == true then
			ufi_chattext( fontLightGreen .. ' DarkMode ON ' );
		else
			ufi_chattext( fontOrange .. ' DarkMode ' .. fontRed ..  'OFF ' );
		end
		if UnitFramesImprovedConfig.ClassPortrait == true then
			ufi_chattext( fontLightGreen .. ' ClassPortrait ON ' );
		else
			ufi_chattext( fontOrange .. ' ClassPortrait ' .. fontRed ..  'OFF ' );
		end
		if UnitFramesImprovedConfig.StatusBarText == true then
			ufi_chattext( fontLightGreen .. ' StatusBarText ON ' );
		else
			ufi_chattext( fontOrange .. ' StatusBarText ' .. fontRed ..  'OFF' );
		end
		return

	elseif  msg == 'help'  then
		ufi_chattext( ' Usage: enter /ufi or /unitframesimproved for commands' );
		ufi_chattext( ' for AddOn help go to '..fontLightGreen..'https://github.com/Ko0z/UnitFramesImproved_Vanilla' );
		return

	else
		ufi_chattext( fontWhite .. ' Usage: ' .. fontOrange .. '/ufi text ' ..fontWhite..  'toggle Player StatusBar text ON/OFF' );
		ufi_chattext( fontWhite .. ' Usage: ' .. fontOrange .. '/ufi class ' ..fontWhite..  'toggle ClassPortraits ON/OFF' );
		ufi_chattext( fontWhite .. ' Usage: ' .. fontOrange .. '/ufi dark ' ..fontWhite..  'toggle DarkMode ON/OFF' );
		ufi_chattext( fontWhite .. ' Usage: ' .. fontLightGreen .. '/ufi status ' ..fontWhite..  ' to see active settings' );
		ufi_chattext( fontWhite .. ' Usage: ' .. fontLightGreen .. '/ufi help ' ..fontWhite..  ' for help' );
	end
end 
SlashCmdList["UNITFRAMESIMPROVED"] = UFI_Slash;

fontLightBlue = "|cff00e0ff"
fontLightGreen = "|cff60ff60"
fontLightRed = "|cffff8080"
fontRed = "|cffff0000"
fontOrange = "|cffff7000"
fontWhite = "|cffffffff"

function ufi_chattext(txt)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( fontLightBlue.."<UFI> "..txt)
	end
end -- ufi_chattext()

UnitFramesImproved_Vanilla_OnLoad();