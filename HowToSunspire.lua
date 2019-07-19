-----------------
---- Globals ----
-----------------
HowToSunspire = HowToSunspire or {}
local HowToSunspire = HowToSunspire

HowToSunspire.name = "HowToSunspire"
HowToSunspire.version = "0.1"

local sV
---------------------------
---- Variables Default ----
---------------------------
HowToSunspire.Default = {
    OffsetX = {
        HA = 0,
        Portal = 0,
        IceTomb = 0,
        SweepBreath = 0,
        LaserLokke = 0,
    },
    OffsetY = {
        HA = 0,
        Portal = 60,
        IceTomb = -60,
        SweepBreath = -120,
        LaserLokke = -120,
    },
    Enable = {
        HA = true,
        Portal = true,
        Interrupt = true,
        Pins = true,
        IceTomb = true,
        SweepBreath = true,
        LaserLokke = true,
    }
}

-----------------------
---- HEAVY ATTACKS ----
-----------------------
local listHA = {}
function HowToSunspire.HeavyAttack(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if targetType ~= COMBAT_UNIT_TYPE_PLAYER or hitValue < 100 or sV.Enable.HA ~= true then return end

	if result == ACTION_RESULT_BEGIN then

        --add the HA timer to the table
		table.insert(listHA, GetGameTimeMilliseconds() + hitValue)

        --run all UI functions for HA
        HowToSunspire.HeavyAttackUI()
        Hts_Ha:SetHidden(false)
		PlaySound(SOUNDS.CHAMPION_POINTS_COMMITTED)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HeavyAttackTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "HeavyAttackTimer", 100, HowToSunspire.HeavyAttackUI)
	end
end

function HowToSunspire.HeavyAttackUI()
    local text = ""
    local currentTime = GetGameTimeMilliseconds()

    --create the text to show with the timers
    for key, value in ipairs(listHA) do
        local timer = value - currentTime
        if timer >= 0 then
            if text == "" then
                text = text .. tostring(string.format("%.1f", timer / 1000)) 
            else
                text = text .. "|cff1493 / |r" .. tostring(string.format("%.1f", timer / 1000))
            end
        else
            --remove previous HA from the table
            table.remove(listHA, key)
        end
    end

    --show timers
    if text ~= "" then
        Hts_Ha_Label:SetText("|cff1493HA: |r" .. text)
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HeavyAttackTimer")
        Hts_Ha:SetHidden(true)
    end
end

--------------------
---- LOKKESTIIZ ----
--------------------
local iceNumber = 0
local prevIce = 0
local iceTime
function HowToSunspire.IceTomb(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN and sV.Enable.IceTomb == true then
        local currentTime = GetGameTimeMilliseconds();
        iceTime = currentTime / 1000 + 13

        if prevIce + 60000 <= currentTime then
            iceNumber = 0
        end
        prevIce = currentTime
        iceNumber = iceNumber % 3 + 1

        HowToSunspire.IceTombTimerUI()
        Hts_Ice:SetHidden(false)
        PlaySound(SOUNDS.DUEL_START)

        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "IceTombTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "IceTombTimer", 100, HowToSunspire.IceTombTimerUI)
    end
end

function HowToSunspire.IceTombTimerUI()
    local currentTime = GetGameTimeMilliseconds() / 1000
    local timer = iceTime - currentTime

    if timer > 9 then
        Hts_Ice_Label:SetText("|c00ffffIce |cff0000" .. iceNumber .. "|r |c00ffffin: |r" .. tostring(string.format("%.1f", timer - 9)))
    elseif timer >= 0 then 
        Hts_Ice_Label:SetText("|c00ffffIce |cff0000" .. iceNumber .. "|r |c00ffffremain: |r" .. tostring(string.format("%.0f", timer)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "IceTombTimer")
        Hts_Ice:SetHidden(true)
    end
end

local laserTime
function HowToSunspire.LokkeLaser(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN and sV.Enable.LaserLokke == true then
        local currentTime = GetGameTimeMilliseconds();
        if abilityId == 122820 then
            laserTime = currentTime / 1000 + 40
        elseif abilityId == 122821 then
            laserTime = currentTime / 1000 + 10
        elseif abilityId == 122822 then
            laserTime = currentTime / 1000 + 32
        else
            return
        end

        HowToSunspire.LokkeLaserTimerUI()
        Hts_Laser:SetHidden(false)

        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "LokkeLaserbTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "LokkeLaserTimer", 1000, HowToSunspire.LokkeLaserTimerUI)
    end
end

function HowToSunspire.LokkeLaserTimerUI()
    local currentTime = GetGameTimeMilliseconds() / 1000
    local timer = laserTime - currentTime

    if timer >= 0 then
        Hts_Laser_Label:SetText("|c7fffd4Laser: |r" .. tostring(string.format("%.0f", timer)))
    else
        Hts_Laser_Label:SetText("|c7fffd4Laser: |rNOW")
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "LokkeLaserTimer")
        zo_callLater(function () Hts_Laser:SetHidden(true) end, 5000)
    end
end

---------------------
---- NAHVIINTAAS ----
---------------------
local rightToLeft
function HowToSunspire.SweepingBreath(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN and sV.Enable.SweepBreath == true then
        if abilityId == 118743 then
            rightToLeft = true
        else
            rightToLeft = false
        end

        --run all UI functions for HA
        HowToSunspire.SweepingBreathUI()
        Hts_Sweep:SetHidden(false)
		PlaySound(SOUNDS.DUEL_START)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "SweepingBreath")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "SweepingBreath", 100, HowToSunspire.SweepingBreathUI)
        
        zo_callLater(function ()
            EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "SweepingBreath")
            Hts_Down:SetHidden(true) 
        end, 5000)
    end
