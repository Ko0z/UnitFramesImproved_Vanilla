--Cred to the dev of ModUI, darkmode in this addon is heavily inspired from his/hers addon.

_G = getfenv(0)

UNITFRAMESIMPROVED_UI_COLOR = {r = .4, g = .4, b = .4}

local UnitFramesImproved = CreateFrame('Button', 'UnitFramesImproved');
local ADDON_NAME = "UnitFramesImproved_Vanilla";
local ufi_modui = false;

function UnitFramesImproved_Default_Options()
	if not UnitFramesImprovedConfig then
		UnitFramesImprovedConfig = { }
	end
	
	if not UnitFramesImprovedConfig.StatusBarText		then	UnitFramesImprovedConfig.StatusBarText = false end
	if not UnitFramesImprovedConfig.ClassPortrait		then	UnitFramesImprovedConfig.ClassPortrait = false end
	if not UnitFramesImprovedConfig.DarkMode			then	UnitFramesImprovedConfig.DarkMode = false end
	--if not ufi_modui				then	ufi_modui = false end
end


function UnitFramesImproved_Vanilla_OnLoad()
	UnitFramesImproved_Default_Options();
	-- Generic status text hook
	HealthBar_OnValueChanged = UnitFramesImproved_ColorUpdate;
	------------------------
	TargetFrame_OnUpdate = UnitFramesImproved_TargetFrame_Update;
	TargetFrame_CheckFaction = UnitFramesImproved_TargetFrame_CheckFaction;
	TargetFrame_CheckClassification = UnitFramesImproved_TargetFrame_CheckClassification;

	ufi_chattext( fontLightGreen..'UnitFramesImproved_Vanilla Loaded. ' .. fontLightRed .. 'Type ' ..fontOrange.. '/ufi ' ..fontLightRed.. 'for options' );
	-------------------------------------------------------------------------------------
	-- Check Saved Configs and apply
	if UnitFramesImprovedConfig.ClassPortrait == true then
		UnitFramesImproved_ClassPortraits();
	end

	if UnitFramesImprovedConfig.DarkMode == true then
		UnitFramesImproved_DarkMode();
	end
	-----------------------
	-- FOR MODUI COMPATIBILITY
	if (ufi_modui == false or ufi_modui == nil) then
		TextStatusBar_UpdateTextString = UnitFramesImproved_TextStatusBar_UpdateTextString;

		PlayerFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 10);
		PlayerFrameHealthBarText:SetShadowColor(0, 0, 0, 1)
		PlayerFrameHealthBarText:SetShadowOffset(1, -1)

		PlayerFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 10);
		PlayerFrameManaBarText:SetShadowColor(0, 0, 0, 1)
		PlayerFrameManaBarText:SetShadowOffset(1, -1)
		--ufi_chattext( fontOrange.. 'modUI ' ..fontLightRed.. 'not detected.' );
		-- Update some values
		TextStatusBar_UpdateTextString(PlayerFrame.healthbar);
		TextStatusBar_UpdateTextString(PlayerFrame.manabar);
	else
		ufi_chattext( fontOrange.. 'modUI ' ..fontLightGreen.. 'detected.' );
		PlayerFrameBackground.bg:Hide();
		UnitFramesImprovedConfig.DarkMode = false;
		
		local NAME_TEXTURE   = [[Interface\AddOns\modui\statusbar\texture\name.tga]]
		PlayerFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)
		TargetFrameHealthBar:SetStatusBarTexture(NAME_TEXTURE)

	end
			-- Set up some stylings
	UnitFramesImproved_Style_PlayerFrame();
	UnitFramesImproved_TargetFrame_CheckClassification();
	UnitFramesImproved_Style_TargetFrame(TargetFrame);
	UnitFramesImproved_Style_TargetFrame(FocusFrame);
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
	
	--PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
	
	--PlayerFrame:SetScale(1.0);
	--TargetFrame:SetScale(1.0);
	----------------------------------------------------------
	--TEST
	--PlayerFrame:SetClampedToScreen(true)
	--TargetFrame:SetClampedToScreen(true)	
end

function UnitFramesImproved_ColorUpdate()
	PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
end

