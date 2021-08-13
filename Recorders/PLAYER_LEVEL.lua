TheEye.Recorder.Recorders.PLAYER_LEVEL = {}
local this = TheEye.Recorder.Recorders.PLAYER_LEVEL

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register
local select = select
local UnitLevel = UnitLevel


function this.Initialize()
    this.gameEvents = { "PLAYER_LEVEL_UP" }
    EventsRegister(this)

    DataRecord(this, UnitLevel("player"))
end

function this:OnEvent(event, ...)
    local level = select(1, ...)
    DataRecord(this, level)
end