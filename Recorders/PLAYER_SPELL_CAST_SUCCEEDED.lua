TheEye.Recorder.Recorders.PLAYER_SPELL_CAST_SUCCEEDED = {}
local this = TheEye.Recorder.Recorders.PLAYER_SPELL_CAST_SUCCEEDED

local DataRecord = TheEye.Recorder.Managers.Recorders.DataRecord
local EventsRegister = TheEye.Core.Managers.Events.Register


function this.Initialize()
    this.gameEvents = { "UNIT_SPELLCAST_SUCCEEDED" }
    EventsRegister(this)
end

function this:OnEvent(event, ...)
    local unit, _, spellID = ...

    if unit == "player" then
        DataRecord(this, spellID)
    end
end