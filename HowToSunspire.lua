-----------------
---- Globals ----
-----------------
HowToSunspire = HowToSunspire or {}
local HowToSunspire = HowToSunspire

HowToSunspire.name = "HowToSunspire"
HowToSunspire.version = "1.0.3.1"

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
        Block = 0,
        Spit = 0,
        Comet = 0,
        Thrash = 0,
        Atro = 0,
    },
    OffsetY = {
        HA = 0,
        Portal = 50,
        IceTomb = -50,
        SweepBreath = -100,
        LaserLokke = 50,
        Block = 50,
        Spit = -50,
        Comet = -150,
        Thrash = 100,
        Atro = -50,
    },
    Enable = {
        HA = true,
        Portal = true,
        Interrupt = true,
        Pins = true,
        IceTomb = true,
        SweepBreath = true,
        LaserLokke = true,
        Block = true,
        Spit = true,
        Comet = true,
        Thrash = true,
        Atro = true,
    }
}

----------------------
---- ENTIRE TRIAL ----
----------------------
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

function HowToSunspire.Block(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN and sV.Enable.Block == true then
        Hts_Block:SetHidden(false)
		PlaySound(SOUNDS.DUEL_START)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HideBlock")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "HideBlock", 3000, HowToSunspire.HideBlock)
    end
end

function HowToSunspire.HideBlock()
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HideBlock")
    Hts_Block:SetHidden(true)
end

local cometTime
function HowToSunspire.Comet(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if (sV.Enable.Comet ~= true) or (hitValue < 100) or --enable
    (abilityId == 121075 and result ~= ACTION_RESULT_EFFECT_GAINED_DURATION) or --downstair
    (abilityId == 117251 and (result ~= ACTION_RESULT_EFFECT_GAINED_DURATION or targetType ~= COMBAT_UNIT_TYPE_PLAYER)) or --molten
    (abilityId == 123067 and (result ~= ACTION_RESULT_EFFECT_GAINED_DURATION or targetType ~= COMBAT_UNIT_TYPE_PLAYER)) or -- molten
    (abilityId == 120359 and (result ~= ACTION_RESULT_BEGIN or targetType ~= COMBAT_UNIT_TYPE_PLAYER)) or --lokke
    (abilityId == 116636 and (result ~= ACTION_RESULT_EFFECT_GAINED_DURATION or targetType ~= COMBAT_UNIT_TYPE_PLAYER)) then return end --trash

    cometTime = GetGameTimeMilliseconds() + hitValue

    HowToSunspire.CometUI()
    Hts_Comet:SetHidden(false)
    PlaySound(SOUNDS.DUEL_START)

    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "CometTimer")
    EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "CometTimer", 100, HowToSunspire.CometUI)
end

function HowToSunspire.CometUI()
    local currentTime = GetGameTimeMilliseconds()
    local timer = cometTime - currentTime

    if timer >= 0 then
        Hts_Comet_Label:SetText("|c87ceebComet: |r" .. tostring(string.format("%.1f", timer / 1000)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "CometTimer")
        Hts_Comet:SetHidden(true)
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

        if (prevIce + 70000 <= currentTime) or (prevIce + 60000 <= currentTime and iceNumber > 1) then
            iceNumber = 0
        end
        prevIce = currentTime
        iceNumber = iceNumber % 3 + 1

        HowToSunspire.IceTombTimerUI()
        Hts_Ice:SetHidden(false)
        PlaySound(SOUNDS.DUEL_START)

        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "IceTombTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "IceTombTimer", 100, HowToSunspire.IceTombTimerUI)
        
        --update all 1 seconds instead of all 0.1 seconds
        zo_callLater(function ()
            HowToSunspire.IceTombTimerUI()
            EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "IceTombTimer")
            EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "IceTombTimer", 1000, HowToSunspire.IceTombTimerUI)
        end, 4000)

        --events for both ice took
        EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IceTombFinished", EVENT_COMBAT_EVENT)
        EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "IceTombFinished", EVENT_COMBAT_EVENT, HowToSunspire.IceTombFinished)
        EVENT_MANAGER:AddFilterForEvent(HowToSunspire.name .. "IceTombFinished", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 119638)
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
        EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IceTombFinished", EVENT_COMBAT_EVENT)
        Hts_Ice:SetHidden(true)
    end