end

local flash = 0
function HowToSunspire.SweepingBreathUI()
    flash = flash % 4 + 1

    --need to put base color in xml #FFD700
    local arrow
    if rightToLeft then
        if flash == 1 then
            arrow = "<<|cffa500<|r|cff0000<|r"
        elseif flash == 2 then
            arrow = "<|cffa500<|r|cff0000<|r|cffa500<|r"
        elseif flash == 3 then
            arrow = "|cffa500<|r|cff0000<|r|cffa500<|r<"
        else
            arrow = "|cff0000<|r|cffa500<|r<<"
        end
    else
        if flash == 1 then
            arrow = "|cff0000>|r|cffa500>|r>>"
        elseif flash == 2 then
            arrow = "|cffa500>|r|cff0000>|r|cffa500>|r>"
        elseif flash == 3 then
            arrow = ">|cffa500>|r|cff0000>|r|cffa500>|r"
        else
            arrow = ">>|cffa500>|r|cff0000>|r"
        end
    end

    Hts_Sweep_Label:SetText(arrow .. " Sweep Breath " .. arrow)
end

------------------------
---- LAST DOWNSTAIR ----
------------------------
local portalTime
function HowToSunspire.Portal(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN and sV.Enable.Portal == true then
        --add the HA timer to the table
        portalTime = GetGameTimeMilliseconds() / 1000 + 14

        --run all UI functions for HA
        HowToSunspire.PortalTimerUI()
        Hts_Down:SetHidden(false)
		PlaySound(SOUNDS.TELVAR_GAINED)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "PortalTimer", 1000, HowToSunspire.PortalTimerUI)
    end
end

function HowToSunspire.PortalTimerUI()
    local currentTime = GetGameTimeMilliseconds() / 1000
    local timer = portalTime - currentTime

    if timer >= 0 then
        Hts_Down_Label:SetText("|c7fffd4Portal: |r" .. tostring(string.format("%.0f", timer)))
        --Hts_Down:SetHidden(false)
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
        Hts_Down:SetHidden(true)
    end
end

