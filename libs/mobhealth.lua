	--Cred to dev of modUI or his/hers src
	local uStatus = 1
	local uBoth = 1
	local uValue = 1

    local move = function()
		if ufi_modui == true then return end;
        for _, v in pairs ({MobHealth3BlizzardHealthText, MobHealth3BlizzardPowerText}) do
			if UnitFramesImprovedConfig.NameOutline == 1 then
			--if (GetCVar("ufiNameOutline") == "1") then
				v:SetFont(STANDARD_TEXT_FONT, UnitFramesImprovedConfig.HPFontSize, 'OUTLINE')
				--v:SetFont(STANDARD_TEXT_FONT, GetCVar("ufiHPFontSize"), 'OUTLINE')
			else
				v:SetFont(STANDARD_TEXT_FONT, UnitFramesImprovedConfig.HPFontSize)
				--v:SetFont(STANDARD_TEXT_FONT, GetCVar("ufiHPFontSize"))
			end
            v:SetShadowOffset(0, 0)
			
            v:SetJustifyV'MIDDLE'
            if uStatus  == 0 and uBoth == 0 then
                v:ClearAllPoints()
                v:SetPoint('CENTER', TargetFrame, v:GetName() == 'MobHealth3BlizzardPowerText' and -26 or -75, -3)
				--v:SetPoint('TOPRIGHT', TargetFrame, v:GetName() == 'MobHealth3BlizzardPowerText' and -260 or -75, -30)

            end
			
        end
    end

    function MH3Blizz:HealthUpdate()
		if ufi_modui == true then return end;
        local v, max  = MobHealth3:GetUnitHealth('target', UnitHealth'target', UnitHealthMax'target')
        local percent = math.floor(v/max*100)
        local string  = MobHealth3BlizzardHealthText
        move()

        if MH3BlizzConfig.healthAbs then
            if max == 100 then
                -- Do nothing!
            else
                v = math.floor(v)
            end
        end

		-- FOR COLOR CHANGING HP 
        --string:SetTextColor(.05, 1, 0)
		--if (GetCVar("ufiColoredSbText") == "1") then
		if UnitFramesImprovedConfig.ColoredSbText == 1 then
			gradient(v, string, 0, max)
		end

        if uBoth == 1 then
            if max == 100 then
                string:SetText(percent..'%')
            else
				if UnitFramesImprovedConfig.Percentage == 1 then
				--if (GetCVar("ufiPercentage") == "1") then
					string:SetText(true_format(v)..'/'..true_format(max)..' — '..percent..'%')
				else
					string:SetText(true_format(v)..'/'..true_format(max))
				end
            end
            string:SetPoint('RIGHT', -8, 0)
        elseif uValue  == 1 and uBoth == 0 then
            local logic = MH3BlizzConfig.healthPerc and v <= 100 and percent == v
            local t = logic and true_format(v)..'%' or true_format(v)
            string:SetText(t)
        else
            string:SetText(percent..'%')
        end
    end

    function MH3Blizz:PowerUpdate()
	
		if ufi_modui == true then return end;
        local _, class = UnitClass'target'
		local pp	   = UnitPowerType'target'
        local v, max   = UnitMana'target', UnitManaMax'target'
        local percent  = math.floor(v/max*100)
        local string   = MobHealth3BlizzardPowerText
        move()

        if max == 0 or cur == 0 or percent == 0 then string:SetText() return end
        if MH3BlizzConfig.powerAbs then v = math.floor(v) end

		-- FOR COLOR CHANGING MP
		--if (GetCVar("ufiColoredSbText") == "1") then
		if UnitFramesImprovedConfig.ColoredSbText == 1 then
            if class == 'ROGUE' or (class == 'DRUID' and pp == 3) then
                string:SetTextColor(250/255, 240/255, 200/255)
            elseif class == 'WARRIOR' or (class == 'DRUID' and pp == 1) then
                string:SetTextColor(250/255, 108/255, 108/255)
            else
                string:SetTextColor(.6, .65, 1)
            end
		end
        
        if uBoth == 1 then
            if max == 100 then
                string:SetText(percent..'%')
            else
				if UnitFramesImprovedConfig.Percentage == 1 then
				--if (GetCVar("ufiPercentage") == "1") then
					string:SetText(true_format(v)..'/'..true_format(max)..' — '..percent..'%')
				else
					string:SetText(true_format(v)..'/'..true_format(max))
				end
            end
			--string:ClearAllPoints();
            string:SetPoint('RIGHT', -8, 0) -- -8
        elseif uValue  == 1 and uBoth == 0 then
            local logic = MH3BlizzConfig.powerPerc and v <= 100 and percent == v and class ~= 'ROGUE'
            local t = logic and true_format(v)..'%' or true_format(v)
            string:SetText(t)
        else
            string:SetText(percent..'%')
        end
    end
	
    local f = CreateFrame'Frame'
    f:RegisterEvent'CVAR_UPDATE' f:RegisterEvent'PLAYER_ENTERING_WORLD'
    f:SetScript('OnEvent', function()
        if arg1 == 'STATUS_BAR_TEXT' or event == 'PLAYER_ENTERING_WORLD' then
            if GetCVar'statusBarText' == '0' then
                MobHealth3BlizzardHealthText:Hide() MobHealth3BlizzardPowerText:Hide()
                TargetFrameHealthBar:SetScript('OnEnter', function() MobHealth3BlizzardHealthText:Show() end)
                TargetFrameHealthBar:SetScript('OnLeave', function() MobHealth3BlizzardHealthText:Hide() end)
                TargetFrameManaBar:SetScript('OnEnter', function() MobHealth3BlizzardPowerText:Show() end)
                TargetFrameManaBar:SetScript('OnLeave', function() MobHealth3BlizzardPowerText:Hide() end)
            else
                MobHealth3BlizzardHealthText:Show() MobHealth3BlizzardPowerText:Show()
            end
        end
    end)

