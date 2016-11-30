local menu = CreateFrame('Frame', 'ufi_options', UIParent)
    menu:SetWidth(360) menu:SetHeight(270)
    menu:SetPoint('CENTER', UIParent)
    menu:SetBackdrop({bgFile   = [[Interface\Tooltips\UI-Tooltip-Background]],
                      edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
    				  insets   = {left = 11, right = 12, top = 12, bottom = 11}})
    menu:SetBackdropColor(0, 0, 0, .7)
    menu:SetBackdropBorderColor(.2, .2, .2)
    menu:SetMovable(true) menu:SetUserPlaced(true)
    menu:RegisterForDrag'LeftButton' menu:EnableMouse(true)
    menu:SetScript('OnDragStart', function() menu:StartMoving() end)
    menu:SetScript('OnDragStop', function() menu:StopMovingOrSizing() end)
    menu:Hide();

	menu.x = CreateFrame('Button', 'ufi_optionsCloseButton', menu, 'UIPanelCloseButton')
    menu.x:SetPoint('TOPRIGHT', -6, -6)
    menu.x:SetScript('OnClick', function() menu:Hide() end)

	menu.header = menu:CreateTexture(nil, 'ARTWORK')
    menu.header:SetWidth(256) menu.header:SetHeight(64)
    menu.header:SetPoint('TOP', menu, 0, 12)
    menu.header:SetTexture[[Interface\DialogFrame\UI-DialogBox-Header]]
    menu.header:SetVertexColor(.2, .2, .2)

	menu.header.t = menu:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
    menu.header.t:SetPoint('TOP', menu.header, 0, -14)
    menu.header.t:SetText'ufi options'

	menu.reload = CreateFrame('Button', 'ufi_optionsreload', menu, 'UIPanelButtonTemplate')
    menu.reload:SetWidth(100) menu.reload:SetHeight(20)
    menu.reload:SetText'Reload UI'
    menu.reload:SetFont(STANDARD_TEXT_FONT, 10)
    menu.reload:SetPoint('TOP', menu, 0, -320)
    menu.reload:Hide()

	function reload_request()
		menu.reload:Show();
		menu:SetHeight(370);
	end

	menu.reload.description = menu.reload:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    menu.reload.description:SetPoint('TOP', menu.reload, 0, 30)
    menu.reload.description:SetWidth(200)
    menu.reload.description:SetText'Your new settings require a UI reload to take effect.'

	menu.reload:SetScript('OnClick', ReloadUI)

	menu.intro = menu:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    --menu.intro:SetTextColor(colour.r, colour.g, colour.b)
    menu.intro:SetPoint('TOP', menu, 0, -30)
    menu.intro:SetWidth(280)
    menu.intro:SetText'Hello! You are using |cffff6c6cUFI|r v0.8. This is a beta version so please report any issues to:'
	

	menu.uilink = CreateFrame('EditBox', 'ufi_uilink', menu, 'InputBoxTemplate')
    menu.uilink:SetFont(STANDARD_TEXT_FONT, 12)
    menu.uilink:SetWidth(250) 
	menu.uilink:SetHeight(10)
    menu.uilink:SetPoint('TOP', menu.intro, 'BOTTOM', 0, -10)
    menu.uilink:SetAutoFocus(false)
    --menu.uilink:SetScript('OnShow', function()
    menu.uilink:SetText'github.com/Ko0z/UnitFramesImproved_Vanilla'
    --end)
	-------------------------------------------------
	--BUTTON
	
	menu.unlock = CreateFrame('Button', 'ufi_lock', menu, 'UIPanelButtonTemplate')
    menu.unlock:SetWidth(100) 
	menu.unlock:SetHeight(20)
    menu.unlock:SetText'Unlock/Lock'
    menu.unlock:SetFont(STANDARD_TEXT_FONT, 10)
    menu.unlock:SetPoint('TOPLEFT', menu, 25, -235)
	--menu.unlock:Disable();

	menu.resetdefault = CreateFrame('Button', 'ufi_resetdefault', menu, 'UIPanelButtonTemplate')
    menu.resetdefault:SetWidth(100) 
	menu.resetdefault:SetHeight(20)
    menu.resetdefault:SetText'Reset to default'
    menu.resetdefault:SetFont(STANDARD_TEXT_FONT, 10)
    menu.resetdefault:SetPoint('TOPRIGHT', menu, -25, -235)
	
	----------------------------------------------------
	--classportraits checkbutton
	menu.classportrait = CreateFrame('CheckButton', 'ufi_classportraits', menu, 'UICheckButtonTemplate')
    menu.classportrait:SetHeight(20) menu.classportrait:SetWidth(20)
    menu.classportrait:SetPoint('TOPLEFT', menu, 25, -80)
	_G[menu.classportrait:GetName()..'Text']:SetJustifyH'LEFT'
    _G[menu.classportrait:GetName()..'Text']:SetWidth(270)
    _G[menu.classportrait:GetName()..'Text']:SetPoint('LEFT', menu.classportrait, 'RIGHT', 4, 0)
    _G[menu.classportrait:GetName()..'Text']:SetText'Class Portraits'
	----------------------------------------------------
	--darkmode checkbutton
	menu.darkmode = CreateFrame('CheckButton', 'ufi_darkmode', menu, 'UICheckButtonTemplate')
    menu.darkmode:SetHeight(20) menu.darkmode:SetWidth(20)
    menu.darkmode:SetPoint('TOPLEFT', menu, 25, -100)
	_G[menu.darkmode:GetName()..'Text']:SetJustifyH'LEFT'
    _G[menu.darkmode:GetName()..'Text']:SetWidth(270)
    _G[menu.darkmode:GetName()..'Text']:SetPoint('LEFT', menu.darkmode, 'RIGHT', 4, 0)
    _G[menu.darkmode:GetName()..'Text']:SetText'Dark Mode'
	----------------------------------------------------
	--name text outline checkbutton
	menu.textoutline = CreateFrame('CheckButton', 'ufi_textoutline', menu, 'UICheckButtonTemplate')
    menu.textoutline:SetHeight(20) menu.textoutline:SetWidth(20)
    menu.textoutline:SetPoint('TOPLEFT', menu, 25, -120)
	_G[menu.textoutline:GetName()..'Text']:SetJustifyH'LEFT'
    _G[menu.textoutline:GetName()..'Text']:SetWidth(270)
    _G[menu.textoutline:GetName()..'Text']:SetPoint('LEFT', menu.textoutline, 'RIGHT', 4, 0)
    _G[menu.textoutline:GetName()..'Text']:SetText'Name text outline'
	-----------------------------------------------------
	menu.nametextX = CreateFrame('Slider', 'ufi_optionsnametextX', menu, 'OptionsSliderTemplate')
    menu.nametextX:SetWidth(200) 
	menu.nametextX:SetHeight(16)
    menu.nametextX:SetPoint('TOP', menu, 0, -155)
    menu.nametextX:SetMinMaxValues(-40, 40)
    menu.nametextX:SetValue(0)
    menu.nametextX:SetValueStep(1)
    menu.nametextX:SetScript('OnValueChanged', function()

        UnitFramesImprovedConfig.NameTextX = menu.nametextX:GetValue();

		PlayerName:SetPoint("CENTER", PlayerFrameHealthBar, "Center", UnitFramesImprovedConfig.NameTextX, UnitFramesImprovedConfig.NameTextY+4); 
		--PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
		TargetName:SetPoint("CENTER", TargetFrameHealthBar, "Center", -UnitFramesImprovedConfig.NameTextX, UnitFramesImprovedConfig.NameTextY+4); 
		--TargetName:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE");
    end)

    _G[menu.nametextX:GetName()..'Low']:SetText''
    _G[menu.nametextX:GetName()..'High']:SetText''
    _G[menu.nametextX:GetName()..'Text']:SetText'Name position X'
	-----------------------------------------------------
	menu.nametextY = CreateFrame('Slider', 'ufi_optionsnametextY', menu, 'OptionsSliderTemplate')
    menu.nametextY:SetWidth(200) 
	menu.nametextY:SetHeight(16)
    menu.nametextY:SetPoint('TOP', menu, 0, -185)
    menu.nametextY:SetMinMaxValues(-40, 40)
    menu.nametextY:SetValue(0)
    menu.nametextY:SetValueStep(1)
    menu.nametextY:SetScript('OnValueChanged', function()

        UnitFramesImprovedConfig.NameTextY = menu.nametextY:GetValue();
		PlayerName:SetPoint("CENTER", PlayerFrameHealthBar, "Center", UnitFramesImprovedConfig.NameTextX, UnitFramesImprovedConfig.NameTextY+4); 
		TargetName:SetPoint("CENTER", TargetFrameHealthBar, "Center", -UnitFramesImprovedConfig.NameTextX, UnitFramesImprovedConfig.NameTextY+4); 
    end)

    _G[menu.nametextY:GetName()..'Low']:SetText''
    _G[menu.nametextY:GetName()..'High']:SetText''
    _G[menu.nametextY:GetName()..'Text']:SetText'Name position Y'
	-----------------------------------------------------------

	menu.nametextfontsize = CreateFrame('Slider', 'ufi_optionsnametextfontsize', menu, 'OptionsSliderTemplate')
    menu.nametextfontsize:SetWidth(200) 
	menu.nametextfontsize:SetHeight(16)
    menu.nametextfontsize:SetPoint('TOP', menu, 0, -215)
    menu.nametextfontsize:SetMinMaxValues(7, 14)
    menu.nametextfontsize:SetValue(10)
    menu.nametextfontsize:SetValueStep(1)
    menu.nametextfontsize:SetScript('OnValueChanged', function()

        UnitFramesImprovedConfig.NameTextFontSize = menu.nametextfontsize:GetValue();
		if UnitFramesImprovedConfig.NameOutline == true then
			PlayerName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize, "OUTLINE");
			TargetName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize, "OUTLINE");
		else
			PlayerName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize);
			TargetName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize);
		end
    end)

    _G[menu.nametextfontsize:GetName()..'Low']:SetText''
    _G[menu.nametextfontsize:GetName()..'High']:SetText''
    _G[menu.nametextfontsize:GetName()..'Text']:SetText'Text Font Size'
	-----------------------------------------------------------
	-- OnClick Button functions
	menu.classportrait:SetScript('OnClick', function()
        if this:GetChecked() == 1 then 
			UnitFramesImprovedConfig.ClassPortrait = true;
			reload_request();
		else 
			UnitFramesImprovedConfig.ClassPortrait = false;
			reload_request();
		end
    end)

	menu.darkmode:SetScript('OnClick', function()
        if this:GetChecked() == 1 then 
			UnitFramesImprovedConfig.DarkMode = true;
			reload_request();
		else 
			UnitFramesImprovedConfig.DarkMode = false;
			reload_request();
		end
    end)

	menu.textoutline:SetScript('OnClick', function()
        if this:GetChecked() == 1 then 
			UnitFramesImprovedConfig.NameOutline = true;
			PlayerName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize, "OUTLINE");
			TargetName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize, "OUTLINE"); 
		else 
			UnitFramesImprovedConfig.NameOutline = false;
			PlayerName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize);
			TargetName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize); 
		end
    end)

	menu.resetdefault:SetScript('OnClick', function()
        StaticPopup_Show("DEFAULT_RELOAD");
    end)

	local ufi_locked = true;
	menu.unlock:SetScript('OnClick', function()
        if ufi_locked == true then
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
			ufi_locked = false;
			return
		else
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
			ufi_locked = true;
			return
		end
    end)

	------------------------------------------------------------
	local f = CreateFrame'Frame'
    f:RegisterEvent'PLAYER_ENTERING_WORLD'
    f:SetScript('OnEvent', function()
        
        if UnitFramesImprovedConfig.ClassPortrait == true then 
			menu.classportrait:SetChecked(true) 
			--menu.darkmode:Disable();
		else 
			menu.classportrait:SetChecked(false) 
		end

		if UnitFramesImprovedConfig.DarkMode == true then 
			menu.darkmode:SetChecked(true) 
		else 
			menu.darkmode:SetChecked(false) 
		end

		if UnitFramesImprovedConfig.NameOutline == true then 
			menu.textoutline:SetChecked(true) 
		else 
			menu.textoutline:SetChecked(false) 
		end

		if UnitFramesImprovedConfig.NameTextX then
			menu.nametextX:SetValue(UnitFramesImprovedConfig.NameTextX)
		else 
			menu.nametextX:SetValue(0)
		end

		if UnitFramesImprovedConfig.NameTextY then
			menu.nametextY:SetValue(UnitFramesImprovedConfig.NameTextY)
		else 
			menu.nametextY:SetValue(0)
		end

		if UnitFramesImprovedConfig.NameTextFontSize then
			menu.nametextfontsize:SetValue(UnitFramesImprovedConfig.NameTextFontSize)
		else 
			menu.nametextfontsize:SetValue(10)
		end

		PlayerName:SetPoint("CENTER", PlayerFrameHealthBar, "Center", UnitFramesImprovedConfig.NameTextX, UnitFramesImprovedConfig.NameTextY+4);
		TargetName:SetPoint("CENTER", TargetFrameHealthBar, "Center", -UnitFramesImprovedConfig.NameTextX, UnitFramesImprovedConfig.NameTextY+4); 

		if UnitFramesImprovedConfig.NameOutline == true then
			PlayerName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize, "OUTLINE");
			TargetName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize, "OUTLINE");
		else
			PlayerName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize);
			TargetName:SetFont("Fonts\\FRIZQT__.TTF", UnitFramesImprovedConfig.NameTextFontSize);
		end

		if ufi_modui == true then
			menu.darkmode:Disable();
			menu.unlock:Disable();
			_G[menu.darkmode:GetName()..'Text']:SetText'Dark Mode |cffff6c6cdisabled by modUI|r'
		else
			PlayerFrameHealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 10);
			PlayerFrameHealthBarText:SetShadowColor(0, 0, 0, 1)
			PlayerFrameHealthBarText:SetShadowOffset(1, -1)

			PlayerFrameManaBarText:SetFont("Fonts\\FRIZQT__.TTF", 10);
			PlayerFrameManaBarText:SetShadowColor(0, 0, 0, 1)
			PlayerFrameManaBarText:SetShadowOffset(1, -1)
		end

    end)
	-------------------------------------------------------------------------
	StaticPopupDialogs["DEFAULT_RELOAD"] = {
	text = "Are you sure you want to reset defualt settings?",
	button1 = "Yes and Reload UI",
	button2 = "Ignore",
	OnAccept = function()
		UnitFramesImprovedConfig.ClassPortrait = false
		UnitFramesImprovedConfig.DarkMode = false
		UnitFramesImprovedConfig.NameTextX = 0		
		UnitFramesImprovedConfig.NameTextY = 0
		UnitFramesImprovedConfig.NameTextFontSize = 10
		UnitFramesImprovedConfig.NameOutline = false
		ReloadUI();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true
}

	fontLightBlue = "|cff00e0ff"
	fontLightGreen = "|cff60ff60"
	fontLightRed = "|cffff8080"
	fontRed = "|cffff0000"
	fontOrange = "|cffff7000"
	fontWhite = "|cffffffff"

	SLASH_UFI_OPTIONS1 = '/ufi'
    SlashCmdList['UFI_OPTIONS'] = function(arg)
        if menu:IsShown() then menu:Hide() else menu:Show() end
    end

	