HowToSunspire = HowToSunspire or {}
local HowToSunspire = HowToSunspire

local LAM2 = LibAddonMenu2

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
		Everything = false,
		HA = false,
		Portal = false,
		IceTomb = false,
		SweepBreath = false,
		LaserLokke = false,
		Block = false,
		Spit = false,
		Comet = false,
		Thrash = false,
		Atro = false,
		Wipe = false,
		Storm = false,
	}

	local sV = HowToSunspire.savedVariables
	local optionsData = {
		{
			type = "header",
			name = "User Interface",
		},
		{	type = "description",
			text = "Here you can change the position of every notifications, you can unlock everything at same time, or only some alerts that you want.",
		},
		{	type = "submenu",
			name = "Unlocks",
			controls = {
				{	type = "checkbox",
					name = "Unlock Everything",
					tooltip = "Use it to set the position of all the notifications.",
					default = false,
					getFunc = function() return Unlock.Everything end,
					setFunc = function(newValue)
						Unlock.Everything = newValue
						Hts_Ha:SetHidden(not newValue)
						Hts_Block:SetHidden(not newValue)
						Hts_Ice:SetHidden(not newValue)
						Hts_Laser:SetHidden(not newValue)
						Hts_Sweep:SetHidden(not newValue)
						Hts_Down:SetHidden(not newValue)
						Hts_Spit:SetHidden(not newValue)
						Hts_Comet:SetHidden(not newValue)
						Hts_Atro:SetHidden(not newValue)
						Hts_Thrash:SetHidden(not newValue)
						Hts_Wipe:SetHidden(not newValue)
						Hts_Storm:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock HA",
					tooltip = "Use it to set the position of the Heavy Attacks timer text.",
					default = false,
					getFunc = function() return Unlock.HA end,
					setFunc = function(newValue)
						Unlock.HA = newValue
						Hts_Ha:SetHidden(not newValue)  
					end,
				},
				{	type = "checkbox",
					name = "Unlock Red Cats's Jump",
					tooltip = "Use it to set the position of the block text.",
					default = false,
					getFunc = function() return Unlock.Block end,
					setFunc = function(newValue)
						Unlock.Block = newValue
						Hts_Block:SetHidden(not newValue)  
					end,
				},
				{	type = "checkbox",
					name = "Unlock Comet / Meteor",
					tooltip = "Use it to set the position of the comet notification.",
					default = false,
					getFunc = function() return Unlock.Comet end,
					setFunc = function(newValue)
						Unlock.Comet = newValue
						Hts_Comet:SetHidden(not newValue)  
					end,
				},
				{	type = "checkbox",
					name = "Unlock Ice Tomb",
					tooltip = "Use it to set the position of the IceTimer.",
					default = false,
					getFunc = function() return Unlock.IceTomb end,
					setFunc = function(newValue)
						Unlock.IceTomb = newValue
						Hts_Ice:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock Laser",
					tooltip = "Use it to set the position of the laser that you have to block.",
					default = false,
					getFunc = function() return Unlock.LaserLokke end,
					setFunc = function(newValue)
						Unlock.LaserLokke = newValue
						Hts_Laser:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock Fire Atro Spawn",
					tooltip = "Use it to set the position of the fire atro spawn text.",
					default = false,
					getFunc = function() return Unlock.Atro end,
					setFunc = function(newValue)
						Unlock.Atro = newValue
						Hts_Atro:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock Sweeping Breath",
					tooltip = "Use it to set the position of the Sweeping Breath.",
					default = false,
					getFunc = function() return Unlock.SweepBreath end,
					setFunc = function(newValue)
						Unlock.SweepBreath = newValue
						Hts_Sweep:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock Thrash",
					tooltip = "Use it to set the position of the thrash.",
					default = false,
					getFunc = function() return Unlock.Thrash end,
					setFunc = function(newValue)
						Unlock.Thrash = newValue
						Hts_Thrash:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock Fire Spit",
					tooltip = "Use it to set the position of the fire spit that will pop an atronach.",
					default = false,
					getFunc = function() return Unlock.Spit end,
					setFunc = function(newValue)
						Unlock.Spit = newValue
						Hts_Spit:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock Fire Storm",
					tooltip = "Use it to set the position of the fire storm.",
					default = false,
					getFunc = function() return Unlock.Storm end,
					setFunc = function(newValue)
						Unlock.Storm = newValue
						Hts_Storm:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock Wipe Countdown",
					tooltip = "Use it to set the position of the Wipe Countdown.",
					default = false,
					getFunc = function() return Unlock.Wipe end,
					setFunc = function(newValue)
						Unlock.Wipe = newValue
						Hts_Wipe:SetHidden(not newValue)
					end,
				},
				{	type = "checkbox",
					name = "Unlock Portals Notif",
					tooltip = "Use it to set the position of all the Downstairs Notifications.",
					default = false,
					getFunc = function() return Unlock.Portal end,
					setFunc = function(newValue)
						Unlock.Portal = newValue
						Hts_Down:SetHidden(not newValue)
					end,
				},
			},
		},
		{	type = "slider",
            name = "Notifications Size",
            tooltip = "Choose here the size of all the notifications.",
            getFunc = function() return sV.FontSize end,
            setFunc = function(newValue)
				sV.FontSize = newValue
				HowToSunspire.SetFontSize(Hts_Ha_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Down_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Ice_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Sweep_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Laser_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Block_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Spit_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Comet_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Thrash_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Atro_Label, newValue)
				HowToSunspire.SetFontSize(Hts_Wipe_Label, newValue)
			end,
            min = 32,
            max = 56,
            step = 2,
            default = 40,
            width = "full",
		},
		{
			type = "header",
			name = "Globals Notifications",
		},
		{	type = "description",
			text = "Here you can track mechanics that can happen kinda everywhere in the trial.",
		},
		{	type = "checkbox",
			name = "Enable HA Tracking",
			tooltip = "To track all major heavy attacks in sunspire.\nIt include HA from all dragons, 1H & Shield, hulks on last boss, and cone of the add downstair on last boss.",
			default = true,
			getFunc = function() return sV.Enable.HA end,
			setFunc = function(newValue)  
				sV.Enable.HA = newValue
			end,
		},
		{	type = "checkbox",
			name = "Enable Red Cats's Jump",
			tooltip = "To enable or not the tracking of the jump from red cats that you need to block.",
			default = true,
			getFunc = function() return sV.Enable.Block end,
			setFunc = function(newValue)  
				sV.Enable.Block = newValue
			end,
		},
		{	type = "checkbox",
			name = "Enable Comet / Meteor",
			tooltip = "To enable the tracking of comet from mage trash, lokkestiiz, add downstair, and molten meteor from nahviintaas.",
			default = true,
			getFunc = function() return sV.Enable.Comet end,
			setFunc = function(newValue)
				sV.Enable.Comet = newValue
			end,
		},
		{
			type = "header",
			name = "Lokkestiiz Notifications",
		},
		{	type = "checkbox",
			name = "Enable Ice Tomb",
			tooltip = "To enable or not the tracking of when Ice Tomb spawn and how many time is remaining to take it.",
			default = true,
			getFunc = function() return sV.Enable.IceTomb end,
			setFunc = function(newValue)
				sV.Enable.IceTomb = newValue
			end,
		},
		{	type = "checkbox",
			name = "Enable Laser",
			tooltip = "To track when Lokkestiiz will cast the next laser.",
			default = true,
			getFunc = function() return sV.Enable.LaserLokke end,
			setFunc = function(newValue)
				sV.Enable.LaserLokke = newValue
			end,
		},
		{
			type = "header",
			name = "Yolnahkriin Notifications",
        },
		{	type = "checkbox",
			name = "Enable Fire Atro Spawn",
			tooltip = "To enable or not the tracking of the fire atronarch spawn.",
			default = true,
			getFunc = function() return sV.Enable.Atro end,
			setFunc = function(newValue)
				sV.Enable.Atro = newValue
			end,
		},
		{
			type = "header",
			name = "Nahviintaas Notifications",
		},
		{	type = "checkbox",
			name = "Enable Sweeping Breath",
			tooltip = "To enable or not the tracking of Sweeping Breath, and from which side it comes from.",
			default = true,
			getFunc = function() return sV.Enable.SweepBreath end,
			setFunc = function(newValue)
				sV.Enable.SweepBreath = newValue
			end,
		},
		{	type = "checkbox",
			name = "Enable Thrash",
			tooltip = "To track when Nahviintaas will cast the next Thrash that you have to block or rolldodge.",
			default = true,
			getFunc = function() return sV.Enable.Thrash end,
			setFunc = function(newValue)
				sV.Enable.Thrash = newValue
			end,
		},
		{	type = "checkbox",
			name = "Enable Fire Spit",
			tooltip = "To tell you when Nahvintaas will spit a fire ball on you that will then create an AoE, and will pop a fire atronach.\n|cff0000Note:|r It will also track the same mechanic on Lokkestiiz HM.",
			default = true,
			getFunc = function() return sV.Enable.Spit end,
			setFunc = function(newValue)
				sV.Enable.Spit = newValue
			end,
		},
		{	type = "checkbox",
			name = "Enable Fire Storm",
			tooltip = "To tell you when Nahvintaas do his Fire Storm attack (room explosion).\n|cff0000Note:|r If you are downstair during room explosion, if someone else upstair use this addon you will also have the notification.",
			default = true,
			getFunc = function() return sV.Enable.Storm end,
			setFunc = function(newValue)
				sV.Enable.Storm = newValue
			end,
		},
		{
			type = "header",
			name = "Downstair Notifications",
		},
		{	type = "checkbox",
			name = "Enable Wipe Countdown",
			tooltip = "It will show you a timer with time remaining before wiping downstair.",
			default = true,
			getFunc = function() return sV.Enable.Wipe end,
			setFunc = function(newValue)
				sV.Enable.Wipe = newValue
			end,
		},
		{	type = "slider",
            name = "Time Remaining to Show",
            tooltip = "Basicly it will only show the wipe notifications if the timer is lower than the value you set here.",
            getFunc = function() return sV.wipeCallLater end,
			setFunc = function(newValue)
				sV.wipeCallLater = newValue
			end,
            min = 10,
            max = 90,
            step = 1,
            default = 90,
            width = "full",
		},
		{	type = "description",
			text = "To track when portal spawn, and then if you are downstair you will track interrupt to do on the add and when the next pins are going to hit.",
		},
		{	type = "checkbox",
			name = "Enable Portal",
			tooltip = "To enable or not the tracking of when portal spawn and how many time is remaining to take it.",
			default = true,
			getFunc = function() return sV.Enable.Portal end,
			setFunc = function(newValue)
				sV.Enable.Portal = newValue
			end,
		},
		{	type = "checkbox",
			name = "Enable Interrupt Down",
			tooltip = "To enable or not the tracking of the attack to interrupt downstair.",
			default = true,
			getFunc = function() return sV.Enable.Interrupt end,
			setFunc = function(newValue)
				sV.Enable.Interrupt = newValue
			end,
		},
		{	type = "checkbox",
			name = "Enable Pins Tracking",
			tooltip = "To enable or not the tracking of the next pins downstair (stack just before end of timer).",
			default = true,
			getFunc = function() return sV.Enable.Pins end,
			setFunc = function(newValue)
				sV.Enable.Pins = newValue
			end,
		},
	}

	LAM2:RegisterOptionControls("HowToSunspire_Settings", optionsData)
end