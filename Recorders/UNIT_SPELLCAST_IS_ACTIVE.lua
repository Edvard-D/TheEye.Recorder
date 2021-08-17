TheEye.Recorder.Recorders.UNIT_SPELLCAST_IS_ACTIVE = {}
local this = TheEye.Recorder.Recorders.UNIT_SPELLCAST_IS_ACTIVE

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local previousValues = {}
local select = select
local UnitCastingInfo = UnitCastingInfo
local UnitGUID = UnitGUID


function this.Initialize()
    this.gameEvents =
    {
        "PLAYER_TARGET_CHANGED",
        "UNIT_SPELLCAST_INTERRUPTED",
        "UNIT_SPELLCAST_START",
        "UNIT_SPELLCAST_SUCCEEDED",
    }
    EventsRegister(this)


    DataRecord(this, "player_false")
    previousValues["player"] = false

    DataRecord(this, "target_nil")
    previousValues["target"] = "nil"
end

function this:OnEvent(event, ...)
    if event == UNIT_SPELLCAST_START then
        unit = select(1, ...)

        if unit == "player" or unit == "target" then
            DataRecord(this, unit .. "_" .. tostring(true))
            previousValues[unit] = true
        end
    elseif event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_SUCCEEDED" then
        unit = select(1, ...)

        if unit == "player" or unit == "target" then
            DataRecord(this, unit .. "_" .. tostring(false))
            previousValues[unit] = false
        end
    else -- PLAYER_TARGET_CHANGED
        if UnitGUID("target") == nil and previousValues ~= "nil" then
            DataRecord(this, "target_nil")
            previousValues["target"] = "nil"
        end
    end
end