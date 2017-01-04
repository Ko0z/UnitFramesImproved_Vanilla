--Cred to the dev of ModUI, darkmode in this addon is heavily inspired from his/hers addon.

_G = getfenv(0)

UNITFRAMESIMPROVED_UI_COLOR = {r = .3, g = .3, b = .3}
local UnitFramesImproved = CreateFrame('Button', 'UnitFramesImproved');
local ADDON_NAME = "UnitFramesImproved_Vanilla";
ufi_modui = false;

function UnitFramesImproved_Default_Options()
	if not UnitFramesImprovedConfig then
		UnitFramesImprovedConfig = { }
	end

	if not UnitFramesImprovedConfig.ClassPortrait		then	UnitFramesImprovedConfig.ClassPortrait		= false end
	if not UnitFramesImprovedConfig.DarkMode			then	UnitFramesImprovedConfig.DarkMode			= false end
	if not UnitFramesImprovedConfig.NameTextX			then	UnitFramesImprovedConfig.NameTextX			= 0		end
	if not UnitFramesImprovedConfig.NameTextY			then	UnitFramesImprovedConfig.NameTextY			= 0		end
	if not UnitFramesImprovedConfig.NameTextFontSize	then	UnitFramesImprovedConfig.NameTextFontSize	= 11	end
	if not UnitFramesImprovedConfig.NameOutline			then	UnitFramesImprovedConfig.NameOutline		= 1		end
	if not UnitFramesImprovedConfig.NPCClassColor		then	UnitFramesImprovedConfig.NPCClassColor		= 0		end
	if not UnitFramesImprovedConfig.PlayerClassColor	then	UnitFramesImprovedConfig.PlayerClassColor	= 1		end
	if not UnitFramesImprovedConfig.Percentage			then	UnitFramesImprovedConfig.Percentage			= 1		end
	if not UnitFramesImprovedConfig.TrueFormat			then	UnitFramesImprovedConfig.TrueFormat			= 1		end
	if not UnitFramesImprovedConfig.HidePetText			then	UnitFramesImprovedConfig.HidePetText		= 0		end
end


function UnitFramesImproved_Vanilla_OnLoad()
	UnitFramesImproved_Default_Options();
	-- Generic status text hook

	HealthBar_OnValueChanged = UnitFramesImproved_ColorUpdate;
	TargetFrame_OnUpdate = UnitFramesImproved_TargetFrame_Update;
	TargetFrame_CheckClassification = UnitFramesImproved_TargetFrame_CheckClassification;

	ufi_chattext( fontLightGreen..'UnitFramesImproved_Vanilla Loaded. ' .. fontLightRed .. 'Type ' ..fontOrange.. '/ufi ' ..fontLightRed.. 'for options.' );
	if MobHealth3Config.saveData == true then
		ufi_chattext( fontLightGreen..'MobHealth3 Loaded. -' .. fontWhite .. ' Saving mob health between sessions =' .. fontGreen..' ON ' .. fontWhite .. 'Type '..fontOrange.. '/mh3 ' ..fontLightGreen.. 'for options.' );
	else
		ufi_chattext( fontLightGreen..'MobHealth3 Loaded. -' .. fontWhite .. ' Saving mob health between sessions =' .. fontRed..' OFF ' .. fontWhite .. 'Type '..fontOrange.. '/mh3 ' ..fontLightGreen.. 'for options.' );
	end
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
		-- Update some values
		TextStatusBar_UpdateTextString(PlayerFrame.healthbar);
		TextStatusBar_UpdateTextString(PlayerFrame.manabar);
	else
		ufi_chattext( fontOrange.. 'modUI ' ..fontLightGreen.. 'detected.' );
		PlayerFrameBackground.bg:Hide();
		UnitFramesImprovedConfig.DarkMode = false;
		UnitFramesImprovedConfig.PlayerClassColor	= 1;
		UnitFramesImprovedConfig.Percentage = 0;
		UnitFramesImprovedConfig.HidePetText = 0;

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
	PlayerFrameHealthBarText:SetPoint("CENTER",50,5);

	PlayerFrameTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-TargetingFrame");
	PlayerStatusTexture:SetTexture("Interface\\Addons\\UnitFramesImproved_Vanilla\\Textures\\UI-Player-Status");	
