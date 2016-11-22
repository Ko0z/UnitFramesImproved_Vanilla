UNITFRAMESIMPROVED_UI_COLOR                = {r = .4, g = .4, b = .4}

-- Dark borders and UI, code from modUI
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

-- Create the addon main instance
local UnitFramesImproved = CreateFrame('Button', 'UnitFramesImproved');

function EnableUnitFramesImproved()
	-- Generic status text hook
	UnitFrame_OnEvent = UnitFramesImproved_ColorUpdate

	TextStatusBar_UpdateTextString = UnitFramesImproved_TextStatusBar_UpdateTextString

	TargetFrame_OnUpdate = UnitFramesImproved_TargetFrame_Update
	TargetFrame_CheckFaction = UnitFramesImproved_TargetFrame_CheckFaction
	TargetFrame_CheckClassification = UnitFramesImproved_TargetFrame_CheckClassification

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
					string:SetText(textStatusBar.prefix.." "..value.." / "..valueMax);
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

EnableUnitFramesImproved();