end

local iceState = false
function HowToSunspire.IceTombFinished(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == EFFECT_RESULT_GAINED then
        iceState = true
    elseif result == EFFECT_RESULT_FADED and iceState == true then
        iceState = false

        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "IceTombTimer")
        EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IceTombFinished", EVENT_COMBAT_EVENT)
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

        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "LokkeLaserTimer")
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
        zo_callLater(function () Hts_Laser:SetHidden(true) end, 8000)
    end
end

--------------------
---- YOLNAKRIIN ----
--------------------
function HowToSunspire.AtroSpawn(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN and sV.Enable.Atro == true then
        Hts_Atro:SetHidden(false)
        PlaySound(SOUNDS.DUEL_START)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HideAtro")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "HideAtro", 4500, HowToSunspire.HideAtro)
    end
end

function HowToSunspire.HideAtro()
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HideAtro")
    Hts_Atro:SetHidden(true)
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
        
        --hide 5sec later
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "HideSweepingBreath", 5000, HowToSunspire.HideSweepingBreath)
    end
end

local flash = 0
local function GetArrowForSweepingBreath()
    flash = flash % 4 + 1

    if rightToLeft then
        if flash == 1 then
            return "<<|cffa500<|r|cff0000<|r"
        elseif flash == 2 then
            return "<|cffa500<|r|cff0000<|r|cffa500<|r"
        elseif flash == 3 then
            return "|cffa500<|r|cff0000<|r|cffa500<|r<"
        else
            return "|cff0000<|r|cffa500<|r<<"
        end
    else
        if flash == 1 then
            return "|cff0000>|r|cffa500>|r>>"
        elseif flash == 2 then
            return "|cffa500>|r|cff0000>|r|cffa500>|r>"
        elseif flash == 3 then
            return ">|cffa500>|r|cff0000>|r|cffa500>|r"
        else
            return ">>|cffa500>|r|cff0000>|r"
        end
    end
end
function HowToSunspire.SweepingBreathUI()
    local arrow = GetArrowForSweepingBreath()

    Hts_Sweep_Label:SetText(arrow .. " Sweep Breath " .. arrow)
end

function HowToSunspire.HideSweepingBreath()
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HideSweepingBreath")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "SweepingBreath")
    Hts_Sweep:SetHidden(true)
end

