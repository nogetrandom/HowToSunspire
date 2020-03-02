HowToSunspire = HowToSunspire or {}
local HowToSunspire = HowToSunspire

local sV

function HowToSunspire.InitUI()
    sV = HowToSunspire.savedVariables
    
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
    Hts_Wipe:SetHidden(true)
    Hts_Storm:SetHidden(true)
    Hts_Geyser:SetHidden(true)
    Hts_NextFlare:SetHidden(true)
    Hts_NextMeteor:SetHidden(true)
    Hts_Negate:SetHidden(true)
    Hts_Shield:SetHidden(true)
    Hts_Cata:SetHidden(true)
    Hts_Leap:SetHidden(true)
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
    Hts_Wipe:ClearAnchors()
    Hts_Storm:ClearAnchors()
    Hts_Geyser:ClearAnchors()
    Hts_NextFlare:ClearAnchors()
    Hts_NextMeteor:ClearAnchors()
    Hts_Negate:ClearAnchors()
    Hts_Shield:ClearAnchors()
    Hts_Cata:ClearAnchors()
    Hts_Leap:ClearAnchors()

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

    --block from leap
    if sV.OffsetX.Leap ~= HowToSunspire.Default.OffsetX.Leap and sV.OffsetY.Leap ~= HowToSunspire.Default.OffsetY.Leap then 
		Hts_Leap:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Leap, sV.OffsetY.Leap)
    else 
		Hts_Leap:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Leap, sV.OffsetY.Leap)
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

    --wipe downstair
    if sV.OffsetX.Wipe ~= HowToSunspire.Default.OffsetX.Wipe and sV.OffsetY.Wipe ~= HowToSunspire.Default.OffsetY.Wipe then 
		Hts_Wipe:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Wipe, sV.OffsetY.Wipe)
    else 
		Hts_Wipe:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Wipe, sV.OffsetY.Wipe)
    end

    --room explosion on last boss
    if sV.OffsetX.Storm ~= HowToSunspire.Default.OffsetX.Storm and sV.OffsetY.Storm ~= HowToSunspire.Default.OffsetY.Storm then 
		Hts_Storm:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Storm, sV.OffsetY.Storm)
    else 
		Hts_Storm:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Storm, sV.OffsetY.Storm)
    end

    --lava geyser
    if sV.OffsetX.Geyser ~= HowToSunspire.Default.OffsetX.Geyser and sV.OffsetY.Geyser ~= HowToSunspire.Default.OffsetY.Geyser then 
      Hts_Geyser:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Geyser, sV.OffsetY.Geyser)
    else 
      Hts_Geyser:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Geyser, sV.OffsetY.Geyser)
    end

    if sV.OffsetX.NextFlare ~= HowToSunspire.Default.OffsetX.NextFlare and sV.OffsetY.NextFlare ~= HowToSunspire.Default.OffsetY.NextFlare then 
      Hts_NextFlare:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.NextFlare, sV.OffsetY.NextFlare)
    else 
      Hts_NextFlare:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.NextFlare, sV.OffsetY.NextFlare)
    end

    if sV.OffsetX.NextMeteor ~= HowToSunspire.Default.OffsetX.NextMeteor and sV.OffsetY.NextMeteor ~= HowToSunspire.Default.OffsetY.NextMeteor then 
      Hts_NextMeteor:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.NextMeteor, sV.OffsetY.NextMeteor)
    else 
      Hts_NextMeteor:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.NextMeteor, sV.OffsetY.NextMeteor)
    end

    if sV.OffsetX.Negate ~= HowToSunspire.Default.OffsetX.Negate and sV.OffsetY.Negate ~= HowToSunspire.Default.OffsetY.Negate then 
      Hts_Negate:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Negate, sV.OffsetY.Negate)
    else 
      Hts_Negate:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Negate, sV.OffsetY.Negate)
    end

    if sV.OffsetX.Shield ~= HowToSunspire.Default.OffsetX.Shield and sV.OffsetY.Shield ~= HowToSunspire.Default.OffsetY.Shield then 
      Hts_Shield:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Shield, sV.OffsetY.Shield)
    else 
      Hts_Shield:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Shield, sV.OffsetY.Shield)
    end

    --cataclysm
    if sV.OffsetX.Cata ~= HowToSunspire.Default.OffsetX.Cata and sV.OffsetY.Cata ~= HowToSunspire.Default.OffsetY.Cata then 
      Hts_Cata:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, sV.OffsetX.Cata, sV.OffsetY.Cata)
    else 
      Hts_Cata:SetAnchor(CENTER, GuiRoot, CENTER, sV.OffsetX.Cata, sV.OffsetY.Cata)
    end

    HowToSunspire.SetFontSize(Hts_Ha_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Down_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Ice_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Sweep_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Laser_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Block_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Spit_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Comet_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Thrash_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Atro_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Wipe_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Storm_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Geyser_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_NextFlare_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_NextMeteor_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Negate_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Shield_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Cata_Label, sV.FontSize)
    HowToSunspire.SetFontSize(Hts_Leap_Label, sV.FontSize)
end

function HowToSunspire.SetFontSize(label, size)
	local path = "EsoUI/Common/Fonts/univers67.otf"
    local outline = "soft-shadow-thick"
    label:SetFont(path .. "|" .. size .. "|" .. outline)
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

function HowToSunspire.SaveLoc_Wipe()
	sV.OffsetX.Wipe = Hts_Wipe:GetLeft()
	sV.OffsetY.Wipe = Hts_Wipe:GetTop()
end

function HowToSunspire.SaveLoc_Storm()
	sV.OffsetX.Storm = Hts_Storm:GetLeft()
	sV.OffsetY.Storm = Hts_Storm:GetTop()
end

function HowToSunspire.SaveLoc_Geyser()
	sV.OffsetX.Geyser = Hts_Geyser:GetLeft()
	sV.OffsetY.Geyser = Hts_Geyser:GetTop()
end

function HowToSunspire.SaveLoc_NextFlare()
	sV.OffsetX.NextFlare = Hts_NextFlare:GetLeft()
	sV.OffsetY.NextFlare = Hts_NextFlare:GetTop()
end

function HowToSunspire.SaveLoc_NextMeteor()
	sV.OffsetX.NextMeteor = Hts_NextMeteor:GetLeft()
	sV.OffsetY.NextMeteor = Hts_NextMeteor:GetTop()
end

function HowToSunspire.SaveLoc_Negate()
	sV.OffsetX.Negate = Hts_Negate:GetLeft()
	sV.OffsetY.Negate = Hts_Negate:GetTop()
end

function HowToSunspire.SaveLoc_Shield()
	sV.OffsetX.Shield = Hts_Shield:GetLeft()
	sV.OffsetY.Shield = Hts_Shield:GetTop()
end

function HowToSunspire.SaveLoc_Cata()
	sV.OffsetX.Cata = Hts_Cata:GetLeft()
	sV.OffsetY.Cata = Hts_Cata:GetTop()
end

function HowToSunspire.SaveLoc_Leap()
	sV.OffsetX.Leap = Hts_Leap:GetLeft()
	sV.OffsetY.Leap = Hts_Leap:GetTop()
end