TheEye.Recorder.Recorders.PLAYER_HAS_TARGET = {}
local this = TheEye.Recorder.Recorders.PLAYER_HAS_TARGET

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local previousValue
local UnitGUID = UnitGUID


function this.Initialize()
    this.gameEvents = { "PLAYER_TARGET_CHANGED" }
    EventsRegister(this)

    DataRecord(this, false)
    previousValue = false
end

function this:OnEvent(event, ...)
    local hasTarget = UnitGUID("target") ~= nil

    if hasTarget ~= previousValue then
        DataRecord(this, hasTarget)
        previousValue = hasTarget
    end
end