local spitTime
function HowToSunspire.FireSpit(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if targetType ~= COMBAT_UNIT_TYPE_PLAYER or hitValue < 100 or sV.Enable.Spit ~= true then return end

	if result == ACTION_RESULT_BEGIN then
		spitTime = GetGameTimeMilliseconds() + hitValue

        HowToSunspire.FireSpitUI()
        Hts_Spit:SetHidden(false)
		PlaySound(SOUNDS.CHAMPION_POINTS_COMMITTED)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "FireSpitTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "FireSpitTimer", 100, HowToSunspire.FireSpitUI)
	end
end

function HowToSunspire.FireSpitUI()
    local currentTime = GetGameTimeMilliseconds()
    local timer = spitTime - currentTime

    if timer >= 0 then
        Hts_Spit_Label:SetText("|c7fffd4Spit: |r" .. tostring(string.format("%.1f", timer / 1000)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "FireSpitTimer")
        Hts_Spit:SetHidden(true)
    end
end

local thrashTime
function HowToSunspire.Thrash(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN and sV.Enable.Thrash == true then
        local currentTime = GetGameTimeMilliseconds()
        thrashTime = currentTime + hitValue

        HowToSunspire.ThrashTimerUI()
        Hts_Thrash:SetHidden(false)

        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "ThrashTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "ThrashTimer", 100, HowToSunspire.ThrashTimerUI)
    end
end

function HowToSunspire.ThrashTimerUI()
    local currentTime = GetGameTimeMilliseconds()
    local timer = thrashTime - currentTime

    if timer >= 0 then
        Hts_Thrash_Label:SetText("|ce51919Thrash: |r" .. tostring(string.format("%.1f", timer / 1000)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "ThrashTimer")
        Hts_Thrash:SetHidden(true)
    end
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

    if timer >= 11 then 
        Hts_Down_Label:SetText("|c7fffd4Portal: |r|cff0000" .. tostring(string.format("%.0f", timer)) .. "|r")
    elseif timer >= 0 then
        Hts_Down_Label:SetText("|c7fffd4Portal: |r" .. tostring(string.format("%.0f", timer)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
        Hts_Down:SetHidden(true)
    end
end

--local downstair = false
local cptDownstair = 0
function HowToSunspire.IsDownstair(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if targetType == COMBAT_UNIT_TYPE_GROUP then
        cptDownstair = cptDownstair + 1
    elseif targetType ~= COMBAT_UNIT_TYPE_PLAYER then
        return
    end
    
    if result == ACTION_RESULT_EFFECT_GAINED_DURATION or cptDownstair == 3 then
        --downstair = true
        cptDownstair = 0
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
        Hts_Down:SetHidden(true)
    end
end

function HowToSunspire.IsUpstair(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    --Unregister for all down relative events
    if result == ACTION_RESULT_EFFECT_GAINED_DURATION and targetType == COMBAT_UNIT_TYPE_PLAYER then
        --downstair = false
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
    Hts_Block:SetHidden(true)
    Hts_Spit:SetHidden(true)
    Hts_Comet:SetHidden(true)
    Hts_Thrash:SetHidden(true)
    Hts_Atro:SetHidden(true)
    Hts_Ha:ClearAnchors()
    Hts_Down:ClearAnchors()
    Hts_Ice:ClearAnchors()
    Hts_Sweep:ClearAnchors()
    Hts_Laser:ClearAnchors()
    Hts_Block:ClearAnchors()
    Hts_Spit:ClearAnchors()
    Hts_Comet:ClearAnchors()
    Hts_Thrash:ClearAnchors()
    Hts_Atro:ClearAnchors()

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

    --block from red cats
    if sV.OffsetX.Block ~= HowToSunspire.Default.OffsetX.Block and sV.OffsetY.Block ~= HowToSunspire.Default.OffsetY.Block then 
		Hts_Block:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Block, sV.OffsetY.Block)
    else 
		Hts_Block:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Block, sV.OffsetY.Block)
    end

    --fire spit from nahvin
    if sV.OffsetX.Spit ~= HowToSunspire.Default.OffsetX.Spit and sV.OffsetY.Spit ~= HowToSunspire.Default.OffsetY.Spit then 
		Hts_Spit:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Spit, sV.OffsetY.Spit)
    else 
		Hts_Spit:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Spit, sV.OffsetY.Spit)
    end

    --comet from various source
    if sV.OffsetX.Comet ~= HowToSunspire.Default.OffsetX.Comet and sV.OffsetY.Comet ~= HowToSunspire.Default.OffsetY.Comet then 
		Hts_Comet:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Comet, sV.OffsetY.Comet)
    else 
		Hts_Comet:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Comet, sV.OffsetY.Comet)
    end

    --thrash from nahvin
    if sV.OffsetX.Thrash ~= HowToSunspire.Default.OffsetX.Thrash and sV.OffsetY.Thrash ~= HowToSunspire.Default.OffsetY.Thrash then 
		Hts_Thrash:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Thrash, sV.OffsetY.Thrash)
    else 
		Hts_Thrash:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Thrash, sV.OffsetY.Thrash)
    end

    --fire atro spawn
    if sV.OffsetX.Atro ~= HowToSunspire.Default.OffsetX.Atro and sV.OffsetY.Atro ~= HowToSunspire.Default.OffsetY.Atro then 
		Hts_Atro:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Atro, sV.OffsetY.Atro)
    else 
		Hts_Atro:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Atro, sV.OffsetY.Atro)
    end
end

