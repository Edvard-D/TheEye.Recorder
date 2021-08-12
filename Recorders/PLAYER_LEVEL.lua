TheEye.Recorder.Recorders.PLAYER_LEVEL = {}
local this = TheEye.Recorder.Recorders.PLAYER_LEVEL

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local select = select
local UnitLevel = UnitLevel


function this.Initialize()
    this.gameEvents = { "PLAYER_LEVEL_UP" }
    EventsRegister(this)

    local data =
    {
        level = UnitLevel("player"),
    }
    DataRecord(this, data)
end

function this:OnEvent(event, ...)
    level = select(1, ...)

    local data =
    {
        level = level,
    }
    DataRecord(this, data)
end