end

function UnitFramesImproved_ColorUpdate()
	if UnitFramesImprovedConfig.PlayerClassColor == 1 then
		PlayerFrameHealthBar:SetStatusBarColor(UnitColor("player"));
	else
		PlayerFrameHealthBar:SetStatusBarColor(0,1,0);
	end
end

function UnitFramesImproved_Style_TargetFrame(unit)
		local classification = UnitClassification("target");
		if (classification == "minus") then
			TargetFrameHealthBar:SetHeight(12);
			TargetFrameHealthBar:SetPoint("TOPLEFT",6,-41);
			TargetDeadText:SetPoint("CENTER",-50,4);
			TargetFrameNameBackground:Hide()
		else
			TargetFrameHealthBar:SetHeight(29);
			TargetFrameHealthBar:SetPoint("TOPLEFT",6,-22);
			TargetDeadText:SetPoint("CENTER",-50,6);
			TargetFrameNameBackground:Hide();
		end
		TargetFrameHealthBar:SetWidth(119);
		TargetFrameHealthBar.lockColor = true;
end

function true_format(v)            -- STATUS TEXT FORMATTING ie 1.5k, 2.3m
         if v > 1E7 then return (math.floor(v/1E6))..'m'
         elseif v > 1E6 then return (math.floor((v/1E6)*10)/10)..'m'
         elseif v > 1E4 then return (math.floor(v/1E3))..'k'
         elseif v > 1E3 and UnitFramesImprovedConfig.TrueFormat == 1 then return (math.floor((v/1E3)*10)/10)..'k'
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
		------------------------
		local pp = UnitPowerType'player'
    	local v  = math.floor(textStatusBar:GetValue())
    	local min, max = textStatusBar:GetMinMaxValues()
        local percent = math.floor(v/max*100)
		---------------------------

		
		if ( valueMax > 0 ) then
			textStatusBar:Show();

			if ( value == 0 and textStatusBar.zeroText ) then
				string:SetText(textStatusBar.zeroText);
				textStatusBar.isZero = 1;
				string:Show();
			else
				textStatusBar.isZero = nil;
					
					if UnitFramesImprovedConfig.Percentage == 1 then
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
	if UnitFramesImprovedConfig.HidePetText == 1 then
		PetFrameHealthBarText:Hide();
		PetFrameManaBarText:Hide();
	end
end

function UnitFramesImproved_TargetFrame_Update()
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
	local sr, sg, sb = TargetFrameNameBackground:GetVertexColor();
	local localizedClass, englishClass = UnitClass(unit);
	local classColor = RAID_CLASS_COLORS[englishClass];
	if ( ( not UnitIsPlayer(unit) ) and ( ( not UnitIsConnected(unit) ) or ( UnitIsDeadOrGhost(unit) ) ) ) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
	elseif ( UnitIsPlayer(unit) ) then
		--Try to color it by class.
		if UnitFramesImprovedConfig.PlayerClassColor == 1 then

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
		if UnitFramesImprovedConfig.NPCClassColor == 1 and classColor then
			r, g, b = classColor.r, classColor.g, classColor.b;
		else
			r, g, b = sr, sg, sb;
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

function ufi_chattext(txt)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( fontLightBlue.."<UFI> "..txt)
	end
end 

function UnitFramesImproved_OnLoad() 
	UnitFramesImproved:SetScript("OnEvent", UnitFramesImproved_OnEvent)
	UnitFramesImproved:RegisterEvent('ADDON_LOADED');
	UnitFramesImproved:RegisterEvent('PLAYER_ENTERING_WORLD');
end

function UnitFramesImproved_OnEvent() 	
	if IsAddOnLoaded'modui' then                   -- modUI
    	ufi_modui = true;
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
