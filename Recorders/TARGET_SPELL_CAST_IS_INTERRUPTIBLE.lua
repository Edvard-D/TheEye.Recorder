TheEye.Recorder.Recorders.TARGET_SPELL_CAST_IS_INTERRUPTIBLE = {}
local this = TheEye.Recorder.Recorders.TARGET_SPELL_CAST_IS_INTERRUPTIBLE

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local previousValue
local select = select
local UnitCastingInfo = UnitCastingInfo


function this.Initialize()
    this.gameEvents = { "UNIT_SPELLCAST_START" }
    EventsRegister(this)

    DataRecord(this, "nil")
    previousValue = "nil"
end

function this:OnEvent(event, ...)
    unit, _, spellID = ...

    if unit == "target" then
        local isInterruptible = select(8, UnitCastingInfo("target")) == false

        if isInterruptible ~= previousValue then
            DataRecord(this, isInterruptible)
            previousValue = isInterruptible
        end
    end
end