function UnitFramesImproved_Style_TargetFrame(unit)
		
		local classification = UnitClassification("target");
		if (classification == "minus") then
			TargetFrameHealthBar:SetHeight(12);
			TargetFrameHealthBar:SetPoint("TOPLEFT",7,-41);
			TargetDeadText:SetPoint("CENTER",-50,4);
			TargetFrameNameBackground:Hide()
			TargetFrameNameBackground:SetPoint("TOPLEFT",7,-41);
		else
			TargetFrameHealthBar:SetHeight(29);
			TargetFrameHealthBar:SetPoint("TOPLEFT",7,-22);
			TargetDeadText:SetPoint("CENTER",-50,6);
			TargetFrameNameBackground:Hide();
			TargetFrameNameBackground:SetPoint("TOPLEFT",7,-22);
		end
		TargetFrameHealthBar:SetWidth(119);
		TargetFrameHealthBar.lockColor = true;
end



function UnitFramesImproved_TextStatusBar_UpdateTextString(textStatusBar)
	
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
						string:SetText(textStatusBar.prefix.." "..value.."/"..valueMax);
					else
						string:SetText(value.."/"..valueMax);
					end
				else
					string:SetText(value.."/"..valueMax);
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
		if ( classColor ) then
			r, g, b = classColor.r, classColor.g, classColor.b;
		else 
			r, g, b = 0, 1, 0;
		end
	end
	
	return r, g, b;
end


function UnitFramesImproved_ClassPortraits ()

	if (UnitFramesImprovedConfig.ClassPortrait == false or UnitFramesImprovedConfig.ClassPortrait == nil ) then
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
	end
end
-----------------------------------------------------------------------
--Popup Dialogs 

StaticPopupDialogs["CLASS_RELOAD"] = {
	text = "A reload is required to toggle this setting.",
	button1 = "Reload",
	button2 = "Ignore",
	OnAccept = function()
		if	UnitFramesImprovedConfig.ClassPortrait == true then
			UnitFramesImprovedConfig.ClassPortrait = false;
			ReloadUI();
		else
			UnitFramesImprovedConfig.ClassPortrait = true;
			ReloadUI();
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}

StaticPopupDialogs["DARK_RELOAD"] = {
	text = "A reload is required to toggle this setting.",
	button1 = "Reload",
	button2 = "Ignore",
	OnAccept = function()
		if	UnitFramesImprovedConfig.DarkMode == true then
			UnitFramesImprovedConfig.DarkMode = false;
			ReloadUI();
		else
			UnitFramesImprovedConfig.DarkMode = true;
			ReloadUI();
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}