function HowToSunspire.ResetAll()
    --hide everything
    Hts_Ha:SetHidden(true)
    Hts_Down:SetHidden(true)
    Hts_Ice:SetHidden(true)
    Hts_Sweep:SetHidden(true)
    Hts_Laser:SetHidden(true)
    Hts_Block:SetHidden(true)
    Hts_Spit:SetHidden(true)   
    Hts_Comet:SetHidden(true)
    Hts_Thrash:SetHidden(true)
    Hts_Atro:SetHidden(true)

    --unregister UI timer events
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HeavyAttackTimer")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HideBlock")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "CometTimer")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "IceTombTimer")
    EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IceTombFinished", EVENT_COMBAT_EVENT)
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "LokkeLaserTimer")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HideAtro")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "HideSweepingBreath")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "SweepingBreath")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "FireSpitTimer")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "ThrashTimer")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "InterruptTimer")
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PinsTimer")
    EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "Pins", EVENT_COMBAT_EVENT)

    --reset variables
    listHA = {}
    cometTime = nil
    iceNumber = 0
    prevIce = 0
    iceTime = nil
    iceState = false
    laserTime = nil
    rightToLeft = nil
    flash = 0
    spitTime = nil
    thrashTime = nil
    portalTime = nil
    cptDownstair = 0
    interruptTime = nil
    interruptUnitId = nil
    pinsTime = nil
end

function HowToSunspire.CombatEnded()
    zo_callLater(function() 
        if (not IsUnitInCombat("player")) then 
            HowToSunspire.ResetAll()
        end 
    end, 3000);
end

function HowToSunspire.OnPlayerActivated()
    
    if GetZoneId(GetUnitZoneIndex("player")) == 1121 then --in Sunspire
        for k, v in pairs(HowToSunspire.AbilitiesToTrack) do --Register for abilities in the other lua file
            EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Ability" .. k, EVENT_COMBAT_EVENT, v)
            EVENT_MANAGER:AddFilterForEvent(HowToSunspire.name .. "Ability" .. k, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, k)
        end
        EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "CombatEnded", EVENT_PLAYER_COMBAT_STATE, HowToSunspire.CombatEnded)
    else
        for k, v in pairs(HowToSunspire.AbilitiesToTrack) do --Unregister for all abilities
            EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "Ability" .. k, EVENT_COMBAT_EVENT)
        end
        EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "CombatEnded", EVENT_PLAYER_COMBAT_STATE)
    end

end

function HowToSunspire:Initialize()
	--Saved Variables
    HowToSunspire.savedVariables = ZO_SavedVars:NewAccountWide("HowToSunspireVariables", 2, nil, HowToSunspire.Default)
    sV = HowToSunspire.savedVariables
	--Settings
	HowToSunspire.CreateSettingsWindow()
	--UI
    HowToSunspire.InitUI()
    
    --Events
    EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Activated", EVENT_PLAYER_ACTIVATED, HowToSunspire.OnPlayerActivated)
    
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

function HowToSunspire.SaveLoc_Block()
	sV.OffsetX.Block = Hts_Block:GetLeft()
	sV.OffsetY.Block = Hts_Block:GetTop()
end

function HowToSunspire.SaveLoc_Spit()
	sV.OffsetX.Spit = Hts_Spit:GetLeft()
	sV.OffsetY.Spit = Hts_Spit:GetTop()
end

function HowToSunspire.SaveLoc_Comet()
	sV.OffsetX.Comet = Hts_Comet:GetLeft()
	sV.OffsetY.Comet = Hts_Comet:GetTop()
end

function HowToSunspire.SaveLoc_Thrash()
	sV.OffsetX.Thrash = Hts_Thrash:GetLeft()
	sV.OffsetY.Thrash = Hts_Thrash:GetTop()
end

function HowToSunspire.SaveLoc_Atro()
	sV.OffsetX.Atro = Hts_Atro:GetLeft()
	sV.OffsetY.Atro = Hts_Atro:GetTop()
end

function HowToSunspire.OnAddOnLoaded(event, addonName)
	if addonName ~= HowToSunspire.name then return end
        HowToSunspire:Initialize()
end

EVENT_MANAGER:RegisterForEvent(HowToSunspire.name, EVENT_ADD_ON_LOADED, HowToSunspire.OnAddOnLoaded)