local downstair = false
function HowToSunspire.IsDownstair(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_EFFECT_GAINED_DURATION and targetType == COMBAT_UNIT_TYPE_PLAYER then
        downstair = true
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
        Hts_Down:SetHidden(true)
    end
end

function HowToSunspire.IsUpstair(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    --Unregister for all down relative events
    if result == ACTION_RESULT_EFFECT_GAINED_DURATION and targetType == COMBAT_UNIT_TYPE_PLAYER then
        downstair = false
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "InterruptTimer")
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PinsTimer")
        Hts_Down:SetHidden(true)
    end
end

local interruptTime
local interruptUnitId
function HowToSunspire.InterruptDown(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, targetUnitId, abilityId)
    if result ~= ACTION_RESULT_EFFECT_GAINED_DURATION --[[or downstair ~= true]] then return end
    
    if sV.Enable.Pins == true then
        --register for when it is bashed
        EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "Pins", EVENT_COMBAT_EVENT)
        EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Pins", EVENT_COMBAT_EVENT, HowToSunspire.PinsDown) --interrupt down
        EVENT_MANAGER:AddFilterForEvent(HowToSunspire.name .. "Pins", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_INTERRUPT)
    end

    if sV.Enable.Interrupt == true then
        --add the HA timer to the table
        interruptTime = GetGameTimeMilliseconds() + hitValue
        interruptUnitId = targetUnitId

        --run all UI functions for HA
        HowToSunspire.InterruptTimerUI()
        Hts_Down:SetHidden(false)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "InterruptTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "InterruptTimer", 100, HowToSunspire.InterruptTimerUI)
    end
end

function HowToSunspire.InterruptTimerUI()
    local currentTime = GetGameTimeMilliseconds()
    local timer = interruptTime - currentTime

    if timer >= 0 then
        Hts_Down_Label:SetText("|c7fffd4Interrupt: |r" .. tostring(string.format("%.1f", timer / 1000)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "InterruptTimer")
        Hts_Down:SetHidden(true)
    end
end

local pinsTime
function HowToSunspire.PinsDown(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, targetUnitId, abilityId)
    --stop the timer of interrupt
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "InterruptTimer")

    if interruptUnitId == targetUnitId then
        interruptUnitId = nil
        pinsTime = GetGameTimeMilliseconds() / 1000 + 20

        --run all UI functions for HA
        HowToSunspire.PinsTimerUI()
        Hts_Down:SetHidden(false)

        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PinsTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "PinsTimer", 1000, HowToSunspire.PinsTimerUI)
    end
end

function HowToSunspire.PinsTimerUI()
    local currentTime = GetGameTimeMilliseconds() / 1000
    local timer = pinsTime - currentTime

    if timer >= 0 then
        Hts_Down_Label:SetText("|c7fffd4Next Pins: |r" .. tostring(string.format("%.0f", timer)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PinsTimer")
        Hts_Down:SetHidden(true)
    end
end

--------------
---- INIT ----
--------------
function HowToSunspire.InitUI()
    
    Hts_Ha:SetHidden(true)
    Hts_Down:SetHidden(true)
    Hts_Ice:SetHidden(true)
    Hts_Sweep:SetHidden(true)
    Hts_Laser:SetHidden(true)
    Hts_Ha:ClearAnchors()
    Hts_Down:ClearAnchors()
    Hts_Ice:ClearAnchors()
    Hts_Sweep:ClearAnchors()
    Hts_Laser:ClearAnchors()
    
    --heavy attacks
    if sV.OffsetX.HA ~= HowToSunspire.Default.OffsetX.HA and sV.OffsetY.HA ~= HowToSunspire.Default.OffsetY.HA then 
        --recover last position
		Hts_Ha:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.HA, sV.OffsetY.HA)
    else 
        --initial position (center)
		Hts_Ha:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.HA, sV.OffsetY.HA)
    end

    --all portal related notifications
    if sV.OffsetX.Portal ~= HowToSunspire.Default.OffsetX.Portal and sV.OffsetY.Portal ~= HowToSunspire.Default.OffsetY.Portal then 
		Hts_Down:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Portal, sV.OffsetY.Portal)
    else 
		Hts_Down:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Portal, sV.OffsetY.Portal)
    end

    --ice tomb notifications
    if sV.OffsetX.IceTomb ~= HowToSunspire.Default.OffsetX.IceTomb and sV.OffsetY.IceTomb ~= HowToSunspire.Default.OffsetY.IceTomb then 
		Hts_Ice:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.IceTomb, sV.OffsetY.IceTomb)
    else 
		Hts_Ice:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.IceTomb, sV.OffsetY.IceTomb)
    end

    --fire sweeping breath
    if sV.OffsetX.SweepBreath ~= HowToSunspire.Default.OffsetX.SweepBreath and sV.OffsetY.SweepBreath ~= HowToSunspire.Default.OffsetY.SweepBreath then 
		Hts_Sweep:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.SweepBreath, sV.OffsetY.SweepBreath)
    else 
		Hts_Sweep:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.SweepBreath, sV.OffsetY.SweepBreath)
    end
    
    --laser beam on lokke
    if sV.OffsetX.LaserLokke ~= HowToSunspire.Default.OffsetX.LaserLokke and sV.OffsetY.LaserLokke ~= HowToSunspire.Default.OffsetY.LaserLokke then 
		Hts_Laser:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.LaserLokke, sV.OffsetY.LaserLokke)
    else 
		Hts_Laser:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.LaserLokke, sV.OffsetY.LaserLokke)
    end
