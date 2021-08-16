TheEye.Recorder.Helpers.Auras = {}
local this = TheEye.Recorder.Helpers.Auras

local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer


function this.IsAuraValidForRecord(sourceUnit, destUnit, sourceUnitCategory)
    local destUnitIsFriendlyPlayer = false
    if destUnit ~= nil then
        destUnitIsFriendlyPlayer = UnitIsEnemy("player", destUnit) == false and UnitIsPlayer(destUnit) == true
    end
    
    return destUnit == "player"
        or (destUnitIsFriendlyPlayer == true
            and (sourceUnitCategory == "NONE"
                or sourceUnitCategory == "BOSS"
                or sourceUnitCategory == "OTHER"))
        or sourceUnit == "player"
end