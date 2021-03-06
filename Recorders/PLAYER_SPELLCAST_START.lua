TheEye.Recorder.Recorders.PLAYER_SPELLCAST_START = {}
local this = TheEye.Recorder.Recorders.PLAYER_SPELLCAST_START

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register


function this.Initialize()
    this.gameEvents = { "UNIT_SPELLCAST_START" }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    unit, _, spellID = ...

    if unit == "player" then
        DataRecord(this, spellID)
    end
end