--[[
--ModUI Compatible with slash command
StaticPopupDialogs["MODUI_RELOAD"] = {
	text = "Reload UI to toggle ModUI Compatibility",
	button1 = "Reload",
	button2 = "Ignore",
	OnAccept = function()
		if	ufi_modui == false then
			ufi_modui = true;
			UnitFramesImprovedConfig.DarkMode = false;
			UnitFramesImprovedConfig.ClassPortrait = false;
			ReloadUI();
		else
			ufi_modui = false;
			ReloadUI();
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}
--]]
-----------------------------------------------------------------------------
-- Add all Slash Commands

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

	elseif  msg == 'unlock'  then
		local function PlayerDragStart()
			PlayerFrame:StartMoving();
		end
		local function PlayerDragStop()
			PlayerFrame:StopMovingOrSizing();
		end
		local function TargetDragStart()
			TargetFrame:StartMoving();
		end
		local function TargetDragStop()
			TargetFrame:StopMovingOrSizing();
		end
		PlayerFrame:SetClampedToScreen(true);
	    TargetFrame:SetClampedToScreen(true);
		PlayerFrame:SetMovable(true);
		PlayerFrame:EnableMouse(true);
		PlayerFrame:RegisterForDrag("LeftButton");
		PlayerFrame:SetScript("OnDragStart", PlayerDragStart);
		PlayerFrame:SetScript("OnDragStop", PlayerDragStop);
		ufi_chattext( fontRed.. ' PlayerFrame Unlocked' );
		TargetFrame:SetMovable(true);
		TargetFrame:EnableMouse(true);
		TargetFrame:RegisterForDrag("LeftButton");
		TargetFrame:SetScript("OnDragStart", TargetDragStart);
		TargetFrame:SetScript("OnDragStop", TargetDragStop);
		ufi_chattext( fontRed.. ' TargetFrame Unlocked' );
		PlayerFrameTexture:SetVertexColor(0, 1, 0);
		TargetFrameTexture:SetVertexColor(0, 1, 0);
		return
		
	elseif  msg == 'lock'  then
		PlayerFrame:SetClampedToScreen(false);
	    TargetFrame:SetClampedToScreen(false);
		if UnitFramesImprovedConfig.DarkMode == true then
			PlayerFrameTexture:SetVertexColor(UNITFRAMESIMPROVED_UI_COLOR.r, UNITFRAMESIMPROVED_UI_COLOR.g, UNITFRAMESIMPROVED_UI_COLOR.b)
			TargetFrameTexture:SetVertexColor(UNITFRAMESIMPROVED_UI_COLOR.r, UNITFRAMESIMPROVED_UI_COLOR.g, UNITFRAMESIMPROVED_UI_COLOR.b)
		else
			PlayerFrameTexture:SetVertexColor(1, 1, 1);
			TargetFrameTexture:SetVertexColor(1, 1, 1);
		end
		PlayerFrame:StopMovingOrSizing();
		TargetFrame:StopMovingOrSizing();
		PlayerFrame:SetScript("OnDragStart", nil);
		PlayerFrame:SetScript("OnDragStop", nil);
		TargetFrame:SetScript("OnDragStart", nil);
		TargetFrame:SetScript("OnDragStop", nil);
		PlayerFrame:IsUserPlaced(true);
		TargetFrame:IsUserPlaced(true);
		ufi_chattext( fontLightGreen.. ' PlayerFrame Locked' )
		ufi_chattext( fontLightGreen.. ' TargetFrame Locked' )
		return

	elseif  msg == 'class'  then
			StaticPopup_Show("CLASS_RELOAD");
		return

	elseif ( msg == 'dark' or msg == 'darkmode' ) then
			StaticPopup_Show("DARK_RELOAD");
		return

	elseif  msg == 'status'  then
		if UnitFramesImprovedConfig.DarkMode == true then
			ufi_chattext( fontOrange .. ' DarkMode ' .. fontLightGreen ..  'ON' );
		else
			ufi_chattext( fontOrange .. ' DarkMode ' .. fontRed ..  'OFF ' );
		end
		if UnitFramesImprovedConfig.ClassPortrait == true then
			ufi_chattext( fontOrange .. ' ClassPortrait ' .. fontLightGreen ..  'ON' );
		else
			ufi_chattext( fontOrange .. ' ClassPortrait ' .. fontRed ..  'OFF ' );
		end
		if UnitFramesImprovedConfig.StatusBarText == true then
			ufi_chattext( fontOrange .. ' StatusBarText ' .. fontLightGreen ..  'ON' );
		else
			ufi_chattext( fontOrange .. ' StatusBarText ' .. fontRed ..  'OFF' );
		end
		if ufi_modui == true then
			ufi_chattext( fontOrange .. ' ModUI ' .. fontLightGreen ..  'ON' );
		end
		return

	elseif  msg == 'help'  then
		ufi_chattext( ' Usage: enter /ufi or /unitframesimproved for options' );
		ufi_chattext( ' for AddOn help go to '..fontLightGreen..'https://github.com/Ko0z/UnitFramesImproved_Vanilla' );
		return

	elseif  msg == 'rl'  then
		ReloadUI();
		return

	else
		ufi_chattext( fontOrange .. '/ufi text ' ..fontWhite..  '-- ' .. fontLightGreen .. '(toggle) ' ..fontWhite.. 'Player StatusBar Text' );
		ufi_chattext( fontOrange .. '/ufi class ' ..fontWhite..  '-- ' .. fontLightGreen .. '(toggle) ' ..fontWhite.. 'ClassPortraits' );
		ufi_chattext( fontOrange .. '/ufi dark ' ..fontWhite..  '-- ' .. fontLightGreen .. '(toggle) ' ..fontWhite.. 'DarkMode' );
		ufi_chattext( fontOrange .. '/ufi unlock ' ..fontWhite..  '-- Move frames' );
		ufi_chattext( fontOrange .. '/ufi lock ' ..fontWhite..  '-- Lock frames' );
		ufi_chattext( fontOrange .. '/ufi status ' ..fontWhite..  '-- to see active settings' );
		ufi_chattext( fontOrange .. '/ufi help ' ..fontWhite..  '-- for help' );
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
end 

function UnitFramesImproved_OnLoad() 
	UnitFramesImproved:SetScript("OnEvent", UnitFramesImproved_OnEvent)
	UnitFramesImproved:RegisterEvent('ADDON_LOADED');
end

function UnitFramesImproved_OnEvent() 	
	if IsAddOnLoaded'modui' then                   -- modUI
    	ufi_modui = true;
    end

	if (event == "ADDON_LOADED") then	--makes sure it doesnt fire more than once.
		if (arg1 == ADDON_NAME) then 
			UnitFramesImproved_Vanilla_OnLoad(); 
		end
    end 
end

UnitFramesImproved_OnLoad();
