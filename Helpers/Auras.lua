TheEye.Recorder.Helpers.Auras = {}
local this = TheEye.Recorder.Helpers.Auras

local UnitCategoryGet = TheEye.Core.Helpers.Unit.UnitCategoryGet
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer


function this.AreSourceAndDestUnitValidForRecord(sourceUnit, sourceUnitCategory, destUnit)
    local destUnitIsFriendlyPlayer = false
    if destUnit ~= nil then
        destUnitIsFriendlyPlayer = UnitIsEnemy(destUnit) == false and UnitIsPlayer(destUnit) == true
    end
    
    return destUnit == "player"
        or (destUnitIsFriendlyPlayer == true
            and (sourceUnitCategory == "NONE"
                or sourceUnitCategory == "BOSS"
                or sourceUnitCategory == "OTHER"))
        or sourceUnit == "player"
end