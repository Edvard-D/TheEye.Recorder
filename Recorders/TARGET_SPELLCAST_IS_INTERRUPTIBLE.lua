TheEye.Recorder.Recorders.TARGET_SPELLCAST_IS_INTERRUPTIBLE = {}
local this = TheEye.Recorder.Recorders.TARGET_SPELLCAST_IS_INTERRUPTIBLE

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local previousValue
local select = select
local UnitCastingInfo = UnitCastingInfo
local UnitGUID = UnitGUID


function this.Initialize()
    this.gameEvents =
    {
        "PLAYER_TARGET_CHANGED",
        "UNIT_SPELLCAST_START",
    }
    EventsRegister(this)

    DataRecord(this, "nil")
    previousValue = "nil"
end

function this:OnEvent(event, ...)
    if event == UNIT_SPELLCAST_START then
        unit = select(1, ...)

        if unit == "target" then
            local isInterruptible = select(8, UnitCastingInfo("target")) == false

            if isInterruptible ~= previousValue then
                DataRecord(this, isInterruptible)
                previousValue = isInterruptible
            end
        end
    else -- PLAYER_TARGET_CHANGED
        if UnitGUID("target") == nil and previousValue ~= "nil" then
            DataRecord(this, "nil")
            previousValue = "nil"
        end
    end
end