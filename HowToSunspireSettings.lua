HowToSunspire = HowToSunspire or {}
local HowToSunspire = HowToSunspire

local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")

function HowToSunspire.CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "HowToSunspire",
		displayName = "HowTo|c989898Sunspire|r",
		author = "Floliroy",
		version = HowToSunspire.version,
		slashCommand = "/HowToSunspire",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	local cntrlOptionsPanel = LAM2:RegisterAddonPanel("HowToSunspire_Settings", panelData)
	local Unlock = {
		HA = false,
		Portal = false,
	}

	local sV = HowToSunspire.savedVariables
	local optionsData = {
		{	type = "description",
			text = " ",
		},
		{	type = "checkbox",
			name = "Unlock Heavy Attack",
			tooltip = "Use it to set the position of the Heavy Attack timer text.",
			default = false,
			getFunc = function() return Unlock.HA end,
			setFunc = function(newValue)
				Unlock.HA = newValue
				Hts_Ha:SetHidden(not newValue)  
			end,
		},
		{	type = "checkbox",
			name = "Enable Heavy Attack Tracking",
			tooltip = "To enable or not the tracking of Heavy Attack from statue.",
			default = true,
			getFunc = function() return sV.Enable.HA end,
			setFunc = function(newValue)  
				sV.Enable.HA = newValue
			end,
		},
		{	type = "description",
			text = " ",
		},
		{	type = "checkbox",
			name = "Unlock Portals Notifications",
			tooltip = "Use it to set the position of the all the Portals Notifications.",
			default = false,
			getFunc = function() return Unlock.Portal end,
			setFunc = function(newValue)
				Unlock.Portal = newValue
				Hts_Ha:SetHidden(not newValue)  
			end,
		},
		{	type = "checkbox",
			name = "Enable All Portals Notifications",
			tooltip = "To enable or not the tracking of portal, pins, interrupt.",
			default = true,
			getFunc = function() return sV.Enable.Portal end,
			setFunc = function(newValue)  
				sV.Enable.Portal = newValue
			end,
		},
	}

	LAM2:RegisterOptionControls("HowToSunspire_Settings", optionsData)
end