end

function HowToSunspire.OnPlayerActivated()
    
    if GetZoneId(GetUnitZoneIndex("player")) == 1121 then --in Sunspire
        for k, v in pairs(HowToSunspire.AbilitiesToTrack) do --Register for abilities in the other lua file
            EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Ability" .. k, EVENT_COMBAT_EVENT, v)
            EVENT_MANAGER:AddFilterForEvent(HowToSunspire.name .. "Ability" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, k)
        end
    else
        for k, v in pairs(HowToSunspire.AbilitiesToTrack) do --Unregister for all abilities
            EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "Ability" .. k, EVENT_COMBAT_EVENT)
        end
    end

end

local cptSaved = 0
function HowToSunspire.Test()
    local cpt = 0
    for i = 1, MAX_BOSSES do
        if DoesUnitExist("boss" .. i) then
            cpt = cpt + 1
        end
    end
    if cpt ~= cptSaved then
        cptSaved = cpt
        d("|cFF0000Boss Changed|r")
        PlaySound(SOUNDS.TELVAR_GAINED)
    end
end

function HowToSunspire:Initialize()
	--Saved Variables
    HowToSunspire.savedVariables = ZO_SavedVars:NewAccountWide("HowToSunspireVariables", 1, nil, HowToSunspire.Default)
    sV = HowToSunspire.savedVariables
	--Settings
	HowToSunspire.CreateSettingsWindow()
	--UI
    HowToSunspire.InitUI()
    
    --Events
    EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Activated", EVENT_PLAYER_ACTIVATED, HowToSunspire.OnPlayerActivated)
    
    --Test
    --EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Test", EVENT_BOSSES_CHANGED, HowToSunspire.Test)
	--EVENT_MANAGER:AddFilterForEvent(HowToSunspire.name .. "Test", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_DIED)

	EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name, EVENT_ADD_ON_LOADED)
end

function HowToSunspire.SaveLoc_HA()
	sV.OffsetX.HA = Hts_Ha:GetLeft()
	sV.OffsetY.HA = Hts_Ha:GetTop()
end
 
function HowToSunspire.SaveLoc_Down()
	sV.OffsetX.Portal = Hts_Down:GetLeft()
	sV.OffsetY.Portal = Hts_Down:GetTop()
end

function HowToSunspire.SaveLoc_Ice()
	sV.OffsetX.IceTomb = Hts_Ice:GetLeft()
	sV.OffsetY.IceTomb = Hts_Ice:GetTop()
end

function HowToSunspire.SaveLoc_Sweep()
	sV.OffsetX.SweepBreath = Hts_Sweep:GetLeft()
	sV.OffsetY.SweepBreath = Hts_Sweep:GetTop()
end

function HowToSunspire.SaveLoc_Laser()
	sV.OffsetX.LaserLokke = Hts_Laser:GetLeft()
	sV.OffsetY.LaserLokke = Hts_Laser:GetTop()
end

function HowToSunspire.OnAddOnLoaded(event, addonName)
	if addonName ~= HowToSunspire.name then return end
        HowToSunspire:Initialize()
end

EVENT_MANAGER:RegisterForEvent(HowToSunspire.name, EVENT_ADD_ON_LOADED, HowToSunspire.OnAddOnLoaded)