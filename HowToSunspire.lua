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
    },
    OffsetY = {
        HA = 0,
        Portal = 100,
    },
    Enable = {
        HA = true,
        Portal = true,
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

------------------------
---- LAST DOWNSTAIR ----
------------------------
local portalTime
function HowToSunspire.Portal(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN then
        --add the HA timer to the table
        portalTime = GetGameTimeMilliseconds() / 1000 + 14

        --run all UI functions for HA
        HowToSunspire.PortalTimerUI()
        Hts_Down:SetHidden(false)
		PlaySound(SOUNDS.TELVAR_GAINED)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "PortalTimer", 1000, HowToSunspire.PortalTimerUI)

        --Run function relative to downstair mechanic
        EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IsDownstair", EVENT_SYNERGY_ABILITY_CHANGED)
        EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "IsDownstair", EVENT_SYNERGY_ABILITY_CHANGED, HowToSunspire.IsDownstair)
    end
end

function HowToSunspire.PortalTimerUI()
    local currentTime = GetGameTimeMilliseconds() / 1000
    local timer = portalTime - currentTime

    if timer >= 0 then
        Hts_Down:SetText("|c7fffd4Portal: |r" .. tostring(string.format("%.0f", timer)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
        EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IsDownstair", EVENT_SYNERGY_ABILITY_CHANGED)
        Hts_Down:SetHidden(true)
    end
end

function HowToSunspire.IsDownstair()
    for i = 1, MAX_BOSSES do
        if DoesUnitExist("boss" .. i) then --when you are down
            d("DownStair")
            EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PortalTimer")
            EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IsDownstair", EVENT_SYNERGY_ABILITY_CHANGED)

            EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IsUpstair", EVENT_COMBAT_EVENT)
            EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "IsUpstair", EVENT_COMBAT_EVENT, HowToSunspire.IsUpstair) --return to reality
            EVENT_MANAGER:AddFilterForEvent(HowToSunspire.name .. "IsUpstair", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 121254) 

            EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "Interrupt", EVENT_COMBAT_EVENT)
            EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Interrupt", EVENT_COMBAT_EVENT, HowToSunspire.InterruptDown) --interrupt thing
            EVENT_MANAGER:AddFilterForEvent(HowToSunspire.name .. "Interrupt", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, 121436) 
        end
    end
end

function HowToSunspire.IsUpstair()
    --Unregister for all down relative events
    d("UpStair")
    EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "IsUpstair", EVENT_COMBAT_EVENT)
    EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "Interrupt", EVENT_COMBAT_EVENT)

    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "InterruptTimer")
    EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "Pins", EVENT_COMBAT_EVENT)
    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PinsTimer")
end

local interruptTime
function HowToSunspire.InterruptDown(_, result, _, _, _, _, _, _, _, targetType, hitValue, _, _, _, _, _, abilityId)
    if result == ACTION_RESULT_BEGIN then
        --add the HA timer to the table
        interruptTime = GetGameTimeMilliseconds() + hitValue

        --run all UI functions for HA
        HowToSunspire.InterruptTimerUI()
        Hts_Down:SetHidden(false)

		EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "InterruptTimer")
        EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "InterruptTimer", 100, HowToSunspire.PortalTimerUI)

        --register for when it is bashed
        EVENT_MANAGER:UnregisterForEvent(HowToSunspire.name .. "Pins", EVENT_COMBAT_EVENT)
        EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Pins", EVENT_COMBAT_EVENT, HowToSunspire.PinsDown) --interrupt down
        EVENT_MANAGER:AddFilterForEvent(HowToSunspire.name .. "Pins", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_INTERRUPT)
    end
end

function HowToSunspire.InterruptTimerUI()
    local currentTime = GetGameTimeMilliseconds()
    local timer = portalTime - currentTime

    if timer >= 0 then
        Hts_Down:SetText("|c7fffd4Interrupt: |r" .. tostring(string.format("%.1f", timer / 1000)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "InterruptTimer")
        Hts_Down:SetHidden(true)
    end
end

local pinsTime
function HowToSunspire.PinsDown()
    pinsTime = GetGameTimeMilliseconds() / 1000 + 20

    --run all UI functions for HA
    HowToSunspire.PinsTimerUI()
    Hts_Down:SetHidden(false)

    EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PinsTimer")
    EVENT_MANAGER:RegisterForUpdate(HowToSunspire.name .. "PinsTimer", 1000, HowToSunspire.PinsTimerUI)
end

function HowToSunspire.PinsTimerUI()
    local currentTime = GetGameTimeMilliseconds() / 1000
    local timer = portalTime - currentTime

    if timer >= 0 then
        Hts_Down:SetText("|c7fffd4Next Pins: |r" .. tostring(string.format("%.0f", timer)))
    else
        EVENT_MANAGER:UnregisterForUpdate(HowToSunspire.name .. "PinsTimer")
        Hts_Down:SetHidden(true)
    end
end

--------------
---- INIT ----
--------------
function HowToSunspire.InitUI()
    --heavy attacks
    Hts_Ha:SetHidden(true)
	Hts_Ha:ClearAnchors()
    if (sV.OffsetX.HA ~= HowToSunspire.Default.OffsetX.HA) and (sV.OffsetY.HA ~= HowToSunspire.Default.OffsetY.HA) then 
        --recover last position
		Hts_Ha:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.HA, sV.OffsetY.HA)
    else 
        --initial position (center)
		Hts_Ha:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.HA, sV.OffsetY.HA)
    end

    --all portal related notifications
    Hts_Down:SetHidden(true)
	Hts_Down:ClearAnchors()
    if (sV.OffsetX.HA ~= HowToSunspire.Default.OffsetX.Portal) and (sV.OffsetY.HA ~= HowToSunspire.Default.OffsetY.Portal) then 
        --recover last position
		Hts_Ha:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Portal, sV.OffsetY.Portal)
    else 
        --initial position (center)
		Hts_Ha:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Portal, sV.OffsetY.Portal)
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

--function HowToSunspire.Test()
--    d("test")
--end

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
    --EVENT_MANAGER:RegisterForEvent(HowToSunspire.name .. "Test", EVENT_COMBAT_EVENT, HowToSunspire.Test)
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

function HowToSunspire.OnAddOnLoaded(event, addonName)
	if addonName ~= HowToSunspire.name then return end
        HowToSunspire:Initialize()
end

EVENT_MANAGER:RegisterForEvent(HowToSunspire.name, EVENT_ADD_ON_LOADED, HowToSunspire.OnAddOnLoaded)