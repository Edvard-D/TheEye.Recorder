TheEye.Recorder.Recorders.PLAYER_HAS_TARGET = {}
local this = TheEye.Recorder.Recorders.PLAYER_HAS_TARGET

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local UnitGUID = UnitGUID


function this.Initialize()
    this.gameEvents = { "PLAYER_TARGET_CHANGED" }
    EventsRegister(this)

    local data =
    {
        hasTarget = false,
    }
    DataRecord(this, data)
end

function this:OnEvent(event, ...)
    local hasTarget = UnitGUID("target") ~= nil

    local data =
    {
        hasTarget = hasTarget,
    }
    DataRecord(this, data)
end